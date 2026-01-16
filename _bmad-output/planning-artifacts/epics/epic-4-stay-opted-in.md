# Epic 4: Stay Opted-In
Participants can pause, leave, and return without penalty, and see their own history.
**FRs covered:** FR4, FR7, FR8, FR9, FR10
**NFR Focus:** NFR7 (least-privilege access), NFR9 (no dark telemetry).

**Epic 4 Clarification:** Ignoring a match is not treated as a pause or leave. Non-response does not change participation state.

**Epic 4 Anti-stories:**
- No are you sure friction
- No warnings about missing opportunities
- No manager visibility into status
- No historical analytics or trend views
- No re-engagement nudges

### Story 4.1: See my participation status

As a participant,
I want to clearly see whether I am opted in, paused, or left,
So that I understand my current state without pressure.

**Acceptance Criteria:**

**Given** I am a participant,
**When** I view my participation status,
**Then** the status is factual and neutral,
**And** it uses no judgmental language,
**And** it includes no prompts to change state.

### Story 4.2: Pause next cycle

As a participant,
I want to pause participation for the next cycle with one action,
So that I can step back temporarily without friction.

**Acceptance Criteria:**

**Given** I am opted in,
**When** I choose to pause,
**Then** the pause applies to the next matching cycle only,
**And** it expires after one cycle unless I pause again,
**And** no explanation is required.

**Given** I pause,
**When** the action completes,
**Then** I see a calm acknowledgement with no extra ceremony.

### Story 4.3: Leave at any time

As a participant,
I want to leave the programme at any time with one action,
So that opting out feels as safe as opting in.

**Acceptance Criteria:**

**Given** I am opted in,
**When** I choose to leave,
**Then** I leave with one action and no friction.

**Given** I leave mid-cycle,
**When** the leave is processed,
**Then** any pending match is cancelled,
**And** other participants are not notified.

**Given** I leave,
**When** I see the confirmation,
**Then** it reassures me there are no consequences.

### Story 4.4: Calm confirmation of state changes

As a participant,
I want a quiet confirmation when I join, pause, or leave,
So that I am not left uncertain about what happened.

**Acceptance Criteria:**

**Given** I change my participation state (join, pause, leave),
**When** the action completes,
**Then** I see an informational confirmation,
**And** it is inline (no email required),
**And** the language reinforces reversibility.

### Story 4.5: View my own participation history

As a participant,
I want a minimal record of my own participation history,
So that I can remember my involvement without performance pressure.

**Acceptance Criteria:**

**Given** I view my participation history,
**When** it is shown,
**Then** it includes my join date, pause or leave actions, and past match dates and names only.

**Given** I view my history,
**When** I review it,
**Then** it does not include counts, streaks, or engagement indicators.
