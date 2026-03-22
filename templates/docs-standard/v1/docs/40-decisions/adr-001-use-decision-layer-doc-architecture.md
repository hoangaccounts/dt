# ADR-001 — Use Decision-Layer Doc Architecture

| version | date | author | change |
|---|---:|---|---|
| 0.1 | YYYY-MM-DD | Hoang | Initial ADR adopting the decision-layer docs structure. |

**AI assistance:** Remove this line if no delegated sections were drafted with AI.

## Document Metadata

- **Status:** Draft
- **Owner:** Hoang
- **Last substantive update:** YYYY-MM-DD
- **Depends on:** none
- **Depended on by:** all docs using this structure
- **Source of truth:** this ADR for the chosen doc architecture
- **Supersedes:** none

## Context

The project needs a docs structure that is easy for humans to navigate and easy for AI to retrieve without confusing product identity, bounded system truth, reusable cores, and temporary execution detail.

## Decision

Use this top-level docs model:

```text
docs/
  00-foundation/
  10-product-systems/
  20-libraries/
  30-delivery/
  40-decisions/
  90-archive/
```

## Consequences

- product identity stays separate from implementation plans
- reusable libraries stay separate from host systems
- cross-cutting decisions are easier to find
- stale docs are easier to quarantine in archive
- new contributors and AI agents have a more predictable retrieval path

## Alternatives Considered

- flat docs tree — rejected because it scales poorly and increases retrieval collisions
- organize by app tabs — rejected because UI structure changes faster than decision layers
- organize by repo modules — rejected because code structure is not the same as documentation purpose

## Related Specs

- `../00-foundation/product-vision-spec.md`
- `../00-foundation/system-architecture-spec.md`
