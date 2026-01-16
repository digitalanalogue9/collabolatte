# Epic 5: Operate Safely
Programme Owners and Admins can run the system safely with strict trust guardrails and operational controls.
**FRs covered:** FR21, FR22, FR23, FR24, FR25, FR26, FR27, FR28, FR29, FR29a (Growth), FR30, FR31, FR32, FR33, FR34, FR35, FR36, FR37, FR38, FR39, FR42
**NFR Focus:** NFR4-10 (security/privacy/retention), NFR25-27 (logging and monitoring).

**Epic 5 Clarification:** Programme Owners are enablers, not operators. They cannot intervene in individual matches, view individual participation, or influence outcomes.

**Epic 5 Anti-stories:**
- No individual-level reporting
- No engagement scoring
- No nudges or reminders triggered by metrics
- No manager visibility
- No optimisation controls for matching

## Story 5.1: Programme exists and can be configured

As a Programme Owner,
I want to set the programme name and description and see the programme cadence,
So that the programme is clear and runs predictably without expanding scope.

**Acceptance Criteria:**

**Given** a single programme exists,
**When** I set or update its name or description,
**Then** the changes apply to future cycles only,
**And** the MVP remains limited to a single programme.

**Given** I am a Programme Owner,
**When** I view the programme settings,
**Then** I can see the cadence in simple terms (monthly by default; weekly optional via ops),
**And** I cannot change cadence via any UI surface in MVP,
**And** participant-facing copy about cadence conforms to the Trust Copy Checklist.

### Story 5.2: Participants can be invited

As a Programme Owner,
I want to invite participants by email or CSV,
So that I can open the programme without friction.

**Acceptance Criteria:**

**Given** I am a Programme Owner,
**When** I send invites by email or CSV,
**Then** the invite message states participation is optional and low-pressure,
**And** it conforms to the Trust Copy Checklist.

**Given** invites are sent,
**When** participants join,
**Then** the system does not track acceptance beyond join status.

### Story 5.3: Programme lifecycle controls

As an Admin,
I want to deactivate the programme safely,
So that matching can be stopped without disrupting trust.

**Acceptance Criteria:**

**Given** the programme is active,
**When** I deactivate it,
**Then** future matching stops,
**And** historical data is not deleted immediately,
**And** participants are not notified loudly.

### Story 5.4: Role assignment is possible

As an Admin,
I want to assign Programme Owner roles from a controlled allowlist,
So that responsibility is explicit and auditable.

**Acceptance Criteria:**

**Given** I am an Admin,
**When** I assign a Programme Owner role,
**Then** the allowlist is stored in Table Storage,
**And** there is no self-service role escalation,
**And** the change is auditable.

### Story 5.5: Aggregate-only visibility

As a Programme Owner or Admin,
I want aggregate, non-identifying visibility only,
So that trust is preserved.

**Acceptance Criteria:**

**Given** I view participation information,
**When** aggregates are shown or exported,
**Then** minimum-N thresholds are enforced everywhere.

**Given** aggregates are shown,
**When** I view them,
**Then** they include cycle execution health, notification delivery health, trust guardrails status, and operational errors (with correlation IDs) only,
**And** they exclude participation counts, adoption signals, per-cycle performance views, or success metrics.

**And** all ops-only health is gated behind minimum-N ≥5.

### Story 5.6: Matching cycle completion notice

As a Programme Owner,
I want a calm operational notice when a cycle completes,
So that I know the system is running without pressure.

**Acceptance Criteria:**

**Given** a matching cycle completes,
**When** the notice is sent,
**Then** it states the cycle completed,
**And** it includes any system errors if relevant,
**And** it does not include participation stats or celebratory language,
**And** it conforms to the Trust Copy Checklist.

### Story 5.7: Privacy controls are real

As a participant,
I want deletion requests honoured and no behavioural tracking,
So that the privacy promise is enforced.

**Acceptance Criteria:**

**Given** I request deletion,
**When** the request is processed,
**Then** identifying data is removed within the stated window,
**And** only minimal system audit data is retained.

**Given** the system operates,
**When** events are logged,
**Then** no behavioural or engagement tracking is recorded.

### Story 5.8: System-event logging

As an Admin,
I want immutable system-event logs for audit and debugging,
So that operations are transparent without surveillance.

**Acceptance Criteria:**

**Given** system events occur,
**When** they are logged,
**Then** logs include programme create/update/deactivate, matching run start/complete/fail, and notification attempt/sent/fail only,
**And** they exclude user-level behaviour events,
**And** correlation IDs are included.
