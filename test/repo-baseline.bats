#!/usr/bin/env bats

load "support/test_helpers.bash"

# Helper to create a minimal git repo
create_test_repo() {
  local repo_dir=$1
  mkdir -p "$repo_dir"
  cd "$repo_dir"
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test User"
  echo "# Test" > README.md
  git add README.md
  git commit -q -m "Initial commit"
}

# Helper to add GitHub remote
add_github_remote() {
  local repo_dir=$1
  local repo_url=${2:-"https://github.com/testuser/testrepo.git"}
  cd "$repo_dir"
  git remote add origin "$repo_url"
}

# =============================================================================
# BASIC HELP AND USAGE
# =============================================================================

@test "repo-baseline help prints" {
  run "$(dt_bin)" help repo-baseline
  [ "$status" -eq 0 ]
  [[ "$output" == *"repo-baseline"* ]]
}

@test "repo-baseline with no args shows help" {
  run "$(dt_bin)" repo-baseline
  [ "$status" -eq 0 ]
  [[ "$output" == *"Install PR workflow baseline"* ]]
}

@test "repo-baseline with unknown subcommand fails" {
  run "$(dt_bin)" repo-baseline invalid-command
  [ "$status" -eq 2 ]
  [[ "$output" == *"Unknown"* ]] || [[ "$output" == *"unknown"* ]]
}

# =============================================================================
# REPOSITORY DETECTION (A)
# =============================================================================

@test "repo-baseline setup: detects repo from root directory" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Run from repo root with --dry-run and --non-interactive
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  # Should detect the repo
  [[ "$output" == *"$work"* ]] || [[ "$output" == *"repository"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: detects repo from subdirectory" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  mkdir -p "$work/src/components"
  
  # Run from deep subdirectory
  cd "$work/src/components"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  # Should resolve to repo root
  [[ "$output" == *"$work"* ]] || [[ "$output" == *"repository"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: rejects auto-detected HOME as repo root" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"
  mkdir -p "$work/subdir"

  cd "$work/subdir"
  run env HOME="$work" "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST

  [ "$status" -ne 0 ]
  [[ "$output" == *"HOME"* ]]
  [[ "$output" == *"--repo"* ]]

  rm -rf "$work"
}

@test "repo-baseline setup: allows HOME repo when --repo is explicit" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"
  mkdir -p "$work/subdir"

  cd "$work/subdir"
  run env HOME="$work" "$(dt_bin)" repo-baseline setup --repo "$work" --dry-run --non-interactive --project-key TEST

  [ "$status" -eq 0 ]
  [[ "$output" == *"$work"* ]]

  rm -rf "$work"
}

@test "repo-baseline setup: fails outside git repo with clear message" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  # No git init - not a repo
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST
  
  [ "$status" -ne 0 ]
  # Should have clear error about no repository
  [[ "$output" == *"No git repository"* ]] || [[ "$output" == *"not found"* ]]
  # Should suggest git init or git clone
  [[ "$output" == *"git init"* ]] || [[ "$output" == *"git clone"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: accepts valid --repo flag" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  local elsewhere
  elsewhere="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl-other")"
  
  create_test_repo "$work"
  
  # Run from different directory using --repo
  cd "$elsewhere"
  run "$(dt_bin)" repo-baseline setup --repo "$work" --dry-run --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"$work"* ]] || [[ "$output" == *"repository"* ]]
  
  rm -rf "$work" "$elsewhere"
}

@test "repo-baseline setup: fails with invalid --repo path" {
  local nonexistent="/tmp/does-not-exist-repo-baseline-test-$$"
  
  run "$(dt_bin)" repo-baseline setup --repo "$nonexistent" --dry-run --non-interactive --project-key TEST
  
  [ "$status" -ne 0 ]
  [[ "$output" == *"not found"* ]] || [[ "$output" == *"invalid"* ]] || [[ "$output" == *"No git"* ]]
}

@test "repo-baseline setup: fails when --repo points to non-git directory" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  # Directory exists but no .git
  mkdir -p "$work/somedir"
  
  run "$(dt_bin)" repo-baseline setup --repo "$work/somedir" --dry-run --non-interactive --project-key TEST
  
  [ "$status" -ne 0 ]
  [[ "$output" == *"git"* ]] || [[ "$output" == *"repository"* ]]
  
  rm -rf "$work"
}

