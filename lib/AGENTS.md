# LIB KNOWLEDGE BASE

## OVERVIEW
`lib/` contains all game logic and UI; platform folders should not hold gameplay state.

## STRUCTURE
```text
lib/
├── core/
│   ├── models/
│   ├── providers/
│   └── services/
└── features/game/widgets/
```

## WHERE TO LOOK
| Intent | File/Dir | Notes |
|--------|----------|-------|
| Boot + modal wiring | `main.dart` | Shop, settings, daily rewards, win overlay |
| Domain entities | `core/models/` | Bottle, level, emotion |
| Mutable app/game state | `core/providers/` | Primary state transitions |
| External integrations | `core/services/` | RevenueCat + level generation |
| Playable UI | `features/game/widgets/` | Board, bottle painter, controls |

## CONVENTIONS
- Keep puzzle rules in providers/services, not widget classes.
- Keep provider APIs small and explicit (`initialize`, `purchase`, `claim`, `record`).
- Add new economy actions through `IapController` gem spend/add paths.

## ANTI-PATTERNS
- Do not place business logic inside `build()` methods.
- Do not introduce parallel state containers for the same concern.
- Do not add platform-channel logic under `lib/features/`.
