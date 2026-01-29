# Chat Summary Guide

## Table of Contents
- [Purpose](#purpose)
- [When to Summarize](#when-to-summarize)
- [What to Extract](#what-to-extract)
- [What to Skip](#what-to-skip)
- [Summary Format](#summary-format)
- [Examples](#examples)
- [Quality Checklist](#quality-checklist)

---

## Purpose

This guide teaches AI assistants how to extract and format key decisions from chat sessions. Good summaries preserve critical knowledge while filtering out noise, enabling future sessions to build on past work without repeating discussions.

**Goal:** Create concise, actionable summaries that future AI sessions can use to maintain continuity and avoid repeated mistakes.

---

## When to Summarize

**Always summarize when:**
- Approaching token limit (~180K tokens)
- Ending a productive session with significant decisions made
- Major architecture or design choices were established
- New patterns were implemented
- Important problems were solved

**Optional to summarize:**
- Short exploratory sessions with no concrete outcomes
- Bug fix sessions (unless bug revealed important insights)
- Sessions that only refined existing work

**User triggers summary by:**
- Saying "let's summarize" or "generate summary"
- Responding "yes" when AI offers summary at session end
- Following chat-end-checklist.md

---

## What to Extract

### Architectural Decisions
**Capture:** Structure, layers, module organization

**Good examples:**
- "Decided to use Clean Architecture with 3 layers: domain, data, presentation"
- "Split user management into separate module for reusability"
- "Using repository pattern with local (Room) + remote (Retrofit) data sources"

**Bad examples:**
- "Talked about architecture" (too vague)
- "Used the approach from the book" (not specific)

### Design Patterns Established
**Capture:** Specific patterns chosen and why

**Good examples:**
- "Implementing UseCase pattern for business logic to keep ViewModels thin"
- "Using Strategy pattern for payment processing to support multiple providers"
- "Sealed classes for API response states (Loading, Success, Error)"

**Bad examples:**
- "Used some design patterns" (not specific)
- "Made the code better" (not actionable)

### Technology/Library Choices
**Capture:** What was chosen and key configuration

**Good examples:**
- "Using Hilt for dependency injection with component scoping"
- "Chose Coil for image loading (50MB cache limit)"
- "Implemented Paging3 for infinite scroll on product list"

**Bad examples:**
- "Added some libraries" (not specific)
- "Used standard Android stuff" (not informative)

### Implementation Details That Matter
**Capture:** Non-obvious decisions that affect future work

**Good examples:**
- "Auth tokens stored in EncryptedSharedPreferences (not plain SharedPreferences)"
- "Using single-activity architecture with Compose Navigation"
- "Error handling: sealed class hierarchy with specific error types"
- "Offline-first: Room is source of truth, sync happens in background"

**Bad examples:**
- "Implemented the feature" (too generic)
- "Code works now" (no detail)

### Trade-offs and Rationale
**Capture:** Why certain approaches were chosen over alternatives

**Good examples:**
- "Chose last-write-wins over conflict resolution to ship faster; will revisit if users report issues"
- "Using in-memory cache instead of Room for 5-item list (YAGNI; can upgrade later)"
- "Skipped multi-module setup for now (single module sufficient for team size)"

**Bad examples:**
- "Made good decisions" (no detail)
- "Did what made sense" (not specific)

### Conventions Established
**Capture:** Project-specific patterns or naming conventions

**Good examples:**
- "ViewModels named `*ViewModel`, UseCases named `*UseCase`"
- "Data classes in `*.model` package, DTOs in `*.dto`"
- "Test files mirror source structure in `test/` directory"

**Bad examples:**
- "Used normal naming" (not specific)

---

## What to Skip

### Exploratory Discussion
**Skip:** Back-and-forth debates, brainstorming that didn't lead to decisions

**Why:** Future sessions don't need to relive the discussion, just need the conclusion.

### Intermediate Iterations
**Skip:** Code that was tried and replaced, approaches that didn't work

**Exception:** If failure revealed important insight, capture the lesson.

**Example of what to skip:**
- "First tried approach A, then B, then C, settled on D"

**Example of what to keep:**
- "Initially tried manual DI but switched to Hilt when complexity grew (threshold: ~10 dependencies)"

### Debugging Details
**Skip:** Step-by-step debugging process

**Exception:** If bug revealed architectural problem or important pattern.

**Example of what to skip:**
- "Fixed NPE in line 47 by adding null check"

**Example of what to keep:**
- "Discovered LiveData emitting on wrong thread; wrapped with `asLiveData()` to ensure main thread"

### Standard Practices
**Skip:** Things that are just following normal conventions

**Example of what to skip:**
- "Used lateinit for injected dependencies" (standard Kotlin)
- "Put repository in data layer" (follows Clean Architecture)

**Example of what to keep:**
- "Using lateinit with @Inject (not constructor injection) to avoid Fragment constructor issues"

### Personal Context Updates
**Skip:** Don't include in project summary

**Handle separately:** Skill level updates go to technical-skills.md via chat-end-checklist.

---

## Summary Format

### Standard Template

```markdown
## Session Summary: [Date]

### Architecture Decisions
- [Decision 1 with brief rationale]
- [Decision 2 with brief rationale]

### Patterns Implemented
- [Pattern 1: where/why]
- [Pattern 2: where/why]

### Technology Choices
- [Library/Framework 1: configuration/notes]
- [Library/Framework 2: configuration/notes]

### Implementation Details
- [Detail 1 that affects future work]
- [Detail 2 that affects future work]

### Trade-offs Made
- [What was chosen over alternatives and why]

### Conventions Established
- [Project-specific patterns/naming]

### Next Steps (Optional)
- [Identified future work or known tech debt]
```

### Writing Style

**Be concise:**
- One line per decision when possible
- Include just enough context to understand later
- Use bullet points, not paragraphs

**Be specific:**
- "Using Hilt" not "Using DI"
- "Room is source of truth" not "Using offline storage"
- "Paging3 with page size 20" not "Added pagination"

**Be actionable:**
- Write so future session can apply the decision
- Include relevant details (configuration, rationale)
- Link related decisions together

---

## Examples

### Good Summary Example

```markdown
## Session Summary: 2025-01-27

### Architecture Decisions
- Implemented Clean Architecture: domain (UseCases, entities), data (repositories, Room, Retrofit), presentation (ViewModels, Compose UI)
- Single-activity architecture with Compose Navigation
- Offline-first: Room is source of truth, API sync happens in WorkManager background job

### Patterns Implemented
- Repository pattern: UserRepository with local (Room) + remote (API) data sources
- UseCase layer: GetUserProfileUseCase orchestrates repository + settings
- Sealed classes for UI state: Loading, Success<T>, Error(message)

### Technology Choices
- Hilt for DI (application and activity component scoping)
- Room 2.6 with suspend functions and Flow
- Retrofit with Moshi for JSON
- Coil for image loading (50MB disk cache)

### Implementation Details
- Auth tokens in EncryptedSharedPreferences (key: "auth_token")
- API base URL configured in BuildConfig for build variants
- Error handling: specific exception types mapped to user-facing messages
- Retry logic: exponential backoff for network errors (max 3 retries)

### Trade-offs Made
- Chose single module over multi-module (team size = 2, can refactor later if grows)
- Using last-write-wins for sync conflicts (simpler than CR; revisit if users report issues)
- In-memory cache for categories (only 5 items; Room would be overkill)

### Conventions Established
- ViewModels: `*ViewModel` (e.g., ProfileViewModel)
- UseCases: `*UseCase` (e.g., GetUserProfileUseCase)
- Repository interfaces in domain layer, implementations in data layer
- Test files mirror source: `UserRepository` → `UserRepositoryTest`
```

### Bad Summary Example (Don't Do This)

```markdown
## Session Summary

We worked on the app today. Made a lot of progress.

Talked about architecture and decided to use good patterns. Implemented some features for users. Fixed a few bugs.

Added some libraries that we needed. The code is much better now.

Need to do more work next time.
```

**Why this is bad:**
- No specific decisions
- No technical details
- Future sessions can't use this
- Doesn't preserve any knowledge

---

## Quality Checklist

Before finalizing a summary, verify:

**Specificity:**
- [ ] Every decision includes specific technology/pattern names
- [ ] No vague terms ("some", "better", "good")
- [ ] Configuration details included where relevant

**Completeness:**
- [ ] All major decisions from session captured
- [ ] Rationale included for non-obvious choices
- [ ] Trade-offs acknowledged

**Actionability:**
- [ ] Future session could apply these decisions
- [ ] Enough context to understand "why"
- [ ] Related decisions linked together

**Conciseness:**
- [ ] One line per decision when possible
- [ ] No back-and-forth discussion
- [ ] No debugging steps (unless revealed insight)

**Format:**
- [ ] Follows template structure
- [ ] Bullet points, not paragraphs
- [ ] Clear section headers

---

## Usage in Workflow

### During Session
**AI monitors for:**
- Architecture decisions being made
- Patterns being established
- Technology choices
- Important implementation details

**Mental notes become summary at end.**

### At Session End
1. **AI offers to summarize** (if productive session or approaching token limit)
2. **AI generates summary** following this guide
3. **User reviews** and approves/refines
4. **User copies summary** and runs: `dt ai-context update <project>`
5. **Summary persisted** in project's context.md file

### Next Session
**New AI assistant:**
1. Reads project context.md
2. Sees all accumulated summaries
3. Understands decisions without repeating discussions
4. Builds on established patterns
5. Avoids contradicting previous choices

---

*This guide ensures knowledge transfer between sessions, maintaining continuity and avoiding repeated work.*
