# Refactoring Patterns

**Source:** Refactoring: Improving the Design of Existing Code (Martin Fowler)

Refactoring changes code structure without changing external behavior.

## When to Refactor

- Adding feature reveals design problems
- Fixing bug shows underlying issues
- During code review
- Rule of Three: first time do it, second time wince, third time refactor

Never refactor when: close to deadline (pay debt later), code works and won't change, rewrite would be faster

## Common Refactorings

Apply these to improve design:

- **Extract Method:** Group code fragment into named method - when method too long or needs comment
- **Inline Method:** Replace method call with method body - when body as clear as name
- **Rename Method/Variable:** Change name to reveal purpose - when name doesn't communicate intent
- **Move Method:** Move to class where it's used most - when method uses more from another class
- **Extract Class:** Split class doing work of two - when class has multiple responsibilities
- **Introduce Parameter Object:** Replace parameter group with object - when parameters naturally belong together
- **Replace Magic Number with Constant:** Extract literal to named constant - when number has special meaning
- **Decompose Conditional:** Extract condition and branches to methods - when complex conditional
- **Replace Conditional with Polymorphism:** Use subclasses for type-based conditionals - when type code determines behavior
- **Replace Nested Conditional with Guard Clauses:** Use early returns for special cases - when deep nesting obscures normal flow
- **Introduce Null Object:** Replace null checks with object providing default behavior - when repeated null checks

## Code Smells

Indicators refactoring needed:

- **Bloaters:** Long Method, Long Parameter List, Large Class, Primitive Obsession
- **OO Abusers:** Switch Statements (use polymorphism), Temporary Field, Refused Bequest
- **Change Preventers:** Divergent Change (one class changes for many reasons), Shotgun Surgery (one change requires many small changes)
- **Dispensables:** Comments (often signal unclear code), Duplicate Code, Lazy Class, Dead Code
- **Couplers:** Feature Envy (method uses another class more), Inappropriate Intimacy, Message Chains

## Safe Refactoring

- Have tests before refactoring
- Take small steps
- Run tests after each step
- Commit frequently
- Use IDE refactoring tools when possible
