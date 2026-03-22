# Future Project — Doc Standard Spec

| version | date | author | change |
|---|---:|---|---|
| 1.1 | 2026-03-22 | Hoang | Expanded the standard into a draft-to-canonical agentic workflow; added 05-working, research, filename rules, promotion rules, AGENT.md rules, and feature execution flow. |
| 1.0 | 2026-03-21 | Hoang | Initial canonical future-project documentation standard covering folder model, entry criteria, naming, metadata, templates, and lifecycle rules. |

**AI assistance:** ChatGPT assisted with drafting delegated sections.

## Status Legend

- **Locked** = explicitly locked during exploration.
- **Delegated** = approved for assistant fill-in under TA, but not explicitly reviewed line by line.

## Document Metadata

- **Status:** Active
- **Owner:** Hoang
- **Last substantive update:** 2026-03-22
- **Depends on:** none
- **Depended on by:** all future project doc packs using this standard
- **Source of truth:** this document
- **Supersedes:** version 1.0 of this document

## 1. Purpose

**[Locked]** This spec defines the canonical documentation architecture for future projects.

**[Locked]** The standard exists to improve human maintainability and AI retrieval quality by separating documentation by purpose, ownership, lifecycle, and decision layer.

**[Locked]** The standard should guide a practical spec workflow for agentic development, not just a static folder taxonomy.

## 2. Scope

**[Locked]** This spec covers:
- top-level folder structure
- working-vs-canonical separation
- naming rules
- metadata rules
- promotion and archive rules
- agent authority rules
- new-project and new-feature spec workflow

**[Locked]** This spec does not define:
- any one product's actual domain model
- repo structure outside the docs tree except for the repo-root `AGENT.md`
- team process beyond documentation rules
- tool-specific automation details

## 3. Out of Scope

**[Locked]** This standard does not require one specific development methodology, one specific architecture pattern, or one specific repository layout.

**[Locked]** This standard is documentation architecture, not total project governance.

**[Locked]** This standard does not require every small task to receive its own formal spec.

## 4. Goals / Non-Goals

### Goals

**[Locked]** The standard should:
- make the project legible quickly
- reduce overlap and stale truth
- help humans find authoritative docs fast
- help AI agents retrieve the right context with fewer collisions
- keep stable truth separate from temporary execution detail
- support a simple draft → canon → delivery → implementation workflow

### Non-Goals

**[Locked]** The standard should not:
- mirror app tabs by default
- mirror repo package structure by default
- force premature splitting of docs
- turn every choice into a separate ADR
- require a large document set before project work can begin
- make working drafts compete with canonical implementation truth

## 5. Users / Actors

**[Delegated]** Primary users:
- project owner
- future maintainers
- AI coding/research agents
- reviewers who need to understand authoritative truth quickly

**[Delegated]** Secondary users:
- collaborators joining the project later
- implementation-focused agents reading only a bounded slice of the project
- humans auditing whether a change belongs in foundation, system, delivery, decision, library, or research docs

## 6. Core Concepts / Definitions

**[Locked]** **Foundation docs** define product identity and the overall map.

**[Locked]** **Product system docs** define real bounded domain or product capabilities.

**[Locked]** **Library docs** define reusable technical or domain-core assets.

**[Locked]** **Delivery docs** define execution and rollout work, not permanent truth.

**[Locked]** **Decision docs** capture cross-cutting rulings that constrain multiple specs.

**[Locked]** **Research docs** reduce uncertainty before decisions or coherent implementation.

**[Locked]** **Archive docs** preserve history without competing with active truth.

**[Locked]** **Working docs** are non-canonical drafts that are still being shaped and must not be treated as default implementation authority.

**[Locked]** **Canonical docs** are the authoritative project documents agents should use by default.

**[Locked]** The high-level operating model is:
- draft system spec first
- promote to canonical system spec
- draft delivery spec from that
- promote to canonical delivery spec
- implement from canonical delivery, with canonical system as higher truth
- use research only when uncertainty blocks coherence

**[Delegated]** **Decision layer** means the level of abstraction or authority a document operates at: product identity, bounded capability, reusable core, temporary execution, cross-cutting ruling, or uncertainty reduction.

