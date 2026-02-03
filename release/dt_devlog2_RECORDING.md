# Devlog #2 — Terminal recording (asciinema)

This produces a clean “terminal tour” clip for LinkedIn.

## Prereqs
- You have the `dt` repo locally (folder contains `./dt` and `./tools/`).
- `asciinema` installed:
  - macOS: `brew install asciinema`

## Record
1) `cd` into the dt repo root.

2) Start recording:

```bash
asciinema rec dt-devlog2.cast
```

3) Run the tour script:

```bash
bash ./dt_devlog2_terminal_tour.sh
```

4) Stop the recording:
- press `Ctrl-D` (common in asciinema), or type `exit` if your shell prompts

## Tips for LinkedIn
- Aim for ~25–45 seconds.
- Keep the terminal font large enough for mobile viewers.
- Optional: convert to GIF/video for autoplay in the feed.

## What the clip shows
- `dt` as one entry point (`dt`, `dt list`, `dt tags`)
- quick peek at the self-documenting headers for each tool
- a teaser for `ai-context` (without demoing it yet)
