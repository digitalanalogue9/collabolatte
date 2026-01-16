# Collabolatte: Objection Handling & FAQ

**Purpose:** Prepare for questions during internal pitch conversations.

---

## Quick Reference: The Three Anchors

When in doubt, return to these:

1. **"It's opt-in, always."** — No one is forced to participate.
2. **"We don't track whether you meet."** — That's the point, not a limitation.
3. **"If it doesn't work, we shut it down."** — Exit is easy.

---

## Manager Questions

### "Is this going to distract you from your actual job?"

> "I'll build it on personal time / [20% time]. The pilot itself is lightweight — once it's running, it takes maybe 30 minutes a week to monitor. If it becomes a distraction, I'll pause or stop."

### "Why are you doing this?"

> "I care about how people connect here. I've seen how hard it is to meet people outside your immediate team, especially for new joiners and remote staff. I think I can build something that helps, and I'd like to test that hypothesis."

### "What do you get out of this?"

> "Learning. I get to build something real, see if it works, and develop skills. If it succeeds, great — the org benefits. If it fails, I've learned something and we move on."

### "Who else knows about this?"

> "I'm talking to you first. I'd like your support before approaching [IT/HR/senior sponsor]. I won't go around you."

---

## Senior Sponsor Questions

### "Why should I care about this?"

> "Connection is a quiet problem. It doesn't show up in engagement surveys until it's severe. This is a low-cost, low-risk way to create more cross-team relationships without running a formal programme. If it works, you get credit for enabling it. If it doesn't, no one remembers."

### "How is this different from what HR already does?"

> "Most connection initiatives are high-effort and programme-shaped — mentoring schemes, ERG events, socials. They work for some people but fade over time. This is deliberately low-effort and ongoing. It's the background hum of connection, not a campaign."

### "What's the ROI?"

> "Honestly? I can't prove ROI in the traditional sense — and I won't try. The whole point is that we're NOT measuring individual participation. What I can show you: retention rate (are people staying opted-in?), cross-team matches (are we creating new connections?), and anecdotes (do people find it useful?). If those signals are positive after 3 months, it's working."

### "What if people complain?"

> "Then we stop. Immediately. This only works if people genuinely want it. Any signal that it's becoming an obligation means we've failed and should shut down."

---

## IT / Security Questions

### "What data are you collecting?"

> "Minimal:
>
> - Name (from Entra ID)
> - Email (for notifications)
> - Department/location (for cross-boundary matching)
> - Opt-in status and match history
>
> That's it. No meeting logs, no calendar data, no conversation content, no participation tracking."

### "Where is the data stored?"

> "Azure Table Storage, in [my personal Azure tenant / a corporate subscription — TBD]. Data at rest is encrypted by Azure default. I can provide the architecture document if you'd like technical detail."

### "Is this GDPR compliant?"

> "By design, yes:
>
> - Lawful basis: consent (opt-in)
> - Data minimisation: only what's needed
> - Right to erasure: users can leave anytime, data deleted
> - No profiling or automated decision-making
>
> I'm not collecting anything that requires a DPIA, but happy to discuss with the DPO if needed."

### "What about SSO / authentication?"

> "I'd use Azure Static Web Apps with EasyAuth, authenticating against our Entra ID tenant. That requires an app registration — I'd need IT to provision that, or guidance on doing it myself in a sandbox."

### "Is this shadow IT?"

> "Not if you approve it. I'm explicitly asking for permission. Happy to register it formally, follow whatever process exists, and shut it down if there are concerns."

### "What if there's a security incident?"

> "The attack surface is small — no sensitive data, no payment info, no PII beyond name/email. If something happened, we'd shut it down, notify affected users, and delete the data. I'd document the incident and share learnings."

---

## HR / People Team Questions

### "Why wasn't I consulted earlier?"

> "I wanted to have something concrete to show before taking your time. I'm consulting you now, before any pilot runs. I'd welcome your input and would be happy for this to be co-sponsored or run through your team if that's preferred."

### "Does this replace [existing initiative]?"

> "No — it's complementary. [Mentoring programme / ERG events / etc.] serve different purposes. This is for low-stakes, ongoing, serendipitous connections. It's not a programme, it's a background utility."

### "How will you promote it?"

> "I won't heavily promote it. A single, calm announcement to the pilot group: 'Optional. Low effort. You'll get matched with someone. No obligation.' If it needs heavy promotion to work, it's probably not working."

### "What if managers pressure their teams to join?"

> "That would undermine the whole point. I'd make clear in communications: 'Opt-in only. Your manager doesn't know if you joined or not. No one is tracking participation.' If I hear of pressure, I'll address it directly or shut down."

### "Can I see participation data?"

> "Not at an individual level — that's a core design principle. I can share aggregate numbers: total opted-in, retention rate, cross-team match percentage. But I can't tell you who specifically is participating, and that's intentional."

### "What if this creates cliques or exclusion?"

