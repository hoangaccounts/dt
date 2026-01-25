# dt-devtools

A tiny, self-documenting toolbox of command-line utilities for day-to-day software development.

- **Discover tools:** `./dt list`, `./dt tags`
- **Read help:** `./dt help <tool>` or `./dt <tool>`
- **Run tools:** `./dt <tool> [args...]`
- **Optional install:** `./dt install` (symlinks `dt` to `~/.local/bin/dt`)

## Design goals

- **No registry:** tools are discovered by scanning `tools/`.
- **Docs live with code:** each tool has a man-style header at the top (DRY).
- **Safe by default:** `dt <tool>` prints help; tools use confirmations for persistent changes.

## Quickstart

```bash
git clone <your-repo-url>
cd dt-devtools

# Optional: put `dt` on PATH (recommended)
./dt -install

dt list
dt tags
dt help git-aliases
dt git-aliases list
```

If you downloaded a ZIP (not a git clone) and `./dt` says `permission denied`, run:

```bash
bash ./dt -install
```

### Install notes

- `dt -install` creates a symlink at `~/.local/bin/dt` pointing to this repo.
- If `~/.local/bin` is not on your PATH, `dt -install` can offer to add it to your shell profile (zsh/bash).
- If you already have a `dt` symlink from a different folder, `dt -install` will prompt to replace it.

## Included tools

- `git-aliases` — print and optionally install a safe git alias set.
- `zip-project` — create a share-friendly zip of a project (excludes common caches).

Example:

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
