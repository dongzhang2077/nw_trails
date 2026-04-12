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

## Running Modes

The app supports two running modes controlled by the `USE_BACKEND` compile-time flag:

| Mode | Flag | Description |
|------|------|-------------|
| **Backend Mode** | `USE_BACKEND=true` (default) | Connects to real backend API. Requires login + backend running. |
| **Stub Mode** | `USE_BACKEND=false` | Uses local mock data. No login required, works offline. |

### Backend Mode (Default)

Use this for full functionality including:
- Real user authentication (login/logout)
- Photo upload to server
- Persistent check-in history
- Multi-device data sync

**Requirements:**
- Backend running at `http://localhost:8080`
- Valid Mapbox token
- Test login accounts (see below)

### Stub Mode (Offline Demo)

Use this for quick UI testing without backend:
- No login required (skips auth screen)
- Uses mock landmark/route data
- Check-ins saved locally only
- Photos not uploaded

**Use case:** Frontend development, UI testing, screenshots.

## Quick Start (Android Emulator)

From `proj/app/nw_trails`:

```bash
flutter pub get
flutter analyze
flutter test
flutter build apk --debug
```

### Option A: Run with Backend (Full Features)

PowerShell:

```powershell
$token = (Get-Content '<path-to-your-mapbox-token.txt>' -Raw).Trim()
flutter run -d emulator-5554 --disable-dds `
  --dart-define=USE_BACKEND=true `
  --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1 `
  --dart-define=MAPBOX_ACCESS_TOKEN=$token
```

macOS/Linux:

```bash
TOKEN=$(cat <path-to-your-mapbox-token.txt>)
flutter run -d emulator-5554 --disable-dds \
  --dart-define=USE_BACKEND=true \
  --dart-define=API_BASE_URL=http://10.0.2.2:8080/api/v1 \
  --dart-define=MAPBOX_ACCESS_TOKEN=$TOKEN
```

### Option B: Run with Config File (Recommended for Daily Development)

**Step 1**: Create `env.json` file (copy from template):

```bash
cp env.json.example env.json
```

Then edit `env.json` with your actual token (get one from https://account.mapbox.com/):

```json
{
  "MAPBOX_ACCESS_TOKEN": "pk.your_actual_mapbox_token_here",
  "API_BASE_URL": "http://10.0.2.2:8080/api/v1",
  "USE_BACKEND": "true"
}
```

⚠️ **Security Note**: Never commit your actual `env.json` file to git. It should already be in `.gitignore`.

**Step 2**: Run with config file:

```bash
flutter run --dart-define-from-file=env.json
```

✅ **Advantages**:
- No need to paste token every time
- Can add multiple config files (e.g., `env.staging.json`, `env.production.json`)
- `env.json` is ignored by git (won't leak your token)

### Option C: VS Code Launch Configuration

If you use VS Code, press `F5` to run with pre-configured settings:

1. Open VS Code in the project folder
2. Press `Ctrl+Shift+D` (Run and Debug)
3. Select configuration:
   - **"NW Trails (Android + Backend)"** - Full features with backend
   - **"NW Trails (Stub Mode)"** - No backend required
   - **"NW Trails (Chrome Web)"** - Run in browser

Edit `.vscode/launch.json` to update the Mapbox token.

### Option D: Run in Stub Mode (No Backend)

```bash
flutter run -d emulator-5554 --disable-dds --dart-define=USE_BACKEND=false
```

**Note:** When `USE_BACKEND=false`, the app will:
- Skip the login screen
- Show mock landmarks and routes
- Allow check-ins without validation
- Not upload any photos

### Device-Specific URLs

| Platform | API_BASE_URL |
|----------|--------------|
| Android Emulator | `http://10.0.2.2:8080/api/v1` |
| iOS Simulator | `http://localhost:8080/api/v1` |
| Desktop (Windows/Mac/Linux) | `http://localhost:8080/api/v1` |
| Physical Device | `http://<your-computer-ip>:8080/api/v1` |

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

### 5) App goes straight to map, skips login

You are running in **Stub Mode** (`USE_BACKEND=false`). To enable login:

```bash
# Add this flag to your flutter run command:
--dart-define=USE_BACKEND=true
```

### 6) "Backend API client not configured" error

You are running in Backend Mode but the app can't connect to the backend. Either:

- **Start the backend**: See `../../backend/nw-trails-backend/README.md`
- **Or switch to Stub Mode**: Add `--dart-define=USE_BACKEND=false`

### 7) Map shows blank / grey screen or app crashes frequently

**Cause**: Mapbox token is missing or invalid.

**Solutions**:

1. **Verify token is set**:
   ```bash
   # Check if token is being passed
   flutter run --dart-define=MAPBOX_ACCESS_TOKEN=your_token_here -v
   ```

2. **Use config file method** (see Option B above):
   ```bash
   # Create env.json with your token, then:
   flutter run --dart-define-from-file=env.json
   ```

3. **Check token validity**:
   - Go to https://account.mapbox.com/
   - Ensure your token has `DOWNLOADS:READ` and `MAPS:READ` scopes
   - Public tokens (pk.*) should work for development

4. **Clear Flutter cache** if token was recently added:
   ```bash
   flutter clean
   flutter pub get
   flutter run --dart-define-from-file=env.json
   ```

### 8) ".env file not working"

This project uses **compile-time environment variables** (`--dart-define`), not runtime `.env` files. 

- ❌ Don't use: `flutter_dotenv` package or `.env` file
- ✅ Use: `--dart-define-from-file=env.json` (see Option B above)

The difference:
- `--dart-define`: Variables embedded at compile time (recommended for Flutter)
- `.env` file: Read at runtime (requires additional packages)

## Demo Video

- https://www.youtube.com/watch?v=6Hc2wNXTypo

## Team Docs

- `docs/README.md`
- `docs/group06-proposal-draft.md`
- `docs/ui_design_sequence_review.md`
- `docs/testing/manual_integration_test_runbook.md`
