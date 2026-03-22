# Tool Docs

This directory is the long-form documentation home for individual `dt` tools.

## Structure

- `docs/tools/<tool-id>/` is the home for one tool.
- Use the docs standard layout when it helps:
  - `00-foundation/` for purpose, CLI contract, system architecture, and core specs
  - `10-product-systems/` for major internal subsystems when a tool is large enough
  - `30-delivery/` for rollout, migration, or implementation notes
  - `40-decisions/` for ADRs

## Guidance

- Keep quick CLI help in the tool header under `tools/<tool-id>`.
- Keep installable template content out of this directory.
- Put cross-tool standards in a shared home such as `docs/` or `templates/`, depending on whether they are repo docs or installable standards.
