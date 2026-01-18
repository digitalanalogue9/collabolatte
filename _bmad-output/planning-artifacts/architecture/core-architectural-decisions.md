# Core Architectural Decisions

## Data Architecture

**Decision Priority:** Critical (blocks implementation)

**Database Choice:** Azure Cosmos DB (NoSQL API).
**Rationale:** Aligns with MVP constraints while providing better scalability and query flexibility than Table Storage. Free tier covers MVP usage.
**SDK:** Azure.Cosmos SDK (latest)

**Data Modelling Approach (Container per entity):**

- **Memberships**: `partitionKey = /programmeId`, `id = {programmeId}_{userId}`
- **Cycles**: `partitionKey = /programmeId`, `id = {programmeId}_{cycleDate}`
- **Matches**: `partitionKey = /programmeId`, `id = {programmeId}_{matchId}`
- **Events (optional MVP)**: `partitionKey = /programmeId`, `id = {timestamp}_{guid}` (only if needed)

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

## Authentication & Security

**Decision Priority:** Critical (blocks implementation)

**Authorisation Pattern:** Role-based, enforced server-side per route.

- Roles: Participant, Programme Owner, Admin.
- Executive Sponsor has no separate role in MVP (same visibility as Programme Owner).
- Role enforcement via `staticwebapp.config.json` and API checks.

**Identity & Claims Handling:**

- EasyAuth for identity; validate claims on every request, deny-by-default.
- Never trust client-provided identity; decode SWA client principal header as untrusted input.

**Encryption & Secrets:**

- Azure Cosmos DB encryption at rest by default.
- No Key Vault in MVP; use SWA/Functions app settings (environment variables) and GitHub Secrets for deployment.
- **Upgrade hook:** SecretsProvider abstraction so Key Vault can be added later without refactoring callers.

**Role Handling (All-Free constraint):**

- Keep the concept of roles in API logic, but implement minimal role handling:
  - Default everyone to Participant.
  - Programme Owner/Admin via small allowlist (Entra Object IDs) in Cosmos DB or app settings.
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

## API & Communication Patterns

**Decision Priority:** Critical (blocks implementation)

**API Design:** RESTful JSON, noun-based routes.

- Keep route surface small and predictable.
- DTOs only at the boundary.

**API Documentation:** OpenAPI specification generated via Azure Functions OpenAPI extension.

- Must stay aligned with DTOs and contract tests.
- Use Microsoft.Azure.Functions.Worker.Extensions.OpenApi (v1.6.0+) for isolated worker model.
- OpenAPI generation uses decorator attributes on HTTP trigger functions.
- Add `<_FunctionsSkipCleanOutput>true</_FunctionsSkipCleanOutput>` to .csproj to prevent DLL removal during publishing.
- OpenAPI spec available at `/api/swagger.json` and Swagger UI at `/api/swagger/ui` when running locally.

**Code Documentation Standards:**

- .NET API: XML doc comments required on public API surface (Functions endpoints, DTOs, options, public services).
- React app: JSDoc/TSDoc required on exported components, hooks, and shared utilities.
- Documentation should capture behaviour, inputs/outputs, auth/role requirements, and non-obvious side effects.

**Error Handling Standard:** Problem Details JSON (RFC 9457, obsoletes 7807).

- Same shape everywhere.
- Human-readable `title` and `detail`.
- Correlation ID included for support/debug.

**Rate Limiting:** None in MVP.

- If abuse appears, add a basic per-user throttle later.

**Implications / Cascading Decisions:**

- Standardise error envelope and ensure correlation ID is generated per request.
- OpenAPI specs must be regenerated when DTOs change.

## Frontend Architecture

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

## Infrastructure & Deployment

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
