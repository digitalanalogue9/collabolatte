# Epic 1 Retrospective: Project Foundation & Deployment

**Epic:** Epic 1 - Project Foundation & Deployment
**Completed:** 2026-01-18
**Team:** DA9 + BMAD Agents
**Facilitator:** Bob (Scrum Master)

---

## Epic Overview

**Epic Scope:** Establish the technical foundation, deploy to Azure, and verify the end-to-end pipeline works before implementing features.

**Success Criteria:** All Met ✅
- Monorepo structure established with web (React/Vite), API (.NET Functions), and marketing (11ty) apps
- Storybook set up for component development and testing in isolation
- Azure infrastructure provisioned (2x Static Web Apps, Storage Account, Azure Communication Services)
- Entra ID authentication configured at platform level
- CI/CD pipelines deploy to Azure successfully
- Minimal "hello world" application deployed and accessible in dev environment
- Developers can run all projects locally without additional scaffolding

**Stories Completed:** 7 (1-0 through 1-6)

**Deployed Environments:**
- **App + API:** https://purple-ocean-0c85fbd03.6.azurestaticapps.net
- **Marketing:** https://green-pebble-0850a8f03.4.azurestaticapps.net

---

## 1. What Went Well 🎉

### 1.1 Automated IaC & CI/CD Pipeline Working

**Achievement:**
- Bicep templates deploy infrastructure consistently and repeatably
- GitHub Actions workflows deploy apps automatically on push to main
- End-to-end pipeline proven before feature development starts
- Infrastructure-as-code provides version control and auditability

**Impact:**
- Epic 2 can start immediately without infrastructure blockers
- Deployment process is repeatable across environments (dev/staging/prod)
- Infrastructure changes are version-controlled and reviewable

**Evidence:**
- Story 1.4: Bicep templates validate successfully (`az bicep build` passes)
- Story 1.5: Infrastructure deployed via GitHub Actions workflow
- Story 1.6: Application deployed successfully, both SWA workflows working
- All deployments idempotent (can run multiple times safely)

---

### 1.2 Documentation-First Approach Sets Up for Success

**Achievement:**
- Story 1.0 documented infrastructure comprehensively before implementation
- Clear handoff: documentation → Bicep templates → deployment
- Architecture decisions documented before coding started

**Impact:**
- Reduced ambiguity and rework in subsequent stories
- Developers had clear reference documentation
- Naming conventions, security patterns, and resource configuration pre-defined

**Evidence:**
- Story 1.0: `/infra/README.md` created with complete resource definitions
- Story 1.4: Bicep implementation followed documented standards exactly
- No significant rework required due to unclear requirements

**Recommendation:** Continue documentation-first pattern for Epic 2+ infrastructure changes.

---

### 1.3 Monorepo Foundation Solid

**Achievement:**
- All three apps (web, api, marketing) scaffolded and running locally
- pnpm workspace configured correctly
- Shared theme package working across apps
- Storybook integrated seamlessly

**Impact:**
- Developers can work on any app without setup friction
- Component development environment ready before features
- Consistent theming across web and marketing sites

**Evidence:**
- Story 1.1: All apps run locally (`pnpm dev`, `func start`, `eleventy`)
- Story 1.2: Storybook runs successfully on port 6006
- Story 1.3: 9 components created with stories, all using shared theme

---

### 1.4 Complete Component Library Ready

**Achievement:**
- 9 foundational UI components created with Storybook stories
- All components follow Sage Calm design direction
- Components use trust-first language patterns
- Accessibility considerations included (ARIA labels, keyboard nav)

**Components Delivered:**
- Layout: AppHeader, AppFooter, AppLayout, Logo
- Content: MatchCard, JoinCard, ContextInfoBlock, ProgrammeStatusCard, EmptyState

**Impact:**
- Epic 2 (Join & Trust) has zero component blockers
- Feature stories can compose existing components
- UX patterns proven in Storybook before integration