# =============================================================================
# FILE INSTALLATION + CONFLICTS (B)
# =============================================================================

@test "repo-baseline setup: fresh install writes all files in dry-run mode" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key SHOP
  
  [ "$status" -eq 0 ]
  # Should show what would be installed
  [[ "$output" == *"traceability.yml"* ]]
  [[ "$output" == *"ci.yml"* ]]
  [[ "$output" == *"test.sh"* ]]
  [[ "$output" == *".githooks/commit-msg"* ]]
  [[ "$output" == *"PULL_REQUEST_TEMPLATE"* ]]
  [[ "$output" == *"project-planning"* ]]
  
  # Files should NOT exist (dry-run)
  [ ! -f "$work/.github/workflows/ci.yml" ]
  [ ! -f "$work/ci/test.sh" ]
  
  rm -rf "$work"
}

@test "repo-baseline setup: fresh install writes all files in actual mode" {
  
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  # Need to provide answers for CI template selection and guided checklist
  # Format: template choice (7=skip), step confirmations (n, n)
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key SHOP 2>&1"
  
  [ "$status" -eq 0 ]
  
  # All files should exist
  [ -f "$work/.github/workflows/traceability.yml" ]
  [ -f "$work/.github/workflows/ci.yml" ]
  [ -f "$work/ci/test.sh" ]
  [ -f "$work/.githooks/commit-msg" ]
  [ -x "$work/.githooks/commit-msg" ]
  [ -f "$work/.github/PULL_REQUEST_TEMPLATE.md" ]
  [ -f "$work/docs/project-planning-traceability.md" ]

  run git -C "$work" config --local --get core.hooksPath
  [ "$status" -eq 0 ]
  [ "$output" = ".githooks" ]
  
  rm -rf "$work"
}

@test "repo-baseline setup: identical existing file treated as no-op" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Pre-create identical file
  mkdir -p "$work/.github/workflows"
  # Would need actual baseline content here
  echo "identical content" > "$work/.github/workflows/ci.yml"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  # Should indicate file already correct
  [[ "$output" == *"already installed"* ]] || [[ "$output" == *"up to date"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: differing file prompts in interactive mode" {
  
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Pre-create different file
  mkdir -p "$work/.github/workflows"
  echo "different content" > "$work/.github/workflows/ci.yml"
  
  cd "$work"
  # Answer: skip (s), then skip CI template (7), skip checklist (n, n)
  run bash -c "printf 's\n7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  # Should show conflict prompt
  [[ "$output" == *"exists"* ]] || [[ "$output" == *"conflict"* ]]
  # Original file should remain
  [ -f "$work/.github/workflows/ci.yml" ]
  grep -q "different content" "$work/.github/workflows/ci.yml"
  
  rm -rf "$work"
}

@test "repo-baseline setup: --force overwrites with timestamped backup" {
  
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Pre-create file
  mkdir -p "$work/.github/workflows"
  echo "original content" > "$work/.github/workflows/ci.yml"
  
  cd "$work"
  # Use DT_TIMESTAMP for deterministic backup name
  DT_TIMESTAMP="20260208-120000" run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --force --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  # Backup should exist with timestamp
  [ -f "$work/.github/workflows/ci.yml.backup-20260208-120000" ]
  grep -q "original content" "$work/.github/workflows/ci.yml.backup-20260208-120000"
  
  # New file should exist
  [ -f "$work/.github/workflows/ci.yml" ]
  ! grep -q "original content" "$work/.github/workflows/ci.yml"
  
  rm -rf "$work"
}

@test "repo-baseline setup: --non-interactive without --force fails on conflict" {
  
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Pre-create conflicting file
  mkdir -p "$work/.github/workflows"
  echo "existing content" > "$work/.github/workflows/ci.yml"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST
  
  [ "$status" -ne 0 ]
  # Should fail with conflict error
  [[ "$output" == *"exists"* ]] || [[ "$output" == *"conflict"* ]] || [[ "$output" == *"--force"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: preserves existing core.hooksPath" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"
  git -C "$work" config --local core.hooksPath ".git/hooks-custom"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST

  [ "$status" -eq 0 ]
  [[ "$output" == *"Existing core.hooksPath"* ]]

  run git -C "$work" config --local --get core.hooksPath
  [ "$status" -eq 0 ]
  [ "$output" = ".git/hooks-custom" ]

  rm -rf "$work"
}

# =============================================================================
# PLACEHOLDER REPLACEMENT (C)
# =============================================================================

@test "repo-baseline setup: replaces PROJECT_KEY placeholder correctly" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key MYAPP 2>&1"
  
  [ "$status" -eq 0 ]
  
  # Check that PROJECT_KEY was replaced in traceability workflow
  [ -f "$work/.github/workflows/traceability.yml" ]
  grep -q "MYAPP" "$work/.github/workflows/traceability.yml"
  ! grep -q "{{PROJECT_KEY}}" "$work/.github/workflows/traceability.yml"
  
  rm -rf "$work"
}

@test "repo-baseline setup: commit subject rule requires issue key at start" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"

  [ "$status" -eq 0 ]
  [ -f "$work/.github/workflows/traceability.yml" ]
  grep -Fq "^\[TEST-[0-9]+\][[:space:]]+.+$" "$work/.github/workflows/traceability.yml"

  rm -rf "$work"
}

@test "repo-baseline setup: installs local commit-msg hook with project key" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST

  [ "$status" -eq 0 ]
  [ -f "$work/.githooks/commit-msg" ]
  [ -x "$work/.githooks/commit-msg" ]
  grep -Fq "^\[TEST-[0-9]+\][[:space:]]+.+$" "$work/.githooks/commit-msg"

  rm -rf "$work"
}

