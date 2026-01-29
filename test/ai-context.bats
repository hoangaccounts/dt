#!/usr/bin/env bats

load "support/test_helpers.bash"

@test "ai-context help prints" {
  run "$(dt_bin)" help ai-context
  [ "$status" -eq 0 ]
}

@test "ai-context status shows installation state" {
  run "$(dt_bin)" ai-context status
  [ "$status" -eq 0 ]
  [[ "$output" == *"Context library:"* ]]
  [[ "$output" == *"Projects:"* ]]
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
  [[ "$output" == *"Error"* ]]
}

@test "ai-context update requires project name and file" {
  run "$(dt_bin)" ai-context update
  [ "$status" -ne 0 ]
  [[ "$output" == *"Project name required"* ]]
}
