import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_panic/core/providers/achievement_controller.dart';
import 'package:order_panic/core/providers/daily_challenge_controller.dart';
import 'package:order_panic/core/providers/game_controller.dart';
import 'package:order_panic/core/providers/iap_controller.dart';
import 'package:order_panic/core/providers/settings_controller.dart';
import 'package:order_panic/core/services/revenuecat_service.dart';
import 'package:order_panic/features/game/widgets/game_board.dart';
import 'package:confetti/confetti.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const ProviderScope(child: MindSortApp()));
  FlutterNativeSplash.remove();
}

class MindSortApp extends ConsumerWidget {
  const MindSortApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    return MaterialApp(
      title: 'Order Panic: Food Frenzy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          brightness: settings.darkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late ConfettiController _confettiController;
  int _lastRecordedWinLevel = -1;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    Future.microtask(() {
      ref.read(gameControllerProvider.notifier).initializeGame();
      ref.read(iapControllerProvider.notifier).initialize();
      ref.read(dailyChallengeProvider.notifier).initialize();
      ref.read(achievementControllerProvider.notifier).initialize();
      ref.read(settingsControllerProvider.notifier).initialize();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initAdsAndTracking();
    });
  }

  Future<void> _initAdsAndTracking() async {
    if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) {
      try {
        final status =
            await AppTrackingTransparency.trackingAuthorizationStatus;
        if (status == TrackingStatus.notDetermined) {
          final newStatus =
              await AppTrackingTransparency.requestTrackingAuthorization();
          if (newStatus != TrackingStatus.authorized) {
            // Apply non-personalized ads configuration if not authorized
            await MobileAds.instance.updateRequestConfiguration(
              RequestConfiguration(
                tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
              ), // Or other NPA flags if needed
            );
          }
        } else if (status != TrackingStatus.authorized) {
          await MobileAds.instance.updateRequestConfiguration(
            RequestConfiguration(
              tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.unspecified,
            ),
          );
        }
      } on PlatformException catch (_) {
        // Fallback if ATT is unsupported or throws
      }
    }
    await MobileAds.instance.initialize();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);
    final iapState = ref.watch(iapControllerProvider);
    final dailyState = ref.watch(dailyChallengeProvider);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading your journey...'),
            ],
          ),
        ),
      );
    }

    if (state.isWon) {
      _confettiController.play();
      if (_lastRecordedWinLevel != state.gameState.levelId) {
        _lastRecordedWinLevel = state.gameState.levelId;
        ref.read(achievementControllerProvider.notifier).recordLevelComplete();
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD32F2F),
                  Color(0xFFE65100),
                  Color(0xFFFF8F00),
                ],
              ),
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        _buildHeader(context, state, iapState, dailyState),
                        const GameHUD(),
                        const GameBoard(),
                        const Spacer(), // Pushes controls to the bottom if there's extra space
                        const GameControls(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFE53935),
                Color(0xFFFDD835),
                Color(0xFF42A5F5),
                Color(0xFFEC407A),
                Color(0xFF66BB6A),
                Color(0xFFAB47BC),
              ],
            ),
          ),
          if (state.isWon) _buildWinOverlay(context, state),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    GameControllerState state,
    IapState iapState,
    DailyChallengeState dailyState,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Order Panic!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Level ${state.gameState.levelId}',
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 4,
            children: [
              _buildGemCounter(iapState),
              IconButton(
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                onPressed: () => _openShop(context),
              ),
              IconButton(
                icon: Icon(
                  dailyState.claimedToday ? Icons.event_available : Icons.event,
                  color: Colors.white,
                ),
                onPressed: () => _openDailyRewards(context),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () => _openSettings(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF37474F),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final settings = ref.watch(settingsControllerProvider);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Settings',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: settings.soundEnabled,
                    onChanged: (value) => ref
                        .read(settingsControllerProvider.notifier)
                        .setSoundEnabled(value),
                    title: const Text(
                      'Sound',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SwitchListTile(
                    value: settings.hapticsEnabled,
                    onChanged: (value) => ref
                        .read(settingsControllerProvider.notifier)
                        .setHapticsEnabled(value),
                    title: const Text(
                      'Haptics',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SwitchListTile(
                    value: settings.darkMode,
                    onChanged: (value) => ref
                        .read(settingsControllerProvider.notifier)
                        .setDarkMode(value),
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openDailyRewards(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF37474F),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final dailyState = ref.watch(dailyChallengeProvider);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Daily Rewards',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Streak: ${dailyState.streak} days',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: dailyState.claimedToday
                        ? null
                        : () async {
                            final reward = await ref
                                .read(dailyChallengeProvider.notifier)
                                .claimDailyReward();
                            ref
                                .read(iapControllerProvider.notifier)
                                .addGems(reward);
                            final streak = ref
                                .read(dailyChallengeProvider)
                                .streak;
                            await ref
                                .read(achievementControllerProvider.notifier)
                                .recordStreak(streak);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                    child: Text(
                      dailyState.claimedToday
                          ? 'Already Claimed Today'
                          : 'Claim Daily Reward',
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGemCounter(IapState iapState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.diamond, size: 16, color: Color(0xFF60A5FA)),
          const SizedBox(width: 4),
          Text(
            '${iapState.gems}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _openShop(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF37474F),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final iapState = ref.watch(iapControllerProvider);
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Shop',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 12),
                  _shopItem(
                    context,
                    title: '100 Gems',
                    price: _localizedPrice(iapState, RevenueCatService.gems100),
                    onTap: () async {
                      await ref
                          .read(iapControllerProvider.notifier)
                          .purchase(RevenueCatService.gems100);
                      await ref
                          .read(achievementControllerProvider.notifier)
                          .recordPurchase();
                    },
                  ),
                  _shopItem(
                    context,
                    title: '500 Gems',
                    price: _localizedPrice(iapState, RevenueCatService.gems500),
                    onTap: () async {
                      await ref
                          .read(iapControllerProvider.notifier)
                          .purchase(RevenueCatService.gems500);
                      await ref
                          .read(achievementControllerProvider.notifier)
                          .recordPurchase();
                    },
                  ),
                  _shopItem(
                    context,
                    title: '1500 Gems',
                    price: _localizedPrice(
                      iapState,
                      RevenueCatService.gems1500,
                    ),
                    onTap: () async {
                      await ref
                          .read(iapControllerProvider.notifier)
                          .purchase(RevenueCatService.gems1500);
                      await ref
                          .read(achievementControllerProvider.notifier)
                          .recordPurchase();
                    },
                  ),
                  _shopItem(
                    context,
                    title: 'Weekly Pass',
                    price: _localizedPrice(
                      iapState,
                      RevenueCatService.weeklyPass,
                    ),
                    onTap: () async {
                      await ref
                          .read(iapControllerProvider.notifier)
                          .purchase(RevenueCatService.weeklyPass);
                      await ref
                          .read(achievementControllerProvider.notifier)
                          .recordPurchase();
                    },
                  ),
                  _shopItem(
                    context,
                    title: 'Remove Ads',
                    price: _localizedPrice(
                      iapState,
                      RevenueCatService.removeAds,
                    ),
                    onTap: () async {
                      await ref
                          .read(iapControllerProvider.notifier)
                          .purchase(RevenueCatService.removeAds);
                      await ref
                          .read(achievementControllerProvider.notifier)
                          .recordPurchase();
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () =>
                        ref.read(iapControllerProvider.notifier).restore(),
                    child: const Text('Restore Purchases'),
                  ),
                  if (iapState.loading) const CircularProgressIndicator(),
                  if (iapState.error != null)
                    Text(
                      iapState.error!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _localizedPrice(IapState iapState, String productId) {
    final availablePackages = iapState.offerings?.current?.availablePackages;
    if (availablePackages == null) {
      return '...';
    }
    for (final package in availablePackages) {
      if (package.storeProduct.identifier == productId) {
        return package.storeProduct.priceString;
      }
    }
    return '...';
  }

  Widget _shopItem(
    BuildContext context, {
    required String title,
    required String price,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        tileColor: Colors.white10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: FilledButton(onPressed: onTap, child: Text(price)),
      ),
    );
  }

  Widget _buildWinOverlay(BuildContext context, GameControllerState state) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.celebration, size: 64, color: Color(0xFFE53935)),
              const SizedBox(height: 16),
              const Text(
                'Harmony Restored!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Level ${state.gameState.levelId} Complete',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Moves: ${state.gameState.moves}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).restartLevel();
                    },
                    child: const Text('Replay'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(gameControllerProvider.notifier).nextLevel();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE53935),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Next Level'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
