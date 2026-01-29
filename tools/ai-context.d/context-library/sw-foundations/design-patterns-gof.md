# Gang of Four Design Patterns

**Source:** Design Patterns: Elements of Reusable Object-Oriented Software (Gang of Four)

Use patterns when they clearly simplify design. Don't force patterns.

## Creational Patterns

Control object creation mechanisms:

- **Abstract Factory:** Create families of related objects without specifying concrete classes
- **Builder:** Construct complex objects step by step - prefer for >4 parameters
- **Factory Method:** Define interface for creating object, let subclasses decide which class to instantiate
- **Prototype:** Create new objects by copying prototypical instance
- **Singleton:** Ensure class has only one instance - avoid; use dependency injection instead

## Structural Patterns

Compose objects into larger structures:

- **Adapter:** Convert interface of class into another interface clients expect
- **Bridge:** Decouple abstraction from implementation so both can vary independently
- **Composite:** Compose objects into tree structures to represent part-whole hierarchies
- **Decorator:** Attach additional responsibilities to object dynamically
- **Facade:** Provide unified interface to set of interfaces in subsystem
- **Flyweight:** Share objects to support large numbers of fine-grained objects efficiently
- **Proxy:** Provide surrogate or placeholder for another object to control access

## Behavioral Patterns

Define object interaction and responsibility distribution:

- **Chain of Responsibility:** Avoid coupling sender to receiver by giving multiple objects chance to handle request
- **Command:** Encapsulate request as object, enabling parameterization, queuing, and undo
- **Iterator:** Access elements of aggregate object sequentially without exposing representation
- **Mediator:** Define object that encapsulates how set of objects interact
- **Memento:** Capture and externalize object's internal state for later restoration
- **Observer:** Define one-to-many dependency so dependents notified when object changes state
- **State:** Allow object to alter behavior when internal state changes
- **Strategy:** Define family of algorithms, encapsulate each, make them interchangeable - prefer over conditionals
- **Template Method:** Define algorithm skeleton in operation, defer steps to subclasses
- **Visitor:** Represent operation to be performed on elements of object structure

## When to Use

- Creational: Complex object creation
- Structural: Object composition challenges
- Behavioral: Object interaction/communication problems
- Always: Consider if pattern simplifies vs complicates
