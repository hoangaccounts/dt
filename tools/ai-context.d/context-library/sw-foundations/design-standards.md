# Design Standards - Overview

## Purpose

This is the entry point for all design standards. Design standards are organized into specialized modules, each covering a specific aspect of software design.

**When to use this document:** During design phase, before writing implementation code. These standards guide structural decisions about how to organize and structure your system.

---

## Design Modules

### [SOLID Principles](design-standards/solid-principles.md)
**Foundation of object-oriented design.**

The five SOLID principles (SRP, OCP, LSP, ISP, DIP) form the bedrock of maintainable object-oriented systems.

**Use when:** Always - these principles apply to every class and interface you design.

**Key concepts:** Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion

---

### [Clean Architecture](design-standards/clean-architecture.md)
**Layered architecture with dependency rule.**

Organize code into concentric layers where dependencies point inward toward business logic. Makes systems independent of frameworks, UI, databases.

**Use when:** Any application with business logic (recommended for all projects).

**Key concepts:** Dependency Rule, Domain Layer, Use Cases, Interface Adapters, Frameworks, Component Principles, Screaming Architecture

---

### [Design Patterns (GoF)](design-standards/design-patterns-gof.md)
**23 fundamental design patterns.**

Complete catalog of Gang of Four patterns: Creational, Structural, and Behavioral patterns.

**Use when:** 
- **Creational:** Complex object creation (Factory, Builder, Prototype)
- **Structural:** Object composition (Adapter, Decorator, Facade, Proxy)
- **Behavioral:** Object interaction (Strategy, Observer, Command, State)

**Key concepts:** All 23 GoF patterns with Kotlin examples

---

### [Domain-Driven Design](design-standards/domain-driven-design.md)
**Model complex business domains.**

Strategic and tactical patterns for building software centered around business domain understanding.

**Use when:** 
- Complex business rules
- Domain logic is core to application
- Working with domain experts
- Large or evolving systems

**Key concepts:** Bounded Contexts, Ubiquitous Language, Entities, Value Objects, Aggregates, Domain Services, Domain Events

---

### [Enterprise Patterns](design-standards/enterprise-patterns.md)
**Patterns of Enterprise Application Architecture.**

Proven patterns for enterprise applications: domain logic, data source, web presentation, distribution, and more.

**Use when:**
- Building enterprise/business applications
- Need proven solutions for common enterprise problems
- Working with databases, transactions, distribution

**Key concepts:** Repository, Unit of Work, Service Layer, Data Mapper, DTO, MVC/MVP, Optimistic Locking, Value Object

---

### [Pragmatic Design](design-standards/pragmatic-design.md)
**Practical design principles from Pragmatic Programmer.**

Focus on flexibility, maintainability, and managing change.

**Use when:**
- Making architectural decisions
- Balancing current needs vs future flexibility
- Deciding how to structure code

**Key concepts:** DRY, Orthogonality, Reversibility, Tracer Bullets, Domain Languages, Design by Contract

---

### [Refactoring Patterns](design-standards/refactoring-patterns.md)
**Improve design of existing code.**

Code smells and refactoring techniques for evolving design toward better structure.

**Use when:**
- Code review identifies problems
- Adding features reveals design issues
- Code is hard to understand or change
- Technical debt accumulation

**Key concepts:** Code Smells (Bloaters, Abusers, Preventers, Dispensables, Couplers), Refactoring Techniques, Safe Refactoring

---

### [Complexity Management](design-standards/complexity-management.md)
**A Philosophy of Software Design - Managing complexity.**

Unique perspective on software complexity through deep modules, information hiding, and interface design.

**Use when:**
- Designing module interfaces
- Deciding what to expose vs hide
- Making abstraction decisions
- Evaluating if design is "good"

**Key concepts:** Deep vs Shallow Modules, Information Hiding, General-Purpose Interfaces, Pull Complexity Downward, Design It Twice, Strategic Programming

---

### [Quality Attributes](design-standards/quality-attributes.md)
**Software Architecture in Practice - Quality-driven design.**

Quality attributes (non-functional requirements) and tactics for achieving them. Architecture is driven by quality requirements.

**Use when:**
- Defining architecture requirements
- Making architectural trade-offs
- Evaluating architecture options
- Understanding system qualities (performance, availability, security, etc.)

