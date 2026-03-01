# Contributing Guide

This guide defines how the team collaborates in this repository.

## Workflow Overview

1. Pull latest `main`.
2. Create a feature branch.
3. Implement one focused change.
4. Run local checks.
5. Open a pull request.
6. Get at least one review.
7. Merge to `main`.

## Branch Naming

Use this pattern:

```text
feature/<name>-<task>
fix/<name>-<bug>
docs/<name>-<topic>
```

Examples:

- `feature/alice-checkin-ui`
- `feature/bob-routes-page`
- `fix/charlie-distance-validation`

## Commit Message Convention

Use clear commit prefixes:

- `feat:` new functionality
- `fix:` bug fix
- `docs:` documentation update
- `refactor:` code cleanup without behavior change
- `test:` tests added or updated
- `chore:` tooling or config updates

Examples:

- `feat: add check-in success dialog layout`
- `fix: prevent duplicate check-in state update`

## Local Checks Before PR

Run from repository root:

```bash
flutter pub get
flutter analyze
flutter test
```

If no tests exist yet, clearly state that in the PR description.

## Pull Request Rules

- Keep each PR focused on one topic.
- Add a clear summary of what changed and why.
- For UI changes, include screenshots or short screen recording.
- Add a simple test plan in the PR body.
- Request at least one teammate review before merge.

## Definition of Done

- Code builds and runs locally.
- Analyzer has no new issues.
- Feature behavior matches the agreed UI/UX flow.
- Related docs are updated if needed.
- PR is reviewed and approved.
