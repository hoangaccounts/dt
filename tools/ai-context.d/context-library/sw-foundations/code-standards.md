# Code Standards

**Sources:** Clean Code (Robert C. Martin), Code Complete (Steve McConnell), The Pragmatic Programmer (Hunt & Thomas), Refactoring (Martin Fowler), Effective Java (Joshua Bloch)

## Functions

Always apply:

- **Size:** 5-10 lines target, max 20-30 lines - extract when longer
- **Arguments:** 0-2 ideal, max 3 - use parameter objects if more
- **Do One Thing:** Function does one thing at one level of abstraction
- **Names:** Verbs describing what function does - be specific, not generic

## Naming

- **Variables:** 10-16 characters optimal - descriptive, pronounceable, searchable
- **Classes:** Nouns or noun phrases - Customer, WikiPage, Account
- **Methods:** Verbs or verb phrases - save, delete, getName
- **Boolean:** Predicate phrases - isActive, hasPermission, canProcess
- **Constants:** SCREAMING_SNAKE_CASE for true constants

## Comments

- **Prefer:** Self-documenting code over comments
- **Use When:** Explain WHY, not WHAT - non-obvious decisions, consequences, warnings
- **Avoid:** Redundant comments, mandated comments, journal comments, commented-out code

## Error Handling

- **Use Exceptions:** Not error codes or return values
- **Don't Return Null:** Return empty collections, Special Case objects, or throw
- **Don't Pass Null:** Check parameters at boundaries
- **Write Try-Catch-Finally First:** Define normal flow and error handling upfront
- **Crash Early (Pragmatic):** When something impossible happens, crash immediately - don't continue with corrupt state

## Testing

Apply F.I.R.S.T. principles:

- **Fast:** Milliseconds - run frequently
- **Independent:** Tests don't depend on each other
- **Repeatable:** Same result every time - no randomness, no time dependencies
- **Self-Validating:** Boolean result (pass/fail) - no manual interpretation
- **Timely:** Written before/with production code (TDD)

## Defensive Programming

- **Assertions:** For impossible conditions (programming errors) - document assumptions
- **Validation:** For possible errors (user input, external data) - use exceptions
- **Contracts:** Document preconditions, postconditions, invariants
- **Resource Management:** Finish what you start - same function allocates and deallocates, use language features (Kotlin `use`)

## Code Organization

- **DRY:** Don't repeat knowledge - extract to single location
- **KISS:** Keep it simple - solve problem, don't over-engineer
- **Boy Scout Rule:** Leave code cleaner than you found it
- **Depend on Abstractions:** Use interfaces, not concrete classes

## Refactoring

When to refactor:

- Third occurrence of duplication (Rule of Three)
- Adding feature reveals design problems
- Method too long (>20 lines)
- Class too large (>300 lines, many responsibilities)
- Deep nesting (>3 levels)

Common refactorings: Extract Method, Rename, Move Method, Extract Class, Introduce Parameter Object, Replace Conditional with Polymorphism

## Effective Java Principles

- **Static Factory Methods:** Named constructors, can return subtype, can cache
- **Builder Pattern:** For >4 parameters - clear, flexible
- **Minimize Mutability:** Immutable by default - thread-safe, simpler
- **Defensive Copies:** When exposing internal collections/objects
- **Check Parameters:** Validate at entry points - fail fast with clear errors
- **Minimize Scope:** Declare variables where used - smallest scope possible
- **Refer to Interfaces:** List<T>, not ArrayList<T> - flexibility
- **Use Standard Exceptions:** IllegalArgumentException, IllegalStateException, etc.

## Performance

- **Measure First:** Don't optimize without profiling
- **Avoid Premature Optimization:** Clarity first, optimize only when needed
- **Know Your Data Structures:** HashMap O(1), TreeSet O(log n), ArrayList O(n)

## Linting

**Always required:**
- **0 errors/warnings** before commit - no exceptions
- Run linters before every commit
- Kotlin: detekt, ktlint
- Bash: shellcheck
- Enforce in CI pipeline

## Formatting

- **Vertical:** Related concepts close together, blank lines between concepts
- **Horizontal:** <120 characters per line
- **Indentation:** Consistent, reveals structure
- **Team Consistency:** Follow team standards over personal preference
