import 'package:expense_tracker/src/features/core/models/premium_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:expense_tracker/src/repository/paywall_repository/paywall_repository.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallController extends GetxController {
  static PaywallController get instance => Get.find();

  final PaywallRepository _paywallRepository = Get.find<PaywallRepository>();

  // Observable variables
  var isLoading = false.obs;
  var isPurchasing = false.obs;
  var premiumStatus = Rx<PremiumStatus?>(null);
  var selectedPackageId = ''.obs;
  var errorMessage = ''.obs;

  // RevenueCat variables
  var revenueCatOfferings = Rx<Offerings?>(null);
  var revenueCatCustomerInfo = Rx<CustomerInfo?>(null);

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // Load initial pricing and premium status
  Future<void> loadInitialData() async {
    isLoading(true);
    try {
      await Future.wait([
        loadPremiumStatus(),
        loadRevenueCatData(),
      ]);
      
      // Set default selected package after loading RevenueCat data
      _setDefaultSelectedPackage();
    } catch (e) {
      print('Error loading initial data: $e');
    } finally {
      isLoading(false);
    }
  }

  // Load RevenueCat offerings and customer info
  Future<void> loadRevenueCatData() async {
    try {
      // Load offerings
      final offerings = await Purchases.getOfferings();
      revenueCatOfferings.value = offerings;
      
      print('RevenueCat offerings loaded:');
      print('- Current offering ID: ${offerings.current?.identifier ?? "None"}');
      print('- Available packages: ${offerings.current?.availablePackages.length ?? 0}');
      
      if (offerings.current?.availablePackages.isNotEmpty == true) {
        for (final package in offerings.current!.availablePackages) {
          print('- Package: ${package.identifier} (${package.packageType.name}) - ${package.storeProduct.priceString}');
        }
      }
      
      // Check if offerings are empty
      if (offerings.current?.availablePackages.isEmpty == true) {
        print('Warning: No products available from RevenueCat. Check your configuration.');
        print('This could mean:');
        print('1. Products not configured in RevenueCat dashboard');
        print('2. Products not available in App Store Connect');
        print('3. Product IDs mismatch between RevenueCat and App Store');
        print('4. Products not approved/available in current App Store environment');
        errorMessage.value = 'Products are currently unavailable. Please check your internet connection or try again later.';
      } else {
        errorMessage.value = ''; // Clear any previous error
      }

      // Load customer info
      final customerInfo = await Purchases.getCustomerInfo();
      revenueCatCustomerInfo.value = customerInfo;
      print('Customer info loaded - Active entitlements: ${customerInfo.entitlements.active.length}');

      print('RevenueCat data loaded successfully');
    } on PlatformException catch (e) {
      String errorMsg = 'Unable to load subscription options.';
      
      print('RevenueCat PlatformException:');
      print('- Code: ${e.code}');
      print('- Message: ${e.message}');
      print('- Details: ${e.details}');
      
      if (e.code == PurchasesErrorCode.configurationError.name) {
        errorMsg = 'Subscription service is currently unavailable. Please try again later.';
        print('This is a configuration error - check:');
        print('1. RevenueCat API key is correct');
        print('2. Products are configured in RevenueCat dashboard');
        print('3. Products exist in App Store Connect');
        print('4. Bundle ID matches between app and RevenueCat');
      } else if (e.code == PurchasesErrorCode.networkError.name) {
        errorMsg = 'Network error. Please check your internet connection.';
      } else if (e.code == PurchasesErrorCode.unknownError.name) {
        errorMsg = 'Service temporarily unavailable. Please try again later.';
      }
      
      errorMessage.value = errorMsg;
    } catch (e) {
      errorMessage.value = 'Unable to load subscription options. Please try again later.';
      print('Unexpected error loading RevenueCat data: $e');
    }
  }

  // Set default selected package from RevenueCat offerings
  void _setDefaultSelectedPackage() {
    final offerings = revenueCatOfferings.value;
    if (offerings?.current?.availablePackages.isNotEmpty == true) {
      // Prefer annual package, fallback to first available
      final annualPackage = offerings!.current!.availablePackages
          .firstWhereOrNull((p) => p.packageType == PackageType.annual);
      
      if (annualPackage != null) {
        selectedPackageId.value = annualPackage.identifier;
      } else {
        selectedPackageId.value = offerings.current!.availablePackages.first.identifier;
      }
    } else {
      // Clear selected package if no offerings available
      selectedPackageId.value = '';
      print('No packages available to select as default');
    }
  }

  // Load user's current premium status
  Future<void> loadPremiumStatus() async {
    try {
      final result = await _paywallRepository.getPremiumStatus();

      if (result['status'] == true && result['data'] != null) {
        premiumStatus.value = PremiumStatus.fromJson(result['data']);
      } else {
        print('Failed to load premium status: ${result['message']}');
      }
    } catch (e) {
      print('Error in loadPremiumStatus: $e');
    }
  }

  // Select a package
  void selectPackage(String packageId) {
    selectedPackageId.value = packageId;
  }

  // Get the currently selected RevenueCat package
  Package? get selectedPackage {
    if (revenueCatOfferings.value?.current == null) return null;

    return revenueCatOfferings.value!.current!.availablePackages
        .firstWhereOrNull((package) => package.identifier == selectedPackageId.value);
  }

  // Get all available packages from RevenueCat
  List<Package> get availablePackages {
    return revenueCatOfferings.value?.current?.availablePackages ?? [];
  }

  // Get formatted price for a package
  String getFormattedPrice(Package package) {
    return package.storeProduct.priceString;
  }

  // Get package title (Monthly, Annual, etc.)
  String getPackageTitle(Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return 'Monthly';
      case PackageType.annual:
        return 'Annual';
      case PackageType.weekly:
        return 'Weekly';
      case PackageType.lifetime:
        return 'Lifetime';
      default:
        return package.identifier.capitalize ?? 'Premium';
    }
  }

  // Get billing period for a package
  String getBillingPeriod(Package package) {
    switch (package.packageType) {
      case PackageType.monthly:
        return 'month';
      case PackageType.annual:
        return 'year';
      case PackageType.weekly:
        return 'week';
      case PackageType.lifetime:
        return 'lifetime';
      default:
        return 'period';
    }
  }

  // Check if package is annual (for showing savings)
  bool isAnnualPackage(Package package) {
    return package.packageType == PackageType.annual;
  }

  // Start free trial using RevenueCat
  Future<bool> startFreeTrial() async {
    isPurchasing(true);
    errorMessage.value = '';

    try {
      // Check if RevenueCat offerings are available
      if (revenueCatOfferings.value?.current?.availablePackages.isEmpty == true) {
        throw Exception('Subscription service is currently unavailable. Please try again later.');
      }

      final package = selectedPackage;
      if (package == null) {
        throw Exception('No subscription package selected or available');
      }

      // Purchase through RevenueCat
      final purchaserInfo = await Purchases.purchasePackage(package);

      // Check if purchase was successful
      if (purchaserInfo.customerInfo.entitlements.active.isNotEmpty) {
        // Refresh premium status from backend
        await syncSubscriptionStatus();

        Get.snackbar(
          'Welcome to Premium!',
          'Your subscription is now active. Enjoy unlimited features!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );

        return true;
      } else {
        throw Exception('Purchase completed but no active entitlements found');
      }
    } on PlatformException catch (e) {
      String errorMessage = 'Purchase failed. Please try again.';

      if (e.code == PurchasesErrorCode.purchaseCancelledError.name) {
        errorMessage = 'Purchase was cancelled';
      } else if (e.code == PurchasesErrorCode.paymentPendingError.name) {
        errorMessage = 'Payment is pending approval';
      } else if (e.code == PurchasesErrorCode.purchaseNotAllowedError.name) {
        errorMessage = 'Purchases are not allowed on this device';
      } else if (e.code == PurchasesErrorCode.purchaseInvalidError.name) {
        errorMessage = 'Purchase is invalid';
      } else if (e.code == PurchasesErrorCode.productNotAvailableForPurchaseError.name) {
        errorMessage = 'Product is not available for purchase';
      } else if (e.code == PurchasesErrorCode.networkError.name) {
        errorMessage = 'Network error. Please check your connection.';
      }

      this.errorMessage.value = errorMessage;

      // Only show error snackbar for non-cancellation errors
      if (e.code != PurchasesErrorCode.purchaseCancelledError.name) {
        Get.snackbar(
          'Purchase Failed',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      }

      return false;
    } catch (e) {
      errorMessage.value = 'Unable to complete purchase. Please try again.';

      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      return false;
    } finally {
      isPurchasing(false);
    }
  }

  // Purchase selected package using RevenueCat
  Future<bool> purchaseSelectedPackage() async {
    if (selectedPackage == null) {
      Get.snackbar('Error', 'Please select a package first');
      return false;
    }

    return await startFreeTrial(); // Same logic for now
  }

  // Sync subscription status with RevenueCat and backend
  Future<void> syncSubscriptionStatus() async {
    try {
      // Get latest customer info from RevenueCat
      final customerInfo = await Purchases.getCustomerInfo();
      revenueCatCustomerInfo.value = customerInfo;

      // Sync with backend
      final result = await _paywallRepository.syncSubscriptionStatus();

      if (result['status'] == true) {
        await loadPremiumStatus();
        print('Subscription status synced successfully');
      } else {
        print('Failed to sync subscription status with backend: ${result['message']}');
      }
    } catch (e) {
      print('Error syncing subscription status: $e');
    }
  }

  // Restore purchases
  Future<bool> restorePurchases() async {
    try {
      isPurchasing(true);

      final customerInfo = await Purchases.restorePurchases();
      revenueCatCustomerInfo.value = customerInfo;

      // Sync with backend
      await syncSubscriptionStatus();

      if (customerInfo.entitlements.active.isNotEmpty) {
        Get.snackbar(
          'Purchases Restored',
          'Your premium subscription has been restored!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return true;
      } else {
        Get.snackbar(
          'No Purchases Found',
          'No active subscriptions found to restore.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Restore Failed',
        'Failed to restore purchases. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      return false;
    } finally {
      isPurchasing(false);
    }
  }

  // Check if user has access to a specific feature
  Future<bool> checkFeatureAccess(String feature) async {
    try {
      // Check RevenueCat entitlements first
      final customerInfo = revenueCatCustomerInfo.value;
      if (customerInfo != null && customerInfo.entitlements.active.isNotEmpty) {
        return true; // Has active subscription
      }

      // Fallback to backend check
      final result = await _paywallRepository.checkFeatureAccess(feature);

      if (result['status'] == true && result['data'] != null) {
        return result['data']['has_access'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking feature access: $e');
      return false;
    }
  }

  // Get management URL for subscription
  Future<String?> getManagementUrl() async {
    try {
      final result = await _paywallRepository.getManagementUrl();

      if (result['status'] == true && result['data'] != null) {
        return result['data']['management_url'];
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting management URL: $e');
      return null;
    }
  }

  // Get custom paywall message based on context
  String getCustomMessage(String? source, Map<String, dynamic>? scanData) {
    if (source == 'receipt_scan') {
      final remainingScans = scanData?['remaining_scans'] ?? 0;
      if (remainingScans <= 0) {
        return "You've used all your free receipt scans this month. Upgrade to Premium for unlimited scanning and advanced features!";
      } else {
        return "You have $remainingScans scans remaining. Upgrade to Premium for unlimited scanning and never worry about limits again!";
      }
    }
    return "You've reached your free scan limit. Upgrade to Premium for unlimited scanning and advanced features!";
  }

  // Calculate and get savings text for annual packages
  String? getSavingsText(Package annualPackage) {
    if (!isAnnualPackage(annualPackage)) return null;
    
    final monthlyPackage = availablePackages
        .firstWhereOrNull((p) => p.packageType == PackageType.monthly);
    
    if (monthlyPackage == null) return null;
    
    final annualPrice = annualPackage.storeProduct.price;
    final monthlyPrice = monthlyPackage.storeProduct.price * 12;
    final savings = monthlyPrice - annualPrice;
    final savingsPercent = ((savings / monthlyPrice) * 100).round();
    
    if (savingsPercent > 0) {
      return 'Save $savingsPercent%';
    }
    return null;
  }

  // Check if user is currently premium (RevenueCat + backend)
  bool get isPremium {
    // Check RevenueCat first
    final customerInfo = revenueCatCustomerInfo.value;
    if (customerInfo != null && customerInfo.entitlements.active.isNotEmpty) {
      return true;
    }

    // Fallback to backend status
    return premiumStatus.value?.isPremium ?? false;
  }

  // Check if user is on trial
  bool get isOnTrial => premiumStatus.value?.trialActive ?? false;

  // Get remaining free scans
  int get remainingFreeScans => premiumStatus.value?.freeScansRemaining ?? 0;

  // Check if user can scan receipts
  bool get canScanReceipts => isPremium || isOnTrial || remainingFreeScans > 0;

  // Refresh all data
  @override
  Future<void> refresh() async {
    await loadInitialData();
  }
}