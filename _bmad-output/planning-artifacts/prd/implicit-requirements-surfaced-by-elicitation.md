# Implicit Requirements (Surfaced by Elicitation)

| Requirement | Rationale | Priority |
|-------------|-----------|----------|
| **Directory/SSO integration** | Pre-fill signup, reduce friction | MVP - hard dependency |
| **One-click introduction action** | Reduce first-move friction | MVP |
| **Conversation starter prompt** | Tips awkwardness toward usefulness | MVP (promoted from Should-Have) |
| **Cross-boundary matching constraint** | Ensures thesis validation | MVP |
| **Delivery confirmation (silent)** | Detect notification failures | MVP |
| **Event logging (match-sent, match-acknowledged)** | Future-proof for re-engagement metrics | MVP |
| **Re-engagement tracking (silent)** | Validates graceful dormancy works | MVP (lightweight) |
| **Optional story capture channel** | Surface anecdotes for Helena | Post-MVP (or manual workaround) |

---

### Integration Requirements

| Requirement | Rationale | Priority |
|-------------|-----------|----------|
| **SSO/Directory integration** | Pre-fill signup, reduce friction, ensure identity | MVP |
| **Teams/Slack integration** | Notification delivery and one-click introduction | MVP |
| **HRIS integration** | For cross-boundary constraint validation (function, region) | Post-MVP |

---

### 5. Programme Management

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR21 | Programme Owner can create a new programme with name, description, and cadence | Growth | Must | Priya |
| FR22 | Programme Owner can invite participants by email address or CSV upload | Growth | Should | Priya |
| FR23 | Programme Owner can view aggregate participation metrics (joined, active, paused) | Growth | Should | Priya |
| FR24 | Matching cadence is configurable as an ops setting (weekly or monthly; **default monthly**); no Programme Owner UI for cadence in MVP | MVP | Must | Priya |
| FR25 | Programme Owner can edit programme name and description (cadence is ops-configured in MVP) | MVP | Should | Priya |
| FR42 | Programme Owner receives notification when matching cycle completes, including status and any system errors (no participation counts) | MVP | Should | Priya |

---

### 6. Administration

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR26 | Admin can view all programmes in the system | MVP | Must | Helena |
| FR27 | Admin can deactivate a programme | MVP | Must | Helena |
| FR28 | Admin can assign Programme Owner role to users | MVP | Must | Helena |
| FR29 | Admin cannot view individual participation or match data | MVP | Must | Helena (trust constraint) |
| FR29a | Admin can view ops‑only programme health (cycle status, notification delivery health, trust guardrails status, operational errors with correlation IDs) gated behind minimum‑N ≥5 | MVP | Should | Helena |

---
