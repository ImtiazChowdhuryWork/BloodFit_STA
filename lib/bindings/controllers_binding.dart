import 'package:bloodfit/controllers/sign_up_screen_controller.dart';
import 'package:get/get.dart';

import '../controllers/edit_profile_screen_controller.dart';
import '../controllers/onboarding_screen_controller.dart';
import '../controllers/otp_validation_controller.dart';
import '../controllers/profile_screen_controller.dart';
import '../controllers/read_more_controller.dart';
import '../controllers/reset_password_screen_controller.dart';
import '../controllers/sign_in_screen_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReadMoreController());
    Get.lazyPut(() => OnboardingScreenController());
    Get.lazyPut(() => SignInScreenController());
    Get.lazyPut(() => SignUpScreenController());
    Get.lazyPut(() => VerifyOtpScreenController());
    Get.lazyPut(() => ResetPasswordScreenController());
    Get.lazyPut(() => ProfileScreenController());
    Get.lazyPut(() => EditProfileScreenController());
  }
}
