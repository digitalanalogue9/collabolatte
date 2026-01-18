---
workflow: check-implementation-readiness
project_name: collabolatte
date: 2026-01-14
stepsCompleted:
  - step-01-document-discovery
  - step-02-prd-analysis
  - step-03-epic-coverage-validation
  - step-04-ux-alignment
  - step-05-epic-quality-review
  - step-06-final-assessment
includedFiles:
  - _bmad-output/planning-artifacts/prd.md
  - _bmad-output/planning-artifacts/architecture.md
  - _bmad-output/planning-artifacts/epics.md
  - _bmad-output/planning-artifacts/ux-design-specification.md
  - _bmad-output/planning-artifacts/ux-design-directions.html
  - _bmad-output/planning-artifacts/ux-visual-themes.html
---

# Implementation Readiness Assessment Report

**Date:** 2026-01-14
**Project:** collabolatte

## Step 1 — Document Discovery Inventory

### PRD Files Found

**Whole Documents:**

- `prd.md` (50,730 bytes, modified 2026-01-14 22:15 UTC)

**Sharded Documents:**

- None found

### Architecture Files Found

**Whole Documents:**

- `architecture.md` (38,937 bytes, modified 2026-01-14 21:10 UTC)

**Sharded Documents:**

- None found

### Epics & Stories Files Found

**Whole Documents:**

- `epics.md` (35,950 bytes, modified 2026-01-14 22:16 UTC)

**Sharded Documents:**

- None found

### UX Design Files Found

**Whole Documents:**

- `ux-design-specification.md` (25,925 bytes, modified 2026-01-14 21:10 UTC)

**Additional UX artefacts (non-Markdown):**

- `ux-design-directions.html` (8,033 bytes, modified 2026-01-14 06:32 UTC)
- `ux-visual-themes.html` (6,951 bytes, modified 2026-01-14 22:54 UTC)

**Sharded Documents:**

- None found

### Issues Found

- No duplicates detected (no whole+sharded conflicts).
- No missing required documents detected (PRD, Architecture, Epics, UX all present).

## PRD Analysis

### Functional Requirements

