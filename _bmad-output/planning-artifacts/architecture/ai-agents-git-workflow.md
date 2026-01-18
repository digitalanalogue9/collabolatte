# AI Agents + Git Workflow (GitHub)

This repository uses BMAD to create epics and stories. This document defines the Git workflow that
keeps AI agent work safe, parallel, and reviewable.

## Goals

1. Isolate intent (one story, one change set).
2. Bound blast radius (easy to revert/abandon a story).
3. Keep review cheap (small PRs with clear scope).
4. Enable safe parallelism (multiple agents without file collisions).

## Branch taxonomy

- `main`
  - Protected release trunk.
  - Humans merge via PR only.
- `epic/<epic-key>-<short-name>`
  - Integration lane for an epic.
  - Receives merges from story PRs.
  - Merged to `main` only when the epic is complete.
- `story/<epic-key>-<story-key>-<short-name>`
  - Execution lane for a single story.
  - Owned by one agent (or a tightly scoped agent group).
  - PRs target the epic branch.

Optional (use sparingly):

- `docs/<topic>` for pure documentation not tied to a story.
- `chore/<topic>` for mechanical repo maintenance not tied to a story.

## Golden rules (agents)

1. Do not push to `main` or `epic/*` directly.
2. Work only on a `story/*` (or `docs/*`/`chore/*` where explicitly permitted).
3. One story branch equals one PR with one unit of intent.
4. If a story becomes multi-PR, the story is too large: split it.

## PR flow

1. Create epic branch from `main`:
   - `epic/E1-project-foundation-deployment`
2. Create story branch from the epic branch:
   - `story/E1-S01-bicep-scaffold`
3. Open PR:
   - Base: `epic/<...>`
   - Head: `story/<...>`
4. When the epic is ready:
   - PR `epic/<...>` into `main`

## Required checks (GitHub rulesets)

GitHub can only require checks that have run at least once for branches matching the ruleset target.
If the required-checks list is empty for `epic/*`, open a tiny PR into an `epic/*` branch to force
workflows to report status checks, then return to ruleset configuration.

Avoid requiring checks that only run on PR close (for example “Close Pull Request Job”), as they can
block merges.

## Merge strategy

- Prefer **squash merge** for `story/* → epic/*` and `epic/* → main` to keep history readable.
- Keep epic branches short-lived; merge `main` into `epic/*` frequently to reduce late conflicts.
- Use feature flags when partially complete work must land without enabling behaviour.

## Labels (recommended)

Require each PR to include:

- Exactly one: `story` or `epic`
- At least one area label: `infra`, `api`, `web`, `marketing`, `ci`, `docs`

## BMAD artefacts and documentation changes

BMAD artefacts change only when a workflow is run or when a file is edited.

- If the story deliverable is documentation/planning:
  - Commit the relevant `_bmad-output/**` updates.
- If the story deliverable is code/infra:
  - Avoid committing unrelated `_bmad-output/**` churn.
- Update `_bmad-output/implementation-artifacts/sprint-status.yaml` only when the PR is ready (or
  after merge), ideally as a tiny follow-up PR based on the latest `main`.

## PR template content (minimum)

Every PR should answer:

1. What story/epic does this implement? (link to BMAD artefact + issue if used)
2. What acceptance criteria are met? (checkboxes)
3. How was it tested? (commands + CI evidence)
4. Rollout/feature flag notes and rollback risk

