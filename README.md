# MindSort

Emotion-sorting puzzle game built with Flutter.

## Run

```bash
flutter pub get
flutter run --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
```

## Build

```bash
flutter build apk --release --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
flutter build ios --simulator --no-codesign --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
flutter build web --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
flutter build macos --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
flutter build linux --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
flutter build windows --dart-define=REVENUECAT_API_KEY=YOUR_REVENUECAT_KEY
```

## RevenueCat Product IDs

- gems_100
- gems_500
- gems_1500
- weekly_pass
- remove_ads

## RevenueCat CLI Setup

Use the script in `scripts/revenuecat/setup_revenuecat_cli.sh` to create/update the full RevenueCat project config (project, apps, products, entitlements, offering, packages) from JSON.

1. Copy and edit the config template:

```bash
cp scripts/revenuecat/revenuecat.config.json scripts/revenuecat/revenuecat.local.json
```

2. Set your RevenueCat v2 secret API key:

```bash
export RC_V2_API_KEY="rc_v2_xxx"
```

3. Run setup:

```bash
bash scripts/revenuecat/setup_revenuecat_cli.sh scripts/revenuecat/revenuecat.local.json
```

Notes:
- The script is idempotent for project/apps/products/entitlements/offerings/packages by lookup key/name checks.
- Product attachments to entitlements/packages are re-applied from config.
- Keep API keys out of source control.
