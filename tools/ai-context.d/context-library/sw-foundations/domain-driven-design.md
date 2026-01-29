# Domain-Driven Design

**Sources:** Domain-Driven Design (Eric Evans), Implementing Domain-Driven Design (Vaughn Vernon)

Use for complex business domains.

## Strategic Design

- **Bounded Context:** Explicit boundary where domain model is defined and applicable
- **Ubiquitous Language:** Shared language between developers and domain experts, used in code
- **Context Mapping:** Document relationships between bounded contexts (Shared Kernel, Customer-Supplier, Anticorruption Layer, Conformist, Separate Ways)

## Tactical Design

Always apply in domain layer:

- **Entities:** Objects with identity that persists over time - equality based on ID, not attributes
- **Value Objects:** Objects defined by attributes, no identity - immutable, compared by value
- **Aggregates:** Cluster of entities/value objects with defined boundary and root - consistency boundary, one repository per aggregate
- **Domain Services:** Operations that don't belong to entity/value object - stateless, domain logic
- **Domain Events:** Something that happened in domain that domain experts care about - immutable, past tense
- **Repositories:** Collection-like interface for aggregates - encapsulate persistence, domain-focused queries
- **Factories:** Encapsulate complex creation logic - ensure valid objects from start

## Aggregate Design Rules

- Keep small (single entity + value objects when possible)
- Reference other aggregates by ID only
- One transaction = one aggregate
- Enforce invariants within aggregate boundary
- Only aggregate root is publicly accessible

## Application

- Use ubiquitous language in all code
- Place behavior with data (rich domain model)
- Entities and value objects in domain layer have no framework dependencies
- Repository interfaces in domain, implementations in infrastructure
