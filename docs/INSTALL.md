# INSTALL

This repo is intentionally low-friction: it runs directly from the cloned folder, and the optional
install step just makes `dt` available on your PATH.

## Requirements

- **macOS / Linux**
- `bash` (or compatible POSIX shell)
- `git` (to clone)
- Optional per-tool dependencies (see each tool’s `dt help <tool>` output)

## Option A: Run without installing (recommended for trying it)

```bash
git clone https://github.com/hoangaccounts/dt
cd dt-devtools

# Run from the repo folder
./dt list
./dt tags
./dt help zip-project
```

## Option B: Install (puts `dt` on PATH)

The repo provides an installer that symlinks the repo’s `dt` script into `~/.local/bin/dt`.

```bash
cd dt-devtools
./dt install
```

Ensure `~/.local/bin` is on your PATH (add to `~/.zshrc` or `~/.bashrc` if needed):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Open a new shell (or `source` your rc file), then:

```bash
dt list
dt help
```

## Uninstall

If you used `./dt install`, uninstall by removing the symlink:

```bash
rm -f "$HOME/.local/bin/dt"
```

(Your cloned repo folder can be deleted after that.)

## Troubleshooting

### “permission denied” when running `./dt` or tools

If you cloned/unzipped and executable bits were lost:

```bash
chmod +x dt bootstrap tools/*
```

### “command not found: dt” after install

Confirm both:

```bash
ls -l "$HOME/.local/bin/dt"
echo "$PATH" | tr ':' '\n' | grep -n "$HOME/.local/bin" || true
```

If `~/.local/bin` isn’t listed, add it to your shell PATH (see above) and restart the shell.
