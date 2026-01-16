# Epic 3: Have the Conversation

Participants get a low-effort, low-pressure invitation that makes the first move easy.
**FRs covered:** FR16, FR17, FR18
**NFR Focus:** NFR15-17 (email delivery reliability).

### Story 3.1: Match notification contains the essentials

As a matched participant,
I want a single calm match email with everything I need to take the first step,
So that I can decide whether to engage without friction.

**Acceptance Criteria:**

**Given** a match is created for me,
**When** the notification email is sent,
**Then** it includes the names of matched participants,
**And** it includes the Teams deep link(s),
**And** it states that the conversation is optional,
**And** it conforms to the Trust Copy Checklist.

**Given** I receive the match email,
**When** I view it,
**Then** it contains no tracking pixels, read receipts, or reminders implied,
**And** it conforms to the Trust Copy Checklist.

### Story 3.2: First-move prompt reduces social friction

As a matched participant,
I want a calm, copy-pasteable first-move prompt,
So that starting the conversation feels easy and non-awkward.

**Acceptance Criteria:**

**Given** I receive a match email,
**When** I read the prompt,
**Then** the tone is calm and optional,
**And** the prompt can be copy-pasted without editing,
**And** it explicitly permits ignoring or adapting the prompt,
**And** it conforms to the Trust Copy Checklist.

### Story 3.3: Teams deep link works reliably

As a matched participant,
I want the Teams link to open the correct chat reliably,
So that I can start the conversation without confusion.

**Acceptance Criteria:**

**Given** I click the Teams deep link from the match email,
**When** Teams is available,
**Then** it opens a 1:1 chat with the matched participant.

**Given** Teams is not available on my device,
**When** I click the link,
**Then** I receive a graceful fallback (no error wall),
**And** I am not forced into calendar scheduling.

### Story 3.4: Silence is an acceptable outcome

As a participant,
I want no negative consequences if I do nothing after a match email,
So that I never feel pressured to engage.

**Acceptance Criteria:**

**Given** I receive a match email,
**When** I take no action,
**Then** I receive no follow-ups or warnings,
**And** no new state is shown that implies failure.

**Given** I take no action,
**When** the next cycle runs,
**Then** the system proceeds normally without calling out my inactivity.
