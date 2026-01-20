import 'package:bloodfit/features/subscription/data/repository/subscription_screen_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/subscription_plans_model.dart';

class SubscriptionPlansScreenController extends GetxController {
  ///--------->>> Importing Subscription Repository
  final SubscriptionScreenRepository _subscriptionScreenRepository;

  ///----------->>> Importing Subscription Plans Model
  Rxn<GetSubscriptionPlansModel> model = Rxn<GetSubscriptionPlansModel>();
  RxList<Datum> subscriptionList = <Datum>[].obs;

  SubscriptionPlansScreenController(this._subscriptionScreenRepository);

  ///------------->>> Checking the Current Tab Type : Monthly Or Yearly
  RxBool isMonthlyTabSelected = true.obs;
  void checkIfMonthlyTabSelected({required int selectedTabIndex}) {
    if (selectedTabIndex == 0) {
      isMonthlyTabSelected.value = true;
    } else if (selectedTabIndex == 1) {
      isMonthlyTabSelected.value = false;
    } else {
      null;
    }
  }

  RxBool isSubscriptionBeingLoad = false.obs;
  RxString subscriptionsLoadingErrorMessage = ''.obs;

  void clearSubscriptionsLoadingErrorMessage() {
    subscriptionsLoadingErrorMessage.value = '';
  }

  Future<void> getSubscriptionPlansApi() async {
    try {
      isSubscriptionBeingLoad.value = true;
      clearSubscriptionsLoadingErrorMessage();

      final response = await _subscriptionScreenRepository
          .subscriptionScreenRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        ///--------->>> Store the response to a variable
        final responseData = GetSubscriptionPlansModel.fromJson(
          response.jsonResponse!,
        );

        ///----------->>> Store the response data to the model
        model.value = responseData;

        ///--------->>> Extracting just the subscription data and storing it to the Subscription List
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
