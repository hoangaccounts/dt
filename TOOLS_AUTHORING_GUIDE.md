# Tool Authoring Guide (dt-devtools)

This document is the **contract** for adding new tools to this repo. If you follow it, `dt` should discover the tool, `dt help <tool>` should render correctly, and `dt test` should prevent regressions.

---

## Tool contract summary

A new tool is considered “done” when:

1. A tool script exists at `tools/<tool-id>` and starts with the required help header (commented) ending in `### END HELP`.
2. The tool runs on **macOS Bash 3.2** (no Bash 4+ features like associative arrays).
3. The tool follows the repo’s **subcommand conventions** (`run` for actions; `install/uninstall/status` for setup tools when applicable).
4. Destructive/persistent changes require confirmation (`SAFETY: confirm`) and support `--yes`.
5. Zip output defaults to `<dir-name>-<timestamp>.zip` (timestamp `YYYYMMDD-HHMMSS`) and supports `DT_TIMESTAMP` for deterministic tests.
6. The tool ships with a `test/<tool-id>.bats` file with at least **2 tests** (happy path + edge/error path).
7. `dt test` passes.

---

## Repo conventions

### Locations and naming

- Tools live in: `tools/<tool-id>`
- Tests live in: `test/<tool-id>.bats`
- Shared test helpers live in: `test/support/`

**Tool id rules**
- lowercase
- words separated with hyphens
- examples: `git-aliases`, `zip-project`, `prompt-setup`

### How users run tools

- Help:
    - `dt <tool-id>`
    - `dt help <tool-id>`
- Run actions:
    - `dt <tool-id> run ...`
- Setup/config tools may also support:
    - `dt <tool-id> install [--yes]`
    - `dt <tool-id> uninstall [--yes]`
    - `dt <tool-id> status`

---

## Shell compatibility (important)

- Assume **macOS default Bash 3.2** is common.
- Avoid Bash 4+ features (e.g., associative arrays `declare -A`).
- Always use:
    - shebang: `#!/usr/bin/env bash`
    - strict mode: `set -euo pipefail`
- Be careful with `$@` under `set -u` and zero args:
    - Guard shifts: `shift || true`
    - Prefer: `local arg="${1:-}"` over assuming `$1` exists.

---

## Tool header (dt-readable help)

Each tool must start with a help header made of **comment lines** and end with `### END HELP`.

### Required header fields (must exist)

- `VERSION: 0.0.1`  (do **not** bump versions unless explicitly requested)
- `SUMMARY: ...`
- `TAGS: ...`        (comma-separated)
- `SYNOPSIS: ...`
- `SAFETY: ...`
- `### END HELP`

### Recommended header fields

- `DESCRIPTION: ...`
- `OPTIONS: ...`
- `EXAMPLES: ...`
- `OUTPUT: ...`
- `DEPS: ...`
- `CREDITS: ...`
- `MISC: ...`

### Header template (copy/paste)

```bash
#!/usr/bin/env bash
# VERSION: 0.0.1
# SUMMARY: One-line description of what the tool does.
# TAGS: git, shell
# SYNOPSIS: dt <tool-id>
#   dt <tool-id> run [args...]
# SAFETY: non-destructive
# DESCRIPTION: Short explanation. Mention defaults and what it will touch.
# OPTIONS:
#   --flag ...  Explanation
# EXAMPLES:
#   dt <tool-id> run .
# OUTPUT: What files it writes / what it prints.
# DEPS: external commands required (zip, git, etc.)
# CREDITS: upstream inspiration (optional)
# MISC: any extra notes (optional)
### END HELP
set -euo pipefail
```

---

## Tags

Tags are used for discovery and filtering. Use only approved tags.

### Approved tags

**Core**
- `share`, `git`, `shell`, `env`, `project`, `net`, `files`, `misc`

**Ecosystem**
- `android`, `ios`, `web`, `node`, `python`, `kotlin`, `flutter`

### Tag rules

- `TAGS:` is a comma-separated list (spaces optional after commas).
- If you use `misc`, include a `# MISC:` section explaining why.

---

## Tool design patterns

### Action tool (typical)

- `dt <tool-id>` prints help
- `dt <tool-id> run ...` performs the work

### Setup tool (persistent config)

- `dt <tool-id>` prints help (or preview)
- `dt <tool-id> install [--yes]`
- `dt <tool-id> uninstall [--yes]`
- `dt <tool-id> status` (optional)

---

## Argument parsing (conventions)

Keep parsing simple and predictable:

- Support `-h|--help|help`
- Prefer explicit flags: `--output`, `--mode`, `--yes`, `--dry-run`
- Fail fast on unknown args:
    - print a short usage line
    - exit with code `2`

