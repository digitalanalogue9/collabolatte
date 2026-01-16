# Lightweight SaaS Specific Requirements

### Project-Type Overview

Collabolatte is a **Ritual Engine / Lightweight SaaS**—not a traditional B2B platform. The architecture prioritises simplicity, trust, and learning velocity over feature completeness or enterprise scalability. Every technical decision passes through the filter: "Does this help us test the ritual, or does it accidentally build a platform?"

**Cost Philosophy:** Run the MVP for as little as possible so the only thing being validated is whether people actually meet.

---

### Technology Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| **Frontend** | React | SPA hosted on Azure Static Web Apps |
| **Backend** | C# Azure Functions (.NET isolated worker) | Integrated with Static Web Apps |
| **Auth** | Azure Entra ID (EasyAuth) | Built-in integration, zero custom auth code |
| **Database** | Azure Table Storage | Accessed via Azure.Data.Tables SDK |
| **Email** | Azure Communication Services | C# SDK |
| **Hosting** | Azure Static Web Apps | Free tier |

**Why This Stack:**
- First-class integration between Static Web Apps, Functions, and Entra ID
- Managed auth handles tokens, sessions, claims automatically
- Strong typing with C# backend and typed Table Storage entities
- Local development via SWA CLI + Azure Functions Core Tools
- GitHub Actions deployment built-in

---

### Azure Architecture (Minimal Viable Infrastructure)

| Component | Implementation | Cost |
|-----------|----------------|------|
| **Frontend** | Azure Static Web Apps (Free tier) | £0 |
| **API** | Azure Functions (Consumption plan) | £0 |
| **Auth** | Azure Entra ID via EasyAuth | £0 |
| **Database** | Azure Table Storage | ~£0.01/month |
| **Email** | Azure Communication Services | ~£2-5/month |
| **Scheduled Jobs** | Azure Functions Timer Trigger | Included |

**Total Services:** 3 (Static Web App, Storage Account, Communication Services)

**Estimated MVP Cost:** ~£5/month

---

### Authentication Architecture

**Entra ID Authentication Flow:**

1. User visits app → Static Web Apps redirects to Entra ID login
2. User authenticates (SSO if already logged into M365)
3. Entra ID returns token → Static Web Apps sets session cookie
4. React app calls `/.auth/me` to get user claims
5. API calls include auth automatically (EasyAuth forwards claims)
6. C# Functions receive `ClaimsPrincipal` with user email, name, etc.

**No custom auth code needed.** Configure identity providers in `staticwebapp.config.json`.

**Directory Data Strategy:**

| Phase | Approach |
|-------|----------|
| **MVP** | Use Entra ID claims (email, name). User confirms/adds department and location on first login. |
| **Post-MVP** | Microsoft Graph API enrichment (`User.Read` permission) if directory data quality is good |

---

### Multi-Tenancy Model

| Phase | Approach | Rationale |
|-------|----------|-----------|
| **MVP** | Single-tenant per organisation | Simplifies trust, compliance, and failure analysis |
| **Future** | Multi-tenant with organisation-level isolation | Only once behaviour is proven |

---

### Permission Model

| Role | Capabilities | Notes |
|------|--------------|-------|
| **Participant** | Join/leave programmes, receive matches and notifications | Nothing else |
| **Programme Owner** | Configure cadence and constraints, view aggregate signals | No individual visibility |
| **Admin** | SSO/identity config, data retention, operational oversight | Ops only—NO analytics access |

**Trust Enforcement:** Admin has operational access but NOT analytics access. Architectural separation.

---

### Data Model (Azure Table Storage)

| Entity | PartitionKey | RowKey | Fields |
|--------|--------------|--------|--------|
| **User** | `"users"` | `{email}` | name, function, location, joinedAt |
| **Programme** | `"programmes"` | `{programmeId}` | name, cadence, constraints, ownerId, createdAt |
| **Membership** | `{userEmail}` | `{programmeId}` | status, joinedAt, pausedAt |
| **Match** | `{programmeId}` | `{matchDate}_{matchId}` | user1Email, user2Email, status, sentAt |
| **Event** | `{programmeId}` | `{timestamp}_{eventType}` | eventType, userId, metadata |

**Design Principles:**
- Partition keys aligned to query patterns
- Denormalise where necessary (no joins)
- Simple lookups: user by email, users in programme, matches for programme

---

### Notification Architecture (Email + Teams Deep Links)

**Notification Flow (MVP):**

1. Match generated → system sends **email** to both users
2. Email contains:
   - Match name, department, location
   - Conversation starter prompt
   - **[Start Conversation]** button → Teams deep link: `https://teams.microsoft.com/l/chat/0/0?users={matched_person_email}`
3. User clicks → Teams opens with new chat to their match → user types intro
4. System logs: `match-sent`

**Trade-offs Accepted:**
- User types their intro (no bot-initiated message)
- Can't detect `match-acknowledged` (no bot)
- Acceptable for MVP—retention is the primary signal

**Why This Works:**
- No Bot Framework complexity
- No IT permissions negotiation
- Email is reliable and universal
- Teams deep link works across desktop, web, mobile

---

### Integration Architecture

| Integration | MVP Approach | Notes |
|-------------|--------------|-------|
| **SSO** | Azure Entra ID via EasyAuth | Built-in |
| **Directory data** | Entra ID claims + user self-service | Graph API Post-MVP |
| **Teams** | Deep links in email notifications | No bot |
| **Email** | Azure Communication Services | Match notifications |

**Explicitly Not MVP:** Teams bot, Slack, Calendar integration, In-app messaging

---

### Matching Algorithm

| Constraint | Implementation |
|------------|----------------|
| **Cross-boundary** | Must match across function OR location (not same team) |
| **No repeat matches** | Within rolling window (e.g., 6 months) |
| **Pair formation** | Simple random pairing within constraints |

**Edge Case Handling:**

| Scenario | Handling |
|----------|----------|
| **Odd number** | One person skipped; log `match-skipped-no-pair` |
| **Small pool (<10)** | Warn Programme Owner |
| **Boundary data missing** | Fall back to pure random |

---

### Privacy-by-Design Enforcement

| Constraint | Implementation |
|------------|----------------|
| **No individual-level API endpoints** | Don't build them |
| **Aggregate queries minimum group size** | 5+ participants |
| **Admin ≠ Analytics** | Architectural separation |
| **Published event schema** | Document every event logged |

---

### Event Logging

| Event | Purpose | Visibility |
|-------|---------|------------|
| `user-joined-programme` | Participation tracking | Aggregate only |
| `match-sent` | Delivery confirmation | Aggregate only |
| `match-skipped-no-pair` | Small pool detection | System ops |
| `user-left-programme` | Churn signal | Aggregate only |

---

### Compliance Architecture

| Requirement | Phase | Implementation |
|-------------|-------|----------------|
| **GDPR / UK GDPR** | MVP (by design) | Legitimate interests; data minimisation |
| **Worker monitoring alignment** | MVP (by design) | No behavioural scoring, no hidden tracking |
| **ISO 27001 / SOC 2** | Post-MVP | Not required to test hypothesis |

---
