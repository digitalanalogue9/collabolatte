---
stepsCompleted: [1, 2, 3]
inputDocuments: []
session_topic: 'Collabolatte MVP - internal matching platform for curiosity coffee connections'
session_goals: 'Testable MVP concept, user flows, assumptions/risks, success metrics'
selected_approach: 'ai-recommended'
techniques_used: ['First Principles Thinking', 'Six Thinking Hats', 'Question Storming']
ideas_generated: [7 First Principles, 16 Green Hat Ideas, 20 Questions]
context_file: ''
---

# Brainstorming Session Results

**Facilitator:** DA9
**Date:** 2026-01-11

## Session Overview

**Topic:** Collabolatte - an internal matching and session platform for regular, opt-in small-group "curiosity coffee" connections (2-3 people) on configurable cadence, aimed at increasing cross-team interaction and organisational value.

**Goals:**

- Clear, testable MVP concept that validates core hypothesis (not a full social platform)
- Defined user flows: creating programmes, joining, matching, lightweight feedback loop
- Explicit assumptions and risks to test during pilot
- Candidate success metrics indicating real value creation

### Framing Statement

The purpose of this product is to create low-friction, opt-in opportunities for serendipitous connections. Not every interaction will be valuable, and that is expected. Value emerges from increasing the number of safe, lightweight "shots taken" rather than optimising for perfect outcomes.

### Core Principles

1. **Opt-in only** - Participation is voluntary and reversible at any time
2. **Low obligation** - Missing or deferring a session carries no penalty or judgement
3. **Opportunity over outcome** - The system creates chances, not guarantees
4. **Simplicity first** - Fewer features preferred if they increase participation
5. **Conservative by design** - Minimal data capture, clear auditable behaviour

### Validation Focus

**Success measured by:**

- Whether people actually meet
- Whether participants report personal value
- Whether interactions surface ideas, insights, or follow-ups with potential organisational benefit

**Failure modes to watch:**

- High scheduling but low meeting follow-through
- Perceived obligation rather than curiosity
- Over-engineering reducing participation

---

## Technique Selection

**Approach:** AI-Recommended Techniques
**Analysis Context:** Collabolatte MVP with focus on testable concept, user flows, assumptions/risks, success metrics

**Recommended Techniques:**

1. **First Principles Thinking:** Strip away social platform assumptions to find irreducible MVP essence
2. **Six Thinking Hats:** Systematic exploration of flows, risks, benefits through six distinct lenses
3. **Question Storming:** Surface testable assumptions and pilot validation questions

**AI Rationale:** Session goals emphasise validation over feature accumulation. User's "simplicity first" principle and "shots taken" framing suggest first-principles approach. Explicit request for assumptions/risks maps directly to Question Storming output. Six Thinking Hats provides structured coverage without over-engineering ideation.

---

## Technique 1: First Principles Thinking

### First Principles Discovered

**[FP1] Nudge + Shared Risk for Connections Beyond Reach**
The system surfaces connections that wouldn't happen organically - not because people lack courage, but because it's impossible to know everyone at a firm. The match creates a nudge (system initiates) and shares the risk (both matched, neither solely responsible). You never know who might spark something.

**[FP2] Opt-In as Curiosity Filter**
Voluntary participation self-selects for curious people. The signup action demonstrates curiosity - no screening needed.

**[FP3] Bio as Conversation Seed, Not Just Matching Input**
Profile information serves the participants first ("here's what they're curious about"), algorithm second. Reduces first-meeting friction.

**[FP4] Choice Architecture Over Feature Completeness**
Expose the framework (random / rules / AI), deliver incrementally. Validates demand without over-building.

**[FP5] Trial Framing as Feedback Permission**
6-month experiment with binary outcome. "Help us decide" = co-ownership, not surveillance.

**[FP6] Passive Metrics Before Active Feedback**
Observe first (sessions, attendance, return rate), ask second. Behaviour beats surveys.

**[FP7] Multi-Channel Feedback Strategy**
In-app optional for iteration; executive interviews for narrative. Comms lead as ally.

### Essential vs Not Essential (Yet)

