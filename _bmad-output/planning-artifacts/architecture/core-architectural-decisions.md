# Core Architectural Decisions

### Data Architecture

**Decision Priority:** Critical (blocks implementation)

**Database Choice:** Azure Table Storage (Azure.Data.Tables SDK, latest verified 12.11.0).
**Rationale:** Aligns with MVP constraints, cost, and simplicity.

**Data Modelling Approach (Table per entity):**
- **Memberships**: `PartitionKey = ProgrammeId`, `RowKey = UserId`
- **Cycles**: `PartitionKey = ProgrammeId`, `RowKey = CycleDate` (ISO, programme TZ)
- **Matches**: `PartitionKey = ProgrammeId`, `RowKey = MatchId` (deterministic from ProgrammeId + CycleDate + sorted UserIds)
- **Events (optional MVP)**: `PartitionKey = ProgrammeId`, `RowKey = Timestamp + Guid` (only if needed)

**Validation Strategy:** Separate schemas per layer.
- Web: Zod validation.
- API: explicit validation at Functions boundaries.
- No shared schema package in MVP.

**Schema Evolution / Migrations:** Additive changes only; no migrations in MVP.

**Caching:** None in MVP (prioritise observability and simplicity).

**Implications / Cascading Decisions:**
- Deterministic MatchId requires stable canonicalisation of participant IDs.
- CycleDate timezone handling must align with programme TZ decision.
- Event table is optional; if deferred, logging must still satisfy audit requirements.

### Authentication & Security

**Decision Priority:** Critical (blocks implementation)

**Authorisation Pattern:** Role-based, enforced server-side per route.
- Roles: Participant, Programme Owner, Admin.
- Executive Sponsor has no separate role in MVP (same visibility as Programme Owner).
- Role enforcement via `staticwebapp.config.json` and API checks.

**Identity & Claims Handling:**
- EasyAuth for identity; validate claims on every request, deny-by-default.
- Never trust client-provided identity; decode SWA client principal header as untrusted input.

**Encryption & Secrets:**
- Azure Storage encryption at rest by default; rely on it for Table Storage data.
- No Key Vault in MVP; use SWA/Functions app settings (environment variables) and GitHub Secrets for deployment.
- **Upgrade hook:** SecretsProvider abstraction so Key Vault can be added later without refactoring callers.

**Role Handling (All-Free constraint):**
- Keep the concept of roles in API logic, but implement minimal role handling:
  - Default everyone to Participant.
  - Programme Owner/Admin via small allowlist (Entra Object IDs) in Table Storage or app settings.
  - No dynamic role management UI in MVP.
- No manager visibility remains non-negotiable.
- **Upgrade hook:** RolesProvider abstraction to support dynamic role management later.

**API Security:**
- Explicit allowlist per route.
- Reject missing/malformed claims; return 401/403.
- No custom auth flows.

**Audit / Event Logging:**
- Immutable system-event log only (no user behaviour analytics).
- Log: matching run start/complete, notification attempts/failures, admin config changes.
- Include correlation IDs for debugging.

**Implications / Cascading Decisions:**
- Role allowlist source must be documented (Table vs app settings) and secured.

### API & Communication Patterns

**Decision Priority:** Critical (blocks implementation)

**API Design:** RESTful JSON, noun-based routes.
- Keep route surface small and predictable.
- DTOs only at the boundary.

**API Documentation:** OpenAPI.NET generated specs as the source of truth.
- Must stay aligned with DTOs and contract tests.
- Use Microsoft.OpenApi (latest verified 3.1.2).

**Error Handling Standard:** Problem Details JSON (RFC 9457, obsoletes 7807).
- Same shape everywhere.
- Human-readable `title` and `detail`.
- Correlation ID included for support/debug.

**Rate Limiting:** None in MVP.
- If abuse appears, add a basic per-user throttle later.

**Implications / Cascading Decisions:**
- Standardise error envelope and ensure correlation ID is generated per request.
- OpenAPI specs must be regenerated when DTOs change.

### Frontend Architecture

**Decision Priority:** Important (shapes implementation)

**State Management:** React hooks + Context only. No global state library in MVP.

**Routing:** React Router v6 with minimal route guards.
- Guards only for auth-required vs public routes.
- Clean redirect back to intended page after EasyAuth.
- No client-side permission logic beyond auth presence (server remains authoritative).

**Forms:** Native forms + small helpers only. No React Hook Form.

**Performance:** Keep simple; no explicit code-splitting beyond Vite defaults.

**Implications / Cascading Decisions:**
- Auth guard UX must avoid loops and preserve return URLs safely.
- Any future state library must justify added complexity.

### Infrastructure & Deployment

**Decision Priority:** Important (shapes implementation)

**CI/CD:** Standard Azure Static Web Apps GitHub Actions workflows.
- One workflow for app+API SWA.
- One workflow for marketing SWA.

**Environment Configuration:**
- `.env` for local dev.
- SWA app settings for deploy-time config.
- No Key Vault in MVP; use app settings and GitHub Secrets.
- **Upgrade hook:** SecretsProvider abstraction to enable Key Vault later.

**Monitoring:**
- No Application Insights in MVP; basic platform logs only.
- Log errors and matching-run outcomes only.
- **Upgrade hook:** TelemetryProvider abstraction so App Insights can be enabled later with capped logging.
- Minimal alerting if enabled later: matching run failures, notification send failures, auth failures spike, storage errors.

**Scaling:**
- Default consumption/serverless only; no pre-provisioned scaling controls for MVP.

**Implications / Cascading Decisions:**
- Alert thresholds and routing must be defined (team email/Slack).
- App settings must be documented per SWA (app vs marketing).
