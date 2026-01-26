#!/usr/bin/env bats

load "support/test_helpers.bash"

@test "jump-dir help prints" {
  run "$(dt_bin)" help jump-dir
  [ "$status" -eq 0 ]
  [[ "$output" == VERSION:* ]]
  [[ "$output" == *$'\nSUMMARY:'* ]]
  [[ "$output" == *$'\nTAGS:'* ]]

  # dt renders this header label as "Safety:" (not "SAFETY:").
  [[ "$output" == *$'\nSafety:'* ]]
}

@test "jump-dir add-here + path resolves" {
  local home
  home="$(make_temp_home)"

  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-work")"

  run bash -c "cd '${work}' && HOME='${home}' '$(dt_bin)' jump-dir add-here gs"
  [ "$status" -eq 0 ]

  run bash -c "cd '${work}' && HOME='${home}' '$(dt_bin)' jump-dir path gs"
  [ "$status" -eq 0 ]
  [ "$output" = "${work}" ]

  rm -rf "${work}" "${home}" || true
}

@test "jump-dir install writes rc block and uninstall removes it" {
  local home
  home="$(make_temp_home)"

  local rc_file="${home}/.zshrc"

  run bash -c "HOME='${home}' SHELL='/bin/zsh' '$(dt_bin)' jump-dir install --yes"
  if [ "$status" -ne 0 ]; then
    echo "install output:" >&2
    echo "$output" >&2
  fi
  [ "$status" -eq 0 ]

  # New behavior: shell-specific integration files.
  [ -f "${home}/.dt/jump-dir/jump-dir.zsh" ]
  [ -f "${home}/.dt/jump-dir/jump-dir.bash" ]
  [ -f "${home}/.dt/jump-dir/aliases" ]

  assert_file_contains_line "${rc_file}" "# dt:jump-dir start"
  assert_file_contains_line "${rc_file}" "# dt:jump-dir end"

  run bash -c "HOME='${home}' SHELL='/bin/zsh' '$(dt_bin)' jump-dir uninstall --yes"
  if [ "$status" -ne 0 ]; then
    echo "uninstall output:" >&2
    echo "$output" >&2
  fi
  [ "$status" -eq 0 ]

  [ ! -f "${home}/.dt/jump-dir/jump-dir.zsh" ]
  [ ! -f "${home}/.dt/jump-dir/jump-dir.bash" ]

  # Keep aliases file to preserve user mappings across uninstall.
  [ -f "${home}/.dt/jump-dir/aliases" ]

  if [[ -f "${rc_file}" ]]; then
    ! grep -Fq "# dt:jump-dir start" "${rc_file}"
    ! grep -Fq "# dt:jump-dir end" "${rc_file}"
  fi

  rm -rf "${home}" || true
}
