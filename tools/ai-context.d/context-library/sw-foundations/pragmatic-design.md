# Pragmatic Design Principles

**Source:** The Pragmatic Programmer (Andrew Hunt & David Thomas)

Always apply these principles.

## Core Principles

- **DRY (Don't Repeat Yourself):** Every piece of knowledge has single, unambiguous representation - applies to code, data, documentation
- **Orthogonality:** Eliminate effects between unrelated things - changes in one place don't affect unrelated areas
- **Reversibility:** Prepare for change, no final decisions - use interfaces, avoid locking into vendors/technologies

## Development Patterns

- **Tracer Bullets:** Build minimal end-to-end functionality early, then expand - production code kept and expanded (vs prototypes which are thrown away)
- **Prototypes:** Disposable exploration to answer specific questions - throw away after learning
- **Design by Contract:** Document preconditions, postconditions, invariants - makes responsibilities explicit

## Design Practices

- **Domain Languages:** Program close to problem domain - internal DSLs where appropriate
- **General-Purpose Interfaces:** Support broad range of uses - fewer methods, deeper modules, less coupling

## Application Guidelines

- Extract common logic to single location (DRY)
- Use abstractions to defer binding (Reversibility)
- Keep components independent (Orthogonality)
- Build working skeleton first (Tracer Bullets)
- Explore with throwaway code when needed (Prototypes)
