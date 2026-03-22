#!/usr/bin/env bats

load "support/test_helpers.bash"

create_project_dir() {
  local root_dir
  root_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-docs")"
  mkdir -p "${root_dir}/alpha-launchpad"
  printf '%s\n' "${root_dir}/alpha-launchpad"
}

@test "docs help paths print correctly" {
  run "$(dt_bin)" docs
  [ "$status" -eq 0 ]
  [[ "$output" == docs* ]]
  [[ "$output" == *$'\nUsage:'* ]]
  [[ "$output" == *"dt docs init [--dest PATH] [--project-name NAME] [--dry-run] [--force] [--yes]"* ]]
  [[ "$output" != *"### END HELP"* ]]

  run "$(dt_bin)" help docs
  [ "$status" -eq 0 ]
  [[ "$output" == docs* ]]
  [[ "$output" == *$'\nUsage:'* ]]
  [[ "$output" == *"dt docs init"* ]]
  [[ "$output" != *"### END HELP"* ]]
}

@test "docs init installs the standard pack into the current directory" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --yes"
  [ "$status" -eq 0 ]
  [[ "$output" == *"create: docs/README.md"* ]]
  [[ "$output" == *"Result:"* ]]

  [ -f "${project_dir}/docs/README.md" ]
  [ -f "${project_dir}/docs/00-foundation/product-vision-spec.md" ]
  [ -f "${project_dir}/docs/10-product-systems/example-system-spec.md" ]
  [ -f "${project_dir}/docs/20-libraries/example-library-spec.md" ]
  [ -f "${project_dir}/docs/30-delivery/implementation-plan.md" ]
  [ -f "${project_dir}/docs/40-decisions/adr-001-use-decision-layer-doc-architecture.md" ]
  [ -f "${project_dir}/docs/90-archive/README.md" ]

  run grep -F "# Alpha Launchpad — Product Vision Spec" "${project_dir}/docs/00-foundation/product-vision-spec.md"
  [ "$status" -eq 0 ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init skips existing files on the second run by default" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --yes >/dev/null"
  [ "$status" -eq 0 ]

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init"
  [ "$status" -eq 0 ]
  [[ "$output" == *"skip: docs/README.md"* ]]
  [[ "$output" == *"No writes were needed."* ]]
  [[ "$output" == *"skipped: 15"* ]]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init dry-run makes no filesystem changes" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --dry-run"
  [ "$status" -eq 0 ]
  [[ "$output" == *"would create: docs/README.md"* ]]
  [[ "$output" == *"Dry run only. No files were written."* ]]

  [ ! -e "${project_dir}/docs" ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init rejects unknown arguments with exit code 2" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --bogus"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Unknown argument: --bogus"* ]]
  [[ "$output" == *"Usage: dt docs init"* ]]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init rejects missing flag values with exit code 2" {
  local project_dir
  project_dir="$(create_project_dir)"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --dest"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Missing value for --dest"* ]]

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-name"
  [ "$status" -eq 2 ]
  [[ "$output" == *"Missing value for --project-name"* ]]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init force overwrites template-owned collisions" {
  local project_dir
  project_dir="$(create_project_dir)"
  local vision_file="${project_dir}/docs/00-foundation/product-vision-spec.md"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --yes >/dev/null"
  [ "$status" -eq 0 ]

  printf '%s\n' 'custom change' >"${vision_file}"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --force --yes"
  [ "$status" -eq 0 ]
  [[ "$output" == *"overwrite: docs/00-foundation/product-vision-spec.md"* ]]
  [[ "$output" == *"overwritten: 15"* ]]

  run grep -F "# Alpha Launchpad — Product Vision Spec" "${vision_file}"
  [ "$status" -eq 0 ]

  rm -rf "$(dirname "${project_dir}")"
}

@test "docs init applies explicit project-name replacement" {
  local root_dir
  root_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-docs")"
  local project_dir="${root_dir}/demo"

  mkdir -p "${project_dir}"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' docs init --project-name 'Nova Console' --yes"
  [ "$status" -eq 0 ]

  run grep -F "# Nova Console — Product Vision Spec" "${project_dir}/docs/00-foundation/product-vision-spec.md"
  [ "$status" -eq 0 ]

  run grep -F "# Nova Console — Implementation Plan" "${project_dir}/docs/30-delivery/implementation-plan.md"
  [ "$status" -eq 0 ]

  rm -rf "${root_dir}"
}

@test "docs init supports destination paths with spaces" {
  local root_dir
  root_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-docs")"
  local destination_dir="${root_dir}/Project Docs"

  run bash -c "cd '${root_dir}' && '$(dt_bin)' docs init --dest '${destination_dir}' --yes"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Target: ${destination_dir}"* ]]

  [ -f "${destination_dir}/docs/README.md" ]
  [ -f "${destination_dir}/docs/00-foundation/system-architecture-spec.md" ]

  rm -rf "${root_dir}"
}
