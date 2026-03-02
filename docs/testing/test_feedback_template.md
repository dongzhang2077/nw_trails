# Test Feedback Template

Use this template after each teammate runs the app.

## 1) Tester Info

- Tester name:
- Date/time:
- Branch + commit hash:
- OS + device/emulator:
- Flutter version (`flutter --version`):
- Token source: shared `pk.*` token (last 6 chars only):

## 2) Environment Checks

- [ ] `flutter pub get` passed
- [ ] `flutter analyze` passed (no errors)
- [ ] `flutter test` passed
- [ ] `flutter build apk --debug` passed
- [ ] App started with token and Android device id

## 3) Test Cases (Fill One Row Per Case)

| Case ID | Feature | Steps (short) | Expected | Actual | Result |
|---|---|---|---|---|---|
| MAP-01 | Map load | Open app -> Map tab | Streets + pins visible | ... | Pass/Fail |
| CHK-01 | Check-in success | Move to stop -> open detail -> CHECK IN | Success dialog shown | ... | Pass/Fail |
| CHK-02 | Duplicate check-in | Repeat same stop same day | Duplicate blocked | ... | Pass/Fail |
| RTE-01 | Route start | Routes -> Historic Downtown Walk -> Start | Active route appears on Map | ... | Pass/Fail |
| RTE-02 | Route progression | Complete current stop check-in | Next stop updates | ... | Pass/Fail |
| RTE-03 | Route completion | Check-in final stop | Route marked complete | ... | Pass/Fail |
| AWD-01 | Awards/profile | Open Awards tab after check-ins | Progress updates correctly | ... | Pass/Fail |

## 4) Defects (If Any)

For each defect:

- Severity: Blocker / High / Medium / Low
- Repro rate: 100%, intermittent, one-time
- Exact steps:
- Screenshot/video evidence:
- Console/log snippet:
- Suggested owner:

## 5) Final Recommendation

- [ ] Ready to merge
- [ ] Ready with minor UI fixes
- [ ] Not ready (must fix blockers)

Notes:
