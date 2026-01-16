# Epic 2: Get Matched

Participants reliably receive predictable, random matches on the agreed cadence.
**FRs covered:** FR11, FR12, FR13, FR14, FR15
**NFR Focus:** NFR2 (no real-time), NFR13-14 (clear failure behavior, atomic matching).

### Story 2.1: Included in the next matching cycle

As a joined participant,
I want to be automatically included in the next matching cycle,
So that I do not have to do anything after joining.

**Acceptance Criteria:**

**Given** I have joined the programme,
**When** a matching cycle runs,
**Then** I am included by default unless I have paused or left.

**Given** I am a joined participant,
**When** I view my status,
**Then** I do not need to confirm availability,
**And** I am not asked for preferences.

## Story 2.2: Matching runs on a predictable cadence

As a joined participant,
I want matching to run on a clear, predictable cadence,
So that I know when to expect my next match.

**Acceptance Criteria:**

**Given** I am a joined participant,
**When** I view the matching cadence,
**Then** I can see it in simple terms (e.g., monthly by default),
**And** I can see when the next match is expected.

**Given** a matching run is delayed or fails,
**When** I view the participant experience,
**Then** I do not see error messaging or urgency,
**And** the experience remains calm and unchanged.

### Story 2.3: Matched with real people

As a joined participant,
I want to be matched with other real participants,
So that the programme actually creates connections.

**Acceptance Criteria:**

**Given** a matching cycle runs,
**When** I am included,
**Then** I am matched into a group with at least one other participant.

**Given** a matching cycle runs,
**When** matches are generated,
**Then** the system pairs eligible participants into matches without manual intervention.

### Story 2.4: Avoid repeats and handle odd counts

As a joined participant,
I want matching to avoid obvious repeats and handle odd numbers gracefully,
So that the experience feels fair and reliable.

**Acceptance Criteria:**

**Given** a matching cycle runs,
**When** matches are generated,
**Then** recent pairings within the repeat-avoidance window are not repeated.

**Given** a matching cycle runs with an odd number of eligible participants,
**When** matches are generated,
**Then** one participant is gracefully excluded for that cycle,
**And** they receive a calm notification explaining they will be included next cycle.

### Story 2.5: Random now, configurable later

As a programme sponsor,
I want matching to be random in MVP but architected for future configurability,
So that different programmes can later adopt light matching rules without rework.

**Acceptance Criteria:**

**Given** MVP matching runs,
**When** matches are generated,
**Then** the algorithm is random and neutral (no optimisation or scoring).

**Given** the system is designed for MVP,
**When** matching is implemented,
**Then** the architecture allows future algorithm configurability without changing participant expectations.

### Story 2.6: Non-participation is handled silently

As a participant,
I want non-participation to be handled without awkward messaging,
So that I do not feel pressure.

**Acceptance Criteria:**

**Given** I am paused or ineligible for a cycle,
**When** a matching run occurs,
**Then** I receive no 'you were skipped' messaging.

**Given** I am paused or ineligible,
**When** the next cycle runs,
**Then** I am included again automatically once eligible.

### Story 2.7: Matching failure does not leak to users

As a participant,
I want internal matching failures to remain invisible to me,
So that trust in the system is preserved.

**Acceptance Criteria:**

**Given** a matching run fails internally,
**When** I view the participant experience,
**Then** I see no error messages or partial notifications,
**And** any participant-visible messaging conforms to the Trust Copy Checklist.

**Given** a matching run fails,
**When** the system recovers for the next cycle,
**Then** the participant experience remains calm and unchanged.
