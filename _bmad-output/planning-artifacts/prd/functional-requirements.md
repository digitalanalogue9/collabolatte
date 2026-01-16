# Functional Requirements

*This is the Capability Contract. Every feature traces back to one of these FRs. If it's not here, it doesn't get built.*

*Reviewed and refined via Party Mode (Winston, Sally, Murat, Mary) - 2026-01-11*

---

### 1. User Identity & Access

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR1 | Users authenticate via Azure Entra ID (EasyAuth); no custom credential storage | MVP | Must | All |
| FR2 | System captures user email and display name from Entra ID claims on first login | MVP | Must | Tomás |
| FR3 | Users can optionally provide department and location if not available from directory | MVP | Should | Tomás |
| FR4 | Users can view their own participation history (programmes joined, past matches) | MVP | Should | Tomás, Priya |

---

### 2. Programme Participation

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR5 | Users can view programmes they are eligible to join | MVP | Must | Tomás |
| FR6 | Users can join a programme with a single action | MVP | Must | Tomás |
| FR7 | Users can leave a programme at any time; if mid-cycle, pending match is cancelled and match partner is notified | MVP | Must | Tomás |
| FR8 | Users can view programmes they are currently enrolled in | MVP | Must | Tomás |
| FR9 | Users can pause participation in a programme (skip next cycle) | MVP | Should | Tomás |
| FR10 | Users receive confirmation of programme join/leave actions | MVP | Should | Tomás |

---

### 3. Matching

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR11 | System executes matching algorithm on a predictable schedule (weekly or monthly; **default monthly**; configured as an ops setting, not user-configurable) | MVP | Must | Marcus (triggered) |
| FR12 | All programme participants are eligible for matching; organisational boundary filtering is a Growth-phase capability | MVP | Must | Marcus |
| FR13 | Random matching with architecture supporting future algorithm configurability | MVP | Must | Marcus |
| FR14 | Matching algorithm avoids repeat pairings within configurable window (default: 3 cycles); historical matches stored per programme | MVP | Must | Marcus |
| FR15 | If participant count is odd, one participant is gracefully excluded with explanation | MVP | Should | Marcus |

---

### 4. Notifications

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR16 | Match notification email contains: matched participant name, Teams deep link, and a simple first‑move prompt with suggested intro copy (copy‑paste friendly) | MVP | Must | Marcus |
| FR17 | Email is sent via Azure Communication Services to user's Entra ID email | MVP | Must | Marcus |
| FR18 | Teams deep link opens 1:1 chat with matched participant | MVP | Must | Marcus |

---

### 7. Privacy & Trust

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR30 | No individual-level API endpoints exist for admin/owner queries about specific participants; individual participants can access their own data via authenticated endpoints | MVP | Must | All |
| FR31 | No tracking of whether matched participants actually met | MVP | Must | Aisha |
| FR32 | All personal data deletable upon user request (GDPR Article 17) | MVP | Must | All |
| FR33 | No analytics on message content or conversation outcomes | MVP | Must | Aisha |
| FR34 | System logs events, not behaviours (see Event Logging) | MVP | Must | All |
| FR41 | Users can view a "What we collect" transparency page explaining data handling | MVP | Should | All |

---

### 8. Event Logging

| ID | Requirement | Phase | Priority | Journey Link |
|----|-------------|-------|----------|---------------|
| FR35 | System logs programme lifecycle events (created, paused, deactivated) | MVP | Must | Priya, Helena |
| FR36 | System logs matching execution events (run started, completed, participants matched) | MVP | Must | Marcus |
| FR37 | Privacy-preserving aggregate queries only; minimum 5 participants required for any aggregate query | MVP | Must | Helena |
| FR38 | Event log entries are immutable and timestamped | MVP | Must | Helena |
| FR39 | No individual-level event queries exposed to admin/owner roles | MVP | Must | Aisha |

---

### Functional Requirements Summary

MVP functional requirements have been aligned to the product brief (single programme, minimal notification, no dashboards or programme creation). Deferred requirements are preserved in the **Deferred / Post‑MVP** section below.

**Traceability:** Every remaining MVP FR links to an MVP‑scope journey and success criteria.

**Party Mode Refinements Applied:**
- FR4: Clarified "own" data access
- FR7: Added mid-cycle leave handling
- FR12: Clarified MVP scope (no boundary filtering yet)
- FR13: Honest about MVP being random-only
- FR16/19: Merged email content specification
- FR20: Added single-reminder constraint
- FR30: Clarified individual vs admin access
- FR37: Added minimum 5-participant threshold
- FR29a: Added admin dashboard requirement (new)

**Pre-mortem Additions (2026-01-11):**
- FR41: User-facing transparency page
- FR42: Cycle completion notification to Programme Owner
- Anti-Mandate Principle added to Cultural Risk Mitigations

---
