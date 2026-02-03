# dt   

A tiny, self-documenting toolbox of command-line utilities for day-to-day software developmentl. 

- **Discover tools:** `dt list`, `dt tags`
- **Read help:** `dt help <tool>` or `dt <tool>`
- **Run tools:** `dt <tool> [args...]`

## Demo

▶ Watch the terminal tour: https://asciinema.org/a/6kRz225VApQqnuLh

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
