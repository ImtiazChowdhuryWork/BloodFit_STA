import 'package:bloodfit/features/subscription/data/repository/subscription_screen_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/services/iap_service.dart';
import 'package:get/get.dart';

import '../model/subscription_plans_model.dart';

/// Controller for [SubscriptionScreen].
///
/// --- DATA SOURCES (Hybrid Approach) ---
/// This controller pulls data from TWO sources and combines them for the UI:
///
/// 1. BACKEND API (via [SubscriptionScreenRepository])
///    → Provides: plan name, slug, features list (with included/excluded flags),
///      isActive status, plan ID (used for billing summary navigation).
///    → Called once on screen load via [getSubscriptionPlansApi].
///
/// 2. APP STORE / PLAY STORE (via [IAPService])
///    → Provides: real subscription prices in the user's local currency.
///    → [IAPService] loads products at app startup, so prices are ready by
///      the time the user opens the subscription screen.
///    → Accessed via [getStorePriceForPlan] which looks up the price
///      by matching the backend plan slug to the store product ID.
///
/// This hybrid approach means:
/// - Plan structure and features are managed by the backend (flexible, server-driven).
/// - Prices are always accurate and come directly from the store (required by
///   App Store / Play Store guidelines — you must show store prices, not backend prices).
class SubscriptionPlansScreenController extends GetxController {
  final SubscriptionScreenRepository _subscriptionScreenRepository;

  /// Full API response model (stored for reference).
  Rxn<GetSubscriptionPlansModel> model = Rxn<GetSubscriptionPlansModel>();

  /// Flat list of all subscription plans returned by the backend.
  /// The UI filters this into monthly and yearly lists based on [Datum.pricing].
  RxList<Datum> subscriptionList = <Datum>[].obs;

  SubscriptionPlansScreenController(this._subscriptionScreenRepository);

  /// Tracks which tab is selected (Monthly = true, Yearly = false).
  /// Currently used for internal state; tabs in [SubscriptionScreen] are
  /// controlled by a [TabController] and filtered directly in the build method.
  RxBool isMonthlyTabSelected = true.obs;
  void checkIfMonthlyTabSelected({required int selectedTabIndex}) {
    if (selectedTabIndex == 0) {
      isMonthlyTabSelected.value = true;
    } else if (selectedTabIndex == 1) {
      isMonthlyTabSelected.value = false;
    }
  }

  /// True while the backend plan list is being fetched.
  RxBool isSubscriptionBeingLoad = false.obs;
  RxString subscriptionsLoadingErrorMessage = ''.obs;

  void clearSubscriptionsLoadingErrorMessage() {
    subscriptionsLoadingErrorMessage.value = '';
  }

  /// Returns the real store price (as a double) for a plan card.
  ///
  /// [slug]     — the plan's slug from the backend (e.g. 'starter', 'pro', 'elite').
  /// [duration] — either 'monthly' or 'yearly', depending on the active tab.
  ///
  /// Internally builds the store product ID using [IAPService.buildProductId],
  /// then looks up the price in the already-loaded [IAPService.products] list.
  ///
  /// Returns 0.0 if [IAPService] hasn't finished loading products yet or if
  /// the product ID is not found (e.g. product not configured in the store).
  double getStorePriceForPlan(String? slug, String duration) {
    final iapService = Get.find<IAPService>();
    final productId = iapService.buildProductId(slug, duration);
    return iapService.getPriceForProductId(productId);
  }

  /// Fetches the list of subscription plans from the backend API.
  ///
  /// On success, populates [subscriptionList] which drives the plan cards.
  /// Features, plan names, isActive status all come from this response.
  /// Prices are NOT used from this response — they come from [IAPService] instead.
  Future<void> getSubscriptionPlansApi() async {
    try {
      isSubscriptionBeingLoad.value = true;
      clearSubscriptionsLoadingErrorMessage();

      final response = await _subscriptionScreenRepository
          .subscriptionScreenRepository();

      if (response.statusCode == 200 && response.isSuccess && response.jsonResponse != null) {
        final responseData = GetSubscriptionPlansModel.fromJson(
          response.jsonResponse!,
        );
        model.value = responseData;
        subscriptionList.value = responseData.data ?? [];
      } else {
        subscriptionsLoadingErrorMessage.value = response.errorMessage
            .toString();
        LoggerUtils.error("Something Went Wrong!");
        LoggerUtils.error("Error Status Code : ${response.statusCode}");
        LoggerUtils.error(
          "Error Message : ${subscriptionsLoadingErrorMessage.value}",
        );
      }
    } catch (e) {
      subscriptionsLoadingErrorMessage.value = e.toString();
      LoggerUtils.error(
        "Error Catched : ${subscriptionsLoadingErrorMessage.value}",
      );
    } finally {
      isSubscriptionBeingLoad.value = false;
    }
  }
}
