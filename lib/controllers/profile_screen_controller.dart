import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  ///Check If User Is Free User or Premimum User
  Rx<UserSubscriptionType> subscriptionType =
      AppConstants.defaultSubscriptionType.obs;
  bool get isFreeUser => subscriptionType.value == UserSubscriptionType.free;
}