@test "repo-baseline setup: issue-link workflow treats PR body as data" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST

  [ "$status" -eq 0 ]
  [ -f "$work/.github/workflows/traceability.yml" ]
  grep -Fq "PR_BODY: \${{ github.event.pull_request.body }}" "$work/.github/workflows/traceability.yml"
  grep -Fq "printf '%s\\n' \"\${PR_BODY:-}\" | grep -qiE '(closes|fixes) #[0-9]+'" "$work/.github/workflows/traceability.yml"

  rm -rf "$work"
}

@test "repo-baseline setup: type-label workflow uses issue labels API and robust count" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST

  [ "$status" -eq 0 ]
  [ -f "$work/.github/workflows/traceability.yml" ]
  grep -Fq "LABELS_API_URL: \${{ github.event.pull_request.issue_url }}/labels" "$work/.github/workflows/traceability.yml"
  ! grep -Fq "pull_request.labels_url" "$work/.github/workflows/traceability.yml"
  grep -Fq "TYPE_COUNT=\$(printf '%s\\n' \"\$TYPE_LABELS\" | awk 'NF {count++} END {print count+0}')" "$work/.github/workflows/traceability.yml"

  rm -rf "$work"
}

@test "repo-baseline setup: offers to reuse existing project key" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST
  [ "$status" -eq 0 ]

  run bash -c "printf 'y\n7\nn\nn\n' | '$(dt_bin)' repo-baseline setup 2>&1"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Detected existing project key: TEST"* ]]
  [[ "$output" == *"Use existing project key?"* ]]
  [[ "$output" == *"Project key: TEST"* ]]

  grep -q "TEST" "$work/.github/workflows/traceability.yml"

  rm -rf "$work"
}

@test "repo-baseline setup: can overwrite existing project key interactively" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST
  [ "$status" -eq 0 ]

  run bash -c "printf 'n\nNEW2\n7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --force 2>&1"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Detected existing project key: TEST"* ]]
  [[ "$output" == *"Enter new project key to overwrite existing configuration."* ]]
  [[ "$output" == *"Project key: NEW2"* ]]

  grep -q "NEW2" "$work/.github/workflows/traceability.yml"
  ! grep -q "TEST-<number>" "$work/.github/workflows/traceability.yml"

  rm -rf "$work"
}

