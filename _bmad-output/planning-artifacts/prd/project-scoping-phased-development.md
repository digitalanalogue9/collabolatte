# Project Scoping & Phased Development

### MVP Strategy & Philosophy

**MVP Type:** Validated Learning MVP

**Goal:** Test whether people will repeatedly take the shot—not build a complete product.

**Philosophy:** The smallest possible thing that validates the core hypothesis. If the MVP can't succeed without a feature, the hypothesis is probably wrong.

---

### MVP Feature Set (Phase 1)

**Timeline:** 4-6 weeks (solo developer) or 2-3 weeks (small team)

**Core Capabilities:**

| Capability | Description | Journey Support |
|------------|-------------|-----------------|
| **SSO Login** | Azure Entra ID authentication | All journeys |
| **User Profile** | Name, department, location (self-service if directory data missing) | Tomás, Marcus |
| **Programme Join** | One pre-configured programme, one-click join | Tomás, Marcus |
| **Programme Leave** | Opt-out at any time, no friction | Marcus, Aisha |
| **Match Generation** | Random + cross-boundary constraint, scheduled | All journeys |
| **Email Notification** | Match details + conversation starter + Teams deep link | All journeys |
| **Aggregate Metrics** | Retention rate, match count, boundary crossing % | Priya, Helena |

**User Journeys Supported:**

| Journey | MVP Support |
|---------|-------------|
| **Tomás (New Joiner)** | Partial—user types intro (no one-click send) |
| **Marcus (Sceptic)** | Full |
| **Priya (Programme Creator)** | Partial—one fixed programme, basic metrics |
| **Helena (Executive Sponsor)** | Partial—aggregate metrics only |
| **Aisha (Dormant User)** | Full |

**Explicitly Excluded from MVP:**

| Feature | Reason |
|---------|--------|
| Profile customisation | Not needed to test hypothesis |
| Multiple programmes | Adds complexity without learning value |
| Multiple matching algorithms | Randomness is a feature |
| Teams bot / Adaptive Cards | Too heavy for MVP |
| Match expiry window | Introduces policy decisions too early |
| Calendar integration | Coordination is user's responsibility |
| Quiet milestones | Nice but not essential |
| HRIS integration | Directory self-service is sufficient |
| SOC 2 / ISO 27001 | Certifications are Post-MVP |

---

### Post-MVP Features

#### Phase 2: Growth (Post-Validation)

**Goal:** Reduce friction, expand surface area.

**Trigger:** Multiple safe monthly cycles completed with no trust escalations, and leadership explicitly requests expansion.

| Capability | Description |
|------------|-------------|
| "Practice coffee" framing | First match feels lower-stakes |
| One free pass per cycle | Explicit permission not to engage |
| Programme Owner dashboard | Aggregate metrics, boundary analysis |
| Multiple programmes | Enable different communities |
| Quiet milestones | "You've had 5 Collabolattes" |
| Graph API enrichment | Pre-fill department/location from directory |
| Framing copy refinement | "Most chats will be fine. A few will be useful." |

**User Journeys Enhanced:**

- Tomás – improved onboarding experience
- Priya – full Programme Owner journey with dashboard

---

#### Phase 3: Scale (Post-Retention)

**Goal:** Enterprise readiness, multi-tenant capability.

**Trigger:** Multiple organisations requesting pilots; sustained qualitative value and continued voluntary participation over time.

| Capability | Description |
|------------|-------------|
| Multi-tenant architecture | Organisation-level isolation |
| SOC 2 / ISO 27001 | Enterprise compliance certification |
| HRIS integration | Automated boundary constraint validation |
| Multiple matching algorithms | Interest-based, role-based options |
| Programme creation by anyone | Self-service programme creation |
| Teams bot (optional) | One-click intro if IT permits |
| Ripple connections | "You met X, they know Y" |
| Coffee roulette mode | Instant match for power users |

**User Journeys Enhanced:**

- Helena – full executive reporting with cross-org view
- New journey: IT Admin (multi-tenant management)

---

### Risk Mitigation Strategy

#### Technical Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Directory data quality poor | Medium | User self-service on first login; CSV import fallback |
| Teams deep link doesn't work on mobile | Low | Test on all platforms pre-launch; email is primary |
| Table Storage query patterns insufficient | Low | Simple patterns; redesign if needed Post-MVP |

#### Market/Adoption Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Ghost Town (matches don't happen) | Medium | Conversation starters; cross-boundary constraint; curated early adopters |
| Obligation Creep (feels mandatory) | Low | Hard policy: no manager visibility; explicit voluntary framing |
| Privacy concerns surface | Low | Transparent architecture; published data model; no hidden logging |

#### Resource Risks

| Risk | Mitigation |
|------|------------|
| Fewer resources than planned | MVP is already minimal; no further cuts needed |
| Timeline slips | Single-tenant, no integrations = minimal dependencies |
| Key person unavailable | Stack is standard; any C#/React dev can continue |

---

### Scoping Summary

| Phase | Goal | Duration | Trigger |
|-------|------|----------|---------|
| **Phase 1: MVP** | Validate hypothesis | 4-6 weeks | Start now |
| **Phase 2: Growth** | Reduce friction | 4-8 weeks | >50% retention, 3 cycles |
| **Phase 3: Scale** | Enterprise ready | 8-12 weeks | Multi-org demand, 6-month retention |

**Core Scoping Principle:** If you're not embarrassed by your MVP, you shipped too late. The goal is learning, not completeness.

---

## MVP Definition of Done

The MVP is complete when:

- [ ] Users can authenticate via Entra ID
- [ ] Users can join the pilot programme
- [ ] Matching runs on schedule (weekly or monthly; **default monthly**; configured as an ops setting, not user-configurable)
- [ ] Match emails are delivered with conversation starter and Teams link
- [ ] At least 20 participants are enrolled
- [ ] First match cycle completes successfully

---
