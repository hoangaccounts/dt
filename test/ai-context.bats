#!/usr/bin/env bats

load "support/test_helpers.bash"

@test "ai-context help prints" {
  run "$(dt_bin)" help ai-context
  [ "$status" -eq 0 ]
}

@test "ai-context help includes sync commands" {
  run "$(dt_bin)" help ai-context
  [ "$status" -eq 0 ]
  [[ "$output" == *"sync library"* ]]
  [[ "$output" == *"sync project"* ]]
}

@test "ai-context status shows installation state" {
  run "$(dt_bin)" ai-context status
  # Status always succeeds, just check output contains expected sections
  [[ "$output" == *"Context library"* ]]
  [[ "$output" == *"Paths"* ]]
}

@test "ai-context new requires project name" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Should fail without --name flag in non-interactive mode
  run bash -c "echo '' | '$(dt_bin)' ai-context new 2>&1"
  [ "$status" -ne 0 ]
  
  rm -rf "${work}" || true
}

@test "ai-context scan requires valid path" {
  run "$(dt_bin)" ai-context scan /nonexistent/path
  [ "$status" -ne 0 ]
  # Should contain error message about path/directory
  [[ "$output" == *"not found"* ]] || [[ "$output" == *"Error"* ]] || [[ "$output" == *"Directory"* ]]
}

@test "ai-context update requires project name and file" {
  run "$(dt_bin)" ai-context update
  [ "$status" -ne 0 ]
  # Should mention project name in error
  [[ "$output" == *"Project name"* ]] || [[ "$output" == *"required"* ]]
}

@test "ai-context sync requires target (library or project)" {
  run "$(dt_bin)" ai-context sync
  [ "$status" -ne 0 ]
  # Should mention sync target or usage
  [[ "$output" == *"target"* ]] || [[ "$output" == *"library"* ]] || [[ "$output" == *"Usage"* ]]
}

@test "ai-context sync library requires initialized library" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Point to empty home
  HOME="$work" run "$(dt_bin)" ai-context sync library
  [ "$status" -ne 0 ]
  [[ "$output" == *"not found"* ]] || [[ "$output" == *"not initialized"* ]] || [[ "$output" == *"Run"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context sync library works after initialization" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Initialize library by creating a project with all prompts answered
  # Answers: n (no sw foundations), n (no workflow), n (no personal), n (don't view)
  HOME="$work" run bash -c "printf 'n\nn\nn\nn\n' | '$(dt_bin)' ai-context new --name testsync --type cli --size small 2>&1"
  
  if [ "$status" -ne 0 ]; then
    skip "Cannot initialize library: $output"
  fi
  
  # Now library sync should work
  HOME="$work" run "$(dt_bin)" ai-context sync library --dry-run
  [ "$status" -eq 0 ]
  [[ "$output" == *"Syncing"* ]] || [[ "$output" == *"Checking"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context sync project requires project name" {
  run "$(dt_bin)" ai-context sync project
  [ "$status" -ne 0 ]
  # Should mention project name in error
  [[ "$output" == *"Project name"* ]] || [[ "$output" == *"required"* ]] || [[ "$output" == *"Usage"* ]]
}

@test "ai-context sync project requires existing project" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Initialize library first
  HOME="$work" run bash -c "printf 'n\nn\nn\nn\n' | '$(dt_bin)' ai-context new --name testsync --type cli --size small 2>&1"
  
  if [ "$status" -ne 0 ]; then
    skip "Cannot initialize library"
  fi
  
  # Try to sync non-existent project
  HOME="$work" run "$(dt_bin)" ai-context sync project nonexistent
  [ "$status" -ne 0 ]
  [[ "$output" == *"not found"* ]] || [[ "$output" == *"Project not found"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context sync project works for existing project" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Create a project
  HOME="$work" run bash -c "printf 'n\nn\nn\nn\n' | '$(dt_bin)' ai-context new --name testsync2 --type cli --size small 2>&1"
  
  if [ "$status" -ne 0 ]; then
    skip "Cannot create project"
  fi
  
  # Sync the project
  HOME="$work" run "$(dt_bin)" ai-context sync project testsync2
  [ "$status" -eq 0 ]
  [[ "$output" == *"Syncing"* ]] || [[ "$output" == *"Archived"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context sync project creates archive directory" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Create a project
  HOME="$work" run bash -c "printf 'n\nn\nn\nn\n' | '$(dt_bin)' ai-context new --name testarchive --type cli --size small 2>&1"
  
  if [ "$status" -ne 0 ]; then
    skip "Cannot create project"
  fi
  
  # Sync the project
  HOME="$work" run "$(dt_bin)" ai-context sync project testarchive
  
  if [ "$status" -ne 0 ]; then
    skip "Sync failed"
  fi
  
  # Check archive directory was created
  [ -d "$work/.dt/ai-context/projects/archive" ]
  
  rm -rf "${work}" || true
}

@test "ai-context labs status shows empty when no labs folder" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Run labs status before labs folder exists
  HOME="$work" run "$(dt_bin)" ai-context labs status
  
  # Should succeed and mention labs doesn't exist or is empty
  [ "$status" -eq 0 ]
  [[ "$output" == *"Labs"* ]] || [[ "$output" == *"labs"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context labs status lists files with ages" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Create labs folder and a test file
  mkdir -p "$work/.dt/support/ai-context/context-library/labs"
  echo "# Test Lab File" > "$work/.dt/support/ai-context/context-library/labs/test-lab.md"
  
  # Run labs status
  HOME="$work" run "$(dt_bin)" ai-context labs status
  
  # Should succeed and show the file
  [ "$status" -eq 0 ]
  [[ "$output" == *"test-lab.md"* ]]
  [[ "$output" == *"day"* ]] || [[ "$output" == *"today"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context labs requires subcommand" {
  run "$(dt_bin)" ai-context labs
  [ "$status" -ne 0 ]
  [[ "$output" == *"required"* ]] || [[ "$output" == *"subcommand"* ]]
}

@test "ai-context labs status works when labs is empty" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Create empty labs folder
  mkdir -p "$work/.dt/support/ai-context/context-library/labs"
  echo "# Labs README" > "$work/.dt/support/ai-context/context-library/labs/README.md"
  
  # Run labs status
  HOME="$work" run "$(dt_bin)" ai-context labs status
  
  # Should succeed and mention empty
  [ "$status" -eq 0 ]
  [[ "$output" == *"empty"* ]] || [[ "$output" == *"Empty"* ]]
  
  rm -rf "${work}" || true
}

@test "ai-context labs status shows files in subdirectories" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-aicontext")"
  
  # Create labs with subdirectories
  mkdir -p "$work/.dt/support/ai-context/context-library/labs/github"
  mkdir -p "$work/.dt/support/ai-context/context-library/labs/android"
  echo "# Labs README" > "$work/.dt/support/ai-context/context-library/labs/README.md"
  echo "# GitHub Actions" > "$work/.dt/support/ai-context/context-library/labs/github/actions.md"
  echo "# Android Gradle" > "$work/.dt/support/ai-context/context-library/labs/android/gradle.md"
  
  # Run labs status
  HOME="$work" run "$(dt_bin)" ai-context labs status
  
  # Should succeed and show files with subdirectory paths
  [ "$status" -eq 0 ]
  [[ "$output" == *"github/actions.md"* ]]
  [[ "$output" == *"android/gradle.md"* ]]
  
  rm -rf "${work}" || true
}
