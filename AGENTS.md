# PROJECT KNOWLEDGE BASE

**Generated:** 2026-02-24 05:39:00 AEDT
**Commit:** bdd50b3
**Branch:** main

## OVERVIEW
Mindsweeper (formerly MindSort) is a Flutter cross-platform puzzle game combining water-sort mechanics with mindfulness features, backed by RevenueCat for IAP and in-app economies.

## STRUCTURE
```text
./
├── lib/
│   ├── core/                # State, domain models, external services (RC)
│   └── features/game/       # Playable board and UI widgets
├── scripts/revenuecat/      # CLI automation for IAP configuration
├── android/ ios/ macos/     # Native shells
└── .github/workflows/       # CI build matrices
```

## WHERE TO LOOK
| Task | Location | Notes |
|------|----------|-------|
| App composition and flow | `lib/main.dart` | Theme, shop modal, daily rewards overlay |
| Game mechanics | `lib/core/providers/game_controller.dart` | Selection, pouring, win state logic |
| In-app economy | `lib/core/providers/iap_controller.dart` | RevenueCat logic, local gem wallet tracking |
| RevenueCat integration | `lib/core/services/revenuecat_service.dart` | Underlying Purchases SDK wrapper |
| RC CLI automation | `scripts/revenuecat/setup_revenuecat_cli.sh` | Idempotent project/product generation |

## CONVENTIONS
- Architecture: Riverpod for state management, separated into providers and value objects.
- Store Configuration: Uses `com.connectio.mindsweeper` identifier.
- Store Pricing: Fetched at runtime via RC's `offerings.current.availablePackages[].storeProduct.priceString` (no hardcoded pricing).

## ANTI-PATTERNS (THIS PROJECT)
- Do not bypass gem costs unless `hasWeeklyPass` is verified true.
- Do not commit hardcoded API keys. Pass RevenueCat key via `--dart-define=REVENUECAT_API_KEY=xxx` or environment variables in CI/scripts.
- Avoid updating platform identifiers piecemeal; ensure `com.connectio.mindsweeper` matches across build.gradle, Info.plist, and CMake.

## COMMANDS
```bash
flutter test
flutter build ios --simulator --no-codesign --dart-define=REVENUECAT_API_KEY=YOUR_KEY
bash scripts/revenuecat/setup_revenuecat_cli.sh scripts/revenuecat/revenuecat.config.json
```