@test "repo-baseline setup: fails on unknown placeholder in template" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  # Build a broken template directory by copying the real templates and injecting
  # an unknown placeholder into one file. The tool is pointed at this directory
  # via REPO_BASELINE_TEMPLATE_DIR.
  local dt_path
  dt_path="$(dt_bin)"
  local dt_root
  dt_root="$(cd "$(dirname "$dt_path")" && pwd)"

  local broken_templates
  broken_templates="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl-tpl")"
  mkdir -p "$broken_templates"
  cp -R "$dt_root/tools/repo-baseline.d/templates" "$broken_templates/templates"

  # Inject an unknown placeholder.
  echo "{{UNKNOWN_PLACEHOLDER}}" >> "$broken_templates/templates/workflows/ci.yml"

  cd "$work"
  run bash -c "export REPO_BASELINE_TEMPLATE_DIR='$broken_templates/templates'; printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"

  [ "$status" -ne 0 ]
  [[ "$output" == *"Unknown placeholder"* ]] || [[ "$output" == *"unknown placeholder"* ]]

  rm -rf "$work" "$broken_templates"
}

# =============================================================================
# DEFAULT CI ADAPTER BEHAVIOR (D)
# =============================================================================

@test "repo-baseline setup: default ci/test.sh fails with clear message" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  # Choose option 7 (skip template, use failing default)
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  # Test that ci/test.sh exists and fails appropriately
  [ -f "$work/ci/test.sh" ]
  [ -x "$work/ci/test.sh" ]
  
  run "$work/ci/test.sh"
  [ "$status" -ne 0 ]
  [[ "$output" == *"not configured"* ]] || [[ "$output" == *"Edit ci/test.sh"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: CI template selector defaults to skip on empty input" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  # Empty choice should default to 7 (skip)
  run bash -c "printf '\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"

  [ "$status" -eq 0 ]
  [ -f "$work/ci/test.sh" ]
  grep -q "Tests are not configured yet" "$work/ci/test.sh"

  rm -rf "$work"
}

@test "repo-baseline setup: warns before installing mismatched CI template" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  # Choose Android (1), decline mismatch install (n), then choose skip (7)
  run bash -c "printf '1\nn\n7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"

  [ "$status" -eq 0 ]
  [[ "$output" == *"Selected template may not match repository markers"* ]]
  [ -f "$work/ci/test.sh" ]
  ! grep -q "gradlew" "$work/ci/test.sh"

  rm -rf "$work"
}

@test "repo-baseline setup: Android template installs gradle command" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  touch "$work/gradlew"
  chmod +x "$work/gradlew"
  
  cd "$work"
  # Choose option 1 (Android)
  run bash -c "printf '1\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  [ -f "$work/ci/test.sh" ]
  grep -q "gradlew" "$work/ci/test.sh"
  
  rm -rf "$work"
}

@test "repo-baseline setup: Node template installs npm test" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  cat > "$work/package.json" <<'EOF'
{"name":"demo","version":"1.0.0"}
EOF
  
  cd "$work"
  # Choose option 3 (Node)
  run bash -c "printf '3\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  [ -f "$work/ci/test.sh" ]
  grep -q "npm test" "$work/ci/test.sh"
  
  rm -rf "$work"
}

# =============================================================================
# GUIDED CHECKLIST FLOW (E)
# =============================================================================

