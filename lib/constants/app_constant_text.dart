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
const String kKeyBangla = 'bangla';
const String kKeySignUpToken = 'sign-up';
const String kKeyForgotPasswordToken = 'forgot_password_token';
const String kKeyUserName = 'user_name';
const String kKeyEmail = 'user_email';