| Essential | Not Essential (Yet) |
|-----------|---------------------|
| Nudge + shared risk to reach out | In-app messaging |
| Opt-in participation | Curiosity screening |
| Basic profile as conversation seed | Sophisticated profile matching |
| Choice architecture visible | All algorithms functional |
| Cross-boundary discovery | Calendar integration |
| Trial framing (6 months) | Permanent platform mindset |
| Passive metrics | Extensive surveys |

### Key Insight

Collabolatte solves a **scale problem** (impossible to know everyone), not a **courage problem** (people too shy). The throughline: remove friction from cross-boundary connection while staying radically simple.

---

## Technique 2: Six Thinking Hats

### ⚪ White Hat - Facts & Information

**[White Hat #1]**: Participant Flow

1. Sign up → write bio, choose/add interests
2. Browse public sessions (filtered by interest tags)
3. Join a session
4. System matches on configured date → emails the group
5. Group self-coordinates meeting time (Teams/email)
6. They meet

**[White Hat #2]**: Programme Creator Flow

1. Create programme → name, description
2. Configure matching → algorithm choice(s), group size
3. Set cadence → first match date, frequency
4. Set visibility → public or private (invite only)
5. Add owners/sponsors (optional)
6. Publish

**[White Hat #3]**: Two Usage Patterns

- **Power users**: Create private/niche programmes for their team or interest group
- **Most users**: Join established public programmes set up by central team

**[White Hat #4]**: Post-Coffee Data Model

| System Knows | System Doesn't Know |
|--------------|---------------------|
| Match was created | Whether meeting happened |
| Participants notified | Quality of conversation |
| Time has passed | Outcomes or follow-ups |

**[White Hat #5]**: Feedback Philosophy

- **Default**: Nothing asked, nothing required. Attending = end of obligation.
- **Passive signals**: Continued opt-in, pause/leave patterns, participation over time
- **Explicit signals**: Single ignorable prompt ("Worth it" / "Not for me"), no reminders, no expectation

**[White Hat #6]**: Learning vs Ease Trade-off
*"If learning competes with ease of use, ease of use wins."*

---

### ⬛ Black Hat - Risks & Caution

**[Black Hat #1]**: Risk Map by Stage

| Stage | Key Risks |
|-------|-----------|
| **Signup** | Bio feels like work; too many fields; unclear value → "I'll try later" |
| **Discovery** | Choice paralysis; noisy tags; joining for politeness not curiosity |
| **Programme creation** | Algorithm choices feel abstract; over-config; private = silos |
| **Matching** | Bad timing; large groups = coordination burden; repeat matches |
| **Self-coordination** | No clear "first move"; threads die quietly; timezone friction |
| **After meeting** | No closure; mediocre experience → silent opt-out |
| **System-level** | Over-engineer = unapproachable; Under-measure = can't justify to sponsors |

**[Black Hat #2]**: The Meta-Risk
*"The system technically works, but socially fails to create momentum or psychological safety, leading to passive disengagement rather than explicit rejection."*

**[Black Hat #3]**: MVP-Critical Risks (Existential)

| Risk | Learning Blocked |
|------|------------------|
| **Early friction at signup** | No data |
| **Failed first meetings** | Poison future cycles |
| **Obligation-driven participation** | Hides true value signal |

*"Everything else is secondary and can be tuned later."*

---

### 🟡 Yellow Hat - Benefits & Value

**[Yellow Hat #1]**: Participant Success

- Lightweight and safe - low friction preserved through real usage
- Human, not transactional - curiosity framing held
- No pressure to justify - "shots taken" philosophy working
- Staying opted in despite misses - value/cost ratio feels right
- "I met someone interesting through Collabolatte" - organic word-of-mouth

*Key phrase: "The occasional genuinely useful connection makes the misses tolerable."*

**[Yellow Hat #2]**: Programme Creator Success

- Simple, low-risk creation - choice architecture working
- Programmes stabilise - self-sustaining, not high-maintenance
- Basic "alive" signals - passive metrics sufficient
- Less managing, more letting it run - simplicity-first validated
- Anecdotal stories without chasing metrics - value surfaces organically

*Key phrase: "They don't feel like they are running an initiative, just setting conditions."*

**[Yellow Hat #3]**: Organisation Success

- Cross-team connections without formal programmes
- Ideas/intros emerge informally, outside official channels
- Steady hum, not spike of hype - sustainable
- Optional utility, not HR tooling - trust preserved
- Fewer "we didn't know X were doing Y" moments

*Key phrase: "A growing number of small, unplanned connections that would not have happened otherwise."*

**Success Throughline:** Success is quiet. No fanfare, no dashboards, no forced testimonials. Just more connection than before.

---

### 🟢 Green Hat - Creativity & Alternatives

**Signup & Onboarding Ideas:**

- **[Green #1]** No Bio, Just Facts - name, department, location only. Conversation is the discovery.
- **[Green #5]** Practice Coffee - first match framed as "warm-up, low stakes, just try it"

**Conversation Support Ideas:**

- **[Green #2]** System-Suggested Conversation Starter - "You both listed sustainability - maybe start there?"
- **[Green #11]** Icebreaker Card - quirky question with match: "What's something you've changed your mind about recently?"

**Match Mechanics Ideas:**

- **[Green #3]** Match Expiry Window - meet within 2 weeks or match dissolves. Gentle urgency.
- **[Green #4]** One Free Pass Per Cycle - skip a match, no questions asked. Explicit safety valve.
- **[Green #8]** Coffee Roulette Mode - one-click, instant match, meet this week. For the spontaneous.

**Programme Design Ideas:**

- **[Green #7]** Programme Personalities - "The Randomiser" / "Bridge Builder" / "Deep Dive"
- **[Green #9]** Optional Ripple Connections - "You met X, they know Y - want an intro?"
- **[Green #12]** Programme Hibernate - pause and resume later. No guilt, no death.
- **[Green #13]** Graceful Programme Closure - "47 connections created. Thank you."

**Adoption & Spread Ideas:**

- **[Green #14]** Gift a Match - "I think you'd enjoy meeting X - here's a Collabolatte invite"
- **[Green #15]** Bring a Sceptic Challenge - playful viral conversion
- **[Green #16]** Time-Boxed Team Experiment - 4-week trial with built-in end date

**Recognition Ideas:**

- **[Green #10]** Quiet Milestones - "You've had 5 Collabolattes" - private, not public

**Design Pattern Combinations:**

| Pattern | Combination | Effect |
|---------|-------------|--------|
| **Effortless Onboarding** | No bio + practice coffee | Zero friction entry |
| **Guided Serendipity** | Minimal profile + conversation starter | System does discovery |
| **Gentle Momentum** | Match expiry + free pass | Urgency without pressure |
| **Progressive Comfort** | Practice coffee → starter → regular | Stakes increase with confidence |

---

### 🔵 Blue Hat - Process & Overview

**[Blue Hat #1]**: Core Insight
*"Collabolatte removes structural friction that stops curious people from ever meeting. The value comes from increasing low-risk opportunities, not optimising each interaction."*

**[Blue Hat #2]**: 30-Second Explanation
*"An opt-in internal matching tool that quietly creates chances for people to meet outside their usual circles. Pairs small groups on a regular cadence and gets out of the way. No performance, no obligation, no heavy measurement. Most conversations will be fine, some forgettable, a meaningful few will spark insight or connection that wouldn't have happened otherwise. Over time, increases cross-team awareness and innovation without feeling like a programme."*

**[Blue Hat #3]**: Four Core Themes

| Theme | Principle |
|-------|-----------|
| **Friction is the enemy** | Every interaction cost must justify itself |
| **Trust over measurement** | Ease beats data; participation beats precision |
| **Conditions over outcomes** | Set up, step back, let it happen |
| **Graceful edges** | Make it easy to pause, pass, leave, or fail without drama |

**[Blue Hat #4]**: MVP Prioritisation

| Priority | Features |
|----------|----------|
| **Must-Have** | Minimal signup, one-click join, match notification with clear first move, match expiry, one public programme |
| **Should-Have** | Conversation starter, practice coffee framing, free pass, quiet milestones |
| **Post-MVP** | Multiple algorithms, programme creation by anyone, ripple connections, coffee roulette, gift a match |

---

## Technique 3: Question Storming

### Assumptions to Test

**Core Value Hypothesis:**

- **[Q1]** We assume people want more cross-team connections. *But what if most feel sufficiently connected already?*
- **[Q2]** We assume opt-in curiosity correlates with perceived value. *But what if curiosity doesn't translate into meaningful conversations?*
- **[Q3]** We assume increasing connections increases chance of value. *But how would we know if volume is helping rather than diluting attention?*
- **[Q5]** We assume serendipitous matches surface useful insights. *But how would we know whether those insights would have emerged anyway?*

**Participation Mechanics:**

- **[Q4]** We assume low-risk framing removes social friction. *But what if ambiguity creates inertia instead?*
- **[Q6]** We assume small groups (2-3) are the right unit. *But what if pairs are too intense or triads too easy to ignore?*
- **[Q7]** We assume people will self-coordinate meetings. *But what if coordination effort outweighs perceived benefit?*
- **[Q8]** We assume missing some meetings is acceptable. *But what if early misses disproportionately reduce future engagement?*
- **[Q19]** We assume busy people will protect 30 minutes for a stranger. *But what if calendar pressure always wins?*

**Measurement Paradox:**

- **[Q11]** We assume passive signals like retention are sufficient. *But what if people stay opted in out of politeness rather than value?*
- **[Q12]** We assume not asking for feedback preserves trust. *But what if lack of reflection reduces perceived importance?*
- **[Q13]** We assume simplicity drives adoption. *But what if too little structure makes the experience forgettable?*

**Organisational Value Chain:**

- **[Q9]** We assume personal value precedes organisational value. *But how would we know if individual benefit ever translates into broader impact?*
- **[Q10]** We assume innovation signals can emerge informally. *But what if they remain invisible to the organisation?*
- **[Q14]** We assume this works across roles and seniority. *But what if value is concentrated in specific cohorts only?*

**Pilot Design:**

- **[Q15]** We assume six months is enough to see signal. *But how would we know if we're stopping too early or too late?*
- **[Q17]** We assume programme creators will set sensible configurations. *But what if early misconfigured programmes poison perception?*
- **[Q18]** We assume one public programme is enough to start. *But what if a single programme feels too generic?*
- **[Q20]** We assume "practice coffee" framing lowers stakes. *But what if labelling something as "practice" signals it's not worth taking seriously?*

**Cultural Factors:**

- **[Q16]** We assume the "first move" problem is solvable with clear framing. *But what if cultural norms override any framing?*

---

### First 8 Weeks - Critical Questions

| Priority | Question | Why First |
|----------|----------|-----------|
| **1** | Do meetings actually happen once matched? | If no meetings, no signal is trustworthy |
| **2** | Does low-risk framing work, or create inertia? | Early drift kills momentum before learning |
| **3** | Does volume increase value, or dilute attention? | Tests core "shots taken" thesis |
| **4** | Is retention genuine value or polite compliance? | Distinguishes signal from noise |
| **5** | Does personal value translate to org value? | Determines if product justifies existence |

**Decision Framework:** Answer these in 8 weeks → clear continue, pivot, or stop.

---

## Session Summary

### What We Built

| Technique | Output |
|-----------|--------|
| **First Principles Thinking** | 7 foundational principles defining what Collabolatte is and isn't |
| **Six Thinking Hats** | Mapped flows, risks, success pictures, 16 creative ideas, 4 core themes, MVP prioritisation |
| **Question Storming** | 20 testable assumptions, 5 critical 8-week validation questions |

### Core Insight

*"Collabolatte removes structural friction that stops curious people from ever meeting. The value comes from increasing low-risk opportunities, not optimising each interaction."*

### Four Themes

1. **Friction is the enemy** - every interaction cost must justify itself
2. **Trust over measurement** - ease beats data; participation beats precision
3. **Conditions over outcomes** - set up, step back, let it happen
4. **Graceful edges** - make it easy to pause, pass, leave, or fail without drama

### MVP Scope

**Must-Have:** Minimal signup, one-click join, match notification with clear first move, match expiry, one public programme

**Should-Have:** Conversation starter, practice coffee framing, free pass, quiet milestones

### Next Steps

1. **Research** - validate assumptions with desk research or competitor analysis
2. **Product Brief** - formalise vision, scope, and success criteria
3. **PRD** - detailed requirements for MVP build

---

**Session Complete.**
*Brainstorming session facilitated: 2026-01-11*
*Techniques used: First Principles Thinking, Six Thinking Hats, Question Storming*
