#!/usr/bin/env bats

load "support/test_helpers.bash"

@test "dt list shows discovered tools" {
  run "$(dt_bin)" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"git-aliases"* ]]
}

@test "dt tags reports approved tag counts" {
  run "$(dt_bin)" tags
  [ "$status" -eq 0 ]
  # At least one tool is tagged 'git'.
  echo "$output" | grep -E '^git[[:space:]]+[1-9][0-9]*$'
}

@test "dt help prints the tool header" {
  run "$(dt_bin)" help git-aliases
  [ "$status" -eq 0 ]
  [[ "$output" == git-aliases* ]]
  [[ "$output" == *$'\nUsage:'* ]]
  [[ "$output" == *$'\nSafety:'* ]]
  [[ "$output" != *"### END HELP"* ]]
}



@test "dt alias resolves to the tool" {
  run "$(dt_bin)" ga list
  [ "$status" -eq 0 ]
  [[ "$output" == *"[alias]"* ]]
}


@test "dt help accepts an alias" {
  run "$(dt_bin)" help ga
  [ "$status" -eq 0 ]
  [[ "$output" == git-aliases* ]]
}

@test "dt list flags invalid tools" {
  local tools_dir
  tools_dir="$(repo_root)/tools"
  local invalid_tool="${tools_dir}/_invalid-tool"

  # Create a fake executable with no header.
  printf '%s\n' '#!/usr/bin/env bash' 'echo hello' >"${invalid_tool}"
  chmod +x "${invalid_tool}"

  run "$(dt_bin)" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"Invalid tools"* ]]
  [[ "$output" == *"_invalid-tool"* ]]

  rm -f "${invalid_tool}"
}
