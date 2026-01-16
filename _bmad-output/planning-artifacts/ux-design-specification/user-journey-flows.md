# User Journey Flows

## Journey 1: New Joiner — First Coffee Match (Tomás)
**Goal:** Join with minimal effort, receive first match, understand no-pressure expectations.

```mermaid
graph TD
  A[Discovery: hears about Collabolatte] --> B[Land on Join screen]
  B --> C{Join?}
  C -->|Join| D[Joined state: Optional, no tracking]
  C -->|Not now| B
  D --> E[Wait for cadence]
  E --> F[Match notification delivered]
  F --> G[Light framing: “We match across teams”]
  G --> H{Engage?}
  H -->|Yes| I[Introduce self via Teams/email]
  H -->|No| J[No action; no penalty]
  I --> K[Coffee chat happens]
  J --> L[Next cadence arrives]
  K --> L[Next cadence arrives]
  L --> M[Stays opted in]
```

**Success Criteria:** Instant comprehension, safe invitation, no-penalty skip, predictable cadence.

## Journey 2: Sceptic — Tests the Waters (Marcus)
**Goal:** Validate trust and low-obligation framing; avoid churn.

```mermaid
graph TD
  A[Discovery: hears about Collabolatte] --> B[Join screen with reassurance]
  B --> C{Join?}
  C -->|Join| D[Joined: no tracking, optional]
  C -->|Not now| B
  D --> E[Match notification]
  E --> F[Light framing: “We match across teams”]
  F --> G{Feels pressured?}
  G -->|No| H[Optional intro sent]
  G -->|Yes| I[Ignore / opt-out]
  H --> J[Conversation happens]
  I --> K[Exit quietly (one click)]
  J --> L[Next cadence arrives]
  L --> M[Stays opted in]
```

**Success Criteria:** Zero obligation signals; easy opt-out; optional action feels safe; explicit “ignoring has no consequences.”

## Journey 3: Dormant User — Returns After Inactivity
**Goal:** Re-engage without guilt or re-onboarding.

```mermaid
graph TD
  A[User inactive for ≥2 cycles] --> B[Next match notification arrives]
  B --> C[Copy acknowledges return: no pressure]
  C --> D[Light framing: “We match across teams”]
  D --> E{Engage?}
  E -->|Yes| F[Intro sent]
  E -->|No| G[No action]
  F --> H[Conversation happens]
  G --> I[Remains opted in]
  H --> I[Remains opted in]
  I --> J[Next cadence arrives]
```

**Success Criteria:** Neutral tone, no guilt, easy return, continuity without re-setup.

## Journey Patterns
- **Invitation-first:** All journeys begin with a low-pressure invite.
- **Silence is valid:** Non-response is an explicit path with no penalty.
- **Predictable cadence:** Time-based rhythm is the stability anchor.
- **Single-step actions:** Join, Introduce, Skip; no multi-step flows.

## Flow Optimization Principles
- Minimise decision points and keep copy consistent.
- Avoid reminders that imply obligation.
- Use the same “optional/no tracking” reassurance in every journey.
- Keep outcomes invisible; the system does not ask for feedback.
- **Operational note:** if a notification fails, recover silently on the next cadence.