## 7. Requirements

### 7.1 Top-level structure

**[Locked]** Every project using this standard should default to:

```text
docs/
  00-foundation/
  05-working/
    foundation/
    product-systems/
    decisions/
    delivery/
    libraries/
    research/
  10-product-systems/
  20-decisions/
  30-delivery/
  40-libraries/
  50-research/
  90-archive/
```

**[Locked]** Folder numbering should reflect stable retrieval/read order and leave room for future insertion without renumbering existing lanes.

**[Locked]** `05-working` is a cross-cutting draft lane that sits between canonical foundation and the canonical lanes that follow.

### 7.2 Folder entry criteria

**[Locked]** `00-foundation` contains canonical project identity and map documents such as product vision and system architecture.

**[Locked]** `05-working` contains non-canonical draft documents organized by intended canonical destination.

**[Locked]** `10-product-systems` contains canonical bounded product/domain system specs.

**[Locked]** `20-decisions` contains canonical cross-cutting rulings affecting multiple specs.

**[Locked]** `30-delivery` contains live implementation/change packages, rollout plans, migration plans, and execution checklists.

**[Locked]** `40-libraries` contains reusable technical/library specs.

**[Locked]** `50-research` contains canonical investigation documents worth preserving as stable reference or active uncertainty-reduction work.

**[Locked]** `90-archive` contains retired, replaced, superseded, or no-longer-authoritative material.

### 7.3 Working-lane structure rule

**[Locked]** `05-working` should mirror canonical document classes with shallow subfolders.

**[Locked]** The bootstrap subdirectories are:
- `foundation/`
- `product-systems/`
- `decisions/`
- `delivery/`
- `libraries/`
- `research/`

**[Locked]** `05-working` should use only one subfolder level inside the working lane.

### 7.4 Canonical vs working rule

**[Locked]** Canonical authority docs and working docs must be kept separate.

**[Locked]** Agents should default to canonical sources only.

**[Locked]** A document in `docs/05-working/` is not implementation authority unless a task explicitly points to it.

### 7.5 Minimum recommended bootstrap pack

**[Locked]** Initial project bootstrap documents should start in `docs/05-working/` as drafts and be promoted into canonical lanes only when they are stable enough to serve as authority.

**[Locked]** A new project should bootstrap with these initial draft documents:
- `docs/05-working/foundation/draft-<project>-foundation-product-vision-spec.md`
- `docs/05-working/foundation/draft-<project>-foundation-system-architecture-spec.md`
- `docs/05-working/research/draft-<project>-research-open-questions-spec.md`

**[Delegated]** The open-questions draft belongs in research because its job is uncertainty reduction, not product definition.

### 7.6 One-job-per-doc rule

**[Locked]** Every document should have one clear primary job.

**[Locked]** A good document should have:
- one main question it answers
- one primary audience
- one owner
- one lifecycle

**[Locked]** A document that mixes broad identity, bounded system rules, and execution planning should usually be split.

### 7.7 Naming rules

**[Locked]** Use lowercase hyphen-case.

**[Locked]** Use stable filenames without version suffixes unless versioning is materially required for a specific delivery pass.

**[Locked]** All non-library canonical document filenames should use:
- `<project>-<lane>-<subject>-spec.md`

**[Locked]** All library canonical document filenames should use:
- `library-<subject>-spec.md`

**[Locked]** Example canonical filenames:
- `tps-foundation-product-vision-spec.md`
- `tps-foundation-system-architecture-spec.md`
- `tps-system-meditation-spec.md`
- `tps-decision-local-db-spec.md`
- `tps-delivery-meditation-v1-implementation-spec.md`
- `tps-research-auth-provider-options-spec.md`
- `library-meditation-core-spec.md`

**[Locked]** All documents under `docs/05-working/` must use the `draft-` filename prefix, regardless of document lane or subject.

**[Locked]** On promotion from working to canonical, keep the same base filename, move it to the canonical folder, and remove `draft-`.

### 7.8 Retrieval spine rule

**[Locked]** The system architecture spec remains the canonical retrieval spine.

**[Delegated]** It should map active systems, later systems, reusable libraries, research-heavy uncertainty zones when relevant, and core dependencies, and link outward to their owning specs.