---

## Safety rules

Tools must be safe for beginners by default.

### Safety values

- `SAFETY: non-destructive`
    - reads/prints only, or creates new output files without modifying user/system config
- `SAFETY: confirm`
    - modifies user/system state (dotfiles, gitconfig, symlinks, deletes files, etc.)
    - must prompt unless `--yes` is provided

### Requirements for `confirm` tools

- Print what will be changed before prompting
- Default answer is **No**
- Support `--yes` to bypass prompt
- Prefer `--dry-run` when reasonable
- Uninstall must remove **only what the tool owns**
    - use markers or exact-line matching
    - never delete unrelated user config

---

## Output conventions

### Zip naming

When a tool creates a zip and the user does not provide `--output`:

- Default: `<dir-name>-<timestamp>.zip`
- Timestamp: `YYYYMMDD-HHMMSS` (local time)

For deterministic tests, tools should support:

- `DT_TIMESTAMP=YYYYMMDD-HHMMSS`

---

## Dependency handling

If a tool requires external commands:

- List them in `# DEPS:`
- Validate early (before doing work)
- Provide a friendly error:
    - what’s missing
    - how to install it (keep short)

Avoid auto-installing dependencies unless:
- it’s clearly safe
- it’s interactive
- it’s opt-in with confirmation

---

## Testing (Bats)

Every tool must ship with tests.

### Minimum requirement per tool

- At least **2 tests**:
    1) happy path
    2) edge case or error path (bad args, missing dependency, idempotency, etc.)

### Test guidelines

- Never touch real user home/config.
    - set `HOME` to a temp dir when testing setup tools
- Prefer stable assertions:
    - exit code
    - key output lines
    - created files and their contents
- Prefer deterministic output:
    - use env vars like `DT_TIMESTAMP`

### Test template (copy/paste)

Create: `test/<tool-id>.bats`

```bash
#!/usr/bin/env bats

load "support/test_helpers.bash"

require_cmd() {
  if ! command -v "${1}" >/dev/null 2>&1; then
    skip "Missing required command: ${1}"
  fi
}

@test "<tool-id> help prints" {
  run "$(dt_bin)" help <tool-id>
  [ "$status" -eq 0 ]
}

@test "<tool-id> run does the thing" {
  local work
  work="$(mktemp -d 2>/dev/null || mktemp -d -t "dt-tool")"

  run bash -c "cd '${work}' && '$(dt_bin)' <tool-id> run ."
  [ "$status" -eq 0 ]

  rm -rf "${work}" || true
}
```

---

## Copy/paste tool skeleton (recommended starting point)

Save as: `tools/<tool-id>`

```bash
#!/usr/bin/env bash
# VERSION: 0.0.1
# SUMMARY: TODO
# TAGS: misc
# SYNOPSIS: dt <tool-id>
#   dt <tool-id> run [args...]
# SAFETY: non-destructive
# DESCRIPTION: TODO
# OPTIONS:
#   -h, --help  Show help
# EXAMPLES:
#   dt <tool-id> run .
# OUTPUT: TODO
# DEPS: TODO
# CREDITS: None
# MISC: TODO
### END HELP
set -euo pipefail

print_usage() {
  echo "Run: dt help <tool-id>"
}

main() {
  local subcmd="${1:-}"
  shift || true

  case "${subcmd}" in
    ""|help|-h|--help)
      print_usage
      ;;
    run)
      # TODO: implement
      ;;
    install)
      echo "Not supported." >&2
      exit 2
      ;;
    uninstall)
      echo "Not supported." >&2
      exit 2
      ;;
    status)
      echo "Not supported." >&2
      exit 2
      ;;
    *)
      echo "Unknown subcommand: ${subcmd}" >&2
      print_usage >&2
      exit 2
      ;;
  esac
}

main "$@"
```

---

## Done checklist for a new tool

Before submitting a new tool:

- [ ] Tool exists at `tools/<tool-id>`
- [ ] Tool is executable in git (`chmod +x tools/<tool-id>`)
- [ ] Header contains required fields and ends with `### END HELP`
- [ ] Bash 3.2 compatible (no Bash 4-only features)
- [ ] Safety rules implemented (`SAFETY: confirm` + prompt + `--yes`) if tool modifies state
- [ ] Tests added at `test/<tool-id>.bats`
- [ ] `dt test` passes locally

---

## Notes for future contributors

Keep tools small, obvious, and easy to remove.

Avoid cleverness. Reliability wins.

If a tool grows large, prefer:
- a thin CLI wrapper in `tools/<tool-id>`
- small helper functions inside the same file (still Bash 3.2 compatible)
