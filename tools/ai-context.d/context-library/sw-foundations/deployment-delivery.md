# Deployment & Delivery

**Sources:** Continuous Delivery (Jez Humble & David Farley), Release It! (Michael Nygard)

## Deployment Pipeline

Every commit goes through automated pipeline:

**Stages:**
1. **Commit Stage (<10 min):** Compile, unit tests, static analysis - fast feedback
2. **Acceptance Stage (<1 hour):** Deploy to test environment, automated acceptance tests
3. **Performance Stage:** Load tests, capacity tests - validate non-functional requirements
4. **Production:** Deploy when all stages pass

**Rules:**
- Failure stops pipeline
- Fix broken builds immediately
- Everyone commits to mainline daily
- All production deployments go through same pipeline

## Continuous Integration

- **Integrate Frequently:** Multiple times per day, not long-lived branches
- **Automated Build:** Every commit triggers build and tests
- **Fast Builds:** <10 minutes for commit stage
- **Visible Status:** Team knows build state instantly

## Configuration Management

Everything in version control:

- Application code and tests
- Database migrations
- Infrastructure as Code
- Configuration files
- Deployment scripts
- Documentation

Benefits: Can recreate any environment, audit trail, easy rollback

## Testing Strategy

**Automate everything that can be automated:**

- Unit tests (commit stage)
- Integration tests (acceptance stage)
- Acceptance tests (acceptance stage)
- Performance tests (performance stage)
- Only manual: Exploratory testing, usability testing

## Release Management

**Decouple deployment from release:**

- **Deployment:** Install software in environment
- **Release:** Make features available to users
- **Feature Toggles:** Deploy anytime, release when ready - enables gradual rollout, A/B testing, quick rollback

## Stability Patterns (Release It!)

Design for production from day one:

- **Circuit Breaker:** Stop calling failing service, fail fast - prevents cascading failures
- **Timeout:** Never wait forever - set timeouts on all network calls
- **Retry with Backoff:** Retry transient failures with exponential backoff
- **Bulkhead:** Isolate resources (thread pools, connections) - failure in one doesn't take down system
- **Fail Fast:** Detect problems early, fail immediately - better than corrupt state

## Capacity Patterns

- **Connection Pool:** Reuse expensive connections - tune pool size based on load
- **Caching:** Cache expensive operations - consider TTL, invalidation strategy
- **Throttling:** Limit request rate - protect system from overload

## Production Readiness

- **Steady State:** Design for continuous operation - log rotation, purge old data, no resource leaks
- **Health Checks:** Expose /health endpoint - check database, cache, external APIs, disk space
- **Monitoring:** Track request rate, error rate, response times (p50/p95/p99), resource usage
- **Logging:** Structured logs, centralized aggregation - ERROR (needs attention), WARN (unexpected, recovered), INFO (key events), DEBUG (troubleshooting)
- **Alerts:** Alert on error rate, response time degradation, resource exhaustion - avoid alert fatigue

## Deployment Patterns

- **Blue-Green:** Two identical environments, switch traffic - zero downtime, easy rollback
- **Canary:** Release to small subset first - monitor metrics, rollback if problems
- **Rolling:** Gradually update instances - progressive rollout, easy to pause

## Observability

**Three Pillars:**
- **Metrics:** Time-series data, aggregatable - dashboards and alerts
- **Logs:** Individual events - debugging
- **Traces:** Request flow across services - distributed systems

**RED Method (services):** Rate (req/s), Errors (errors/s), Duration (response time)
**USE Method (resources):** Utilization (% busy), Saturation (queue depth), Errors (error count)
