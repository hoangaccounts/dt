#!/usr/bin/env bats

load "support/test_helpers.bash"

setup() {
  export ORIGINAL_HOME="${HOME}"
  export TEMP_HOME
  TEMP_HOME="$(make_temp_home)"
  export HOME="${TEMP_HOME}"
}

teardown() {
  rm -rf "${TEMP_HOME}" || true
  export HOME="${ORIGINAL_HOME}"
}

@test "git-aliases list prints a gitconfig block" {
  run "$(dt_bin)" git-aliases list
  [ "$status" -eq 0 ]
  [[ "$output" == *"[alias]"* ]]
  [[ "$output" == *"st = status"* ]]
}

@test "git-aliases install is idempotent and updates gitconfig include" {
  local include_file="${HOME}/.config/dt/git-aliases.gitconfig"

  run "$(dt_bin)" git-aliases install --yes
  [ "$status" -eq 0 ]
  [ -f "${include_file}" ]

  local gitconfig_file="${HOME}/.gitconfig"
  grep -Eq "^[[:space:]]*path = ${include_file}$" "${gitconfig_file}"

  # Re-run install; should not add duplicate includes.
  run "$(dt_bin)" git-aliases install --yes
  [ "$status" -eq 0 ]

  local count
  count="$(grep -Ec "^[[:space:]]*path = ${include_file}$" "${gitconfig_file}")"
  [ "${count}" -eq 1 ]
}

@test "git-aliases uninstall removes include and deletes include file" {
  local include_file="${HOME}/.config/dt/git-aliases.gitconfig"
  local gitconfig_file="${HOME}/.gitconfig"

  run "$(dt_bin)" git-aliases install --yes
  [ "$status" -eq 0 ]
  [ -f "${include_file}" ]

  run "$(dt_bin)" git-aliases uninstall --yes
  [ "$status" -eq 0 ]
  [ ! -f "${include_file}" ]

  # If the gitconfig exists, it should not include our include file.
  if [ -f "${gitconfig_file}" ]; then
    ! grep -Eq "^[[:space:]]*path = ${include_file}$" "${gitconfig_file}"
  fi
}
