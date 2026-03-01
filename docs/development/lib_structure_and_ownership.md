# lib Structure and File Ownership

This is the startup file map for parallel development with minimal merge
conflicts.

## Directory Tree (File-Level)

```text
lib/
  main.dart
  app/
    app.dart
    main_shell.dart
    state/
      app_scope.dart
      app_state.dart
  core/
    constants/
      app_theme.dart
    models/
      badge_progress.dart
      checkin_record.dart
      landmark.dart
      landmark_category.dart
      route_plan.dart
    repositories/
      checkin_repository.dart
      landmark_repository.dart
      route_repository.dart
      stub/
        stub_checkin_repository.dart
        stub_landmark_repository.dart
        stub_route_repository.dart
    services/
      location_service.dart
      stub_location_service.dart
  features/
    awards/
      awards_page.dart
    checkin/
      checkin_history_page.dart
    landmarks/
      landmark_detail_page.dart
      map_page.dart
    routes/
      routes_page.dart
```

## Ownership Split (Initial)

- Dong (integration owner)
  - `lib/app/main_shell.dart`
  - `lib/app/state/app_state.dart`
  - `lib/features/routes/routes_page.dart`
  - integration changes across modules
- Diego
  - `lib/features/landmarks/map_page.dart`
  - `lib/features/landmarks/landmark_detail_page.dart` (layout portions)
- Zhi Kang
  - `lib/features/landmarks/landmark_detail_page.dart` (check-in logic portions)
  - `lib/features/checkin/checkin_history_page.dart`
  - Figma prototype linking (outside code)
- Menghua
  - `lib/features/awards/awards_page.dart`

## Shared/No-Touch Rules

- `lib/core/models/*` changes require team lead review before merge.
- `lib/app/app.dart` and `lib/main.dart` are owned by team lead for stability.
- Do not rename files without posting in team chat first.

## Daily Integration Routine

1. Pull latest `main`
2. Rebase feature branch
3. Run `flutter analyze`
4. Push and open PR
