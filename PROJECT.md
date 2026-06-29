# garminbowling — Project Reference

## Goal

A Garmin Connect IQ watch app that tracks bowling games as a fitness activity. The app allows a bowler to record each shot during a game, calculates the score according to the rules of the selected game type, displays a running scorecard, and saves the completed game to the Garmin Fit activity system.

---

## Platform

| Item | Value |
|---|---|
| Runtime | Garmin Connect IQ (Monkey C) |
| Min API Level | 5.2.0 |
| Target Device | Garmin FR970 |
| App Type | watch-app |
| Required Permissions | Fit, FitContributor, Sensor |

---

## Supported Game Types

### Tenpin
Standard ten-pin bowling.
- 10 frames per game
- Up to 2 shots per normal frame; up to 3 shots in the 10th frame
- Strike: all 10 pins on the first shot → frame ends, next 2 shots count as bonus
- Spare: all 10 pins across 2 shots → frame ends, next 1 shot counts as bonus
- Open frame: fewer than 10 pins after 2 shots → no bonus
- 10th frame: a strike or spare earns fill balls (up to 3 shots total in the 10th)
- Maximum score: 300 (12 consecutive strikes)

### Candlepin
Candlepin bowling, popular in New England.
- 10 frames per game
- 3 shots per frame
- Fallen pins (deadwood) are **not** cleared between shots within a frame — bowlers can aim at or around deadwood
- Strike: all 10 pins on the first shot → 10 + next 2 shots count as bonus (same as Tenpin)
- Spare: all 10 pins across the first 2 shots → 10 + next 1 shot counts as bonus (same as Tenpin)
- Ten-box: all 10 pins across all 3 shots → no bonus, just the 10 points
- Open frame: fewer than 10 pins after 3 shots → total pins knocked, no bonus
- 10th frame: a strike or spare earns fill balls (up to 3 shots total)
- Maximum score: 300 (12 consecutive strikes)

### Duckpin
Duckpin bowling, popular in the Mid-Atlantic US.
- 10 frames per game
- 3 shots per frame
- Fallen pins **are** cleared between shots within a frame (unlike Candlepin)
- Strike: all 10 pins on the first shot → 10 + next 2 shots count as bonus (same as Tenpin)
- Spare: all 10 pins across the first 2 shots → 10 + next 1 shot counts as bonus (same as Tenpin)
- Ten: all 10 pins across all 3 shots → no bonus, just the 10 points
- Open frame: fewer than 10 pins after 3 shots → total pins knocked, no bonus
- 10th frame: a strike or spare earns fill balls (up to 3 shots total)
- Maximum score: 300 (never achieved under official conditions)

The scoring engine correctly handles all three game types. The `NormalFrame` `addShot` logic awards 2 bonus shots for a strike (`_currentShot == 0`), 1 for a spare (`_currentShot == 1`), and 0 for a ten-box/ten (`_currentShot == 2`).

---

## Optional Game Settings

Settings are selected before each game and stored in `GameSettings`.

| Setting | Description | Currently Used |
|---|---|---|
| Bumpers | Bumper rails active (casual/youth play) | Declared only |
| League Lanes | Alternate lanes after each frame | Declared only |

These settings are toggled in the UI but are not yet wired into any scoring or display logic.

---

## Architecture

The project is organized into two layers:

```
source/
  garminbowlingApp.mc       # App entry point
  domain/                   # Scoring engine (no UI dependencies)
    Frame.mc                # Frame data model and shot logic
    Game.mc                 # Game orchestration and bonus tracking
    Score.mc                # Score formatting for display
  views/                    # UI layer
    GameTypePicker.mc       # Game type selection
    GameSettings.mc         # Pre-game settings menu
    StartGame.mc            # Start screen
    ThreeFrame.mc           # Main scorecard view (in progress)
```

The domain layer has no dependency on Garmin UI modules and is independently unit-testable. The views layer reads from the domain via `Game` and `Score`.

---

## Domain Model

### Frame (`Frame.mc`)

Represents one frame of bowling. Two implementations share the `Frame` interface:

**`NormalFrame`** — used for frames 1–9.
- Constructed with `shotsPerFrame` (2 for Tenpin, 3 for Candlepin/Duckpin).
- Tracks shots in `_wood` array.
- `Bowled` becomes `true` when the frame is complete:
  - Total pins = 10 on any shot → strike (shot 0) or spare (shot 1+)
  - All shots used without reaching 10
- `GetNumberBonusShots()` returns 2 for a strike, 1 for a spare, 0 for an open frame.

**`TenthFrame`** — used for frame 10 only.
- Always allows up to 3 shots.
- A strike or spare on the first 2 shots unlocks the fill ball.
- `Bowled` becomes `true` when:
  - Total pins < 10 and `shotsPerFrame` shots used (no bonus earned), or
  - 3 shots taken
- Always returns 0 bonus shots (the fill balls are baked into the frame itself).

Both classes throw `InvalidFrameException` if:
- A shot is added to a completed frame.
- A getter is called on an incomplete frame.

### Game (`Game.mc`)

Orchestrates 10 frames and tracks bonus shot accounting.

