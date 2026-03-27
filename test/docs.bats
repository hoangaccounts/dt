#!/usr/bin/env bats

load "support/test_helpers.bash"

DT_DOCS_TEMPLATE_METADATA=""
DT_DOCS_TEMPLATE_BACKUP=""
DT_DOCS_PROJECT_ROOT=""

cleanup_docs_template_metadata() {
  if [[ -n "${DT_DOCS_TEMPLATE_BACKUP}" && -f "${DT_DOCS_TEMPLATE_BACKUP}" ]]; then
    mv "${DT_DOCS_TEMPLATE_BACKUP}" "${DT_DOCS_TEMPLATE_METADATA}"
  elif [[ -n "${DT_DOCS_TEMPLATE_METADATA}" ]]; then
    rm -f "${DT_DOCS_TEMPLATE_METADATA}"
  fi

  if [[ -n "${DT_DOCS_PROJECT_ROOT}" && -d "${DT_DOCS_PROJECT_ROOT}" ]]; then
    rm -rf "$(dirname "${DT_DOCS_PROJECT_ROOT}")"
  fi

  DT_DOCS_TEMPLATE_METADATA=""
  DT_DOCS_TEMPLATE_BACKUP=""
  DT_DOCS_PROJECT_ROOT=""
}

create_project_dir() {
  local root_dir
  root_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-docs")"
  mkdir -p "${root_dir}/alpha-launchpad"
  printf '%s\n' "${root_dir}/alpha-launchpad"
}

write_repo_baseline_marker() {
  local project_dir="$1"
  local project_key="$2"

  mkdir -p "${project_dir}/.github/workflows"
  cat >"${project_dir}/.github/workflows/traceability.yml" <<EOF
name: traceability
jobs:
  check:
    steps:
      - run: echo "[${project_key}-123] Example commit subject"
EOF
}

assert_draft_first_tree() {
  local project_dir="$1"
  local project_prefix="$2"

  [ -f "${project_dir}/AGENT.md" ]
  [ -f "${project_dir}/docs/README.md" ]
  [ -f "${project_dir}/docs/00-foundation/README.md" ]
  [ -f "${project_dir}/docs/05-working/README.md" ]
  [ -f "${project_dir}/docs/05-working/foundation/README.md" ]
  [ -f "${project_dir}/docs/05-working/product-systems/README.md" ]
  [ -f "${project_dir}/docs/05-working/decisions/README.md" ]
  [ -f "${project_dir}/docs/05-working/delivery/README.md" ]
  [ -f "${project_dir}/docs/05-working/libraries/README.md" ]
  [ -f "${project_dir}/docs/05-working/research/README.md" ]
  [ -f "${project_dir}/docs/10-product-systems/README.md" ]
  [ -f "${project_dir}/docs/20-decisions/README.md" ]
  [ -f "${project_dir}/docs/30-delivery/README.md" ]
  [ -f "${project_dir}/docs/40-libraries/README.md" ]
  [ -f "${project_dir}/docs/50-research/README.md" ]
  [ -f "${project_dir}/docs/90-archive/README.md" ]

  [ -f "${project_dir}/docs/05-working/foundation/draft-${project_prefix}-foundation-product-vision-spec.md" ]
  [ -f "${project_dir}/docs/05-working/foundation/draft-${project_prefix}-foundation-system-architecture-spec.md" ]
  [ -f "${project_dir}/docs/05-working/product-systems/draft-${project_prefix}-system-example-spec.md" ]
  [ -f "${project_dir}/docs/05-working/delivery/draft-${project_prefix}-delivery-example-v1-implementation-spec.md" ]
  [ -f "${project_dir}/docs/05-working/research/draft-${project_prefix}-research-open-questions-spec.md" ]

  [ ! -e "${project_dir}/docs/00-foundation/product-vision-spec.md" ]
  [ ! -e "${project_dir}/docs/10-product-systems/example-system-spec.md" ]
  [ ! -e "${project_dir}/docs/20-libraries" ]
  [ ! -e "${project_dir}/docs/40-decisions" ]
}