FR1 (MVP, Must, Journey: All): Users authenticate via Azure Entra ID (EasyAuth); no custom credential storage  
FR2 (MVP, Must, Journey: Tomás): System captures user email and display name from Entra ID claims on first login  
FR3 (MVP, Should, Journey: Tomás): Users can optionally provide department and location if not available from directory  
FR4 (MVP, Should, Journey: Tomás, Priya): Users can view their own participation history (programmes joined, past matches)  
FR5 (MVP, Must, Journey: Tomás): Users can view programmes they are eligible to join  
FR6 (MVP, Must, Journey: Tomás): Users can join a programme with a single action  
FR7 (MVP, Must, Journey: Tomás): Users can leave a programme at any time; if mid-cycle, pending match is cancelled and match partner is notified  
FR8 (MVP, Must, Journey: Tomás): Users can view programmes they are currently enrolled in  
FR9 (MVP, Should, Journey: Tomás): Users can pause participation in a programme (skip next cycle)  
FR10 (MVP, Should, Journey: Tomás): Users receive confirmation of programme join/leave actions  
FR11 (MVP, Must, Journey: Marcus): System executes matching algorithm on programme-defined schedule (weekly/fortnightly)  
FR12 (MVP, Must, Journey: Marcus): All programme participants are eligible for matching; organisational boundary filtering is a Growth-phase capability  
FR13 (MVP, Must, Journey: Marcus): Random matching with architecture supporting future algorithm configurability  
FR14 (MVP, Must, Journey: Marcus): Matching algorithm avoids repeat pairings within configurable window (default: 3 cycles); historical matches stored per programme  
FR15 (MVP, Should, Journey: Marcus): If participant count is odd, one participant is gracefully excluded with explanation  
FR16 (MVP, Must, Journey: Marcus): Match notification email contains: matched participant name, Teams deep link, and a simple first‑move prompt with suggested intro copy (copy‑paste friendly)  
FR17 (MVP, Must, Journey: Marcus): Email is sent via Azure Communication Services to user's Entra ID email  
FR18 (MVP, Must, Journey: Marcus): Teams deep link opens 1:1 chat with matched participant  
FR19 (Deferred / Post‑MVP): Conversation starter selection (post‑MVP conversation support)  
FR20 (Deferred / Post‑MVP): Reminder per match cycle (not in MVP; risks obligation)  
FR21 (Growth, Must, Journey: Priya): Programme Owner can create a new programme with name, description, and cadence  
FR22 (Growth, Should, Journey: Priya): Programme Owner can invite participants by email address or CSV upload  
FR23 (Growth, Should, Journey: Priya): Programme Owner can view aggregate participation metrics (joined, active, paused)  
FR24 (MVP, Must, Journey: Priya): Programme Owner can configure matching cadence (MVP: monthly only; weekly/fortnightly are Growth)  
FR25 (MVP, Should, Journey: Priya): Programme Owner can edit programme name, description, and cadence  
FR26 (MVP, Must, Journey: Helena): Admin can view all programmes in the system  
FR27 (MVP, Must, Journey: Helena): Admin can deactivate a programme  
FR28 (MVP, Must, Journey: Helena): Admin can assign Programme Owner role to users  
FR29 (MVP, Must, Journey: Helena): Admin cannot view individual participation or match data  
FR29a (MVP, Should, Journey: Helena): Admin can view ops‑only programme health (cycle status, notification delivery health, trust guardrails status, operational errors with correlation IDs) gated behind minimum‑N ≥5  
FR30 (MVP, Must, Journey: All): No individual-level API endpoints exist for admin/owner queries about specific participants; individual participants can access their own data via authenticated endpoints  
FR31 (MVP, Must, Journey: Aisha): No tracking of whether matched participants actually met  
FR32 (MVP, Must, Journey: All): All personal data deletable upon user request (GDPR Article 17)  
FR33 (MVP, Must, Journey: Aisha): No analytics on message content or conversation outcomes  
FR34 (MVP, Must, Journey: All): System logs events, not behaviours (see Event Logging)  
FR35 (MVP, Must, Journey: Priya, Helena): System logs programme lifecycle events (created, paused, deactivated)  
FR36 (MVP, Must, Journey: Marcus): System logs matching execution events (run started, completed, participants matched)  
FR37 (MVP, Must, Journey: Helena): Privacy-preserving aggregate queries only; minimum 5 participants required for any aggregate query  
FR38 (MVP, Must, Journey: Helena): Event log entries are immutable and timestamped  
FR39 (MVP, Must, Journey: Aisha): No individual-level event queries exposed to admin/owner roles  
FR41 (MVP, Should, Journey: All): Users can view a "What we collect" transparency page explaining data handling  
FR42 (MVP, Should, Journey: Priya): Programme Owner receives notification when matching cycle completes, including status and any system errors (no participation counts)  

Total FRs: 42

### Non-Functional Requirements

NFR1 (Measure: 95th percentile < 3s): Page loads complete within 3 seconds on standard corporate network  
NFR2 (Measure: N/A): No hard real-time requirements  
NFR3 (Measure: Core flows complete even if slow): System remains usable under degraded conditions  
NFR4 (Measure: Certificate validation on all endpoints): All data encrypted in transit (TLS 1.2+)  
NFR5 (Measure: Azure Storage Service Encryption enabled): All data encrypted at rest  
NFR6 (Measure: Zero stored passwords): Authentication via Azure Entra ID only; no custom credential storage  
NFR7 (Measure: Role-based access enforced at API layer): Least-privilege access: users see only their own data; owners see only aggregate  
NFR8 (Measure: GDPR Article 17 compliance): Clear data retention policy: personal data deleted within 30 days of account deletion request  
NFR9 (Measure: Code review confirms no hidden analytics): No dark telemetry or behavioural tracking  
NFR10 (Measure: Logical isolation by design): Tenant isolation: single-tenant MVP with architecture supporting future multi-tenant separation  
NFR11 (Measure: Target 99% monthly uptime (informational)): Best-effort availability; no formal SLA for MVP  
NFR12 (Measure: No pager duty for MVP): One hour of downtime during business hours is acceptable  
NFR13 (Measure: All failures logged and surfaced): Clear failure behaviour: no silent errors, no partial matches  
NFR14 (Measure: No half-matched cohorts): Matching algorithm is atomic: runs completely or not at all  
NFR15 (Measure: 95% delivered within 60 mins): Match notifications sent within 60 minutes of algorithm completion  
NFR16 (Measure: 3 retries with exponential backoff): Email delivery includes retry logic for transient failures  
NFR17 (Measure: Admin-visible delivery failures): Failed email delivery logged for operational review  
NFR18 (Measure: Best-effort conformance): WCAG 2.1 AA as aspiration, not hard gate  
NFR19 (Measure: Tab order works; no mouse-only interactions): Keyboard navigation for all core flows  
NFR20 (Measure: Automated contrast checking in build): Readable contrast ratios (4.5:1 minimum for text)  
NFR21 (Measure: Semantic HTML, ARIA labels on interactive elements): Screen-reader friendliness where straightforward  
NFR22 (Measure: Partition key strategy accommodates org isolation): Architecture supports future multi-tenant expansion  
NFR23 (Measure: Single-tenant pilot is sufficient): No requirement to prove scale in MVP  
NFR24 (Measure: No fixed capacity provisioning): Consumption-based infrastructure (Azure Functions, Table Storage)  
NFR25 (Measure: Structured logs for all API calls and background jobs): Sufficient logging to debug failures and explain what happened  
NFR26 (Measure: No tracking of user actions beyond system events): No user-level behavioural analytics beyond operational necessity  
NFR27 (Measure: Alerts on elevated error rates): Application Insights or equivalent for error monitoring  

