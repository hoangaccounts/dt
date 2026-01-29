# Testing Standards

**Sources:** Test-Driven Development: By Example (Kent Beck), Growing Object-Oriented Software, Guided by Tests (Freeman & Pryce), xUnit Test Patterns (Gerard Meszaros), Working Effectively with Legacy Code (Michael Feathers), The Pragmatic Programmer (Hunt & Thomas)

## Test Requirements

**Always required:**
- New code MUST have tests before considered complete
- Changed code MUST have updated tests
- Domain layer: 100% coverage - no exceptions
- Use cases: 100% coverage - no exceptions
- No code merged without passing tests

## Test-Driven Development

Use TDD for new code:

- **Red-Green-Refactor:** Write failing test → Make it pass → Refactor
- **Three Laws (Beck):**
  1. Write no production code except to pass failing test
  2. Write only enough test to demonstrate failure
  3. Write only enough production code to pass test

## Test Pyramid

Maintain this ratio:

- **Unit Tests (70-80%):** Fast, isolated, many - test single units without dependencies
- **Integration Tests (15-25%):** Medium speed, test boundaries - database, network, file system
- **End-to-End Tests (5-10%):** Slow, brittle, few - critical user paths only

## What to Test

- **Test Behavior:** Not implementation - refactoring shouldn't break tests
- **Public Interfaces Only:** Don't test private methods - if needed, design smell
- **Edge Cases:** Boundaries, empty, null, max/min values, zero, negative
- **One Concept Per Test:** Single reason to fail - easier debugging

## Test Organization

Use Arrange-Act-Assert (or Given-When-Then):

```kotlin
@Test
fun `user with sufficient balance can withdraw money`() {
    // Arrange
    val account = Account(balance = Money(100))
    
    // Act
    val result = account.withdraw(Money(50))
    
    // Assert
    assertTrue(result.isSuccess)
    assertEquals(Money(50), account.balance)
}
```

## Test Doubles

Know when to use each:

- **Dummy:** Fill parameters, never used - when signature requires object
- **Stub:** Canned answers - when need predetermined responses
- **Fake:** Working simplified implementation - in-memory database, fake repository
- **Mock:** Verify interactions - when behavior is the interaction itself
- **Spy:** Record + real behavior - when need to verify calls but also need real functionality

Prefer fakes over mocks when possible (classicist approach).

## Testing by Layer

- **Domain (Entities/Value Objects):** 100% unit tests, zero dependencies
- **Use Cases:** Unit tests with repository/service mocks
- **Data (Repositories):** Integration tests with real database
- **Presentation (ViewModels):** Unit tests with mocked use cases

## Legacy Code

When tests don't exist:

- **Characterization Tests:** Document current behavior before changing
- **Seams:** Points where behavior can be altered - object seam (dependency injection), link seam (different library)
- **Sprout Method/Class:** Add new code in testable method/class, call from legacy code
- **Cover and Modify:** Get code under test, then make changes safely

## Test Smells

Refactor when tests have:

- **Fragile Tests:** Break from unrelated changes - coupled to implementation
- **Slow Tests:** Take too long - using real dependencies unnecessarily
- **Obscure Tests:** Hard to understand - too much setup, unclear purpose
- **Assertion Roulette:** Multiple assertions, unclear which failed
- **Conditional Test Logic:** if/loop in tests - test should be simple

## Coverage

- **Target:** 80%+ line coverage in domain layer
- **Not Sufficient:** High coverage doesn't guarantee good tests
- **Focus:** Test important behaviors thoroughly, not just coverage number
- **State Coverage:** More important than code coverage - test state transitions, combinations

## Best Practices

- **Fast Feedback:** Unit tests run in milliseconds, full suite <10 minutes
- **Deterministic:** Same input → same output, always - no random, no time, no external services
- **Isolated:** Tests don't depend on each other, run in any order
- **Independent:** Can run one test alone
- **Test Pyramid:** Many unit, some integration, few E2E
- **Listen to Tests (Freeman & Pryce):** Hard to test = design problem - too many dependencies, too much coupling

## Ruthless Testing (Pragmatic)

- **Test Early:** Write tests as you write code (or before with TDD)
- **Test Often:** Continuous integration runs all tests on every commit
- **Test Automatically:** No manual testing - automate everything possible
- **Find Bugs Once:** Write test when bug found, keep test to prevent regression
