#!/usr/bin/env bats

load "support/test_helpers.bash"

setup() {
  export HOME="$(make_temp_home)"
  mkdir -p "${HOME}"
  : > "${HOME}/.zshrc"
}

@test "prompt help prints" {
  run "$(dt_bin)" help prompt
  [ "$status" -eq 0 ]
}

@test "prompt install writes rc block and uninstall removes it" {
  run "$(dt_bin)" prompt install --yes
  [ "$status" -eq 0 ]

  run grep -q "dt:prompt start" "${HOME}/.zshrc"
  [ "$status" -eq 0 ]

  run "$(dt_bin)" prompt uninstall --yes
  [ "$status" -eq 0 ]

  run grep -q "dt:prompt start" "${HOME}/.zshrc"
  [ "$status" -ne 0 ]
}

@test "prompt use sets preset" {
  run "$(dt_bin)" prompt install --yes
  [ "$status" -eq 0 ]

  run "$(dt_bin)" prompt use pomodoro
  [ "$status" -eq 0 ]

  run bash -lc "grep -q '^preset=pomodoro$' '${HOME}/.dt/prompt/config'"
  [ "$status" -eq 0 ]
}
