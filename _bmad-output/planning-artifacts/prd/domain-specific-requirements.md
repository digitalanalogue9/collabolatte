# Domain-Specific Requirements

### Domain Pattern: Trust Infrastructure

Collabolatte operates in the **Organisational Network Design** domain. The core pattern is that this is **trust infrastructure**, not engagement tooling. Every design decision must pass through the lens:

> "Does this preserve or erode participant trust?"

If it erodes trust, it doesn't ship.

---

### Compliance & Regulatory

| Requirement | Detail |
|-------------|--------|
| **GDPR (EU)** | Lawful basis for processing employee data—likely legitimate interests with transparency, not consent (consent under employment relationship is problematic) |
| **UK GDPR** | ICO guidance on worker monitoring applies—must demonstrate transparency and proportionality |
| **CCPA (California)** | Employee data in scope as of January 2023—notice and rights obligations |
| **Cross-border transfers** | EU SCCs or UK IDTA/Addendum required for multinational deployments |
| **DPIA** | Recommended (and likely required) given employee data and potential privacy impact |

**Key Insight:** None of these block the MVP. They require design-time decisions (data minimisation, transparency, transfer mechanisms) rather than feature gates.

**Retention Policy:** Match history retained for 12 months, then anonymised. Users can request deletion at any time (GDPR Article 17).

---

### Technical Constraints (Privacy-by-Design)

| Constraint | Implication |
|------------|-------------|
| **Data minimisation** | Capture only what's needed for matching (name, function, location). No profile richness beyond that. |
| **Purpose limitation** | Participation data cannot be repurposed for performance evaluation or surveillance |
| **Retention limits** | Match history retention should be time-bounded; define retention period |
| **No individual-level reporting** | Aggregate metrics only; no manager access to participation data |
| **Audit trail** | Log what the system does (match-sent, match-acknowledged), not what users do |

---

### Cultural Risk Mitigations

| Risk | Mitigation |
|------|------------|
| **Ghost Town** | "Practice coffee" framing, conversation starters, match-acknowledged signal |
| **Obligation Creep** | Hard policy: no manager visibility, no OKR linkage, explicit voluntary framing |
| **Privacy Breach Perception** | Transparent architecture, published data model, no hidden logging |
| **Surveillance Rumours** | "We waited" copy, graceful dormancy, explicit opt-out without consequence |

**Anti-Mandate Principle:** Programme Owners must never position Collabolatte as required, expected, or tied to performance. Violation of this principle erodes trust and defeats the product's purpose.

---
