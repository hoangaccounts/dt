#!/usr/bin/env bats

load "support/test_helpers.bash"

require_cmd() {
  if ! command -v "${1}" >/dev/null 2>&1; then
    skip "Missing required command: ${1}"
  fi
}

@test "zip-project creates a compact archive using git mode (excludes ignored)" {
  require_cmd git
  require_cmd zip
  require_cmd unzip

  local project_dir
  project_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-zip-project")"
  local project_name
  project_name="$(basename "${project_dir}")"

  mkdir -p "${project_dir}/src"
  printf '%s\n' 'hello' >"${project_dir}/README.md"
  printf '%s\n' 'world' >"${project_dir}/src/main.txt"

  # Common bloat we should not include.
  mkdir -p "${project_dir}/node_modules"
  printf '%s\n' 'nope' >"${project_dir}/node_modules/big.txt"
  mkdir -p "${project_dir}/build"
  printf '%s\n' 'nope' >"${project_dir}/build/out.bin"

  # Git ignored file should not be included in git mode.
  printf '%s\n' 'secret.txt' >"${project_dir}/.gitignore"
  printf '%s\n' 'secret' >"${project_dir}/secret.txt"

  (cd "${project_dir}" && git init -q)
  (cd "${project_dir}" && git add README.md src/main.txt .gitignore >/dev/null)

  local output_zip
  output_zip="${project_dir}/out.zip"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' zip-project run . --mode git --output '${output_zip}'"
  [ "$status" -eq 0 ]
  [ -f "${output_zip}" ]

  # Verify included files.
  local files
  files="$(unzip -Z1 "${output_zip}" | sort)"
  [[ "${files}" == *"${project_name}/README.md"* ]]
  [[ "${files}" == *"${project_name}/src/main.txt"* ]]

  # Verify excluded files.
  [[ "${files}" != *"node_modules"* ]]
  [[ "${files}" != *"build"* ]]
  [[ "${files}" != *"secret.txt"* ]]

  rm -rf "${project_dir}" || true
}

@test "zip-project creates an archive using filesystem mode (excludes common caches)" {
  require_cmd zip
  require_cmd unzip

  local project_dir
  project_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-zip-project")"
  local project_name
  project_name="$(basename "${project_dir}")"

  mkdir -p "${project_dir}/lib"
  printf '%s\n' 'ok' >"${project_dir}/lib/app.txt"

  mkdir -p "${project_dir}/.gradle"
  printf '%s\n' 'nope' >"${project_dir}/.gradle/cache.bin"

  local output_zip
  output_zip="${project_dir}/out-fs.zip"

  run bash -c "cd '${project_dir}' && '$(dt_bin)' zip-project run . --mode fs --output '${output_zip}'"
  [ "$status" -eq 0 ]
  [ -f "${output_zip}" ]

  local files
  files="$(unzip -Z1 "${output_zip}" | sort)"
  [[ "${files}" == *"${project_name}/lib/app.txt"* ]]
  [[ "${files}" != *".gradle"* ]]

  rm -rf "${project_dir}" || true
}

@test "zip-project defaults output name to <dir-name>-<timestamp>.zip" {
  require_cmd zip
  require_cmd unzip

  local project_dir
  project_dir="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-zip-project")"
  local project_name
  project_name="$(basename "${project_dir}")"

  mkdir -p "${project_dir}/src"
  printf '%s\n' 'ok' >"${project_dir}/src/app.txt"

  # Freeze time for deterministic output naming.
  local ts
  ts="20260125-181000"

  local expected_zip
  expected_zip="${project_dir}/${project_name}-${ts}.zip"

  run bash -c "cd '${project_dir}' && DT_TIMESTAMP='${ts}' '$(dt_bin)' zip-project run . --mode fs"
  [ "$status" -eq 0 ]
  [ -f "${expected_zip}" ]

  local files
  files="$(unzip -Z1 "${expected_zip}" | sort)"
  [[ "${files}" == *"${project_name}/src/app.txt"* ]]

  rm -rf "${project_dir}" || true
}
