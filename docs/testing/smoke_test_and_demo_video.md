# Smoke Test + Demo Video Guide

This is the minimum evidence pack before final submission.

## Why keep a demo video?

The assignment does not explicitly require a video, but it is strongly recommended.
If the instructor cannot run the app locally due to environment differences, the
video proves the expected behavior and reduces risk.

## Video Scope (One take, 3-6 minutes)

Record on Android emulator/device and show:

1. App launch with token-based run command.
2. Map tab loads with streets + landmark pins.
3. Start `Historic Downtown Walk`.
4. One successful check-in at current stop.
5. `Next stop` updates and map focus behavior works.
6. Awards/Profile progress changed after check-in.
7. (Optional) Final-stop route completion flow.

## Quick Smoke Checklist

- [ ] Build/runtime prerequisites pass (`pub get/analyze/test/build apk`)
- [ ] Map loads correctly
- [ ] Check-in works in-range
- [ ] Duplicate check-in is blocked
- [ ] Route start/progression/completion works
- [ ] Awards/Profile progress updates correctly

## Save Artifacts

- Save video as: `group06-smoke-demo.mp4`
- Save one test feedback file per tester (use `test_feedback_template.md`)
- Keep both files in team shared drive for submission backup
