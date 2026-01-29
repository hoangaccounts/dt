# Enterprise Patterns

**Source:** Patterns of Enterprise Application Architecture (Martin Fowler)

Use for enterprise application challenges.

## Domain Logic Patterns

- **Domain Model:** Rich objects with behavior and data - use for complex business logic
- **Service Layer:** Defines application boundary with services - coordinates domain objects, establishes transaction boundaries

## Data Source Patterns

- **Repository:** Mediates between domain and data mapping using collection-like interface - one per aggregate root
- **Unit of Work:** Maintains list of objects affected by transaction, coordinates writing - tracks new/dirty/removed objects, commits atomically
- **Data Mapper:** Layer that moves data between objects and database while keeping them independent - domain objects don't know about database
- **Active Record:** Object wraps database row, encapsulates access, adds domain logic - simpler but couples domain to database; use only for simple domains

## Object-Relational Patterns

- **Identity Map:** Ensures each object loaded only once by keeping loaded objects in map - maintains object identity, acts as cache

## Web Presentation Patterns

- **MVC (Model-View-Controller):** Separates data (Model), presentation (View), input handling (Controller)
- **MVP (Model-View-Presenter):** Variation where Presenter contains UI logic, View is passive

## Distribution Patterns

- **DTO (Data Transfer Object):** Carries data between processes to reduce method calls - no behavior, just data
- **Remote Facade:** Coarse-grained facade over fine-grained objects for network efficiency

## Concurrency Patterns

- **Optimistic Offline Lock:** Prevents conflicts by detecting them and rolling back - use when conflicts rare
- **Pessimistic Offline Lock:** Prevents conflicts by locking when editing begins - use when conflicts common

## Base Patterns

- **Value Object:** Small object with no identity, defined by attributes - immutable, compared by value (Money, DateRange, Email)
- **Special Case (Null Object):** Subclass providing special behavior for particular cases - removes null checks
