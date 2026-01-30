# dt    

A tiny, self-documenting toolbox of command-line utilities for day-to-day software developmentl. 

- **Discover tools:** `dt list`, `dt tags`
- **Read help:** `dt help <tool>` or `dt <tool>`
- **Run tools:** `dt <tool> [args...]`

## Install / Uninstall

See [`INSTALL.md`](INSTALL.md).

## Design goals

- **No registry:** tools are discovered by scanning `tools/`.
- **Docs live with code:** each tool has a man-style header at the top (DRY).
- **Safe by default:** `dt <tool>` prints help; tools use confirmations for persistent changes.

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

- **`ai-context`** — generate comprehensive AI assistant context files combining your coding standards, workflow preferences, and project details.
- **`git-aliases`** — print and optionally install a safe git alias set.
- **`jump-dir`** — bookmark and jump to frequently used directories.
- **`prompt`** — customizable shell prompt with git status.
- **`zip-project`** — create a share-friendly zip of a project (excludes common caches).

### ai-context

Generate rich context files for AI assistants (Claude, GPT, etc.) that include your coding standards, workflow preferences, personal expertise, and project-specific details.

```bash
# Create context for new project
dt ai-context new --name my-app --type android --size medium

# Scan existing project
dt ai-context scan .

# Update with session summary
dt ai-context update my-app ./session-notes.md

# Check status
dt ai-context status
```

The tool auto-installs a curated context library on first use at `~/.dt/ai-context/`.
Customize by editing personal templates at `~/.dt/ai-context/context-library/personal/`.

### git-aliases

Print and optionally install a safe git alias set.

```bash
dt git-aliases list
dt git-aliases install
```

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

The prompt is designed to be **dt-owned and reversible**:
- All changes live inside a clearly marked block in your shell rc file
- `dt prompt uninstall` cleanly removes everything it added

### zip-project

Create a share-friendly zip of a project (excludes common caches).

```bash
dt zip-project run .
dt zip-project run . --output myproject.zip
```

## Testing

Tests are written with **bats-core**.

Install bats:

```bash
# macOS
brew install bats-core

# Ubuntu/Debian (package name may be 'bats' or 'bats-core' depending on distro)
sudo apt-get update && sudo apt-get install -y bats
```

Run the suite:

```bash
./dt test
```

## Contributing (add a tool)

Create an executable file in `tools/` with the required header keys:

- `VERSION`, `SUMMARY`, `TAGS`, `SYNOPSIS`, `SAFETY`, and `### END HELP`

Keep tags strict and lowercase. Run `./dt tags` to see the approved list.

## License

MIT (see `LICENSE`).
