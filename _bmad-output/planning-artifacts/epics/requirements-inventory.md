# Requirements Inventory

### Functional Requirements

FR1: Users authenticate via Azure Entra ID (EasyAuth); no custom credential storage
FR2: System captures user email and display name from Entra ID claims on first login
FR3: Users can optionally provide department and location if not available from directory
FR4: Users can view their own participation history (programmes joined, past matches)
FR5: Users can view programmes they are eligible to join
FR6: Users can join a programme with a single action
FR7: Users can leave a programme at any time; if mid-cycle, pending match is cancelled and match partner is notified
FR8: Users can view programmes they are currently enrolled in
FR9: Users can pause participation in a programme (skip next cycle)
FR10: Users receive confirmation of programme join/leave actions
FR11: System executes matching algorithm on a predictable schedule (weekly or monthly; default monthly; configured as an ops setting, not user-configurable)
FR12: All programme participants are eligible for matching; organisational boundary filtering is a Growth-phase capability (MVP is random-only)
FR13: Random matching with architecture supporting future algorithm configurability
FR14: Matching algorithm avoids repeat pairings within configurable window (default: 3 cycles); historical matches stored per programme
FR15: If participant count is odd, one participant is gracefully excluded with explanation
FR16: Match notification email contains: matched participant name, Teams deep link, and a simple first-move prompt with suggested intro copy (copy-paste friendly)
FR17: Email is sent via Azure Communication Services to user's Entra ID email
FR18: Teams deep link opens 1:1 chat with matched participant
FR19 (Deferred / Post‑MVP): Conversation starter selection (post‑MVP conversation support)
FR20 (Deferred / Post‑MVP): Reminder per match cycle (not in MVP; risks obligation)
FR21: Programme Owner can create a new programme with name, description, and cadence
FR22: Programme Owner can invite participants by email address or CSV upload
FR23: Programme Owner can view aggregate participation metrics (joined, active, paused) [Growth]
FR24: Matching cadence is configurable as an ops setting (weekly or monthly; default monthly); no Programme Owner UI for cadence in MVP
FR25: Programme Owner can edit programme name and description (cadence is ops-configured in MVP)
FR26: Admin can view all programmes in the system
FR27: Admin can deactivate a programme
FR28: Admin can assign Programme Owner role to users
FR29: Admin cannot view individual participation or match data
FR29a: Admin can view ops-only programme health (cycle execution, notification delivery health, trust guardrails status, operational errors) gated behind minimum-N ≥5
FR30: No individual-level API endpoints exist for admin/owner queries about specific participants; individual participants can access their own data via authenticated endpoints
FR31: No tracking of whether matched participants actually met
FR32: All personal data deletable upon user request (GDPR Article 17)
FR33: No analytics on message content or conversation outcomes
FR34: System logs events, not behaviours (see Event Logging)
FR35: System logs programme lifecycle events (created, paused, deactivated)
FR36: System logs matching execution events (run started, completed, participants matched)
FR37: Privacy-preserving aggregate queries only; minimum 5 participants required for any aggregate query
FR38: Event log entries are immutable and timestamped
FR39: No individual-level event queries exposed to admin/owner roles
FR41: Users can view a "What we collect" transparency page explaining data handling
FR42: Programme Owner receives notification when matching cycle completes, including status and any system errors (no participation counts)

### NonFunctional Requirements

NFR1: Page loads complete within 3 seconds on standard corporate network
NFR2: No hard real-time requirements
NFR3: System remains usable under degraded conditions
NFR4: All data encrypted in transit (TLS 1.2+)
NFR5: All data encrypted at rest
NFR6: Authentication via Azure Entra ID only; no custom credential storage
NFR7: Least-privilege access: users see only their own data; owners see only aggregate
NFR8: Clear data retention policy: personal data deleted within 30 days of account deletion request
NFR9: No dark telemetry or behavioural tracking
NFR10: Tenant isolation: single-tenant MVP with architecture supporting future multi-tenant separation
NFR11: Best-effort availability; no formal SLA for MVP
NFR12: One hour of downtime during business hours is acceptable
NFR13: Clear failure behaviour: no silent errors, no partial matches
NFR14: Matching algorithm is atomic: runs completely or not at all
NFR15: Match notifications sent within 60 minutes of algorithm completion
NFR16: Email delivery includes retry logic for transient failures
NFR17: Failed email delivery logged for operational review
NFR18: WCAG 2.1 AA as aspiration, not hard gate
NFR19: Keyboard navigation for all core flows
NFR20: Readable contrast ratios (4.5:1 minimum for text)
NFR21: Screen-reader friendliness where straightforward
NFR22: Architecture supports future multi-tenant expansion
NFR23: No requirement to prove scale in MVP
NFR24: Consumption-based infrastructure (Azure Functions, Table Storage)
NFR25: Sufficient logging to debug failures and explain what happened
NFR26: No user-level behavioural analytics beyond operational necessity
NFR27: Application Insights or equivalent for error monitoring

