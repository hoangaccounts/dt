# Future Project — Doc Standard Spec

| version | date | author | change |
|---|---:|---|---|
| 1.0 | 2026-03-21 | Hoang | Initial canonical future-project documentation standard covering folder model, entry criteria, naming, metadata, templates, and lifecycle rules. |

**AI assistance:** ChatGPT assisted with drafting delegated sections.

## Status Legend

- **Locked** = explicitly locked during exploration.
- **Delegated** = approved for assistant fill-in under TA, but not explicitly reviewed line by line.

## Document Metadata

- **Status:** Active
- **Owner:** Hoang
- **Last substantive update:** 2026-03-21
- **Depends on:** none
- **Depended on by:** all future project doc packs using this standard
- **Source of truth:** this document
- **Supersedes:** none

## 1. Purpose

**[Locked]** This spec defines the canonical documentation architecture for future projects.

**[Locked]** The standard exists to improve human maintainability and AI retrieval quality by separating documentation by purpose, ownership, lifecycle, and decision layer.

## 2. Scope

**[Locked]** This spec covers:
- top-level folder structure
- entry criteria for each folder
- naming rules
- template rules
- metadata rules
- split/merge/archive rules
- starter-pack expectations

**[Locked]** This spec does not define:
- any one product's actual domain model
- repo structure outside the docs tree
- team process beyond documentation rules
- tool-specific automation details

## 3. Out of Scope

**[Locked]** This standard does not require one specific development methodology, one specific architecture pattern, or one specific repository layout.

**[Locked]** This standard is documentation architecture, not total project governance.

## 4. Goals / Non-Goals

### Goals

**[Locked]** The standard should:
- make the project legible quickly
- reduce overlap and stale truth
- help humans find authoritative docs fast
- help AI agents retrieve the right context with fewer collisions
- keep stable truth separate from temporary execution detail

### Non-Goals

**[Locked]** The standard should not:
- mirror app tabs by default
- mirror repo package structure by default
- force premature splitting of docs
- turn every choice into a separate ADR
- require a large document set before project work can begin

## 5. Users / Actors

**[Delegated]** Primary users:
- project owner
- future maintainers
- AI coding/research agents
- reviewers who need to understand authoritative truth quickly

**[Delegated]** Secondary users:
- collaborators joining the project later
- implementation-focused agents reading only a bounded slice of the project
- humans auditing whether a change belongs in specs, decisions, or delivery docs

## 6. Core Concepts / Definitions

**[Locked]** **Foundation docs** define product identity and the overall map.

**[Locked]** **Product system docs** define real bounded domain or product capabilities.

**[Locked]** **Library docs** define reusable technical or domain-core assets.

**[Locked]** **Delivery docs** define execution and rollout work, not permanent truth.

**[Locked]** **Decision docs** capture cross-cutting rulings that constrain multiple specs.

**[Locked]** **Archive docs** preserve history without competing with active truth.

**[Delegated]** **Decision layer** means the level of abstraction or authority a document operates at: product identity, bounded capability, reusable core, temporary execution, or cross-cutting ruling.

## 7. Requirements

### 7.1 Top-level structure

**[Locked]** Every project using this standard should default to:

```text
docs/
  00-foundation/
  10-product-systems/
  20-libraries/
  30-delivery/
  40-decisions/
  90-archive/
```

### 7.2 Folder entry criteria

**[Locked]** `00-foundation` contains product identity, glossary, principles, IA, and system map documents.

**[Locked]** `10-product-systems` contains bounded product/domain system specs.

**[Locked]** `20-libraries` contains reusable technical/library specs.

**[Locked]** `30-delivery` contains implementation plans, rollout, QA, analytics, migration, and ops docs.

**[Locked]** `40-decisions` contains cross-cutting rulings affecting multiple docs.

**[Locked]** `90-archive` contains retired, replaced, or superseded material.

### 7.3 Minimum recommended pack

**[Locked]** Start with only:
- product vision spec
- glossary when needed
- information architecture spec when the product is user-facing
- system architecture spec
- the first 1–3 real system specs

**[Locked]** Do not create delivery docs before implementation planning begins.

**[Locked]** Do not create library docs until reuse is real or intentionally committed.

### 7.4 One-job-per-doc rule

**[Locked]** Every document should have one clear primary job.

**[Locked]** A good document should have:
- one main question it answers
- one primary audience
- one owner
- one lifecycle

**[Locked]** A document that mixes broad identity, bounded system rules, and execution planning should usually be split.

### 7.5 Naming rules

**[Locked]** Use lowercase hyphen-case.

**[Locked]** Use stable filenames without version suffixes.