### 7.9 README and index rule

**[Locked]** Put an index or README at:
- the root `docs/` level
- each top-level canonical folder when density justifies it
- any subfolder with enough density that discovery would otherwise slow down

**[Delegated]** Those index files should say what belongs there, what does not, and what to read first.

### 7.10 Metadata rule

**[Delegated]** Every live spec, decision doc, research doc, or delivery doc should declare:
- status
- owner
- last substantive update
- depends on
- depended on by
- source of truth
- supersedes when relevant

### 7.11 Status vocabulary

**[Delegated]** Keep statuses tight:
- Draft
- Active
- Superseded
- Archived

### 7.12 Delivery-doc rule

**[Locked]** Delivery docs are temporary by default.

**[Locked]** `10-product-systems` defines enduring system truth; `30-delivery` defines the change package for a particular implementation pass.

**[Locked]** Put in the system spec what should still be true months later.

**[Locked]** Put in the delivery spec what is specific to this implementation pass, such as exact files to create or edit, implementation order, migration steps, wiring sequence, validation steps, and test execution checklist.

**[Delegated]** When a delivery document contains a rule that becomes permanent project truth, that rule should be moved into the relevant stable spec or decision doc.

### 7.13 Decision rule

**[Locked]** Use decision docs for cross-cutting choices such as navigation model, module boundaries, offline posture, privacy/analytics posture, and other decisions that constrain multiple specs.

**[Locked]** Keep local feature decisions inside the owning system spec.

### 7.14 Research rule

**[Locked]** Research is a first-class lane for structured investigation and uncertainty reduction before decisions and implementation.

**[Locked]** Use research only when investigation has its own real value or when uncertainty prevents a coherent system spec or delivery spec.

**[Delegated]** Typical research outputs are findings, tradeoffs, recommendation, and proposed next decision or spec refinement.

### 7.15 Library rule

**[Locked]** Do not create library docs until reuse is real or intentionally committed.

**[Delegated]** A library doc is justified when a reusable module, engine, or shared contract has its own lifecycle or cross-project value.

### 7.16 Promotion and archive rule

**[Locked]** Promotion from `05-working` to a canonical lane requires explicit movement into the canonical lane and removal of the `draft-` prefix.

**[Locked]** Drafts are never promoted implicitly.

**[Locked]** Promotion should also update relevant indexes and links when needed.

**[Locked]** Archive delivery docs when completed, superseded, or no longer operationally useful.

**[Locked]** Archive aggressively when a document is replaced, merged, renamed materially, or no longer authoritative.

**[Locked]** Do not leave stale docs mixed beside active docs with similar names.

### 7.17 AGENT.md rule

**[Locked]** Each project should include a single repo-root file named `AGENT.md` for agent authority, document precedence, and canonical-lane rules.

**[Locked]** `AGENT.md` must define:
- canonical authority lanes
- exclusion of `docs/05-working/` from default authority
- requirement for `draft-` filenames in working
- conflict precedence between canonical and draft documents
- prohibition on implicit draft promotion

**[Delegated]** `AGENT.md` should tell agents to treat `docs/05-working/**` as non-canonical by default and ignore it unless a task explicitly references a specific working draft.

### 7.18 Header rule

**[Locked]** Canonical spec headers should include:
- title
- changelog near the top
- AI assistance line when applicable
- status/provenance legend before the main body

**[Delegated]** The metadata block should appear near the top as part of the document header area.

## 8. States / Flows

### 8.1 High-level spec lifecycle

**[Locked]** The high-level lifecycle of a spec is:
- idea or uncertainty
- working draft in `05-working`
- canonical promotion when stable enough
- delivery/change package draft in `05-working/delivery`
- canonical delivery doc in `30-delivery`
- implementation from canonical delivery with canonical system as higher truth
- validated spec delta update when needed

### 8.2 New-project bootstrap flow

**[Locked]** The practical bootstrap flow is:
1. create the top-level docs tree
2. create the initial draft foundation and open-questions docs in `05-working`
3. refine the draft product vision until user, problem, product purpose, and initial scope are explicit
4. refine the draft system architecture until main systems, boundaries, and key dependencies are named
5. promote those drafts into `00-foundation` when stable enough to be authoritative
6. create the first draft system spec in `05-working/product-systems/`
7. use research only when uncertainty blocks coherence

