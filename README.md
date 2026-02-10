# dt

A tiny, self-documenting toolbox of command-line utilities for day-to-day software development.

- **Discover tools:** `dt list`, `dt tags`
- **Read help:** `dt help <tool>` or `dt <tool>`
- **Run tools:** `dt <tool> [args...]`

## Demo

[![dt demo](https://asciinema.org/a/6kRz225VApQqnuLh.svg)](https://asciinema.org/a/6kRz225VApQqnuLh)

## Install / Uninstall

See [`INSTALL.md`](docs/INSTALL.md).

## Design goals

- **No registry:** tools are discovered by scanning `tools/`.
- **Docs live with code:** each tool has a man-style header at the top (DRY).
- **Safe by default:** `dt <tool>` prints help; tools use confirmations for persistent changes.
- **Portable:** no background services, no daemons, no lock-in.

## Quickstart (run from repo)

```bash
git clone https://github.com/hoangaccounts/dt
cd dt

./dt list
./dt tags
./dt help zip-project
./dt zip-project run .
```

If you downloaded a ZIP (not a git clone) and `./dt` says `permission denied`, run:

```bash
chmod +x dt bootstrap tools/*
```

## Included tools

- **`ai-context`** — generate structured AI assistant context from your standards, workflows, and projects.
- **`git-aliases`** — print and optionally install a safe git alias set.
- **`jump-dir`** — bookmark and jump to frequently used directories.
- **`prompt`** — install a reversible, git-aware shell prompt.
- **`repo-baseline`** — install PR workflow baseline (branch protection, CI, traceability). See [repo-baseline docs](docs/repo-baseline.md).
- **`zip-project`** — create a share-friendly zip of a project (excludes common caches).

---

## Tool details

### ai-context

Generate rich context files for AI assistants (Claude, GPT, etc.) that include your coding standards,
workflow preferences, personal expertise, and project-specific details.

```bash
# Create context for a new project
dt ai-context new --name my-app --type android --size medium

# Scan an existing project
dt ai-context scan .

# Update with session summary
dt ai-context update my-app ./session-notes.md

# Manage experimental context files
dt ai-context labs status

# Check status
dt ai-context status
```

The tool auto-installs a curated context library on first use at:

```
~/.dt/ai-context/
```

You can customize behavior by editing templates in:

```
~/.dt/ai-context/context-library/personal/
```

**Experimental features**

Add experimental context docs to:

```
~/.dt/ai-context/context-library/labs/
```

These are automatically loaded during context generation and can be promoted later.

---

### git-aliases

Print and optionally install a safe git alias set.

```bash
dt git-aliases list
dt git-aliases install
```

---

### jump-dir

Bookmark and jump to frequently used directories.

```bash
# List saved directories
dt jump-dir list

# Add the current directory (or a path) under a name
dt jump-dir add work .
dt jump-dir add gs ~/dev/goodstocks-android

# Jump to a saved directory
dt jump-dir go work
```

Saved directories persist across shells and machines (once dt is installed).

---

### prompt

Install and manage a git-aware shell prompt with optional themes.

```bash
# Install prompt integration (adds a dt-managed block to your shell rc)
dt prompt install

# Switch prompt theme
dt prompt use git
dt prompt use minimal

# List available prompt themes
dt prompt list

# Uninstall prompt integration
dt prompt uninstall
```

The prompt is **dt-owned and reversible**:
- All changes live inside a clearly marked block in your shell rc
- `dt prompt uninstall` removes everything cleanly

---

### zip-project

Create a share-friendly zip of a project (excludes common caches).

```bash
dt zip-project run .
dt zip-project run . --output myproject.zip
```

---

## Testing

Tests are written using **bats-core**.

Install bats:

```bash
# macOS
brew install bats-core

# Ubuntu / Debian
sudo apt-get update && sudo apt-get install -y bats
```

Run the test suite:

```bash
./dt test
```

---

## Contributing (add a tool)

Create an executable file in `tools/` with the required header keys:

- `VERSION`
- `SUMMARY`
- `TAGS`
- `SYNOPSIS`
- `SAFETY`
- `### END HELP`

Keep tags strict and lowercase. Run `./dt tags` to see the approved list.

---

## License

MIT — see `LICENSE`.