**Key concepts:** Performance, Availability, Modifiability, Security, Testability, Scalability, Architecture Tactics, Trade-off Analysis, Quality Scenarios

---

### [Fundamental Abstraction](design-standards/fundamental-abstraction.md)
**SICP - Computational thinking fundamentals.**

Timeless principles of abstraction, composition, and computational thinking that transcend languages and paradigms.

**Use when:**
- Learning to think about programs fundamentally
- Understanding evaluation models
- Designing abstractions
- Creating domain-specific languages
- Understanding relationship between functions and data

**Key concepts:** Building Abstractions with Functions, Building Abstractions with Data, Higher-Order Functions, Closure, Modularity and State, Metalinguistic Abstraction, Evaluation Models

---

## Quick Decision Guide

**"Should I use Clean Architecture?"**
→ Yes, for any application with business logic. See [clean-architecture.md](design-standards/clean-architecture.md)

**"Which design pattern should I use?"**
→ Identify your problem type, then see [design-patterns-gof.md](design-standards/design-patterns-gof.md)

**"How do I model this complex domain?"**
→ Start with [domain-driven-design.md](design-standards/domain-driven-design.md) for bounded contexts and aggregates

**"What's wrong with my current design?"**
→ Check [refactoring-patterns.md](design-standards/refactoring-patterns.md) for code smells

**"How should I structure my data access?"**
→ See Repository pattern in both [domain-driven-design.md](design-standards/domain-driven-design.md) and [enterprise-patterns.md](design-standards/enterprise-patterns.md)

**"My code violates SOLID - which principle?"**
→ See [solid-principles.md](design-standards/solid-principles.md) for all five with examples

**"How do I know if my module design is good?"**
→ Check [complexity-management.md](design-standards/complexity-management.md) for deep vs shallow modules

**"What quality attributes should I optimize for?"**
→ See [quality-attributes.md](design-standards/quality-attributes.md) for performance, availability, security, etc.

**"How do I think about abstraction fundamentally?"**
→ See [fundamental-abstraction.md](design-standards/fundamental-abstraction.md) for SICP principles

---

## Relationship Between Modules

**Foundation:**
- Start with [SOLID Principles](design-standards/solid-principles.md) - applies to all code

**Architecture:**
- [Clean Architecture](design-standards/clean-architecture.md) provides overall structure
- [Pragmatic Design](design-standards/pragmatic-design.md) guides architectural decisions

**Domain Modeling:**
- [Domain-Driven Design](design-standards/domain-driven-design.md) for complex business domains
- [Enterprise Patterns](design-standards/enterprise-patterns.md) for implementation details

**Implementation Patterns:**
- [Design Patterns (GoF)](design-standards/design-patterns-gof.md) for specific problems
- [Enterprise Patterns](design-standards/enterprise-patterns.md) for enterprise concerns

**Improvement:**
- [Refactoring Patterns](design-standards/refactoring-patterns.md) for evolving design

---

## Design Philosophy

**From [development-philosophy.md](development-philosophy.md):**
- Start simple (YAGNI)
- Use Clean Architecture always (even small projects)
- Patterns emerge from refactoring
- Production quality from day one

**What's NOT in these modules:**
- Code-level implementation → see [code-standards.md](code-standards.md)
- Testing strategies → see [testing-standards.md](testing-standards.md)
- Workflow and process → see [working-style.md](working-style.md)

---

## Getting Started

**For new projects:**
1. Read [clean-architecture.md](design-standards/clean-architecture.md) for overall structure
2. Review [solid-principles.md](design-standards/solid-principles.md) for class design
3. Check [pragmatic-design.md](design-standards/pragmatic-design.md) for DRY, Orthogonality
4. If complex domain → read [domain-driven-design.md](design-standards/domain-driven-design.md)

**For existing projects:**
1. Identify code smells in [refactoring-patterns.md](design-standards/refactoring-patterns.md)
2. Find refactoring techniques to fix smells
3. Gradually refactor toward patterns when beneficial

**For specific problems:**
1. Search [design-patterns-gof.md](design-standards/design-patterns-gof.md) for solution
2. Or check [enterprise-patterns.md](design-standards/enterprise-patterns.md) for enterprise-specific patterns

---

*Design standards guide structural decisions. They work together to create maintainable, flexible systems.*