### Additional Requirements

- Starter template: monorepo with Vite React + TypeScript SPA, Azure Functions (.NET isolated), and 11ty marketing site; pnpm workspaces; two Azure Static Web Apps (app+API and marketing).
- Authentication via Azure Entra ID EasyAuth; no custom auth flows; claims treated as untrusted per request.
- Authorisation is role-based (Participant, Programme Owner, Admin) with a small allowlist stored in Table Storage; no manager visibility.
- Data storage is Azure Table Storage with programme-scoped partitioning; MatchId deterministic; idempotent matching keyed by ProgrammeId + CycleDate.
- API: REST JSON, plural noun routes; Problem Details (RFC 9457) for errors; OpenAPI.NET specs aligned to DTOs and contract tests.
- Logging: immutable system-event logs only (no behaviour analytics); correlation IDs are GUIDs.
- Retention: match records retained 12 months; deletion on request; aggregate reporting minimum N = 5.
- Deployment: SWA config via staticwebapp.config.json; no Key Vault or App Insights in MVP (upgrade hooks only).
- Web-only MVP; primary interactions via email and Teams links; notifications are the core experience.
- Single-screen, low-pressure UI; minimal navigation; one clear primary action with safe secondary actions (Skip/Later/Leave).
- No reminders, no feedback collection, no dashboards, no gamification, no profile optimisation.
- Transparency surfaces: short "What we store" link on join and match screens; calm, plain-language copy.
- Responsive design: desktop-first but mobile-safe; breakpoints at 360px, 768px, 1024px, 1280px.
- Accessibility: WCAG 2.1 AA aspiration; visible focus states; keyboard navigation; readable contrast; respect reduced-motion.

### FR Coverage Map

FR1: Epic 1 - Join & Trust
FR2: Epic 1 - Join & Trust
FR3: Epic 1 - Join & Trust
FR4: Epic 4 - Stay Opted-In
FR5: Epic 1 - Join & Trust
FR6: Epic 1 - Join & Trust
FR7: Epic 4 - Stay Opted-In
FR8: Epic 4 - Stay Opted-In
FR9: Epic 4 - Stay Opted-In
FR10: Epic 4 - Stay Opted-In
FR11: Epic 2 - Get Matched
FR12: Epic 2 - Get Matched
FR13: Epic 2 - Get Matched
FR14: Epic 2 - Get Matched
FR15: Epic 2 - Get Matched
FR16: Epic 3 - Have the Conversation
FR17: Epic 3 - Have the Conversation
FR18: Epic 3 - Have the Conversation
FR19: Deferred / Post‑MVP (not in epics)
FR20: Deferred / Post‑MVP (not in epics)
FR21: Epic 5 - Operate Safely
FR22: Epic 5 - Operate Safely
FR23: Epic 5 - Operate Safely
FR24: Epic 5 - Operate Safely
FR25: Epic 5 - Operate Safely
FR26: Epic 5 - Operate Safely
FR27: Epic 5 - Operate Safely
FR28: Epic 5 - Operate Safely
FR29: Epic 5 - Operate Safely
FR29a: Epic 5 - Operate Safely (Growth)
FR30: Epic 5 - Operate Safely
FR31: Epic 5 - Operate Safely
FR32: Epic 5 - Operate Safely
FR33: Epic 5 - Operate Safely
FR34: Epic 5 - Operate Safely
FR35: Epic 5 - Operate Safely
FR36: Epic 5 - Operate Safely
FR37: Epic 5 - Operate Safely
FR38: Epic 5 - Operate Safely
FR39: Epic 5 - Operate Safely
FR41: Epic 1 - Join & Trust
FR42: Epic 5 - Operate Safely
