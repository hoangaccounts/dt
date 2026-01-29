# Chat Protocol: Notes, Updates, and End-of-Chat Flow

## Purpose

This document defines the **conversation protocol** used to reliably capture durable knowledge and documentation changes during AI chats, without interrupting flow or relying on end-of-chat summarization.

It works in conjunction with the `dt ai-context` tool, which owns **storage and placement** of context. This protocol defines **how meaning is captured and confirmed**.

---

## Core Principles

- **No forced summarization**
- **No silent persistence**
- **No guessing**
- **User retains final control**
- **Durable knowledge is captured incrementally**
- **Verbatim grounding prevents drift**

---

## Supported Tags

### `@note`

## Optional `@note` Tags (Classification)

Notes may optionally include one or more **classification tags** to indicate status and meaning.
Tags are **plain-text metadata only** and are preserved verbatim.

Format:
```
@note
[Tag][Tag]...
<note content>
```

### Tag Sets

#### 1) Status tags (Kanban)
If a status tag is present, it **must be the first tag**, and there should be **only one** status tag.

- `[Backlog]` — idea parked
- `[Todo]` — committed, not started
- `[Doing]` — in progress
- `[Review]` — waiting for review/feedback
- `[Done]` — completed/shipped
- `[Blocked]` — cannot proceed

#### 2) Artifact / meaning tags
Use these after the status tag (if present):

- `[Research]`
- `[Questions]`
- `[Plan]`
- `[Execution]`

Optional qualifiers (also after status/artifact tags):

- `[Invariant]`
- `[Constraint]`
- `[Risk]`
- `[Decision]`

### Ordering Rule

When combining tags, order them as:

**status → artifact → qualifiers**

Example:
```
@note
[Todo][Plan][Risk]
Write migration steps with rollback.
```

### Semantics

- Tags are optional.
- Tags do **not** affect acceptance, storage, or summarization semantics.
- Untagged notes remain fully valid.


Marks knowledge worth preserving across chats.

### `@update`
Proposes a change to an existing documentation file.

### `@summary`
Triggers the structured end-of-chat wrap-up process.

No other tags are part of this protocol.

---

## `@note` Protocol

There are **three supported ways** a note may be created.

---

### Mode 1 — Assistant-suggested notes

When the assistant believes something is worth preserving, it must use **exactly this format**:

```
@note?
Context:
"<verbatim quote from the chat>"

Recorded as:
<concise canonical note>
```

Then the assistant **stops** and waits.

#### Valid user responses
- `yes` or `@note` → accept as written
- edit **Recorded as** → accept edited version
- `no` or silence → discard

Only the **Recorded as** text is persisted via `ai-context`.

The verbatim context is shown only to prevent paraphrase drift.

---

### Mode 2 — Highlight + annotate

If the user highlights text and sends only:

```
@note
```

Then:
- the highlighted text becomes **Context**
- the assistant proposes a **Recorded as** summary
- the same confirmation rules from *Mode 1* apply

This mode minimizes typing when reacting to existing text.

---

### Mode 3 — Direct user-authored notes

The user may create a note directly, without highlighting or prompting, by writing:

```
@note <free-form text>
```

or multi-line:

```
@note
<free-form text>
```

In this mode:
- the user-provided text is treated as the **Recorded as** value
- no verbatim context is required
- the note is considered **explicitly authored and accepted**

The assistant must **not reinterpret, summarize, or restate** the note unless asked.

---

### When NOT to suggest `@note`

The assistant must not suggest notes for:
- brainstorming or speculation
- repetition or agreement
- procedural chatter
- session-local details
- tool mechanics already encoded elsewhere
- uncertain or hedged ideas
- assistant-originated ideas not explicitly adopted by the user

---

## `@update` Protocol

### Assistant-suggested updates

When the assistant identifies a documentation change worth proposing, it must use **exactly this format**:

```
@update?
Suggested file: <one specific existing doc>

Context:
"<verbatim quote from the chat>"

Proposed update:
<concise description of the change>
```

Then the assistant waits.

#### Valid user responses
- `yes` → update is marked as pending
- edit **Proposed update** → edited version is pending
- `no` or silence → discarded

---

### Meaning of “pending”

A pending update:
- exists **only in the current chat**
- is **not applied**
- is **not written to disk**
- is **not persisted across chats**

Pending updates are surfaced only during `@summary`.

---

### Applying updates

Documentation updates are **only applied** after:
1. the user accepts the update, **and**
2. the user uploads or pastes the **current file contents**

Without a baseline file, **no edits are performed**.

The assistant returns a **full updated document**, never partial diffs.

---

## `@summary` Protocol (End-of-Chat)

Running:

```
@summary
```

initiates a **two-part guided wrap-up**.

---

## Part A — Notes Summary

### A1) Verbatim notes
All accepted notes are listed **exactly as recorded**.

---

### A2) Late-pass note candidates (full chat review)

The assistant makes a **complete pass over the entire chat** and may suggest additional notes that are now important in hindsight.

Each candidate follows the **assistant-suggested `@note?` format** and requires explicit acceptance.

Nothing is auto-added.

---

### A3) Summarized notes (consolidation)

The assistant produces a **deduplicated, merged, canonical note set**, combining:
- direct user-authored notes
- accepted assistant-suggested notes
- accepted late-pass notes

---

### A4) Confirmation and output

The assistant asks:
- confirm / edit / redo summarization
- whether to generate a `summary.md` output

Only confirmed summaries should be persisted via `dt ai-context update`.

---

## Part B — Updates Summary

### B1) Group updates by file
All accepted updates are grouped by target file.

---

### B2) Per-file review
For each file:
- verbatim updates are shown
- a consolidated suggested update set is presented

The user confirms / edits / skips **per file**.

---

### B3) Apply (optional)
For each confirmed file:
- the user may upload or paste the current file contents
- the assistant returns a **full updated version**
- otherwise, the update remains a proposal only

---

## Guarantees

- Silence never mutates state
- No knowledge is persisted without explicit acceptance
- No file is modified without a baseline
- Verbatim grounding prevents semantic drift
- The protocol works across ChatGPT, Claude, and long chats

---

## Relationship to `ai-context`

- This protocol defines **how meaning is captured**
- `dt ai-context` defines **where it is stored**
- Storage location, file layout, and persistence are owned by the tool

This separation keeps the system reliable and evolvable.
