# Code Completion Checklist

**Before considering any code complete:**

## Required Before Completion

- [ ] **Tests written/updated** - All changes have corresponding tests
- [ ] **All tests passing** - 100% pass rate, no skipped tests
- [ ] **Domain/Use Cases: 100% coverage** - No exceptions for business logic
- [ ] **Lint passes** - 0 errors, 0 warnings (detekt, ktlint, shellcheck)
- [ ] **Code follows standards** - Naming, formatting, error handling per code-standards
- [ ] **No TODOs or FIXMEs** - Resolve or create tickets
- [ ] **No commented-out code** - Remove or uncomment
- [ ] **No debug statements** - Remove println, console.log, etc.

## Code Quality Checks

- [ ] **Functions < 20 lines** - Extract if longer
- [ ] **No magic numbers** - Use named constants
- [ ] **Error handling present** - Proper exceptions, no silent failures
- [ ] **No null returns** - Return empty collections or throw
- [ ] **Meaningful names** - Variables, functions, classes are clear

## Architecture Checks

- [ ] **Follows project patterns** - Matches existing architecture
- [ ] **Dependencies correct** - Domain doesn't depend on frameworks
- [ ] **Single responsibility** - Each class has one reason to change
- [ ] **No circular dependencies** - Clean dependency graph

## Ready for Review

- [ ] **Commit message clear** - Describes what and why
- [ ] **Changes focused** - Only what was requested (scope discipline)
- [ ] **No unrelated changes** - No "while we're here" refactoring
- [ ] **Ready for production** - No placeholders, no temporary hacks

---

**If ANY checkbox is unchecked, code is NOT complete.**
