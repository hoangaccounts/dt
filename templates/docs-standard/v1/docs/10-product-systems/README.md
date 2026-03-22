# 10-product-systems

Put one spec here per real bounded product or domain capability.

## What belongs here

- user-facing or domain-facing system specs
- system contracts
- system states and flows
- system-level responsibilities and non-goals

## What does not belong here

- reusable library/domain cores that belong in `20-libraries`
- temporary implementation plans
- broad product vision
- cross-cutting ADRs

## Split rule

Create a separate system spec when the capability has a distinct purpose, owner, lifecycle, or boundary.

## Merge rule

Merge docs when one file only paraphrases another, or when changes always happen together and the boundaries are not real.