Total NFRs: 27

### Additional Requirements

**MVP Definition of Done (as stated in PRD):**

- Users can authenticate via Entra ID
- Users can join the pilot programme
- Matching runs on schedule (weekly)
- Match emails are delivered with conversation starter and Teams link
- At least 20 participants are enrolled
- First match cycle completes successfully

**Compliance & Regulatory (as stated in PRD):**

- GDPR (EU): Lawful basis likely legitimate interests with transparency (consent problematic in employment)
- UK GDPR: ICO worker monitoring guidance applies (transparency + proportionality)
- CCPA (California): Employee data in scope as of January 2023 (notice and rights obligations)
- Cross-border transfers: EU SCCs or UK IDTA/Addendum for multinational deployments
- DPIA: Recommended (and likely required) given employee data and potential privacy impact
- Retention Policy: Match history retained for 12 months, then anonymised; users can request deletion at any time (GDPR Article 17)

**Technical Constraints (Privacy-by-Design) (as stated in PRD):**

- Data minimisation: Capture only what's needed for matching (name, function, location); no profile richness beyond that
- Purpose limitation: Participation data cannot be repurposed for performance evaluation or surveillance
- Retention limits: Match history retention should be time-bounded; define retention period
- No individual-level reporting: Aggregate metrics only; no manager access to participation data
- Audit trail: Log what the system does (match-sent, match-acknowledged), not what users do

**Implicit Requirements (Surfaced by Elicitation) (as stated in PRD):**

- Directory/SSO integration (MVP - hard dependency): Pre-fill signup, reduce friction
- One-click introduction action (MVP): Reduce first-move friction
- Conversation starter prompt (MVP): Tips awkwardness toward usefulness
- Cross-boundary matching constraint (MVP): Ensures thesis validation
- Delivery confirmation (silent) (MVP): Detect notification failures
- Event logging (match-sent, match-acknowledged) (MVP): Future-proof for re-engagement metrics
- Re-engagement tracking (silent) (MVP): Validates graceful dormancy works
- Optional story capture channel (Post-MVP or manual workaround): Surface anecdotes for Helena

**Integration Requirements (as stated in PRD):**

- SSO/Directory integration (MVP): Pre-fill signup, reduce friction, ensure identity
- Teams/Slack integration (MVP): Notification delivery and one-click introduction
- HRIS integration (Post-MVP): For cross-boundary constraint validation (function, region)

### PRD Completeness Assessment

- Strength: Clear traceability structure (success criteria → journeys → FRs/NFRs), with explicit phase + priority per requirement.
- Strength: Strong privacy/trust guardrails are made explicit (e.g., no manager visibility, aggregate-only, minimum‑N thresholds).
- Gap / Ambiguity to resolve before implementation: Cadence consistency across PRD (e.g., MVP DoD says weekly; FR11 says weekly/fortnightly; FR24 says MVP monthly only with weekly/fortnightly as Growth for owner-configured cadence).
- Gap: Several requirements are expressed as table statements but do not yet include explicit acceptance criteria or error/edge-case definitions suitable for engineering stories (e.g., what “eligible to join” means; what “gracefully excluded” looks like; how “deleted within 30 days” is verified/audited).