**Evidence:**
- Story 1.3: All components complete with `.stories.tsx` files
- All stories render correctly in Storybook
- Components demonstrate all variants (matched/pending/empty states)

---

## 2. What Could Have Gone Better 🤔

### 2.1 Azure Static Web Apps .NET Version Compatibility

**Issue:**
- Attempted to use .NET 10 based on research
- Azure SWA does not support .NET 10 (only .NET 9 and earlier)
- Multiple workflow failures during Story 1.6 deployment
- Trial-and-error debugging before discovering version constraint
- Eventually downgraded to .NET 9

**Impact:**
- Significant time lost to version incompatibility ("major hassle")
- Workflow failures delayed Story 1.6 completion
- Multiple failed GitHub Actions runs

**Root Cause:**
- Research didn't surface actual Azure SWA runtime constraints
- Prioritized general .NET articles over Azure-specific documentation
- Version compatibility not validated early in architecture phase

**Learning:**
- Verify Azure service compatibility EARLY before committing to versions
- Prioritize official Azure documentation over general research
- Check service-specific constraints (Azure SWA, Functions, etc.) before architecture finalization

**Action Item:**
- Update Architecture Document to explicitly state: ".NET 9 (Azure SWA does not support .NET 10)"

---

### 2.2 Styling Issues on First Deployment

