# Implementation Sequencing (Reasoning via Planning)

**Epic 1 - Project Foundation & Deployment (Stories 1.0-1.6)**

- Document infrastructure (Bicep)
- Scaffold repo + monorepo structure
- Set up Storybook for component development
- Create core web app UI components
- Implement Bicep templates
- Deploy infrastructure to Azure
- Deploy minimal application and verify end-to-end pipeline
- Outcome: deployed foundation with working auth, API, storage, and ACS connections; Storybook ready for component development; core UI components built

**Epic 2 - Join & Trust (Stories 2.0-2.5)**

- First contact trust surface
- Entra auth flow
- What-we-store transparency
- One-click join
- Leave/pause clarity at join
- Default participant role
- Outcome: users can safely opt in and trust the system

**Epic 3 - Get Matched (Stories 3.0-3.6)**

- Inclusion in cycle
- Cadence visibility
- Matching logic (random)
- Repeat avoidance + odd handling with calm notice
- Future algorithm configurability
- Non-participation handled silently
- Failures do not leak
- Outcome: the ritual runs without user effort

**Epic 4 - Have the Conversation (Stories 4.0-4.3)**

- Essential match email
- First-move prompt
- Teams deep link
- Silence acceptable
- Outcome: low-pressure invite delivered

**Epic 5 - Stay Opted-In (Stories 5.0-5.4)**

- Participation status
- Pause next cycle
- Leave mid-cycle handling
- Calm confirmations
- Minimal history
- Outcome: voluntary loop stays safe

**Epic 6 - Operate Safely (Stories 6.0-6.7)**

- Single programme config
- Invites
- Deactivate
- Role assignment
- Aggregate-only visibility
- Cycle completion notice
- Privacy controls
- System-event logs
- Outcome: hands-off operations with trust guardrails
