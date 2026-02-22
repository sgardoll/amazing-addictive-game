# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-22 17:48:31 AEDT
**Commit:** f55edfb
**Branch:** main

## OVERVIEW
MindSort is a Flutter emotion-sorting puzzle game (water-sort mechanics, mindfulness wrapper) with RevenueCat-backed IAP, daily rewards, and achievement tracking.

## STRUCTURE
```text
./
├── lib/
│   ├── core/                # state, domain models, services
│   └── features/game/       # board + bottle UI widgets
├── test/                    # widget smoke tests
├── android/ ios/ macos/ linux/ windows/ web/   # platform shells
└── .github/workflows/       # CI matrix for platform builds
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| App composition and modal flows | `lib/main.dart` | Home screen, shop, daily rewards, settings modal |
| Puzzle move logic | `lib/core/providers/game_controller.dart` | Selection, pour, win, restart, next level |
| Level generation | `lib/core/services/level_generator.dart` | 120 generated levels, tiered difficulty |
| IAP + gems state | `lib/core/providers/iap_controller.dart` | Purchase, restore, spend/add gems |
| RevenueCat integration | `lib/core/services/revenuecat_service.dart` | Product IDs and Purchases SDK glue |
| Daily streak and reward cycle | `lib/core/providers/daily_challenge_controller.dart` | SharedPreferences-backed claim logic |
| Achievements | `lib/core/providers/achievement_controller.dart` | Unlock and persistence rules |
| Settings persistence | `lib/core/providers/settings_controller.dart` | Sound/haptics/theme toggles |
| Board widgets | `lib/features/game/widgets/` | Bottle painter + game controls/HUD |

## CODE MAP
| Symbol | Type | Location | Role |
|--------|------|----------|------|
| `MindSortApp` | widget | `lib/main.dart` | App root and theme wiring |
| `_GameScreenState` | stateful widget state | `lib/main.dart` | Session initialization + modal orchestration |
| `GameController` | state notifier | `lib/core/providers/game_controller.dart` | Core puzzle state machine |
| `IapController` | state notifier | `lib/core/providers/iap_controller.dart` | Currency and entitlements state |
| `RevenueCatService` | service | `lib/core/services/revenuecat_service.dart` | Purchases SDK wrapper |
| `DailyChallengeController` | state notifier | `lib/core/providers/daily_challenge_controller.dart` | Streak and daily reward cycle |
| `AchievementController` | state notifier | `lib/core/providers/achievement_controller.dart` | Achievement unlock tracking |
| `LevelGenerator` | service | `lib/core/services/level_generator.dart` | Difficulty-scaled puzzle generation |
| `EmotionBottle` | widget + custom painter | `lib/features/game/widgets/emotion_bottle.dart` | Bottle rendering and interaction visuals |

## CONVENTIONS
- State management: Riverpod `StateNotifier` + immutable `copyWith` value objects.
- Runtime config: RevenueCat API key passed through `--dart-define=REVENUECAT_API_KEY=...`.
- Persistence: SharedPreferences for settings, streaks, and achievements.
- CI: GitHub Actions matrix covers web/android/apple/linux/windows builds.

## ANTI-PATTERNS (THIS PROJECT)
- Do not hardcode API keys in source files.
- Do not bypass gem costs for action buttons outside weekly-pass rules.
- Do not add generated build artifacts under `build/` as source-of-truth documentation.

## UNIQUE STYLES
- Theme wrapper is mindfulness/emotion-centric while mechanics remain classic sort puzzle.
- Economy coupling in controls: `Undo=10`, `Hint=25`, `Add Bottle=50` gems unless weekly pass active.
- Daily reward and achievement updates occur from UI-triggered flows in `main.dart`.

## COMMANDS
```bash
flutter pub get
flutter run --dart-define=REVENUECAT_API_KEY=YOUR_KEY
flutter test
flutter build web
flutter build apk --release
flutter build ios --simulator --no-codesign
flutter build macos
```

## NOTES
- Linux builds require Linux host; Windows builds require Windows host.
- Purchases on web are effectively no-op in current service wrapper (`kIsWeb` guard).