@test "docs help paths print correctly" {
  run "$(dt_bin)" docs
  [ "$status" -eq 0 ]
  [[ "$output" == *"dt docs init [--dest PATH] [--project-name NAME] [--project-prefix PREFIX] [--dry-run] [--force] [--yes]"* ]]
  [[ "$output" == *"draft-first"* ]]
  [[ "$output" == *"AGENT.md"* ]]
  [[ "$output" != *"### END HELP"* ]]

  run "$(dt_bin)" help docs
  [ "$status" -eq 0 ]
  [[ "$output" == *"dt docs init"* ]]
  [[ "$output" == *"--project-prefix <prefix>"* ]]
  [[ "$output" != *"### END HELP"* ]]
}

@test "docs init installs the draft-first standard pack into the current directory" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix alp --yes 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"create: AGENT.md"* ]]
  [[ "$output" == *"create: docs/05-working/foundation/draft-alp-foundation-product-vision-spec.md"* ]]
  [[ "$output" != *".DS_Store"* ]]
  [[ "$output" == *"Project prefix: alp"* ]]
  [[ "$output" == *"AGENT.md: created"* ]]

  assert_draft_first_tree "${project_dir}" "alp"
  [ ! -e "${project_dir}/.DS_Store" ]
  [ ! -e "${project_dir}/docs/.DS_Store" ]

  run grep -F "# Draft — Alpha Launchpad Product Vision Spec" "${project_dir}/docs/05-working/foundation/draft-alp-foundation-product-vision-spec.md"
  [ "$status" -eq 0 ]

  run grep -F "docs/05-working/**" "${project_dir}/AGENT.md"
  [ "$status" -eq 0 ]

  run grep -F "Every file under \`docs/05-working/**\` must begin with \`draft-\`." "${project_dir}/AGENT.md"
  [ "$status" -eq 0 ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init ignores macOS metadata files in the template tree" {
  local project_dir
  project_dir="$(create_project_dir)"

  DT_DOCS_PROJECT_ROOT="${project_dir}"
  DT_DOCS_TEMPLATE_METADATA="$(repo_root)/templates/docs-standard/v1/docs/.DS_Store"
  DT_DOCS_TEMPLATE_BACKUP=""
  trap cleanup_docs_template_metadata EXIT

  if [[ -f "${DT_DOCS_TEMPLATE_METADATA}" ]]; then
    DT_DOCS_TEMPLATE_BACKUP="$(mktemp 2>/dev/null || mktemp -t "dt-docs-ds-store")"
    cp "${DT_DOCS_TEMPLATE_METADATA}" "${DT_DOCS_TEMPLATE_BACKUP}"
  fi

  printf '\377\376binary-metadata\n' >"${DT_DOCS_TEMPLATE_METADATA}"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix alp --yes 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" != *".DS_Store"* ]]
  [ ! -e "${project_dir}/docs/.DS_Store" ]
}

