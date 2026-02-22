# GAME WIDGETS KNOWLEDGE BASE

## OVERVIEW
This directory contains visual gameplay composition and user interaction controls.

## STRUCTURE
```text
widgets/
├── emotion_bottle.dart
└── game_board.dart
```

## WHERE TO LOOK
| Task | File | Notes |
|------|------|-------|
| Bottle visuals and painter | `emotion_bottle.dart` | Layer rendering, selected/complete effects |
| Board + HUD + controls | `game_board.dart` | Tap routing, control costs, feedback hooks |

## CONVENTIONS
- Widgets call providers for state mutation; no local game state duplication.
- Keep control costs aligned to economy constants (`10/25/50`) unless design explicitly changes.
- Preserve responsive layout using `Wrap` for variable bottle counts.

## ANTI-PATTERNS
- Do not hardcode gem grants/costs in multiple widget locations.
- Do not bypass settings toggles for haptic/sound feedback.
- Do not move move-validation rules out of providers.

## QUICK CHECKS
- Bottle taps should route through `GameController.onBottleTap` only.
- Control buttons must enforce costs: undo(10), hint(25), add bottle(50), pass bypass.
- Haptic and click feedback must honor `SettingsController` toggles.

## NOTES
- Keep painter-heavy visuals in `emotion_bottle.dart`; keep orchestration in `game_board.dart`.
- Prefer `Wrap`/responsive placement over fixed bottle grid assumptions.
