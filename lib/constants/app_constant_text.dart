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

const String kKeyAccessToken = 'access_token';
const String kKeyRefreshToken = 'refresh_token';
const String kKeyName = 'name';
const String kKeyFirstName = 'first_name';
const String kKeyLastName = 'lst_name';
const String kImageUrl = 'imageUrl';
const String kKeyfirstTime = "first";
const String kKeyStatus = 'status';
const String kEmail = 'email';
const String kPassword = 'password';
const String kKeyIsLoggedIn = 'is_logged_in';
const String kKeyDeviceID = 'device_id';
const String kKeyIsUserVerified = 'user-verified';
const String kKeyEnglish = 'english';
const String kKeySouthKorean = 'south_korean';
const String kKeySignUpToken = 'sign-up';
const String kKeyForgotPasswordToken = 'forgot_password_token';
const String kKeyUserName = 'user_name';
const String kKeyEmail = 'user_email';
const String kKeyUserID = 'user_id';

///------->>> Information Gather Meal Plan Constants
const String kKeyBloodGroup = 'blood_group';
const String kKeyGender = 'gender';
const String kKeyUserAge = 'user_age';
const String kKeyUserWeight = 'user_weight';
const String kKeyDesiredWeight = 'desired_weight';
const String kKeyDesiredWeightWithoutUnit = 'desired_weight_without_unit';
const String kKeyDesiredBodyShape = 'desired_body_shape';
const String kKeyUserWeightWithoutUnit = 'user_weight_without_unit';
const String kKeyUserHeight = 'user_height';
const String kKeyUserHeightWithoutUnit = 'user_height_without_unit';
const String kKeyUserCountryName = 'user_country_name';
const String kKeyUserDietType = 'user_diet_type';
const String kKeyUserFoodAlergisList = 'user_food_alergies_list';
const String kKeyUserDislLikeFoodList = 'user_dislike_food_list';
const String kKeyIsMealPlanSubmitted = 'is_meal_plan_submitted';
const String kKeyExpectedBodyShape = 'expected_body_shape';



///----------->>> Information Gather Work-Out Plan
const String kKeyCurrentBodyShape = 'user_current_body_shape';
const String kKeyActivityLevel = 'user_activity_level';
const String kKeyPreffredWorkout = 'user_preffered_workout';