## Epic Coverage Validation

### Coverage Matrix

| FR Number | PRD Requirement | Epic Coverage | Status |
| --------- | --------------- | ------------- | ------ |
| FR1 | Users authenticate via Azure Entra ID (EasyAuth); no custom credential storage | Epic 1 - Join & Trust | ✓ Covered |
| FR2 | System captures user email and display name from Entra ID claims on first login | Epic 1 - Join & Trust | ✓ Covered |
| FR3 | Users can optionally provide department and location if not available from directory | Epic 1 - Join & Trust | ✓ Covered |
| FR4 | Users can view their own participation history (programmes joined, past matches) | Epic 4 - Stay Opted-In | ✓ Covered |
| FR5 | Users can view programmes they are eligible to join | Epic 1 - Join & Trust | ✓ Covered |
| FR6 | Users can join a programme with a single action | Epic 1 - Join & Trust | ✓ Covered |
| FR7 | Users can leave a programme at any time; if mid-cycle, pending match is cancelled and match partner is notified | Epic 4 - Stay Opted-In | ✓ Covered |
| FR8 | Users can view programmes they are currently enrolled in | Epic 4 - Stay Opted-In | ✓ Covered |
| FR9 | Users can pause participation in a programme (skip next cycle) | Epic 4 - Stay Opted-In | ✓ Covered |
| FR10 | Users receive confirmation of programme join/leave actions | Epic 4 - Stay Opted-In | ✓ Covered |
| FR11 | System executes matching algorithm on programme-defined schedule (weekly/fortnightly) | Epic 2 - Get Matched | ✓ Covered |
| FR12 | All programme participants are eligible for matching; organisational boundary filtering is a Growth-phase capability | Epic 2 - Get Matched | ✓ Covered |
| FR13 | Random matching with architecture supporting future algorithm configurability | Epic 2 - Get Matched | ✓ Covered |
| FR14 | Matching algorithm avoids repeat pairings within configurable window (default: 3 cycles); historical matches stored per programme | Epic 2 - Get Matched | ✓ Covered |
| FR15 | If participant count is odd, one participant is gracefully excluded with explanation | Epic 2 - Get Matched | ✓ Covered |
| FR16 | Match notification email contains: matched participant name, Teams deep link, and a simple first‑move prompt with suggested intro copy (copy‑paste friendly) | Epic 3 - Have the Conversation | ✓ Covered |
| FR17 | Email is sent via Azure Communication Services to user's Entra ID email | Epic 3 - Have the Conversation | ✓ Covered |
| FR18 | Teams deep link opens 1:1 chat with matched participant | Epic 3 - Have the Conversation | ✓ Covered |
| FR19 | Conversation starter selection (post‑MVP conversation support) | **NOT FOUND** | ❌ MISSING |
| FR20 | Reminder per match cycle (not in MVP; risks obligation) | **NOT FOUND** | ❌ MISSING |
| FR21 | Programme Owner can create a new programme with name, description, and cadence | Epic 5 - Operate Safely | ✓ Covered |
| FR22 | Programme Owner can invite participants by email address or CSV upload | Epic 5 - Operate Safely | ✓ Covered |
| FR23 | Programme Owner can view aggregate participation metrics (joined, active, paused) | Epic 5 - Operate Safely | ✓ Covered |
| FR24 | Programme Owner can configure matching cadence (MVP: monthly only; weekly/fortnightly are Growth) | Epic 5 - Operate Safely | ✓ Covered |
| FR25 | Programme Owner can edit programme name, description, and cadence | Epic 5 - Operate Safely | ✓ Covered |
| FR26 | Admin can view all programmes in the system | Epic 5 - Operate Safely | ✓ Covered |
| FR27 | Admin can deactivate a programme | Epic 5 - Operate Safely | ✓ Covered |
| FR28 | Admin can assign Programme Owner role to users | Epic 5 - Operate Safely | ✓ Covered |
| FR29 | Admin cannot view individual participation or match data | Epic 5 - Operate Safely | ✓ Covered |
| FR29a | Admin can view ops‑only programme health (cycle status, notification delivery health, trust guardrails status, operational errors with correlation IDs) gated behind minimum‑N ≥5 | Epic 5 - Operate Safely (Growth) | ✓ Covered |
| FR30 | No individual-level API endpoints exist for admin/owner queries about specific participants; individual participants can access their own data via authenticated endpoints | Epic 5 - Operate Safely | ✓ Covered |
| FR31 | No tracking of whether matched participants actually met | Epic 5 - Operate Safely | ✓ Covered |
| FR32 | All personal data deletable upon user request (GDPR Article 17) | Epic 5 - Operate Safely | ✓ Covered |
| FR33 | No analytics on message content or conversation outcomes | Epic 5 - Operate Safely | ✓ Covered |
| FR34 | System logs events, not behaviours (see Event Logging) | Epic 5 - Operate Safely | ✓ Covered |
| FR35 | System logs programme lifecycle events (created, paused, deactivated) | Epic 5 - Operate Safely | ✓ Covered |
| FR36 | System logs matching execution events (run started, completed, participants matched) | Epic 5 - Operate Safely | ✓ Covered |
| FR37 | Privacy-preserving aggregate queries only; minimum 5 participants required for any aggregate query | Epic 5 - Operate Safely | ✓ Covered |
| FR38 | Event log entries are immutable and timestamped | Epic 5 - Operate Safely | ✓ Covered |
| FR39 | No individual-level event queries exposed to admin/owner roles | Epic 5 - Operate Safely | ✓ Covered |
| FR41 | Users can view a "What we collect" transparency page explaining data handling | Epic 1 - Join & Trust | ✓ Covered |
| FR42 | Programme Owner receives notification when matching cycle completes, including status and any system errors (no participation counts) | Epic 5 - Operate Safely | ✓ Covered |

