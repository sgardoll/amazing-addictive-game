import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static String get _apiKey {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return const String.fromEnvironment('REVENUECAT_GOOGLE_API_KEY');
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return const String.fromEnvironment('REVENUECAT_APPLE_API_KEY');
    }
    return '';
  }

  static const String gems100 = 'gems_100';
  static const String gems500 = 'gems_500';
  static const String gems1500 = 'gems_1500';
  static const String weeklyPass = 'weekly_pass';
  static const String removeAds = 'remove_ads';

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized || kIsWeb) {
      return;
    }
    if (_apiKey.isEmpty) {
      return;
    }
    final configuration = PurchasesConfiguration(_apiKey);
    await Purchases.configure(configuration);
    _initialized = true;
  }

  Future<Offerings?> getOfferings() async {
    if (!_initialized) {
      return null;
    }
    return Purchases.getOfferings();
  }

  Future<CustomerInfo?> purchaseByProductId(String productId) async {
    if (!_initialized) {
      return null;
    }
    final offerings = await Purchases.getOfferings();
    final current = offerings.current;
    if (current == null) {
      return null;
    }
    for (final package in current.availablePackages) {
      if (package.storeProduct.identifier == productId) {
        final result = await Purchases.purchasePackage(package);
        return result;
      }
    }
    return null;
  }

  Future<CustomerInfo?> restorePurchases() async {
    if (!_initialized) {
      return null;
    }
    return Purchases.restorePurchases();
  }

  Future<CustomerInfo?> customerInfo() async {
    if (!_initialized) {
      return null;
    }
    return Purchases.getCustomerInfo();
  }
}
