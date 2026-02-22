# PROVIDERS KNOWLEDGE BASE

## OVERVIEW
State transitions live here; this directory is the source of truth for runtime behavior.

## STRUCTURE
```text
providers/
├── game_controller.dart
├── iap_controller.dart
├── daily_challenge_controller.dart
├── achievement_controller.dart
└── settings_controller.dart
```

## WHERE TO LOOK
| Concern | File | Notes |
|--------|------|-------|
| Puzzle rules + move pipeline | `game_controller.dart` | Select/pour, undo, add bottle, hint, win state |
| Purchases + gems | `iap_controller.dart` | RevenueCat calls, gem wallet, entitlement flags |
| Daily cycle | `daily_challenge_controller.dart` | 7-day reward loop, streak rollover |
| Achievements | `achievement_controller.dart` | Unlock tracking by level/purchase/streak |
| Settings | `settings_controller.dart` | Sound, haptics, theme persistence |

## CONVENTIONS
- Use `StateNotifier` + immutable state objects with `copyWith`.
- Persist only durable state (streaks/settings/achievement counters).
- Keep provider methods deterministic and side-effect scoped.

## ANTI-PATTERNS
- Avoid direct UI dependencies in providers.
- Avoid silent failures on purchase/reward flows; propagate errors into state.
- Avoid writing to SharedPreferences from widgets.

## QUICK CHECKS
- After provider edits, verify affected screens still render (`flutter test`).
- Keep reward/cost constants synchronized with product rules in UI controls.
- Confirm restore-purchase and daily-claim flows remain idempotent.

## NOTES
- Purchase entitlements are evaluated through `RevenueCatService` product IDs.
- Daily and achievement providers use local persistence only (SharedPreferences).
