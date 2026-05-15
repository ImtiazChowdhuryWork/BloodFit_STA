import 'dart:async';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

/// [IAPService] is a global singleton (GetxService) that manages all
/// In-App Purchase (IAP) communication with the App Store (iOS) and
/// Play Store (Android) using Flutter's `in_app_purchase` plugin.
///
/// --- WHY THIS EXISTS ---
/// Previously, RevenueCat was used to handle subscription purchases.
/// IAPService is the custom replacement that talks directly to the store.
/// It replaces RevenueCat for: fetching product prices, initiating purchases,
/// handling purchase callbacks, and restoring past purchases.
///
/// --- HOW IT FITS INTO THE SUBSCRIPTION FLOW ---
/// 1. Registered globally in [ControllerBindings] on app launch so products
///    start loading before the user even opens the subscription screen.
/// 2. [SubscriptionPlansScreenController] reads prices from this service
///    to show real store prices on the subscription plan cards.
/// 3. [PlanSummeryDetailsScreen] calls [buyProduct] when the user taps "Pay Now".
///
/// --- PRODUCT ID NAMING CONVENTION ---
/// All product IDs follow this pattern:
///   com.bloodfitltd.bloodfit.{plan-slug}.{duration}
/// Example: com.bloodfitltd.bloodfit.pro.monthly
/// The {plan-slug} matches the `slug` field returned by the backend API.
class IAPService extends GetxService {
  final InAppPurchase _iap = InAppPurchase.instance;

  /// Active stream subscription to the store's purchase update events.
  /// Cancelled in [onClose] to prevent memory leaks.
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  /// All store product IDs registered in App Store Connect / Google Play Console.
  /// These must match exactly what is configured in the store dashboards.
  static const Set<String> productIds = {
    'com.bloodfitltd.bloodfit.starter.monthly',
    'com.bloodfitltd.bloodfit.pro.monthly',
    'com.bloodfitltd.bloodfit.elite.monthly',
    'com.bloodfitltd.bloodfit.starter.yearly',
    'com.bloodfitltd.bloodfit.pro.yearly',
    'com.bloodfitltd.bloodfit.elite.yearly',
  };

  /// Store products fetched from App Store / Play Store.
  /// Populated after [_loadProducts] completes. Used to get real prices.
  RxList<ProductDetails> products = <ProductDetails>[].obs;

  /// Whether the store is reachable on this device.
  RxBool isAvailable = false.obs;

  /// True while products are being fetched from the store.
  RxBool isLoading = true.obs;

  /// True while a purchase is in progress (native payment sheet is shown
  /// or waiting for the store's purchase callback).
  /// UI listens to this to show a loading indicator on the "Pay Now" button.
  RxBool isPurchasing = false.obs;

  /// Holds the latest error message, if any.
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  @override
  void onClose() {
    _purchaseSubscription?.cancel();
    super.onClose();
  }

  /// Initialises the IAP connection in 3 steps:
  /// 1. Check if the store is available on this device.
  /// 2. Subscribe to the purchase stream to receive real-time purchase updates.
  /// 3. Load product details (prices) from the store.
  /// 4. Silently restore any past purchases the user already owns.
  Future<void> _initialize() async {
    final available = await _iap.isAvailable();
    isAvailable.value = available;

    if (!available) {
      error.value = 'In-app purchases not available';
      isLoading.value = false;
      return;
    }

    // The purchase stream delivers events for every status change:
    // pending → purchased/restored/error. Must be set up before any purchase.
    _purchaseSubscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _purchaseSubscription?.cancel(),
      onError: (e) => error.value = e.toString(),
    );

