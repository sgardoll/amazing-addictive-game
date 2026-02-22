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
