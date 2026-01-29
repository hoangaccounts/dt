# Development Philosophy

**Sources:** Clean Code (Robert C. Martin), The Pragmatic Programmer (Hunt & Thomas), Code Complete (Steve McConnell)

## Core Philosophy

Always apply:

- **Care About Craft:** No point developing software unless doing it well - think while working, constantly critique
- **Take Responsibility:** Provide options, not excuses - "I don't know, but I'll find out"
- **Software Entropy (Broken Windows):** Don't leave bad code unrepaired - one broken window leads to more, fix immediately or board up
- **Stone Soup:** Be catalyst for change - show people the future, they'll help build it
- **Good-Enough Software:** Meets requirements, no more, no less - involve users in quality decisions, know when to stop
- **Strategic Programming:** Invest 10-20% time in design improvement - working code isn't enough, structure matters most

## Your Knowledge Portfolio

Manage like financial portfolio:

- **Invest Regularly:** Learn something new consistently, even small amounts
- **Diversify:** More different things you know, more valuable
- **Review and Rebalance:** Industry changes, portfolio should too

Goals: Learn new language yearly, read technical book monthly, experiment with different environments

## Communication

- **It's Both What You Say and the Way You Say It:** Great ideas worthless without effective communication
- **Know Your Audience:** Choose style that suits them
- **Make It Look Good:** Presentation matters
- **Be a Listener:** Encourage people to talk, get feedback early

## Automation

- **Ubiquitous Automation:** Automate everything possible - computers better at repetitive tasks, humans make mistakes when bored
- **Automate:** Build process, testing, deployment, code generation, anything done more than twice

## Key Principles

Use these to guide all decisions:

- **Working Code Isn't Enough (Ousterhout):** Most important thing is system structure, not just functionality
- **Start Simple (YAGNI):** Don't add complexity until needed - simplest thing that works
- **Production Quality from Day One:** No "temporary" hacks, no "we'll clean it up later"
- **Use Clean Architecture Always:** Even small projects - structure same for small/large, just fewer files
- **Boy Scout Rule (Martin):** Leave code cleaner than you found it - continuous improvement

## Code Approach

- **Start with simplest solution** - Don't prematurely apply patterns
- **Refactor toward patterns** - Let patterns emerge from actual needs
- **Use patterns early when:** Domain naturally fits (e.g., Builder for UI construction), Team expertise exists, Pattern genuinely simplifies

## Testing & Refactoring

- **Tests Enable Change:** Without tests, can't safely refactor or modify
- **Red-Green-Refactor (Beck):** Write failing test → Make it pass → Improve design
- **Refactor Continuously:** Don't accumulate technical debt - refactor as you go
- **Listen to Tests (Freeman & Pryce):** Hard to test = design problem

## Operational Considerations

From production experience:

- **Design for Failure:** Everything fails eventually - circuit breakers, timeouts, retries
- **Monitor Everything:** Can't fix what you can't see - metrics, logs, alerts
- **Automate Deployment:** Manual deploys are error-prone - deployment pipeline required
