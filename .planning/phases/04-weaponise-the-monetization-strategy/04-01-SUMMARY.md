---
phase: 04-weaponise-the-monetization-strategy
plan: 01
subsystem: monetization
tags: [admob, google_mobile_ads, interstitial, monetization]

# Dependency graph
requires:
  - phase: 03-rewrite-the-resolution-logic
    provides: [Game over detection, turn ticking logic]
provides:
  - Google Mobile Ads initialization
  - AdService with interstitial ad loading and displaying
  - Interstitial ad triggered on game over
affects: [04-02]

# Tech tracking
tech-stack:
  added: [google_mobile_ads]
  patterns: [Riverpod provider for AdService, auto-reloading interstitial ads on dismiss]

key-files:
  created: [lib/core/services/ad_service.dart]
  modified: [pubspec.yaml, android/app/src/main/AndroidManifest.xml, ios/Runner/Info.plist, lib/main.dart, lib/core/providers/game_controller.dart]

key-decisions:
  - "Added MobileAds.instance.initialize() directly in main() before runApp for earliest possible initialization."
  - "AdService reloads a new interstitial ad automatically after it is dismissed to ensure the next game over is ready to serve an ad."

patterns-established:
  - "Interstitial ads triggered conditionally on state transition (isGameOver) using the AdService singleton provider."

issues-created: [] 

# Metrics
duration: 10 min
completed: 2026-02-24
---

# Phase 04 Plan 01: AdMob Interstitial Integration Summary

**Google Mobile Ads SDK integrated with an auto-reloading interstitial AdService that triggers on Game Over**

## Performance

- **Duration:** 10 min
- **Started:** 2026-02-24T16:50:00Z
- **Completed:** 2026-02-24T17:00:00Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments
- Integrated `google_mobile_ads` SDK into Flutter, AndroidManifest, and Info.plist
- Built a Riverpod-managed `AdService` that reliably caches and displays interstitial ads
- Triggered ads effectively as a punishment when the game's timer causes a "Game Over"

## Task Commits

Each task was committed atomically:

1. **Task 1: Add AdMob Dependency & Native Config** - `754bc4a` (feat)
2. **Task 2: Create AdService** - `81e096c` (feat)
3. **Task 3: Trigger Ads on Game Over** - `55ae6f0` (feat)

## Files Created/Modified
- `lib/core/services/ad_service.dart` - `AdService` handles loading, displaying, and reloading interstitial ads.
- `pubspec.yaml` - Added `google_mobile_ads: ^5.0.0`
- `android/app/src/main/AndroidManifest.xml` - Inserted Google Ads App ID meta-data
- `ios/Runner/Info.plist` - Inserted GADApplicationIdentifier
- `lib/main.dart` - Initialized MobileAds before `runApp()`
- `lib/core/providers/game_controller.dart` - Modified `initializeGame` and `_tickGame` to load and show ads.

## Decisions Made
- Added `MobileAds.instance.initialize()` directly in `main()` before `runApp()` for earliest possible initialization.
- `AdService` reloads a new interstitial ad automatically after it is dismissed to ensure the next game over is ready to serve an ad.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
None

## Next Phase Readiness
- AdMob foundation complete. Interstitials are functioning as intended.
- Ready for integrating rewarded video ads for "Continue / Extra Time" mechanism in next plan.
