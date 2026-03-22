# Docs Standard

This directory contains the canonical source for the `dt docs` standard pack.

## Source of truth

- `future-project-doc-standard-spec.md` defines the documentation standard itself.
- `v1/docs/` contains the committed starter pack installed by `dt docs init`.

## Update flow

1. Update `future-project-doc-standard-spec.md` first when the standard changes.
2. Apply any agreed changes to the versioned pack under `v1/docs/`.
3. Add a new version directory when the installable pack needs a breaking or historical split.
