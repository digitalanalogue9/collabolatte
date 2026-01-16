# Non-Functional Requirements

*Quality attributes for Collabolatte MVP – deliberately boring, defensible, and aligned with the product's low-pressure nature.*

---

### Performance

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR1 | Page loads complete within 3 seconds on standard corporate network | 95th percentile < 3s | Weekly touchpoint, not productivity tool |
| NFR2 | No hard real-time requirements | N/A | Matching runs on schedule, not on-demand |
| NFR3 | System remains usable under degraded conditions | Core flows complete even if slow | Occasional slowness acceptable; failure is not |

---

### Security

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR4 | All data encrypted in transit (TLS 1.2+) | Certificate validation on all endpoints | Baseline enterprise expectation |
| NFR5 | All data encrypted at rest | Azure Storage Service Encryption enabled | Defence in depth |
| NFR6 | Authentication via Azure Entra ID only; no custom credential storage | Zero stored passwords | Reduces attack surface to zero |
| NFR7 | Least-privilege access: users see only their own data; owners see only aggregate | Role-based access enforced at API layer | Trust architecture is the product |
| NFR8 | Clear data retention policy: personal data deleted within 30 days of account deletion request | GDPR Article 17 compliance | Right to erasure is non-negotiable |
| NFR9 | No dark telemetry or behavioural tracking | Code review confirms no hidden analytics | Anti-surveillance is a feature |
| NFR10 | Tenant isolation: single-tenant MVP with architecture supporting future multi-tenant separation | Logical isolation by design | Avoid painful refactoring later |

---

### Availability & Reliability

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR11 | Best-effort availability; no formal SLA for MVP | Target 99% monthly uptime (informational) | Convenience service, not critical system |
| NFR12 | One hour of downtime during business hours is acceptable | No pager duty for MVP | Right-sized for internal pilot |
| NFR13 | Clear failure behaviour: no silent errors, no partial matches | All failures logged and surfaced | Users must trust the system told them the truth |
| NFR14 | Matching algorithm is atomic: runs completely or not at all | No half-matched cohorts | Consistency over speed |

---

### Email Delivery

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR15 | Match notifications sent within 60 minutes of algorithm completion | 95% delivered within 60 mins | Reliability over speed |
| NFR16 | Email delivery includes retry logic for transient failures | 3 retries with exponential backoff | Azure Communication Services handles this |
| NFR17 | Failed email delivery logged for operational review | Admin-visible delivery failures | Debuggability matters |

---

### Accessibility

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR18 | WCAG 2.1 AA as aspiration, not hard gate | Best-effort conformance | Good practice without blocking delivery |
| NFR19 | Keyboard navigation for all core flows | Tab order works; no mouse-only interactions | Low-hanging fruit |
| NFR20 | Readable contrast ratios (4.5:1 minimum for text) | Automated contrast checking in build | Easy to enforce |
| NFR21 | Screen-reader friendliness where straightforward | Semantic HTML, ARIA labels on interactive elements | Falls out of good design |

---

### Scalability

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR22 | Architecture supports future multi-tenant expansion | Partition key strategy accommodates org isolation | Don't paint yourself into a corner |
| NFR23 | No requirement to prove scale in MVP | Single-tenant pilot is sufficient | Validate hypothesis first |
| NFR24 | Consumption-based infrastructure (Azure Functions, Table Storage) | No fixed capacity provisioning | Scales down to near-zero; scales up if needed |

---

### Observability

| ID | Requirement | Measure | Rationale |
|----|-------------|---------|----------|
| NFR25 | Sufficient logging to debug failures and explain what happened | Structured logs for all API calls and background jobs | Operational necessity |
| NFR26 | No user-level behavioural analytics beyond operational necessity | No tracking of user actions beyond system events | Anti-surveillance by design |
| NFR27 | Application Insights or equivalent for error monitoring | Alerts on elevated error rates | Know when things break |

---

### Non-Functional Requirements Summary

| Category | NFR Count | MVP Hard Gate | Aspiration |
|----------|-----------|---------------|------------|
| Performance | 3 | 2 | 1 |
| Security | 7 | 7 | 0 |
| Availability & Reliability | 4 | 3 | 1 |
| Email Delivery | 3 | 3 | 0 |
| Accessibility | 4 | 0 | 4 |
| Scalability | 3 | 1 | 2 |
| Observability | 3 | 3 | 0 |
| **Total** | **27** | **19** | **8** |

**Design Principle:** These NFRs are deliberately boring. Security is non-negotiable. Everything else is right-sized for a trust-first internal pilot where the goal is learning, not perfection.

---
