# Shared helpers for Bats tests.
#
# Intent:
# - Keep tests deterministic by running dt from the repo root.
# - Isolate HOME so tools that touch ~/.gitconfig or ~/.config do not mutate
#   the developer machine or CI runner state.

repo_root() {
  # BATS_TEST_DIRNAME points to '<repo>/test'.
  cd "${BATS_TEST_DIRNAME}/.." && pwd
}

dt_bin() {
  echo "$(repo_root)/dt"
}

make_temp_home() {
  # mktemp portability: macOS requires a template.
  if command -v mktemp >/dev/null 2>&1; then
    mktemp -d 2>/dev/null || mktemp -d -t "dt-home"
    return 0
  fi
  echo "mktemp is required for tests" >&2
  return 1
}

assert_file_contains_line() {
  local file="$1"
  local expected_line="$2"
  if [[ ! -f "${file}" ]]; then
    echo "Expected file to exist: ${file}" >&2
    return 1
  fi
  grep -Fxq "${expected_line}" "${file}"
}