### Missing Requirements

#### Critical Missing FRs

FR19: Conversation starter selection (post‑MVP conversation support)  

- Impact: Post‑MVP capability is not traceable to an epic/story location; risk of accidental omission when planning Growth work.
- Recommendation: Add an explicit “Post‑MVP / Deferred” epic (or clearly labelled backlog section) and trace FR19 to it.

FR20: Reminder per match cycle (not in MVP; risks obligation)  

- Impact: As above; additionally, reminder behaviour has trust/obligation implications and should be explicitly designed rather than “sneaking in”.
- Recommendation: Place under a “Post‑MVP / Deferred” epic with explicit trust guardrails and opt-out language.

### Coverage Statistics

- Total PRD FRs: 42
- FRs covered in epics: 40
- Coverage percentage: 95.24%

## UX Alignment Assessment

### UX Document Status

Found:

- `ux-design-specification.md`
- Additional UX artefacts (non-Markdown): `ux-design-directions.html`, `ux-visual-themes.html`

### Alignment Issues

- Cadence language inconsistency appears across PRD/epics/UX (“weekly/fortnightly/monthly” vs “monthly-only” vs “weekly”); UX surfaces “next match” prominently, so this must be made unambiguous before build.
- PRD defers FR19 (conversation starter selection), but UX describes “conversation starter prompt” as core; confirm MVP behaviour is a single fixed prompt (FR16) vs selectable prompts (FR19 post‑MVP).
- Epics treat FR29a as Growth in the coverage map, while PRD frames it as MVP (ops-only) in Administration; UX has no direct conflict, but this impacts which UI states need design coverage for MVP.

### Warnings

- None: UX is present and broadly consistent with the trust-first, minimal-surface philosophy stated in PRD and Architecture; remaining issues are primarily scope/cadence clarification rather than missing UX work.

## Epic Quality Review (create-epics-and-stories standards)

### 🔴 Critical Violations

- None detected (no “technical milestone” epics; all epics are framed around user value outcomes).

### 🟠 Major Issues

- **Cadence ambiguity leaks into stories:** multiple stories use examples that imply different MVP cadence configurations (e.g., participant-facing cadence examples vs PRD’s mixed “weekly/monthly-only” constraints). This is likely to create forward-dependency churn during implementation (UI + scheduler + config).
  - Recommendation: pick one MVP cadence rule and reflect it consistently across PRD (DoD + FR11/FR24), epics/stories, UX copy, and architecture scheduler configuration.
