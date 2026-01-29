# Complexity Management

**Source:** A Philosophy of Software Design (John Ousterhout)

Fighting complexity is most important element of software design.

## Core Principles

Always apply:

- **Deep Modules:** Simple interface, powerful functionality - maximize functionality to interface complexity ratio
- **Shallow Modules (Avoid):** Interface almost as complex as implementation - signals poor design
- **Information Hiding:** Design so knowledge about implementation not needed outside module
- **General-Purpose Interfaces:** Support broad range of uses - fewer special cases, more reusable
- **Pull Complexity Downward:** Better for module to have simple interface than simple implementation

## Design Practices

- **Design It Twice:** Consider 2-3 different approaches before choosing - invest 5-10% extra time
- **Strategic Programming:** Invest 10-20% time in design, not just features - working code isn't enough
- **Different Layer, Different Abstraction:** Each layer provides different abstraction - avoid pass-through methods
- **Define Errors Out of Existence:** Reduce exceptions by making operations idempotent, providing defaults

## Red Flags

Indicators of design problems:

- Shallow module (interface complexity ≈ implementation)
- Information leakage (same knowledge in multiple places)
- Temporal decomposition (structure mirrors order of operations)
- Pass-through method (does nothing but call another method)
- Repetition (same code/pattern in multiple places)
- Hard to describe (can't write clear comment)
- Nonobvious code (reader must think hard to understand)

## Application

- Make modules deep: hide complexity behind simple interfaces
- Each class should have simple public interface, complex internals
- Avoid classes that expose implementation details
- When adding functionality, pull complexity into module rather than exposing to users
- Test: if hard to comment, design is probably wrong