**Key state:**
- `_frames`: array of 10 Frame objects (allocated lazily as the game progresses)
- `_bonusShotsLeft`: dictionary mapping frame index → shots still owed as bonus
- `_bonusWood`: dictionary mapping frame index → bonus pins accumulated so far
- `FrameNumber`: current active frame (0–9)
- `GameDone`: true when the 10th frame is complete

**`AddShot(wood)`** — the main input method:
1. Records the shot in the current frame.
2. For each frame in `_bonusShotsLeft`, decrements its counter and adds `wood` to its `_bonusWood`.
3. Calls `checkFrameStatus()` and returns `FRAMENOTDONE`, `NEXTFRAME`, or `ENDGAME`.

**`GetFrameStats()`** — returns a `FrameStats` object for all completed frames:
- Each `SingleFrameStats` has `WoodShots` (array of pin counts) and `TotalWood` (frame pins + bonus, or `null` if bonus is still pending).

### Score (`Score.mc`)

Sits on top of `Game` and formats output for display.

**`GetScore()`** returns a `ScoreDisplay` with:
- `DisplayWood`: per-frame arrays of formatted shot strings
- `RunningTotal`: cumulative score per frame (`null` while any prior frame's bonus is still pending)

**Shot display notation:**

| Condition | Display |
|---|---|
| First shot = 10 (strike) | `"X"` |
| Cumulative = 10 on 2nd shot (spare) | `"/"` |
| 0 pins (gutter) | `"-"` |
| Any other count | pin count as string |

---

## UI Flow

```
App Launch
  └─> Game Type Picker  (Tenpin / Candlepin / Duckpin)
        └─> Game Settings Menu  (Bumpers, League Lanes toggles)
              └─> Start Game Screen  ("Press Start to Start Game")
                    └─> ThreeFrame View  [in progress]
```

**ThreeFrame View** is the main scorecard screen. It displays 3 frames at a time with:
- Shot boxes at the top of each frame (2 boxes for Tenpin, 3 for Candlepin/Duckpin — the 3rd box is hidden for Tenpin via `setVisible(false)`)
- A score box at the bottom of each frame showing the running total
- Frame number label

The view layout is defined in `resources/layouts/ThreeFrames.xml` and the frame border graphics in `resources/drawables/Frame.xml`. Input handling and shot recording from the ThreeFrame view are not yet implemented.

---

## Persistence

**Target state:** Completed games should be saved as Garmin FIT activities via the FitContributor API. The `Fit` and `FitContributor` permissions are already declared in `manifest.xml`.

**Current state:** No persistence is implemented. All game data lives in memory for the duration of the session and is lost when the app exits.

---

## Testing

Tests live in `test/` and run in the Garmin ConnectIQ simulator.

| File | Coverage |
|---|---|
| `TestFrame.mc` | NormalFrame and TenthFrame — shot logic, completion conditions, bonus shot counts, error cases |
| `TestGame.mc` | Game orchestration — frame transitions, bonus tracking, GetFrameStats output |
| `TestScore.mc` | Score display — shot notation (X, /, -), running totals, null handling for pending frames |

Tests are tagged with `(:test)` and executed via `monkeydo -t` against the simulator. `mise run test` builds the test binary, runs it on a headless Xvfb display, and determines pass/fail by parsing the final `PASSED (passed=N, failed=0, errors=0)` summary line (monkeydo's own exit code is always 1, so it is ignored).

**Run tests:**
```
mise run test
```

**Run app in simulator:**
```
mise run run
```

**Build only:**
```
mise run build
```

---

## CI/CD

GitHub Actions runs on every push and pull request to `main`.

Build and test run in one job on a standard `ubuntu-latest` runner. The job checks
out the code, then `docker run`s the public matco Connect IQ tester image
([`ghcr.io/matco/connectiq-tester`](https://github.com/matco/connectiq-tester),
pinned by digest), which bundles the Connect IQ SDK, the `fr970` device, and a
headless Xvfb display. It compiles `monkey.jungle` for `fr970` with `-t`, runs the
unit tests on the simulator, and fails the job if any test fails. No credentials
are required — a temporary signing certificate is generated in-container. The full
test output is printed to the step log and uploaded as the `ciq-test-output`
artifact.

The image is invoked directly via `docker run` rather than matco's GitHub Action,
whose argument order has drifted out of sync with the current image. To move to a
newer SDK, repull the image and update the pinned digest. Locally, the same build
and tests run via `mise run build` / `mise run test` (see
[docs/REMOTE-DEV.md](docs/REMOTE-DEV.md)).

---

## What Is Complete

- Scoring engine: frame logic, bonus tracking, running totals (`Frame.mc`, `Game.mc`, `Score.mc`)
- Unit tests for the full scoring engine
- UI flow through game type picker and settings menu to the start screen
- ThreeFrame scorecard layout and drawable definitions
- CI/CD pipeline

## What Is Not Yet Complete

- Shot input handling in ThreeFrame view (recording shots during a game)
- Updating the scorecard display as shots are recorded
- FIT activity save on game completion
- Bumpers / League Lanes settings wired into game logic
- Navigation for scrolling through all 10 frames
