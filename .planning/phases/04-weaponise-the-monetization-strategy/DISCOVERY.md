# Discovery: Weaponise the Monetization Strategy

## Research Goal
Integrate `google_mobile_ads` for forcing interstitial video ads on game over.

## Ecosystem Options
- **google_mobile_ads**: Official package by Google, provides robust support for AdMob (Banners, Interstitials, Rewarded).

## Selected Stack
- **Library**: `google_mobile_ads: ^5.0.0`
- **Native Config**:
  - **Android**: Requires `com.google.android.gms.ads.APPLICATION_ID` inside `<application>` in `AndroidManifest.xml`.
  - **iOS**: Requires `GADApplicationIdentifier` in `Info.plist`.
  - **Note**: Use Test App IDs during development to avoid policy violations.
    - Android Test App ID: `ca-app-pub-3940256099942544~3347511713`
    - iOS Test App ID: `ca-app-pub-3940256099942544~1458002511`
  - **Interstitial Ad Unit IDs**:
    - Android: `ca-app-pub-3940256099942544/1033173712`
    - iOS: `ca-app-pub-3940256099942544/4411468910`

## Architecture Patterns
- **Service Locator**: Abstract the SDK into an `AdService` (or `AdController` riverpod provider) that initializes the SDK and manages loading/showing ads.
- **Preloading**: Preload the interstitial ad so it is ready immediately when the player loses (cornered by the timer).
- **Callback Handling**: Use `FullScreenContentCallback` to detect when the user closes the ad, so the game loop can be reset seamlessly.

## Anti-Patterns & Pitfalls
- **Showing without loading**: `InterstitialAd.show()` fails if the ad isn't loaded yet. Always check if the reference is non-null.
- **State Blocking**: Don't let the ad presentation block the Riverpod state transition. Show the ad, and execute state changes via callbacks.
- **Forgetting Initialization**: `MobileAds.instance.initialize()` must be called before loading ads (usually in `main.dart`).