### 8.3 New-feature workflow

**[Locked]** The default new-feature workflow is:
1. create `docs/05-working/product-systems/draft-<project>-system-<feature>-spec.md`
2. write the enduring cross-layer truth for that feature: UX flows, UI states, rules, data, integrations, and key architecture
3. refine until coherent enough to be authoritative
4. promote to `docs/10-product-systems/<project>-system-<feature>-spec.md`
5. if unknowns block clarity, create targeted research draft documents in `docs/05-working/research/` and fold findings back into the system spec
6. create `docs/05-working/delivery/draft-<project>-delivery-<feature>-<pass>-implementation-spec.md`
7. write the implementation/change package: exact files, order, migrations, wiring, tests, and validation steps
8. refine until execution-ready
9. promote to `docs/30-delivery/<project>-delivery-<feature>-<pass>-implementation-spec.md`
10. ask the agent to implement from the canonical delivery spec, using the canonical system spec as higher-order truth
11. after validation, update specs only from intended, validated canonical deltas

### 8.4 Split/merge flow

**[Locked]** Split when:
- ownership differs
- lifecycle differs
- abstraction layer differs
- the file mixes stable truth with temporary execution
- a reusable asset genuinely deserves its own library spec

**[Locked]** Merge when:
- two docs cannot be read independently
- one mostly paraphrases the other
- changes always happen together and the boundary is not real

## 9. Data / Entities / Contracts

**[Delegated]** Canonical doc entities under this standard:
- `FoundationSpec`
- `ProductSystemSpec`
- `LibrarySpec`
- `DeliverySpec`
- `DecisionSpec`
- `ResearchSpec`
- `ReadmeIndex`
- `ArchivedDocument`

**[Delegated]** Every live document should expose a minimal contract:
- authoritative purpose
- current status
- owner
- dependency context
- update history
- stable filename
- clear lane ownership

## 10. Dependencies / Integrations

**[Delegated]** This standard depends only on:
- a version-controlled docs tree
- markdown or another plain-text documentation format
- consistent naming and review discipline
- a repo-root `AGENT.md` when agents are part of the workflow

**[Delegated]** It integrates well with:
- AI coding agents
- docs-as-code workflows
- TDD and verification-driven implementation
- repository-level code review

## 11. Risks / Edge Cases / Failure Modes

**[Locked]** Main failure modes:
- too many overlapping medium-quality docs
- stale docs left beside active docs
- delivery docs becoming accidental source of truth
- fake libraries created before reuse is real
- folder structure treated as product architecture rather than a document architecture
- drafts being treated as implementation authority by default

**[Delegated]** Another common failure mode is over-splitting early. A doc tree with too many tiny files can also harm retrieval and maintainability.

**[Delegated]** Another failure mode is canonizing implementation accident instead of validated intent; the workflow must update specs from validated canonical deltas, not blindly mirror code.

## 12. Open Questions

**[Delegated]** None required to adopt the standard.

**[Delegated]** Future refinements should come from real friction during project use, not more theory up front.

## 13. Appendix

### A. Canonical templates included in this pack

- `foundation-spec-template.md`
- `product-system-spec-template.md`
- `library-spec-template.md`
- `delivery-spec-template.md`
- `decision-spec-template.md`
- `research-spec-template.md`

### B. Root rule of thumb

**[Locked]** AI performs worse on a pile of overlapping medium-quality docs than on a smaller set of clearly bounded docs with stronger indexes.

### C. Bootstrap filename examples

**[Delegated]** Example draft bootstrap set for The Peace Seeker:
- `docs/05-working/foundation/draft-tps-foundation-product-vision-spec.md`
- `docs/05-working/foundation/draft-tps-foundation-system-architecture-spec.md`
- `docs/05-working/research/draft-tps-research-open-questions-spec.md`
- `docs/05-working/product-systems/draft-tps-system-meditation-spec.md`
- `docs/05-working/delivery/draft-tps-delivery-meditation-v1-implementation-spec.md`
