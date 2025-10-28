import 'package:bloodfit/constants/app_enums.dart';

class AppConstants {
  ///Section : ---------///Check If user signing for the first time///--------------
  static const UserSignInType defaultUserType = UserSignInType.firstTime;

  ///Section : -----------///Check user subscription type///-----------------
  static const UserSubscriptionType defaultSubscriptionType =
      UserSubscriptionType.pro;

  ///Section : -----------///Check user subscription type///-----------------
  static const UserSubscriptionType eliteSubscriptionType =
      UserSubscriptionType.free;

  ///Section : ----------///Meal Plan Availability///--------------
  static const MealPlanAvailability mealPlanAvailability =
      MealPlanAvailability.mealPlanNotAvilable;
}