**[Locked]** Use these suffixes by default:
- `*-spec.md`
- `*-plan.md`
- `adr-###-slug.md`
- `*-runbook.md`

### 7.6 Retrieval spine rule

**[Locked]** `system-architecture-spec.md` should be the canonical retrieval spine.

**[Delegated]** It should map active systems, later systems, reusable libraries, and core dependencies, and link outward to their owning specs.

### 7.7 README and index rule

**[Locked]** Put an index or README at:
- the root `docs/` level
- each top-level folder
- any subfolder with enough density that discovery would otherwise slow down

**[Delegated]** Those index files should say what belongs there, what does not, and what to read first.

### 7.8 Metadata rule

**[Delegated]** Every live spec, ADR, or plan should declare:
- status
- owner
- last substantive update
- depends on
- depended on by
- source of truth
- supersedes when relevant

### 7.9 Status vocabulary

**[Delegated]** Keep statuses tight:
- Draft
- Active
- Superseded
- Archived

### 7.10 Delivery-doc rule

**[Locked]** Delivery docs are temporary by default.

**[Delegated]** When a delivery document contains a rule that becomes permanent project truth, that rule should be moved into the relevant stable spec or ADR.

### 7.11 Archive rule

**[Locked]** Archive aggressively when a document is replaced, merged, renamed materially, or no longer authoritative.

**[Locked]** Do not leave stale docs mixed beside active docs with similar names.

### 7.12 Decision rule

**[Locked]** Use ADRs for cross-cutting choices such as navigation model, module boundaries, offline posture, privacy/analytics posture, and other decisions that constrain multiple specs.

**[Locked]** Keep local feature decisions inside the owning spec.

### 7.13 Template rule

**[Locked]** The standard should include canonical templates for:
- foundation spec
- product system spec
- library spec
- delivery plan
- ADR

### 7.14 Header rule

**[Locked]** Canonical spec headers should include:
- title
- changelog near the top
- AI assistance line when applicable
- status/provenance legend before the main body

**[Delegated]** The metadata block should appear near the top as part of the document header area.

## 8. States / Flows

### 8.1 New-project bootstrap flow

**[Delegated]**
1. create the top-level docs tree
2. add the root README and folder READMEs
3. create foundation docs first
4. create the first 1–3 system specs
5. add ADRs only when cross-cutting rulings appear
6. add delivery docs when implementation planning becomes real
7. move replaced docs into archive immediately

### 8.2 New-doc creation flow

**[Delegated]**
1. decide whether the content is foundation, system, library, delivery, decision, or archive
2. confirm the doc has one clear primary job
3. check whether an active doc already owns the truth
4. use the matching canonical template
5. add metadata and changelog
6. link upstream and downstream dependencies

### 8.3 Split/merge flow

**[Locked]** Split when:
- ownership differs
- lifecycle differs
- abstraction layer differs
- the file mixes stable truth with temporary execution

**[Locked]** Merge when:
- two docs cannot be read independently
- one mostly paraphrases the other
- changes always happen together and the boundary is not real

## 9. Data / Entities / Contracts

**[Delegated]** Canonical doc entities under this standard:
- `FoundationSpec`
- `ProductSystemSpec`
- `LibrarySpec`
- `DeliveryPlan`
- `ADR`
- `ReadmeIndex`
- `ArchivedDocument`

**[Delegated]** Every live document should expose a minimal contract:
- authoritative purpose
- current status
- owner
- dependency context
- update history
- stable filename

## 10. Dependencies / Integrations

**[Delegated]** This standard depends only on:
- a version-controlled docs tree
- markdown or another plain-text documentation format
- consistent naming and review discipline

**[Delegated]** It integrates well with:
- AI coding agents
- docs-as-code workflows
- ADR practices
- repository-level code review

## 11. Risks / Edge Cases / Failure Modes

**[Locked]** Main failure modes:
- too many overlapping medium-quality docs
- stale docs left beside active docs
- delivery plans becoming accidental source of truth
- fake libraries created before reuse is real
- folder structure treated as product architecture rather than a document architecture

**[Delegated]** Another common failure mode is over-splitting early. A doc tree with too many tiny files can also harm retrieval and maintainability.

## 12. Open Questions

**[Delegated]** None required to adopt the standard.

**[Delegated]** Future refinements should come from real friction during project use, not more theory up front.

## 13. Appendix

### A. Canonical templates included in this pack

- `foundation-spec-template.md`
- `product-system-spec-template.md`
- `library-spec-template.md`
- `delivery-plan-template.md`
- `adr-template.md`

### B. Root rule of thumb

**[Locked]** AI performs worse on a pile of overlapping medium-quality docs than on a smaller set of clearly bounded docs with stronger indexes.
