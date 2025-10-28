import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:get/get.dart';

class EnumsController extends GetxController {
  ///Section : ----------///Meal Plan Availability Section///---------------
  Rx<MealPlanAvailability> mealPlanAvailability =
      AppConstants.mealPlanAvailability.obs;

  ///Checking -> is MealPlan Not Available
  bool get isMealPlanAvailable =>
      mealPlanAvailability.value == MealPlanAvailability.mealPlanAvailable;

  void setMealPlanAvailable() {
    mealPlanAvailability.value = MealPlanAvailability.mealPlanAvailable;
  }

  void setMealPlanNotAvailable() {
    mealPlanAvailability.value = MealPlanAvailability.mealPlanNotAvilable;
  }

  ///Section : -----///Set UserType to Subscription Type Elite User///-------------
  Rx<UserSubscriptionType> userSubscriptionTypeElite =
      AppConstants.eliteSubscriptionType.obs;
  void setUserSubscriptionTypeToElite() {
    userSubscriptionTypeElite.value = UserSubscriptionType.elite;
  }
}