**Issue:**
- Story 1.6 initial deployment had visual issues:
  - Marketing site used wrong primary colour (purple #6B4EFF instead of Sage Calm green #3a7f6c)
  - App site constrained to 1-column width (Vite default CSS issue)
- Issues detected only after manual verification in deployed environment
- Required follow-up PR #3 to fix styling

**Impact:**
- Additional deployment cycle required
- User-facing issues visible in production (even though pre-feature)
- Rework after "completion" of Story 1.6

**Root Cause:**
- Styling not tested in deployed environment before marking story complete
- Local development (Vite dev server) behaved differently than deployed SWA
- Visual regression not caught before deployment

**Learning:**
- Test styling in Azure SWA CLI emulation locally before deployment
- Create visual regression checklist for first deploy: colours, layout, responsive behaviour
- Don't rely solely on local Vite dev server for styling validation

**Action Item:**
- Use SWA CLI (`swa start`) for local testing before deployment
- Visual checklist: primary colour, layout width, responsive breakpoints

---

### 2.3 Dependency Version Mismatches

**Issue:**
- Storybook dependency version warnings (8.6.14 vs 8.6.15)
- Non-blocking but noisy in console output

**Impact:**
- Minor - warnings only, functionality not affected
- Could cause confusion for developers

**Learning:**
- Pin exact versions in package.json for consistency
- Run `pnpm update` periodically to align versions

---

## 3. Lessons Learned 📚

### Key Learnings for Future Epics

1. **Verify Azure service compatibility EARLY**
   - Check official Azure documentation for runtime/framework support
   - Validate version constraints before architecture phase
   - Don't assume general research applies to Azure-specific services

2. **Update Architecture Document with explicit constraints**
   - Add: ".NET 9 (Azure SWA does not support .NET 10)"
   - Document any version-specific limitations discovered
   - Make constraints visible to prevent future confusion

3. **Test styling locally with SWA CLI before deployment**
   - Use `swa start` to emulate deployed environment
   - Create visual regression checklist: colours, layout, responsive
   - Don't rely solely on Vite dev server for final validation

4. **Continue Documentation-First Pattern**
   - Worked well for infrastructure (Story 1.0 → 1.4)
   - Reduced ambiguity and rework
   - Keep this pattern for Epic 2+ infrastructure changes

---

## 4. Epic Transition: Setup → Implementation

### Nature of Work Shift

**Epic 1 = Setup & Foundation**
- Infrastructure provisioning
- Project scaffolding
- Deployment pipeline setup
- Component library creation
- Zero user-facing features

**Epic 2+ = Feature Implementation**
- User-facing functionality
- Business logic
- Data operations (Table Storage, matching algorithms)
- Trust-critical features (opt-in, data visibility, leave/pause)

**Implications:**
- Different testing patterns (E2E tests, contract tests, trust-guard tests)
- User claims validation at API boundaries (EasyAuth headers are untrusted)
- Feature delivery velocity vs infrastructure setup velocity

---

## 5. Epic 2 Readiness Assessment

### Prerequisites Satisfied ✅

- ✅ Project scaffolding deployed and working
- ✅ Azure infrastructure deployed (SWAs, Storage Account, ACS)
- ✅ Entra ID authentication working (EasyAuth verified in Story 1.6)
- ✅ Storage and ACS connections verified (Status endpoint confirms connectivity)
- ✅ Component library ready (9 components with Storybook stories)
- ✅ CI/CD pipelines proven (GitHub Actions workflows deploy successfully)

### No Changes Needed to Epic 2 Stories

- .NET 9 is already in place and correct
- Architecture decisions validated in Epic 1
- Component patterns proven in Storybook
- Epic 2 can start immediately

### Critical Reminder for Epic 2

⚠️ **Validate user claims from EasyAuth headers at API boundaries**
- EasyAuth headers (`x-ms-client-principal-*`) are untrusted input
- All API endpoints must validate claims before business logic
- Follow Architecture decision: boundary validation on all API inputs

---

## 6. Metrics & Outcomes

### Story Completion

- **Total Stories:** 7 (1-0 through 1-6)
- **Completion Rate:** 100%
- **Rework Required:** 1 story (1.6 styling fixes)

### Deployment Artifacts

- **Azure Resources Created:** 6 (Resource Group, 2x SWA, Storage Account, ACS, Entra ID app registration)
- **GitHub Actions Workflows:** 3 (infra-deploy.yml, swa-app.yml, swa-marketing.yml)
- **Bicep Templates:** 4 (main.bicep, storage.bicep, acs.bicep, swa.bicep)
- **Components with Stories:** 9 (all UX patterns for Epic 2)

### Cost Validation

- ✅ All resources within Azure Free Tier limits
- ✅ No unexpected charges
- ✅ Infrastructure matches budget constraints

---

## 7. Action Items for Epic 2

| Action | Owner | Priority |
|--------|-------|----------|
| Update Architecture Document with .NET 9 constraint | DA9 | High |
| Use SWA CLI for local testing before deployment | DA9 | Medium |
| Create visual regression checklist | DA9 | Low |
| Validate user claims at API boundaries (all Epic 2 stories) | DA9 | Critical |

---

## 8. Team Observations

### What Made This Epic Successful

- **Clear scope:** Epic 1 intentionally avoided features, focused purely on foundation
- **Documentation-first mindset:** Reduced ambiguity and rework
- **Incremental validation:** Each story built on previous, validated locally before deployment
- **Automation early:** CI/CD working before features means Epic 2 can iterate faster

### Challenges Overcome

- Azure SWA .NET version compatibility (downgraded to .NET 9)
- Styling issues caught and fixed after deployment
- Entra ID manual setup (cannot be fully automated via Bicep)

---

## 9. Conclusion

**Epic 1 Status:** ✅ **COMPLETE**

All success criteria met. Infrastructure is deployed, CI/CD pipelines working, component library ready. Epic 2 (Join & Trust) is unblocked and ready to start.

**Key Takeaway:**
Automated IaC and documentation-first approach set the project up for success. The .NET version compatibility issue was painful but resolved, with lessons learned to prevent recurrence. Epic 2 can now focus on feature delivery without infrastructure friction.

**Next Step:**
Begin Epic 2: Join & Trust - first user-facing features.

---

**Retrospective Completed:** 2026-01-18
**Facilitator:** Bob (Scrum Master)
**Participants:** DA9, BMAD Team
