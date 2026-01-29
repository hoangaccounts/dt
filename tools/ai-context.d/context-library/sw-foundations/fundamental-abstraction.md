# Fundamental Abstraction

**Source:** Structure and Interpretation of Computer Programs (Abelson & Sussman)

Timeless computational thinking principles transcending languages and paradigms.

## Core Principles

Always apply:

- **Abstraction:** Hide details behind interfaces - functions hide implementation, data abstractions hide representation
- **Composition:** Build complex from simple - compose functions, compose data structures, compose systems
- **Naming:** Create computational objects through binding names to values - builds vocabulary, enables reuse
- **Higher-Order Functions:** Functions that operate on functions - enables powerful abstractions and code reuse
- **Closure:** Functions that capture variables from enclosing scope - enables encapsulation and state

## Key Concepts

- **Functions as First-Class Values:** Pass, return, store functions like any value
- **Data Defined by Operations:** Data is whatever operations are defined on it, not internal representation
- **Abstraction Barriers:** Users work with abstract operations, not representations - can change representation without affecting users
- **Hierarchical Composition:** Complex structures built from simpler ones (lists from pairs, trees from lists)

## Evaluation Models

Understand how programs execute:

- **Substitution Model (Functional):** Replace function call with body, substitute arguments - no side effects, order doesn't matter
- **Environment Model (With State):** Track bindings in environment, state changes over time - order matters

## Application to Modern Development

- Use functions to hide complexity
- Compose operations rather than duplicate logic
- Build abstractions through interfaces
- Higher-order functions for reusable patterns (map, filter, reduce, retry)
- Closures for encapsulation
- Think about evaluation: functional (simpler to reason) vs stateful (when needed)
