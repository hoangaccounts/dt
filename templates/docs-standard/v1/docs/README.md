# Docs Root README

This directory is the canonical documentation tree for a project that follows the decision-layer documentation standard.

## Read order

1. `00-foundation/`
2. `40-decisions/` when a major ruling affects interpretation
3. `10-product-systems/`
4. `20-libraries/`
5. `30-delivery/`
6. `90-archive/` only when researching superseded history

## Top-level folder purposes

- `00-foundation` — product identity, glossary, principles, IA, and the system map
- `10-product-systems` — bounded product/domain capability specs
- `20-libraries` — reusable technical/library specs
- `30-delivery` — implementation plans, rollout, QA, analytics, migration, and ops
- `40-decisions` — cross-cutting rulings affecting multiple docs
- `90-archive` — retired, replaced, or superseded material

## Naming rules

- use lowercase hyphen-case
- use stable filenames without version suffixes
- use these suffixes by default:
  - `*-spec.md`
  - `*-plan.md`
  - `adr-###-slug.md`
  - `*-runbook.md`

## Minimum recommended pack for a new product

- `00-foundation/product-vision-spec.md`
- `00-foundation/system-architecture-spec.md`
- `00-foundation/information-architecture-spec.md` for user-facing products
- `00-foundation/glossary.md` when domain terms can be misread
- the first 1–3 real system specs in `10-product-systems/`

## Source-of-truth rule

Stable domain truth belongs in foundation, system, or library specs. Temporary execution truth belongs in delivery docs. Cross-cutting rulings belong in ADRs. Replaced docs belong in archive.
