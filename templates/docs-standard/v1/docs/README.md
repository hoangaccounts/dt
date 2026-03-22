# Docs Root README

This tree separates canonical documentation from non-canonical working drafts.

## Canonical lanes

- `00-foundation/` — stable project identity and system map
- `10-product-systems/` — canonical bounded system truth
- `20-decisions/` — canonical cross-cutting rulings
- `30-delivery/` — canonical implementation/change packages
- `40-libraries/` — canonical reusable library specs
- `50-research/` — preserved or active research worth keeping
- `90-archive/` — retired or superseded material

## Working lane

- `05-working/` holds draft docs only.
- Every file under `05-working/` must begin with `draft-`.
- Promote by moving a draft to its canonical lane and removing `draft-`.

## Bootstrap flow

1. Start in `05-working/foundation/` with draft foundation docs.
2. Capture active uncertainty in `05-working/research/`.
3. Draft system and delivery docs in `05-working/` first.
4. Promote only when a draft is stable enough to be authoritative.
