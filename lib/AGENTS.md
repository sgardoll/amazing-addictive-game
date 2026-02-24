# LIB KNOWLEDGE BASE

## OVERVIEW
`lib/` contains all game logic and UI. No platform-specific native channels should be added here unless wrapped in a service.

## STRUCTURE
```text
lib/
├── core/
│   ├── models/           # Domain entities (Bottle, Level, Emotion)
│   ├── providers/        # State transitions (Game, IAP, Daily, Settings)
│   └── services/         # External integrations (RevenueCat, LevelGenerator)
└── features/game/widgets/# Playable UI (Board, Bottle, Controls)
```

## WHERE TO LOOK
| Intent | File/Dir | Notes |
|--------|----------|-------|
| Boot + Modals | `main.dart` | Shop, settings, daily rewards, localized pricing |
| Game State | `core/providers/game_controller.dart` | Puzzle mechanics |
| Purchase State| `core/providers/iap_controller.dart` | RevenueCat proxy |

## CONVENTIONS
- Keep provider APIs small and explicit (`initialize`, `purchase`, `spendGems`).
- Add economy actions exclusively through `IapController` paths.

## ANTI-PATTERNS
- Do not place business logic inside `build()` methods.
- Do not introduce parallel state containers for the same concern.
- Do not hardcode currency symbols; use `storeProduct.priceString` via `IapState`.
