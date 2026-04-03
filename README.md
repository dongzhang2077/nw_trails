# NW Trails (Flutter App)

NW Trails is a Flutter app for exploring New Westminster landmarks with GPS check-ins, route guidance, badges/progress, and account-based auth.

## Current Feature Coverage

- Map discovery + category filters
- Landmark detail + `GET DIRECTIONS` (native maps, web fallback)
- Check-in with 50m validation and duplicate-day guard
- Optional multi-photo check-in upload (up to 9 photos)
- Check-in history with photo review
- Awards/profile progress
- Curated routes + active route progression
- Login + account page + sign out

## Prerequisites

1. Flutter SDK (Dart 3.10+ compatible)
2. Android Studio + Android emulator (recommended)
3. A Mapbox public token (`pk.*`)
4. Backend running locally at `http://localhost:8080`

> Backend setup guide: `../../backend/nw-trails-backend/README.md`

## Quick Start (Android Emulator)

From `proj/app/nw_trails`:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

PowerShell run example:

```powershell
$token = (Get-Content '<path-to-your-mapbox-token.txt>' -Raw).Trim()
flutter run -d emulator-5554 --disable-dds --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1 --dart-define=MAPBOX_ACCESS_TOKEN=$token
```

macOS/Linux bash run example:

```bash
TOKEN=$(cat <path-to-your-mapbox-token.txt>)
flutter run -d emulator-5554 --disable-dds \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1 \
  --dart-define=MAPBOX_ACCESS_TOKEN=$TOKEN
```

If you run on iOS simulator/desktop instead of Android emulator, use:

- `API_BASE_URL=http://localhost:8080/api/v1`

## Test Login Accounts

- `student01 / Passw0rd!`
- `admin01 / AdminPass!`

These are seeded by the backend on first startup.

## 5-Minute Smoke Test

1. Launch app and sign in.
2. Open **Map**, tap any pin, open landmark detail.
3. Tap **ADD PHOTOS** (optional), then **CHECK IN**.
4. Open **Check-in** tab, verify new record and **View photos**.
5. Open **Routes**, start a route, verify progress updates after check-in.
6. Open **Account**, verify user info and **SIGN OUT**.

## Photo Upload Testing Notes

- Photo upload is tied to check-in submit:
  - select photos first (`ADD PHOTOS`)
  - upload happens when you tap `CHECK IN`
- Max: 9 photos per check-in.
- On emulator, if gallery is empty, drag a `.jpg/.png` file into emulator first.

## Common Troubleshooting

### 1) `DartDevelopmentServiceException` / service protocol disconnect

Use `--disable-dds` (already included in recommended command above).

### 2) `Photo upload failed`

Usually backend is not running or `API_BASE_URL` is wrong.

- Android emulator must use `http://10.0.2.2:8080/api/v1`
- Localhost on host machine is not directly reachable from emulator without `10.0.2.2`

### 3) Check-in blocked by distance

Use in-app test mode/location simulation to move near the landmark before checking in.

### 4) Login fails immediately

Confirm backend is running and seeded users exist.

If you upgraded from an older backend build, reseed users in MongoDB and restart backend.

## Demo Video

- https://www.youtube.com/watch?v=6Hc2wNXTypo

## Team Docs

- `docs/README.md`
- `docs/group06-proposal-draft.md`
- `docs/ui_design_sequence_review.md`
- `docs/testing/manual_integration_test_runbook.md`
