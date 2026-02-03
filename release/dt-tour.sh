#!/usr/bin/env bash
# dt_devlog2_terminal_tour_v12.sh
#
# Fixes zip-project output failure from v11:
# - zip-project appears to `cd` into the output directory; when a relative path is used,
#   that can break if the tool changes working dirs internally.
# - We now use an ABSOLUTE output directory path and ensure it exists right before zipping.
#
# Prompt demo: removed (as requested).
# Jump-dir demo: clear home ↔ dt ↔ dt/tools story.
#
# Safe demo mode:
# - HOME=./_dt_demo_home so install steps do NOT touch your real dotfiles.
#
# Usage:
#   cd <dt-repo-root>
#   asciinema rec dt-devlog2.cast
#   bash ./dt_devlog2_terminal_tour_v12.sh
set -euo pipefail

TYPE_DELAY_SECONDS="0.105"
PAUSE_AFTER_CMD_SECONDS="1.35"
PAUSE_BETWEEN_SECTIONS="1.80"

DEMO_HOME="./_dt_demo_home"
OUT_DIR_REL="./_dt_demo_output"

banner() {
  local title="$1"
  printf "\n\n==========================\n%s\n==========================\n" "${title}"
  sleep "${PAUSE_BETWEEN_SECTIONS}"
}

print_prompt() {
  printf "\n%s$ " "dt feature_labs*  ✓"
}

type_text() {
  local text="$1"
  local i
  for (( i=0; i<${#text}; i++ )); do
    printf "%s" "${text:i:1}"
    sleep "${TYPE_DELAY_SECONDS}"
  done
  printf "\n"
}

run_cmd() {
  local cmd="$1"
  print_prompt
  type_text "${cmd}"
  # shellcheck disable=SC2090
  eval "${cmd}"
  sleep "${PAUSE_AFTER_CMD_SECONDS}"
}

require_repo() {
  [[ -f "./dt" ]] || { echo "ERROR: ./dt not found. cd into the dt repo root first."; exit 1; }
  [[ -d "./tools" ]] || { echo "ERROR: ./tools not found. cd into the dt repo root first."; exit 1; }
}

setup_demo_home() {
  mkdir -p "${DEMO_HOME}"

  export HOME
  HOME="$(cd "${DEMO_HOME}" && pwd -P)"

  # Make `dt` resolvable without `./dt`.
  export PATH
  PATH="$(pwd -P):${PATH}"

  export LANG="C"
  export LC_ALL="C"
}

clear
require_repo
setup_demo_home

# Compute absolute repo + output paths once (keeps zip-project stable).
REPO_ROOT_ABS="$(pwd -P)"
OUT_DIR_ABS="${REPO_ROOT_ABS}/${OUT_DIR_REL#./}"
ZIP_ABS="${OUT_DIR_ABS}/dt-demo.zip"

banner "DT OVERVIEW (why: one entry point)"
run_cmd "dt list"
run_cmd "dt tags"

banner "SHOWING GIT ALIASES (ga) DEMO"
run_cmd "dt ga list"
run_cmd "dt ga install --yes"
run_cmd "git st -sb"
run_cmd "git lg -5"
run_cmd "git st"
run_cmd "git br"

banner "SHOWING JUMP DIR (jd) DEMO"
run_cmd "dt jd install --yes"
run_cmd "source \"./_dt_demo_home/.dt/jump-dir/jump-dir.bash\""

run_cmd "cd ~"
run_cmd "pwd -P"
run_cmd "dt jd add-here home"

run_cmd "cd \"${REPO_ROOT_ABS}\""
run_cmd "pwd -P"
run_cmd "dt jd add-here dt"

run_cmd "dt jd list"
run_cmd "jd home"
run_cmd "pwd -P"
run_cmd "jd dt"
run_cmd "pwd -P"
run_cmd "jd dt/tools"
run_cmd "pwd -P"
run_cmd "jd home"
run_cmd "pwd -P"

banner "SHOWING ZIP PROJECT (zp) DEMO"
# Ensure output dir exists (absolute path avoids internal `cd` surprises).
run_cmd "mkdir -p \"${OUT_DIR_ABS}\""
run_cmd "rm -f \"${ZIP_ABS}\" || true"
run_cmd "dt zp run . --output \"${ZIP_ABS}\""
run_cmd "ls -lh \"${OUT_DIR_ABS}\""
run_cmd "unzip -l \"${ZIP_ABS}\" | head -n 18"

banner "DONE (NEXT: ai-context deep dive)"
printf "\nCreated demo artifacts:\n  - %s\n" "${ZIP_ABS}"
printf "Demo HOME (isolated):\n  - %s\n\n" "${HOME}"
