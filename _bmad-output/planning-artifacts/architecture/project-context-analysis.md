# Project Context Analysis

## Requirements Overview

**Functional Requirements:**

- Identity & access: Entra ID (EasyAuth) sign-in, minimal profile capture, and user-only data access.
- Programme participation: join/leave/pause with single-programme MVP; opt-in only and no penalties.
- Matching: scheduled cadence, random/lightly constrained matching, avoid repeats, odd-participant handling, idempotent cycles.
- Notifications: match emails with first-move prompt and Teams deep link; email is authoritative fallback.
- Privacy & trust: no individual-level reporting; strict deletion rights; transparency page; event logging of system actions only.
- Administration: role assignment, programme lifecycle controls, aggregate programme health only.

**Non-Functional Requirements:**

- Security & privacy: TLS, encryption at rest, least-privilege access, no surveillance analytics, GDPR/UK GDPR/CCPA compliance.
- Reliability: predictable matching execution, atomic runs, clear failure behaviour, idempotent retries.
- Performance: basic web performance expectations (sub-3s load), no real-time constraints.
- Accessibility: WCAG 2.1 AA aspiration, keyboard support, readable contrast.
- Observability: structured logs, error monitoring, aggregate-only insights.
- Email delivery: retry logic, delivery logging, within-60-minute window post-match.

**Scale & Complexity:**

- Primary domain: SPA + serverless API + scheduled jobs
- Complexity level: Medium (trust/privacy constraints dominate)
- Estimated architectural components: 6-8 (SPA, auth, API, matching worker, data store, notification service, logging/monitoring, CI/CD)

## Technical Constraints & Dependencies

- Azure Static Web Apps + EasyAuth (no custom auth flows in MVP).
- Azure Functions v4 (.NET isolated) with explicit auth checks per handler.
- Azure Table Storage partitioning by ProgrammeId; avoid cross-partition scans.
- Idempotent matching runs keyed by ProgrammeId + CycleId.
- OpenAPI.NET generated specs aligned to DTOs and contract tests.
- Email via Azure Communication Services; Teams is secondary.
- Single-tenant MVP with future multi-tenant readiness.
- React 18 + Vite 5 SPA; minimal routing; no state management library in MVP.

## Cross-Cutting Concerns Identified

- Trust contract enforcement (anti-surveillance, opt-in only, no individual metrics).
- Authorisation at every boundary with untrusted claims validation.
- Data minimisation, retention, and deletion workflows.
- Idempotency and failure handling for scheduled matching.
- Aggregate-only reporting constraints for admin/owner views.
- UX tone/clarity as a product promise (low-pressure, low-effort).

## Failure Risks & Early Preventive Guards

- **Trust breach perception:** any hint of surveillance or manager visibility kills adoption -> enforce aggregate-only endpoints and guard-suite tests.
- **Cross-programme data leakage:** partition mistakes expose data -> repository-level key enforcement and negative contract tests.
- **Matching integrity failure:** duplicate runs or partial matches undermine credibility -> idempotency keys and atomic cycle processing.
- **Notification reliability gap:** silent delivery failures feel like "ghosting" -> delivery logging and retry strategy.
- **UX drift into "programme" feel:** extra screens or metrics create obligation -> single-screen core and consistent "no pressure" copy.

## Architectural Drivers

- **Trust by design:** privacy posture drives data minimisation and transparency surfaces.
- **Boundary discipline:** auth/authorisation and partition keys must enforce programme isolation on every query and endpoint.
- **Predictable cadence:** scheduling and idempotent matching are central reliability anchors.
- **Minimal surface area:** few routes and minimal UI states reduce risk and effort.
- **Operational clarity:** logging must explain what the system did, not what users did.

## Stakeholder Lens

- **Participants:** need effortless opt-in/out, zero penalty for silence, and visible proof of non-surveillance -> minimal data capture and clear "what we store" surface.
- **Programme Owners:** need hands-off operation and credible aggregate signals -> aggregate metrics only and reliable cycle completion reporting.
- **Executive Sponsors:** need narrative evidence without privacy risk -> anonymised aggregates and story capture outside the system.
- **Security/Privacy:** require lawful basis, minimisation, retention controls, and auditability -> explicit retention workflows and DPIA-ready documentation.
- **Engineering/Ops:** need low-complexity, debuggable flows -> serverless, deterministic jobs, strong contract tests.

## Cross-Functional Trade-offs

- **PM:** wants validation speed and minimal scope -> architecture stays small, low-config, no platform sprawl.
- **Engineering:** wants reliability and debuggability -> deterministic jobs, explicit failure logging, contract-first APIs.
- **UX:** wants calm, low-pressure surfaces -> avoid extra flows, keep copy consistent, no KPI-styled UI.
- **Privacy/Legal:** wants defensible minimisation and transparency -> strict retention, no behavioural analytics, clear data-handling docs.

## Security & Privacy Lens

- **Attacker view:** highest value targets are identity claims, cross-programme access, and match history -> boundary validation and partition isolation are critical.
- **Defender view:** rely on SWA/EasyAuth for identity, but treat claims as untrusted per request -> explicit auth checks and schema validation everywhere.
- **Auditor view:** needs evidence of minimisation, retention, and deletion controls -> document retention policies and ensure logs exclude user behaviour.

## Expert Panel Notes

- **Serverless architect:** keep Functions thin, avoid framework-building, isolate matching logic into a testable service with idempotency guarantees.
- **Data/privacy specialist:** minimise stored attributes (name, email, department, location), enforce retention windows, prefer anonymised aggregates.
- **Test architect:** prioritise contract tests for auth edge cases, cross-programme access, and idempotent matching; guard tests for anti-surveillance promises.

## Component Failure Modes

- **Auth boundary:** missing/forged claims -> requests must fail closed with explicit 401/403.
- **Programme scoping:** incorrect PartitionKey usage -> accidental cross-programme data access.
- **Matching cycle:** re-run creates duplicate matches -> must detect and no-op on duplicates.
- **Notification delivery:** transient email failures -> retry with observable failure logs.
- **Retention/deletion:** stale personal data persists -> explicit delete workflows and retention checks.
- **Aggregate reporting:** small cohort sizes enable re-identification -> enforce minimum-N thresholds.
- **UX trust drift:** any copy/UI implying obligation or monitoring -> treat as defect, block release.

## Clarifications & Defaults (from stakeholder decisions)

- **Trust contract visibility:** "What we store" is a primary surface on join and first-match screens; full detail behind a link.
- **Cadence promise:** best-effort within a consistent window (e.g., first Tuesday by 10:00 local time); internal alerts on delay, calm external messaging.
- **Aggregate threshold:** minimum-N fixed at 5 for MVP.
- **Retention:** match records retained 12 months; user deletion requests honoured promptly; when leaving, stop matching and retain only minimal non-identifying audit data.
- **Notifications:** email is authoritative; Teams is additive; no SMS.
- **Identity key:** Entra Object ID is canonical; email stored for display/contact only.
- **Time zones:** cadence runs per programme time zone (single-programme MVP).
- **Idempotency key:** ProgrammeId + CycleDate (programme time zone).
- **Opt-out semantics:** pause for one cycle and leave programme are both supported; pause is a per-cycle flag.
- **No follow-ups:** ignored matches receive no reminders.