@test "repo-baseline setup: prints branch protection steps with GitHub URL" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  add_github_remote "$work" "https://github.com/testuser/myrepo.git"
  
  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  # Should show GitHub URL in instructions
  [[ "$output" == *"github.com/testuser/myrepo"* ]]
  # Should list all required status checks
  [[ "$output" == *"traceability/pr-title"* ]]
  [[ "$output" == *"traceability/commit-subjects"* ]]
  [[ "$output" == *"traceability/type-label"* ]]
  [[ "$output" == *"traceability/issue-link"* ]]
  [[ "$output" == *"ci"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: prints label creation steps" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  # Should list required labels
  [[ "$output" == *"type:feat"* ]]
  [[ "$output" == *"type:fix"* ]]
  [[ "$output" == *"type:docs"* ]]
  [[ "$output" == *"type:ci"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: skips checklist in --non-interactive mode" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  
  # Should NOT show interactive checklist
  [[ "$output" != *"Complete? [y/n]"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: waits for step confirmation in interactive mode" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  # Answer: skip template (7), confirm step 1 (y), confirm step 2 (y), confirm step 3 (y)
  run bash -c "printf '7\ny\ny\ny\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  
  [ "$status" -eq 0 ]
  
  # Should show step-by-step confirmation
  [[ "$output" == *"Step 1/3"* ]]
  [[ "$output" == *"Step 2/3"* ]]
  [[ "$output" == *"Step 3/3"* ]]
  [[ "$output" == *"Complete? [y/n]"* ]]
  
  rm -rf "$work"
}

# =============================================================================
# STATUS COMMAND
# =============================================================================

@test "repo-baseline status: shows not installed when no files present" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline status
  
  [ "$status" -eq 0 ]
  [[ "$output" == *"0/7"* ]] || [[ "$output" == *"not installed"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline status: shows installed files count" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Install baseline
  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  [ "$status" -eq 0 ]
  
  # Check status
  run "$(dt_bin)" repo-baseline status
  [ "$status" -eq 0 ]
  [[ "$output" == *"7/7"* ]] || [[ "$output" == *"✅"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline status: detects project key from existing files" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Install with project key
  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key MYAPP 2>&1"
  [ "$status" -eq 0 ]
  
  # Status should show the key
  run "$(dt_bin)" repo-baseline status
  [ "$status" -eq 0 ]
  [[ "$output" == *"MYAPP"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline status: accepts --repo flag" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  local elsewhere
  elsewhere="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl-other")"
  
  create_test_repo "$work"
  
  # Install baseline
  cd "$work"
  run bash -c "printf '7\nn\nn\n' | '$(dt_bin)' repo-baseline setup --project-key TEST 2>&1"
  [ "$status" -eq 0 ]
  
  # Check status from different directory
  cd "$elsewhere"
  run "$(dt_bin)" repo-baseline status --repo "$work"
  [ "$status" -eq 0 ]
  [[ "$output" == *"$work"* ]]
  
  rm -rf "$work" "$elsewhere"
}

# =============================================================================
# NON-INTERACTIVE MODE REQUIREMENTS
# =============================================================================

@test "repo-baseline setup: --non-interactive requires --project-key" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive
  
  [ "$status" -ne 0 ]
  [[ "$output" == *"project-key"* ]] || [[ "$output" == *"required"* ]]
  
  rm -rf "$work"
}

@test "repo-baseline setup: --non-interactive with --project-key succeeds" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST --dry-run
  
  [ "$status" -eq 0 ]
  
  rm -rf "$work"
}

@test "repo-baseline setup: --non-interactive reuses existing project key" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"

  create_test_repo "$work"

  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key TEST
  [ "$status" -eq 0 ]

  run "$(dt_bin)" repo-baseline setup --non-interactive --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"Using existing project key: TEST"* ]]
  [[ "$output" == *"{{PROJECT_KEY}} → TEST"* ]]

  rm -rf "$work"
}

# =============================================================================
# DRY RUN MODE
# =============================================================================

@test "repo-baseline setup: --dry-run shows plan without writing files" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  
  # Should show what would be done
  [[ "$output" == *"would"* ]] || [[ "$output" == *"dry"* ]] || [[ "$output" == *"plan"* ]]
  
  # No files should be created
  [ ! -d "$work/.github/workflows" ]
  [ ! -d "$work/ci" ]
  [ ! -f "$work/.github/PULL_REQUEST_TEMPLATE.md" ]
  
  rm -rf "$work"
}

# =============================================================================
# EDGE CASES
# =============================================================================

@test "repo-baseline setup: handles repo with existing .github directory" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  mkdir -p "$work/.github/workflows"
  
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --dry-run --non-interactive --project-key TEST
  
  [ "$status" -eq 0 ]
  
  rm -rf "$work"
}

@test "repo-baseline setup: validates project key format" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-rbl")"
  
  create_test_repo "$work"
  
  # Invalid key: contains spaces
  cd "$work"
  run "$(dt_bin)" repo-baseline setup --non-interactive --project-key "INVALID KEY"
  
  [ "$status" -ne 0 ]
  [[ "$output" == *"invalid"* ]] || [[ "$output" == *"format"* ]]
  
  rm -rf "$work"
}
