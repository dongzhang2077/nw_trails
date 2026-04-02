# NW Trails Manual Integration Test Runbook (Teacher + Team)

Version: `v1.0`  
Last updated: `2026-04-01`

---

## 1) Purpose and Scope

This runbook standardizes **frontend-backend manual integration testing** for NW Trails.

It is designed for:

- instructor review
- teammate QA
- pre-submission acceptance checks

Primary focus:

1. login + protected API integration
2. route/check-in/progress end-to-end flow
3. **simulated location testing** (without physically traveling)

---

## 2) Test Environment Baseline

### Recommended environment (authoritative)

- Device: **Android emulator** (preferred) or Android physical device
- Backend: local Spring Boot server (`localhost:8080`)
- Frontend: Flutter app with backend enabled

### Platform caveats

- `mapbox_maps_flutter` supports **Android/iOS** (not web/desktop).
- App code also shows map fallback text on web: `Map preview is not available on web.`

Therefore, for map/check-in route validation, use Android/iOS instead of web.

---

## 3) Prerequisites (Gate 0)

Run these before manual testing:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

Backend:

```bash
mvnw.cmd test
```

If any command fails, stop and fix first.

---

## 4) Start Services

## 4.1 Start backend

```powershell
cd D:\DouglasLearning\5-SpecialTopicsInEmergingTopics\proj\backend\nw-trails-backend
mvnw.cmd spring-boot:run
```

Expected: app listens on `http://localhost:8080`.

## 4.2 Start frontend (Android emulator)

```powershell
cd D:\DouglasLearning\5-SpecialTopicsInEmergingTopics\proj\app\nw_trails
$token = (Get-Content '<path-to-your-mapbox-pk-token.txt>' -Raw).Trim()

flutter run -d emulator-5554 `
  --dart-define=USE_BACKEND=true `
  --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1 `
  --dart-define=API_USERNAME=student01 `
  --dart-define=API_PASSWORD=Passw0rd! `
  --dart-define=MAPBOX_ACCESS_TOKEN=$token
```

Notes:

- Android emulator uses `10.0.2.2` to reach host `localhost`.
- For iOS simulator/desktop, use `http://localhost:8080/api/v1`.

---

## 5) Standard Manual Test Flow

Use this execution order to reduce false failures:

1. **MAP-01**: map load + pins visible
2. **RTE-01**: start route
3. **CHK-01**: successful check-in in range
4. **CHK-02**: duplicate check-in blocked
5. **CHK-03**: out-of-range blocked
6. **RTE-02/RTE-03**: route progression + completion
7. **AWD-01**: awards progress update
8. **HIS-01**: check-in history update

Record results in `docs/testing/test_feedback_template.md`.

---

## 6) Simulated Location SOP (Key Section)

You can test location rules without physically moving by using either method below.

## Method A — In-app joystick simulation (fastest)

This project already contains an internal simulation path:

- Map page top-right **gamepad button** toggles joystick
- joystick movement injects mock location into app state

How to run:

1. Open **Map** tab.
2. Tap top-right gamepad icon.
3. Joystick appears at bottom.
4. Drag joystick to move simulated location.
5. Open landmark detail and press `CHECK IN`.

Use this for quick iteration during teammate reviews.

## Method B — ADB precise GPS injection (deterministic)

Use this when you need reproducible evidence for instructor review.

Command format:

```powershell
adb -s <device-id> emu geo fix <longitude> <latitude>
```

> Important: order is **longitude first, then latitude**.

Example (Historic Downtown Walk):

```powershell
adb -s emulator-5554 emu geo fix -122.9094 49.2064  # l1 Irving House
adb -s emulator-5554 emu geo fix -122.9079 49.2060  # l2 New Westminster Museum
adb -s emulator-5554 emu geo fix -122.9119 49.2070  # l3 City Hall
adb -s emulator-5554 emu geo fix -122.9119 49.2046  # l4 Westminster Pier Park
adb -s emulator-5554 emu geo fix -122.9079 49.2058  # l12 Anvil Centre
```

Recommended usage:

- inject one stop coordinate
- perform check-in
- verify next stop text updates
- inject next coordinate and repeat

## Method C — Force out-of-range test

Inject a far-away coordinate, then check-in should fail with out-of-range message:

```powershell
adb -s emulator-5554 emu geo fix 0 0
```

Expected: check-in blocked and distance warning shown.

---

## 7) Test Cases and Acceptance Criteria

| Case ID | Steps | Expected Result |
|---|---|---|
| MAP-01 | Launch app -> Map tab | Streets + landmark pins visible; no blocking sync error |
| RTE-01 | Routes -> Historic Downtown Walk -> Start | Active route appears on Map; next stop displayed |
| CHK-01 | Move to current stop (joystick/ADB) -> Landmark Detail -> CHECK IN | Success dialog; progress text updates |
| CHK-02 | Repeat check-in at same landmark same day | Blocked with duplicate message |
| CHK-03 | Move far away (`geo fix 0 0`) -> CHECK IN | Blocked with out-of-range message |
| RTE-02 | Complete one valid stop while route active | Completed count increments, next stop changes |
| RTE-03 | Complete final stop | Route completion message; active route cleared |
| AWD-01 | Open Awards after check-ins | Visited count/category progress updated |
| HIS-01 | Open Check-in History | New record appears in descending time order |

Pass rule: all core cases above pass with no blocker defects.

---

## 8) Evidence Collection Requirements

For each tester session, capture:

- tester name/date/device
- branch + commit hash
- run command used (mask token)
- Pass/Fail per case ID
- at least one screenshot/video for each failed case
- console/log snippet for failures

Store evidence in team shared drive and keep a local backup.

---

## 9) Known Scope Boundaries (Do Not Misclassify as Regression)

These are currently out of core integration pass criteria:

- Favorites action is stub (`Saved to favorites (stub).`)
- Directions button shows pending integration message

Do not fail MAP/CHK/RTE/AWD/HIS core integration because of these two UI placeholders.

---

## 10) Troubleshooting Quick Guide

## `Backend sync failed` banner

- check backend process is running
- verify `API_BASE_URL`, username, password dart-defines
- retry via app banner button

## `adb` not found

- use `<ANDROID_SDK_ROOT>\platform-tools\adb.exe`
- verify device id via `flutter devices` or `adb devices`

## Map not rendering

- verify Mapbox `pk.*` token is valid
- avoid web target for map validation

---

## References

- Android Emulator console commands (`geo fix longitude latitude`):  
  https://developer.android.google.cn/studio/run/emulator-console
- Android advanced emulator usage:  
  https://developer.android.google.cn/studio/run/advanced-emulator-usage
- Mapbox Flutter package (platform support):  
  https://pub.dev/packages/mapbox_maps_flutter
- Mapbox Flutter guides:  
  https://docs.mapbox.com/flutter/maps/guides/