@test "docs init infers project prefix from repo-baseline and confirms with the user" {
  local project_dir
  project_dir="$(create_project_dir)"
  write_repo_baseline_marker "${project_dir}" "SHOP"

  run bash -c "cd '${project_dir}' && printf 'y\ny\n' | '$(dt_bin)' docs init 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Detected project prefix candidate from repo-baseline: shop"* ]]
  [[ "$output" == *"Use detected project prefix? [y/N]:"* ]]
  [[ "$output" == *"Project prefix: shop (confirmed from repo-baseline)"* ]]

  [ -f "${project_dir}/docs/05-working/foundation/draft-shop-foundation-product-vision-spec.md" ]
  [ ! -f "${project_dir}/docs/05-working/foundation/draft-{{PROJECT_PREFIX}}-foundation-product-vision-spec.md" ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init allows manual deferred project-prefix installation" {
  local project_dir
  project_dir="$(create_project_dir)"
  local deferred_file="${project_dir}/docs/05-working/foundation/draft-{{PROJECT_PREFIX}}-foundation-product-vision-spec.md"

  run bash -c "cd '${project_dir}' && printf '\ny\n' | '$(dt_bin)' docs init 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Project prefix (lowercase letters, numbers, hyphens; leave blank to defer):"* ]]
  [[ "$output" == *"Project prefix: deferred ({{PROJECT_PREFIX}} retained)"* ]]

  [ -f "${deferred_file}" ]

  run grep -F "{{PROJECT_PREFIX}}" "${deferred_file}"
  [ "$status" -eq 0 ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init skips existing files on the second run by default" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix alp --yes >/dev/null 2>&1"
  [ "$status" -eq 0 ]

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix alp 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"skip: AGENT.md"* ]]
  [[ "$output" == *"skip: docs/05-working/foundation/draft-alp-foundation-product-vision-spec.md"* ]]
  [[ "$output" == *"No writes were needed."* ]]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init dry-run makes no filesystem changes" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --dry-run 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"would create: AGENT.md"* ]]
  [[ "$output" == *"Project prefix: deferred ({{PROJECT_PREFIX}} retained)"* ]]
  [[ "$output" == *"Dry run only. No files were written."* ]]

  [ ! -e "${project_dir}/AGENT.md" ]
  [ ! -e "${project_dir}/docs" ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init rejects unknown arguments with exit code 2" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --bogus 2>&1"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Unknown argument: --bogus"* ]]
  [[ "$output" == *"Usage: dt docs init"* ]]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init rejects missing flag values with exit code 2" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --dest 2>&1"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Missing value for --dest"* ]]

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-name 2>&1"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Missing value for --project-name"* ]]

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix 2>&1"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Missing value for --project-prefix"* ]]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init force overwrites template-owned collisions" {
  local project_dir
  project_dir="$(create_project_dir)"
  local vision_file="${project_dir}/docs/05-working/foundation/draft-alp-foundation-product-vision-spec.md"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix alp --yes >/dev/null 2>&1"
  [ "$status" -eq 0 ]

  printf '%s\n' 'custom change' >"${vision_file}"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-prefix alp --force --yes 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"overwrite: AGENT.md"* ]]
  [[ "$output" == *"overwrite: docs/05-working/foundation/draft-alp-foundation-product-vision-spec.md"* ]]
  [[ "$output" == *"overwritten:"* ]]

  run grep -F "# Draft — Alpha Launchpad Product Vision Spec" "${vision_file}"
  [ "$status" -eq 0 ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init applies explicit project-name replacement" {
  local root_dir
  root_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-docs")"
  local project_dir="${root_dir}/demo"

  mkdir -p "${project_dir}"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-name 'Nova Console' --project-prefix nc --yes 2>&1"
  [ "$status" -eq 0 ]

  run grep -F "# Draft — Nova Console Product Vision Spec" "${project_dir}/docs/05-working/foundation/draft-nc-foundation-product-vision-spec.md"
  [ "$status" -eq 0 ]

  run grep -F "# Draft — Nova Console System Architecture Spec" "${project_dir}/docs/05-working/foundation/draft-nc-foundation-system-architecture-spec.md"
  [ "$status" -eq 0 ]

  rm -rf "${root_dir}"
}

@test "docs init supports destination paths with spaces" {
  local root_dir
  root_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-docs")"
  local destination_dir="${root_dir}/Project Docs"

  run bash -c "cd '${root_dir}' && '$(dt_bin)' docs init --dest '${destination_dir}' --project-prefix pd --yes 2>&1"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Target: ${destination_dir}"* ]]

  [ -f "${destination_dir}/AGENT.md" ]
  [ -f "${destination_dir}/docs/05-working/foundation/draft-pd-foundation-system-architecture-spec.md" ]

  rm -rf "${root_dir}"
}