> "Matching is random across the whole opt-in pool, specifically to avoid cliques. The goal is cross-boundary connections, not reinforcing existing groups. I'd monitor the cross-team match rate to ensure it's working as intended."

---

## Skeptic Questions

### "Isn't this just Donut?"

> "Donut and similar tools are built for HR — they have dashboards, participation tracking, manager visibility, feedback collection. They optimise for measurement. Collabolatte is built for participants — no tracking, no dashboards, no pressure. That's a fundamental difference in philosophy, not just features."

### "Why would anyone use this?"

> "Because it gives them a shared excuse to meet someone they wouldn't otherwise encounter. The system initiates, so no one has to make the awkward first move. And because there's no tracking, there's no performance pressure. Some people won't use it — that's fine. It's opt-in."

### "What if no one shows up?"

> "Then it doesn't work, and we shut it down. That's a valid outcome. I'm not trying to force connection — I'm testing whether removing friction helps it happen naturally."

### "Isn't 'no metrics' just an excuse for not proving value?"

> "It's a design choice, not an excuse. The hypothesis is that surveillance kills participation. If I tracked meetings, people would either game it or avoid it. By not tracking, I'm trusting that people will participate because they want to — and retention rate will tell me if that's true."

### "This sounds like a solution looking for a problem."

> "Fair challenge. Here's the problem: in large orgs, people don't know who to reach, feel awkward initiating, and have no shared context for meeting. That's not controversial — it's well-documented in organisational research. The question is whether this specific solution helps. The pilot will tell us."

### "What happens when you leave the company?"

> "Good question. Options:
>
> - Hand it over to someone else who wants to run it
> - Open-source the code so anyone can continue
> - Shut it down cleanly
>
> I'd document everything so it's not dependent on me. But honestly, if it only works because I'm running it, it's probably not a sustainable solution anyway."

---

## The "What If It Fails" Deep Dive

Since this is the main concern, here's the full breakdown:

### Failure Scenarios

| Scenario | How We'd Know | Response |
|----------|---------------|----------|
| **No one signs up** | <10 people after invite | Shut down, reflect on why |
| **People sign up but leave quickly** | >50% churn after cycle 1 | Pause, survey leavers (optional), decide to iterate or stop |
| **Sign up but don't meet** | Anecdotal feedback: "I ignored it" | Adjust cadence or messaging; if persistent, shut down |
| **Complaints about time/pressure** | Any direct complaint | Immediate pause, investigate, likely shut down |
| **IT/HR concerns emerge** | Raised by stakeholders | Pause, address concerns, continue only if resolved |
| **I lose interest/time** | I stop maintaining it | Hand over or shut down cleanly |

### Shutdown Process

1. **Announce** — "We're ending the pilot. Thanks for participating."
2. **Stop matching** — Disable the scheduled function
3. **Export/delete data** — Offer participants their data, then delete
4. **Decommission** — Remove Azure resources
5. **Retrospective** — Document what we learned

**Total time:** One afternoon.

### What We'd Learn from Failure

Even failure is useful:

| Failure Mode | Learning |
|--------------|----------|
| No sign-ups | Messaging didn't resonate; problem not felt acutely |
| Quick churn | Onboarding unclear; value not obvious |
| No meetings | Friction still too high; or people genuinely don't want this |
| Complaints | Tone was wrong; felt obligatory despite intentions |

---

## Conversation Starters

Depending on who you're talking to:

**For your manager:**
> "I've been thinking about how hard it is to meet people outside our team. I've designed a simple tool to help with that and I'd like to run a small pilot. Can I walk you through what I'm proposing?"

**For a senior sponsor:**
> "I've been working on an idea for low-friction cross-team connection — not a programme, just a simple matching tool. Would you be open to hearing about it? I'm looking for a sponsor who'd back a small pilot."

**For IT:**
> "I'm proposing a small internal pilot for a connection tool. It's minimal — just Entra ID auth and email notifications. I'd like to understand what I'd need from IT to do this properly."

**For HR:**
> "I know you're thinking about connection and engagement. I've been working on something complementary — a very lightweight opt-in tool. I wanted to share it with you before running any pilot."

---

## One-Liner Responses

For quick objection handling:

| Objection | Response |
|-----------|----------|
| "We have Donut" | "Donut tracks participation. This doesn't. That's the difference." |
| "No one will use it" | "Maybe. The pilot will tell us. If not, we shut down." |
| "What's the ROI?" | "Retention rate and anecdotes. I can't prove meetings happened — by design." |
| "What if it fails?" | "We shut it down in an afternoon. Low risk." |
| "Is this your job?" | "No — it's a side project I believe in. Built on my own time." |
| "Who owns the data?" | "I do, for now. Happy to transfer to corporate if preferred." |
| "Sounds like extra work" | "30 minutes a week once it's running. I'll stop if it becomes more." |

---

*Prepared to support internal pitch conversations. Adapt tone and detail to your audience.*
