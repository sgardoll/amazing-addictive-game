import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:order_panic/core/services/revenuecat_service.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IapState {
  const IapState({
    this.gems = 0,
    this.hasWeeklyPass = false,
    this.hasRemoveAds = false,
    this.loading = false,
    this.error,
    this.offerings,
  });

  final int gems;
  final bool hasWeeklyPass;
  final bool hasRemoveAds;
  final bool loading;
  final String? error;
  final Offerings? offerings;

  IapState copyWith({
    int? gems,
    bool? hasWeeklyPass,
    bool? hasRemoveAds,
    bool? loading,
    String? error,
    Offerings? offerings,
  }) {
    return IapState(
      gems: gems ?? this.gems,
      hasWeeklyPass: hasWeeklyPass ?? this.hasWeeklyPass,
      hasRemoveAds: hasRemoveAds ?? this.hasRemoveAds,
      loading: loading ?? this.loading,
      error: error,
      offerings: offerings ?? this.offerings,
    );
  }
}

class IapController extends StateNotifier<IapState> {
  IapController(this._service) : super(const IapState());

  final RevenueCatService _service;

  Future<void> initialize() async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _service.initialize();
      final offerings = await _service.getOfferings();
      final info = await _service.customerInfo();
      state = state.copyWith(
        offerings: offerings,
        hasWeeklyPass:
            info?.entitlements.active.containsKey(
              RevenueCatService.weeklyPass,
            ) ??
            false,
        hasRemoveAds:
            info?.entitlements.active.containsKey(
              RevenueCatService.removeAds,
            ) ??
            false,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> purchase(String productId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final info = await _service.purchaseByProductId(productId);
      var gems = state.gems;
      if (productId == RevenueCatService.gems100) gems += 100;
      if (productId == RevenueCatService.gems500) gems += 500;
      if (productId == RevenueCatService.gems1500) gems += 1500;
      state = state.copyWith(
        gems: gems,
        hasWeeklyPass:
            info?.entitlements.active.containsKey(
              RevenueCatService.weeklyPass,
            ) ??
            state.hasWeeklyPass,
        hasRemoveAds:
            info?.entitlements.active.containsKey(
              RevenueCatService.removeAds,
            ) ??
            state.hasRemoveAds,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> restore() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final info = await _service.restorePurchases();
      state = state.copyWith(
        hasWeeklyPass:
            info?.entitlements.active.containsKey(
              RevenueCatService.weeklyPass,
            ) ??
            state.hasWeeklyPass,
        hasRemoveAds:
            info?.entitlements.active.containsKey(
              RevenueCatService.removeAds,
            ) ??
            state.hasRemoveAds,
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  bool spendGems(int amount) {
    if (state.gems < amount) {
      return false;
    }
    state = state.copyWith(gems: state.gems - amount);
    return true;
  }

  void addGems(int amount) {
    if (amount <= 0) {
      return;
    }
    state = state.copyWith(gems: state.gems + amount);
  }
}

final iapServiceProvider = Provider<RevenueCatService>(
  (ref) => RevenueCatService(),
);

final iapControllerProvider = StateNotifierProvider<IapController, IapState>(
  (ref) => IapController(ref.read(iapServiceProvider)),
);