- **Testability gaps in trust/copy-focused acceptance criteria:** several ACs rely on subjective wording (“plain English”, “calm”, “avoids obligation”) without concrete, verifiable checks.
  - Recommendation: add explicit copy snippets or a checklist of prohibited phrases/claims (e.g., “required”, “must”, “tracked”, “performance”) and define a lightweight UX QA rubric for these surfaces.
- **Error and failure-path coverage is uneven:** NFR13 requires “no silent errors”, but many participant-flow stories lack explicit failure behaviour (what user sees vs what is logged vs what admins see), beyond matching failure handling.
  - Recommendation: for each trust-critical flow (join, pause, leave, match view, notification send), add at least one AC covering failure behaviour (Problem Details surfaced calmly to user where appropriate; correlation IDs logged; ops-only surfaces show health).

### 🟡 Minor Concerns

- **Story numbering irregularity:** `Story 1.0a` is atypical and may not import cleanly into tooling or maintain consistent sequencing expectations.
  - Recommendation: renumber to a standard sequence (e.g., make it `Story 1.0` and shift others, or fold it into `Story 1.0` as a subtask).
- **Some “delivery team” stories are non-user-facing:** `Story 1.0a` and `Story 1.0` are necessary for greenfield, but they do not deliver participant value directly.
  - Recommendation: keep them, but label clearly as “Delivery Enablement” and ensure they remain minimal and do not expand into broad “set up everything” milestones.

### Best Practices Compliance Checklist (summary)

- [x] Epics deliver user value (not technical milestones)
- [x] Epic independence (no Epic N requires Epic N+1)
- [~] Stories appropriately sized (generally yes; enablement stories should stay tight)
- [x] No forward dependencies detected
- [~] Database/entities created when needed (not explicitly stated per story; verify during implementation)
- [~] Clear acceptance criteria (format is good; some criteria are subjective)
- [x] Traceability to FRs maintained (coverage map present; 2 deferred FRs not mapped)

## Summary and Recommendations

### Overall Readiness Status

NEEDS WORK

### Critical Issues Requiring Immediate Action

- **Cadence decision is inconsistent across artefacts (PRD/epics/UX):** PRD mixes weekly (MVP DoD), weekly/fortnightly (FR11), and monthly-only (FR24); epics and UX copy also reference cadence and “next match” prominently. This will directly affect scheduler configuration, UI copy, and expectations.

### Recommended Next Steps

1. **Resolve and lock MVP cadence rules** (what is fixed vs configurable; weekly vs monthly; what participants see), then update PRD (DoD + FR11/FR24), epics/stories, UX copy, and architecture scheduler notes to match.
2. **Make deferrals explicit and traceable:** add a labelled “Deferred / Post‑MVP” epic or backlog section and map FR19 + FR20 to it (so they are intentionally excluded from MVP without being “lost”).
3. **Tighten acceptance criteria for trust-critical copy and failures:** convert subjective ACs (“calm/plain English/no obligation”) into a verifiable checklist and add explicit failure behaviour ACs for join/pause/leave/match view/notification send (user message vs ops visibility vs logs/correlation IDs).

### Final Note

This assessment identified 7 issues across 3 categories (coverage, alignment, and epic/story quality). Address the critical cadence inconsistency before implementation; the remaining items can be resolved iteratively but will reduce rework and ambiguity if handled upfront.

**Assessor:** DA9 (facilitated)  
**Assessment Date:** 2026-01-14

## Post-assessment Updates (Implemented)

**Update Date:** 2026-01-14  
These changes were applied after the assessment to address the identified blockers.

- **Cadence resolved:** MVP cadence is an ops setting (weekly or monthly; **default monthly**); no Programme Owner UI for cadence in MVP. Updated in `prd.md`, `epics.md`, and cadence wording in `ux-design-specification.md`.
- **Deferred traceability fixed:** FR19 and FR20 are explicitly listed under a `Deferred / Post‑MVP` section in `epics.md`.
- **Acceptance criteria tightened (single source):** Added a `Trust Copy Checklist` section in `epics.md` and referenced it from key participant-facing stories.

**Revised Readiness Status:** READY (with minor concerns remaining around subjective AC wording in some stories and story numbering conventions such as `1.0a`).