    await _loadProducts();
    await restorePurchases();
  }

  /// Fetches product details (title, description, price) from the store
  /// for all products listed in [productIds].
  /// On success, populates [products] which is used to display real prices.
  Future<void> _loadProducts() async {
    isLoading.value = true;
    error.value = '';

    try {
      final response = await _iap.queryProductDetails(productIds);
      if (response.error != null) {
        error.value = response.error!.message;
      } else {
        products.value = response.productDetails;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Silently restores any subscriptions the user has already purchased.
  /// This triggers [_onPurchaseUpdate] with status [PurchaseStatus.restored]
  /// for each previously purchased product.
  Future<void> restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (_) {}
  }

  /// Initiates a purchase for the given [productId].
  ///
  /// Called from [PlanSummeryDetailsScreen] when the user taps "Pay Now".
  /// The [productId] is passed from [SubscriptionScreen] via navigation arguments.
  ///
  /// Subscriptions are purchased as non-consumables because they are
  /// one-time-per-user items managed by the store (not consumed on use).
  Future<void> buyProduct(String productId) async {
    if (productId.isEmpty) return;

    // Ensure the product was successfully loaded from the store first.
    final product = products.firstWhereOrNull((p) => p.id == productId);
    if (product == null) {
      Get.snackbar('Error', 'Product not available. Please try again later.');
      return;
    }

    isPurchasing.value = true;
    try {
      final param = PurchaseParam(productDetails: product);
      // This shows the native store payment sheet (App Store / Play Store).
      // The result arrives asynchronously via [_onPurchaseUpdate].
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Purchase Failed', e.toString());
      isPurchasing.value = false;
    }
  }

  /// Handles all purchase status updates delivered by the store's purchase stream.
  ///
  /// Every purchase goes through these states:
  /// - [PurchaseStatus.pending]   → payment is being processed by the store.
  /// - [PurchaseStatus.purchased] → payment succeeded, grant access.
  /// - [PurchaseStatus.restored]  → past purchase restored, grant access.
  /// - [PurchaseStatus.error]     → payment failed, show error.
  ///
  /// [pendingCompletePurchase] must be acknowledged with [completePurchase]
  /// to inform the store that the app has delivered the product.
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.pending) {
        Get.snackbar('Purchase Pending', 'Your purchase is being processed...');
      } else {
        if (purchase.status == PurchaseStatus.error) {
          Get.snackbar(
            'Purchase Failed',
            purchase.error?.message ?? 'Something went wrong.',
          );
          isPurchasing.value = false;
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          _verifyAndDeliverProduct(purchase);
        }

        // Always acknowledge completed purchases to avoid the store
        // refunding or re-prompting the user.
        if (purchase.pendingCompletePurchase) {
          _iap.completePurchase(purchase);
        }
      }
    }
  }

  /// Called when a purchase is confirmed by the store.
  ///
  /// ⚠️ TODO: Before granting access, send the purchase receipt to your
  /// backend server for server-side verification. Only unlock premium features
  /// after the server confirms the receipt is valid.
  /// See: https://developer.apple.com/documentation/storekit/original_api_for_in-app_purchase/validating_receipts_with_the_app_store
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchase) async {
    final isRestored = purchase.status == PurchaseStatus.restored;
    Get.snackbar(
      'Success',
      isRestored ? 'Subscription restored!' : 'Subscription activated!',
    );
    isPurchasing.value = false;
  }

  /// Returns the raw numeric price (e.g. 9.99) for a given [productId].
  /// Returns 0.0 if the product hasn't loaded yet or the ID doesn't match.
  /// Used by [SubscriptionPlansScreenController.getStorePriceForPlan].
  double getPriceForProductId(String productId) {
    final product = products.firstWhereOrNull((p) => p.id == productId);
    return product?.rawPrice ?? 0.0;
  }

  /// Constructs the full store product ID from a backend plan [slug] and [duration].
  ///
  /// Example: slug = 'pro', duration = 'monthly'
  /// → 'com.bloodfitltd.bloodfit.pro.monthly'
  ///
  /// The [slug] comes from the backend API response ([Datum.slug]).
  String buildProductId(String? slug, String duration) {
    return 'com.bloodfitltd.bloodfit.${slug ?? ''}.${duration.toLowerCase()}';
  }
}
