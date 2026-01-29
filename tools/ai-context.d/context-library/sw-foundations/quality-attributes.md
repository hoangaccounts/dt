# Quality Attributes

**Source:** Software Architecture in Practice (Bass, Clements, Kazman)

Architecture driven by quality attribute requirements, not functional requirements.

## Key Quality Attributes

Design for quality requirements from start:

- **Performance:** Response time (latency) and throughput (events/time) - tactics: caching, concurrency, reduce computation, manage resources
- **Availability:** Proportion of time system operational - tactics: redundancy, health checks, retry, circuit breaker, failover
- **Modifiability:** Ease of making changes - tactics: low coupling, high cohesion, interfaces, defer binding, split modules
- **Security:** Resist unauthorized access while serving legitimate users - tactics: authentication, authorization, encryption, input validation
- **Testability:** Ease of demonstrating faults - tactics: dependency injection, observable state, reduce complexity, determinism
- **Scalability:** Handle increased load - tactics: horizontal scaling, data partitioning, caching, stateless services
- **Usability:** Ease of accomplishing tasks - tactics: cancel, undo, defaults, help

## Trade-offs

Quality attributes often conflict - make explicit choices:

- Performance vs Security: encryption slows operations
- Performance vs Modifiability: optimization reduces flexibility
- Availability vs Security: redundancy increases attack surface
- Cost vs Everything: quality requires resources

## Measuring Quality

Use scenarios to make requirements concrete:

**Format:** [Source] [Stimulus] [Environment] [Response] [Response Measure]

**Example - Performance:** 1000 concurrent users submit requests during normal operations, system returns results in <2 seconds (p95)

**Example - Availability:** Database crashes during normal operations, system fails over to replica in <30 seconds with no data loss

## Application

- Identify most important quality attributes early
- Understand conflicts between attributes
- Make explicit trade-off decisions
- Design tactics to achieve required qualities
- Measure to verify requirements met
