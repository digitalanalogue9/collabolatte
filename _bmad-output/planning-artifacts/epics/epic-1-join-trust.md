# Epic 1: Join & Trust

Participants can safely opt in, understand what is happening, and trust the system from the first touch.
**FRs covered:** FR1, FR2, FR3, FR5, FR6, FR41
**NFR Focus:** NFR1 (baseline performance), NFR6 (Entra ID only), NFR18-21 (accessibility basics).

**Epic 1 Prerequisites:** Minimal project scaffolding and Azure foundations are in place (repo structure, SWA config stubs, Entra ID auth wiring baseline, and storage connection placeholders).

**Azure Setup Note (pre-Story 1.0):**

- Create Azure Static Web Apps resources (app+api, marketing)
- Configure Entra ID app registration and EasyAuth for SWA
- Create Storage Account (Table Storage)
- Create Azure Communication Services resource (email)
- Set required app settings and secrets in SWA

### Story 1.0: Document infrastructure provisioning (Bicep)

As a delivery team,
I want a documented Bicep-based infrastructure plan in /infra,
So that we can provision Azure consistently when we are ready.

**Acceptance Criteria:**

**Given** infrastructure is not yet provisioned,
**When** the /infra documentation is created,
**Then** it defines the resources required for MVP (2x SWA, Storage Account, ACS),
**And** it specifies naming conventions per Azure resource rules,
**And** it lists required parameters (project, environment, region, identifier),
**And** it documents Entra ID and EasyAuth setup steps.

**Given** the document exists,
**When** a developer reviews /infra/README.md,
**Then** they can follow it to implement Bicep later without ambiguity.

### Story 1.1: Set up initial project from starter template

As a delivery team,
I want to set up the initial project from the approved starter templates,
So that Join & Trust stories can be implemented without blocking setup work.

**Acceptance Criteria:**

**Given** the starter templates are approved in Architecture,
**When** we initialise the project,
**Then** the repo is scaffolded as a monorepo with `/apps/web`, `/apps/api`, and `/apps/marketing`,
**And** the web app is created from the official Vite React TypeScript template,
**And** the API is initialised with Azure Functions (.NET isolated),
**And** the marketing site is initialised with 11ty.

**Given** the scaffolding exists,
**When** baseline configuration is applied,
**Then** `staticwebapp.config.json` and SWA workflow stubs exist for app+api and marketing,
**And** Entra ID auth wiring is configured at the platform level (no custom auth code),
**And** storage connection placeholders are defined for local and cloud environments.

**Given** the foundations are in place,
**When** a developer starts work on Epic 1 stories,
**Then** they can run the web and API projects locally without additional scaffolding.

### Story 1.2: First contact feels safe

As a prospective participant,
I want to understand what Collabolatte is and is not before doing anything,
So that I can decide whether it feels safe and optional.

**Acceptance Criteria:**

**Given** I land on the Collabolatte app unauthenticated,
**When** I view the first screen,
**Then** I can immediately see that participation is optional and lightweight,
**And** the screen explicitly states that behaviour is not tracked,
**And** the copy conforms to the Trust Copy Checklist,
**And** no action is required to understand this.

**Given** I have not signed in,
**When** I read the first screen,
**Then** the trust message is in plain English without legal language,
**And** it conforms to the Trust Copy Checklist.

### Story 1.3: Authenticate without friction

As a prospective participant,
I want to authenticate using my corporate Entra ID without creating an account,
So that joining feels invisible and low-effort.

**Acceptance Criteria:**

**Given** I choose to sign in,
**When** I authenticate via Entra ID,
**Then** I am signed in without creating any custom credentials,
**And** I do not see any additional create account steps.

**Given** I have authenticated successfully,
**When** I land back in the app,
**Then** I see clear reassurance that only basic identity data is used.

### Story 1.4: See what we store (and do not)

As a prospective participant,
I want to see a clear, plain-English summary of what data is stored about me before joining,
So that I can decide with confidence.

**Acceptance Criteria:**

**Given** I am on the join screen,
**When** I look for data handling information,
**Then** I can see a short, plain-English summary of what is stored and what is not,
**And** it conforms to the Trust Copy Checklist.

**Given** I want more detail,
**When** I select the "What we store" link,
**Then** I can view the full explanation without legalese,
**And** I can return to the join screen without losing my place.

### Story 1.5: Join with a single action

As a prospective participant,
I want to opt in with one clear, reversible action,
So that joining feels low-stakes.

**Acceptance Criteria:**

**Given** I am on the join screen,
**When** I choose to join,
**Then** there is a single primary Join action,
**And** I am not asked for a bio, interests, or extra details,
**And** the language avoids commitment or obligation,
**And** it conforms to the Trust Copy Checklist.

**Given** I select Join,
**When** the action completes,
**Then** I see a clear confirmation that I am now opted in.

### Story 1.6: Know I can leave or pause

As a prospective participant,
I want to know I can pause or leave at any time,
So that I feel safe opting in.

**Acceptance Criteria:**

**Given** I am on the join screen,
**When** I read the opt-in information,
**Then** I can clearly see that leaving or pausing is allowed at any time,
**And** it is stated as consequence-free.

**Given** I have not joined yet,
**When** I read the join copy,
**Then** pausing or leaving is mentioned explicitly at join time.

### Story 1.7: Be treated as a participant by default

As a newly joined participant,
I want to be treated as a standard participant with no special visibility or responsibilities,
So that I do not feel pressure or role confusion.

**Acceptance Criteria:**

**Given** I have joined,
**When** I view the post-join state,
**Then** I do not see admin or programme-owner surfaces,
**And** I do not see metrics or status indicators beyond "You may be matched."

**Given** I am a standard participant,
**When** I use the app,
**Then** my default role is participant only.
