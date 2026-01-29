# Documentation Creation Guidelines

## Purpose

This document defines standards for creating and maintaining documentation in this foundation. Following these guidelines ensures consistency, readability, and maintainability across all documentation files.

---

## General Standards

### File Format
- **All documentation uses Markdown (.md)**
- UTF-8 encoding
- Unix line endings (LF, not CRLF)
- No trailing whitespace

### File Naming
- **Lowercase with hyphens:** `code-standards.md`, `personal-background.md`
- Descriptive names that reveal content
- No spaces, underscores, or special characters
- Use `.md` extension for all markdown files

### File Structure
Every documentation file should include:

1. **Title** (H1, single `#`)
2. **Table of Contents** (see below)
3. **Purpose section** explaining what the document covers
4. **Main content** organized with clear headings
5. **Footer** (optional, for context/updates)

---

## Table of Contents Requirements

### When to Include TOC
**Always include a TOC for:**
- Documents longer than 3 sections
- Reference documents (code-standards, design-standards)
- Any document where users need to quickly find specific information

**Optional for:**
- Very short documents (<3 sections)
- Checklists
- Brief templates

### TOC Format

**Standard two-level structure:**
```markdown
# Document Title

## Table of Contents
- [Major Section](#major-section)
  - [Subsection 1](#subsection-1)
  - [Subsection 2](#subsection-2)
- [Another Section](#another-section)
  - [Subsection A](#subsection-a)

---

## Major Section
Content...

### Subsection 1
Content...
```

**Rules:**
- Two levels maximum in TOC (avoid visual clutter)
- Links use lowercase with hyphens: `#major-section`
- Spaces become hyphens: "Code Standards" → `#code-standards`
- Include separator `---` between TOC and content

### Anchor Link Format
Markdown auto-generates anchors from headers:
- `## Functions` → `#functions`
- `## Error Handling` → `#error-handling`
- `## Tell, Don't Ask` → `#tell-dont-ask`
- Lowercase, spaces to hyphens, remove special characters

---

## Content Organization

### Heading Hierarchy
- **H1 (`#`)**: Document title (only one per file)
- **H2 (`##`)**: Major sections
- **H3 (`###`)**: Subsections
- **H4 (`####`)**: Sub-subsections (use sparingly)
- Never skip levels (don't jump from H2 to H4)

### Section Structure

**Major sections should include:**
1. Brief introduction/context
2. Clear subsections with descriptive headers
3. Examples where helpful
4. Related information grouped together

**Example:**
```markdown
## Error Handling

Error handling should use exceptions rather than error codes.

### Use Exceptions, Not Error Codes

**Principle:** Exceptions separate error handling from main logic.

**Example:**
[code example]

### Don't Return Null

**Principle:** Returning null creates potential errors.

**Example:**
[code example]
```

---

## Writing Style

### Tone
- **Clear and direct** - get to the point
- **Practical** - focus on application, not theory
- **Consistent** - use same terminology throughout
- **Professional but approachable**

### Formatting Emphasis
- **Bold** for principles, key concepts, important terms
- *Italics* for emphasis (use sparingly)
- `Code formatting` for code terms, file names, commands
- > Blockquotes for important notes or warnings

### Lists
- Use **bullet points** for unordered lists
- Use **numbered lists** for sequences or priorities
- Keep list items parallel in structure
- Don't overuse nested lists

### Code Examples

**Always include:**
- Both ❌ bad and ✅ good examples when showing right/wrong
- Brief explanation of why the good example is better
- Realistic, practical code (not foo/bar)

**Format:**
```markdown
❌ **Bad - reason why:**
[code]

✅ **Good - what's better:**
[code]
```

---

## Special Sections

### Purpose Section
**Every document starts with a Purpose section:**
```markdown
## Purpose

This document defines [what it covers].

**What's in this document:**
- Key topic 1
- Key topic 2

**What's NOT in this document:**
- Related topic → see other-doc.md
```

### Examples and Code
- Use fenced code blocks with language specification
- Include context/explanation before code
- Show realistic examples
- Prefer Kotlin for examples (primary language)

### Cross-References
**Link to related documents:**
```markdown
See [code-standards.md](code-standards.md) for implementation details.
For SOLID principles, see [design-standards](design-standards.md#solid-principles).
```

---

## Maintenance

### Versioning
- Documents evolve over time
- Note major changes in commit messages
- Don't include version numbers in document (use git)
- Add "Last updated" only if helpful for time-sensitive content

### Updates
When updating documents:
- Update TOC if sections change
- Maintain consistent style with existing content
- Check all internal links still work
- Update cross-references if needed

### Review Checklist
Before committing documentation:
- [ ] TOC present and accurate
- [ ] All internal links work
- [ ] Code examples tested/verified
- [ ] Consistent formatting throughout
- [ ] No spelling/grammar errors
- [ ] Clear and concise writing

---

## File-Type Specific Guidelines

### Foundation Documents
**Examples:** development-philosophy.md, code-standards.md

**Requirements:**
- Comprehensive TOC (two levels)
- Purpose section explaining scope
- Clear section organization
- Extensive examples
- Checklist or summary at end

### Personal Documents
**Examples:** personal-background.md, technical-skills.md

**Requirements:**
- TOC for navigation
- Purpose section
- Organized chronologically or by category
- Context for AI assistants

### Process Documents
**Examples:** working-style.md, chat-summary-guide.md

**Requirements:**
- TOC for quick reference
- Step-by-step procedures where applicable
- Examples of good/bad practices
- Clear action items

### Checklists
**Examples:** chat-begin-checklist.md, chat-end-checklist.md

**Requirements:**
- Purpose section
- Clear checkbox format
- Brief explanations
- Examples where helpful
- TOC optional (usually short)

---

## Templates

### Standard Document Template
```markdown
# Document Title

## Table of Contents
- [Purpose](#purpose)
- [Major Section 1](#major-section-1)
  - [Subsection](#subsection)
- [Major Section 2](#major-section-2)

---

## Purpose

Brief description of what this document covers.

**What's in this document:**
- Item 1
- Item 2

**What's NOT in this document:**
- Related topic → see other-doc.md

---

## Major Section 1

Content...

### Subsection

Content...

---

## Major Section 2

Content...

---

*Footer note if needed*
```

---

## Summary

**Every documentation file should:**
1. Use markdown format with .md extension
2. Include a two-level table of contents
3. Start with a Purpose section
4. Use clear heading hierarchy (H1 → H2 → H3)
5. Include practical examples
6. Link to related documents
7. Follow consistent style and formatting

**Goal:** Documentation that is easy to navigate, understand, and maintain over time.

---

*These guidelines ensure consistency and quality across all foundation documentation.*
