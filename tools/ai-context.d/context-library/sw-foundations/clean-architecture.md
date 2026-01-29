# Clean Architecture

**Source:** Clean Architecture (Robert C. Martin)

Always use for applications with business logic.

## The Dependency Rule

**Core rule:** Dependencies point inward. Outer layers depend on inner layers, never reverse.

```
Frameworks & Drivers (UI, DB, Web)
  ↓
Interface Adapters (Controllers, Presenters, Gateways)
  ↓
Use Cases (Application Business Rules)
  ↓
Entities (Enterprise Business Rules)
```

- Inner layers define interfaces
- Outer layers implement interfaces
- Business logic independent of frameworks, UI, database

## Layers

- **Entities (Domain):** Core business logic, no dependencies on anything
- **Use Cases:** Application-specific business rules, orchestrate entities
- **Interface Adapters:** Convert data between use cases and external world (ViewModels, Repositories)
- **Frameworks & Drivers:** Tools and frameworks (UI, database, network)

## Component Principles

**Cohesion:**
- REP: Reuse/Release Equivalence - classes released together
- CCP: Common Closure - classes that change together belong together
- CRP: Common Reuse - don't force users to depend on things they don't use

**Coupling:**
- ADP: Acyclic Dependencies - no cycles in dependency graph
- SDP: Stable Dependencies - depend in direction of stability
- SAP: Stable Abstractions - stable components should be abstract

## Key Practices

- One transaction per aggregate
- Repository only for aggregate roots
- Use cases are interactors
- ViewModels/Controllers adapt for UI
- Database implements repository interfaces defined in domain
