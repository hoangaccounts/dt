# AGENT.md

## Canonical Authority

By default, use only these canonical lanes as implementation authority:

- `docs/00-foundation/**`
- `docs/10-product-systems/**`
- `docs/20-decisions/**`
- `docs/30-delivery/**`
- `docs/40-libraries/**`
- `docs/50-research/**`

Treat `docs/90-archive/**` as historical context only.

## Working Drafts

- `docs/05-working/**` is non-canonical by default.
- Ignore working drafts unless a task explicitly references a specific working file.
- Every file under `docs/05-working/**` must begin with `draft-`.

## Precedence

- Canonical docs outrank draft docs when both exist for the same subject.
- Foundation, system, and decision truth outrank delivery details when they conflict.
- Delivery docs define an implementation pass; they do not silently replace higher-order system truth.

## Promotion

- Never promote a draft implicitly.
- Promotion requires an explicit move from `docs/05-working/**` to the matching canonical lane.
- Promotion also requires removing the `draft-` prefix.
- Update any affected indexes or links as part of promotion.
