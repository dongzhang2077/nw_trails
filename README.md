# NW Trails

NW Trails is a Flutter mobile app prototype for exploring landmarks in New Westminster.
It is built for the CSIS4280 Project 01 proposal/prototype milestone.

## Project Goal

Help users discover local landmarks, check in during visits, track progress, and follow curated walking routes.

## Current Status

- Repository and project structure are set up for team collaboration.
- UI/UX wireframe specifications are defined.
- Flutter app implementation is in early prototype stage.

## Planned MVP Features

- Landmark discovery on map and detail view
- Location-based check-in flow
- Awards/profile progress tracking
- Route list and route detail flow

## Tech Stack

- Flutter (Dart)
- Material Design
- Local stub/mock data for prototype stage

## Quick Start

```bash
flutter pub get
flutter run
```

Android-first run (recommended for this project):

```bash
flutter run -d android --dart-define=MAPBOX_ACCESS_TOKEN=<your_mapbox_public_token>
```

## Team Collaboration Workflow

### 1) Repository Access

Yes, add your teammates as GitHub collaborators for this private class repo.

- GitHub -> Settings -> Collaborators and teams -> Add people
- Give each teammate write access

### 2) Branch Strategy

- `main`: stable integration branch
- `feature/<name>-<task>`: each teammate works in a dedicated feature branch

Example:

```bash
git checkout -b feature/alice-checkin-ui
```

### 3) Pull Request Flow

1. Push feature branch
2. Open PR into `main`
3. At least one teammate reviews
4. Merge after checks and review

## Suggested Team Rules

- Keep commits focused and small
- Use clear commit messages (`feat:`, `fix:`, `docs:`)
- Run `flutter analyze` before opening PR
- Do not commit generated build artifacts

## Collaboration Templates

- Contribution guide: `CONTRIBUTING.md`
- PR template: `.github/pull_request_template.md`

## Team Sync Docs

- Docs index: `docs/README.md`
- Full proposal draft: `docs/group06-proposal-draft.md`
- Full UI/UX flow doc: `docs/ui_design_sequence_review.md`
- UI/UX sync snapshot: `docs/design/ui_ux_flow_sync.md`
- Proposal scope snapshot: `docs/proposal/proposal_scope_sync.md`
- lib file ownership map: `docs/development/lib_structure_and_ownership.md`
