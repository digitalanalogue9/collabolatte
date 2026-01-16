# Epic Failure Modes & Guardrails

### Epic 1: Join & Trust

Failure modes:

- Trust undermined by silently capturing extra fields or implying monitoring
- Join flow feels like onboarding (too long, too many steps)
Mitigations:
- Strictly limit data capture to name/email/department/location
- Single-screen join with explicit "What we store" link
- No multi-programme UI in MVP

### Epic 2: Get Matched

Failure modes:

- Matching becomes algorithm feature creep (preferences, optimisation)
- Inconsistent cadence erodes predictability
Mitigations:
- Random + repeat-avoidance only; no preferences or boundary filters in MVP
- Match runs idempotent and logged; cadence communicated

### Epic 3: Have the Conversation

Failure modes:

- Notification UX drifts into reminders or nudges (pressure)
- Tracking whether meetings happened violates trust
Mitigations:
- One notification per match; no reminders
- No meeting-happened tracking or click analytics

### Epic 4: Stay Opted-In

Failure modes:

- Pause/leave becomes a status signal
- Re-engagement nudges create pressure
Mitigations:
- Pause/leave affects matching eligibility only; no behaviour prompts
- No re-engagement campaigns

### Epic 5: Operate Safely

Failure modes:

- Admin tooling becomes a dashboard (metrics pressure)
- Individual visibility creeps in
Mitigations:
- Aggregate-only, minimum-N enforced; no individual-level endpoints
- FR29a is MVP but strictly ops-only; no participation counts or adoption signals
- No multi-programme UI in MVP
