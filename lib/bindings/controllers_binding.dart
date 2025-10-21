import 'package:bloodfit/controllers/sign_up_screen_controller.dart';
import 'package:get/get.dart';

import '../controllers/edit_profile_screen_controller.dart';
import '../controllers/enums_controller.dart';
import '../controllers/faq_screen_controller.dart';
import '../controllers/fitness_screen_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/information_gather_screen_controller.dart';
import '../controllers/meal_plan_screen_controller.dart';
import '../controllers/onboarding_age_picker_screen_controller.dart';
import '../controllers/onboarding_screen_controller.dart';
import '../controllers/otp_validation_controller.dart';
import '../controllers/profile_screen_controller.dart';
import '../controllers/read_more_controller.dart';
import '../controllers/reset_password_screen_controller.dart';
import '../controllers/ruler_controller.dart';
import '../controllers/sign_in_screen_controller.dart';
import '../controllers/slider_button_controller.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReadMoreController());
    Get.lazyPut(() => OnboardingScreenController());
    Get.lazyPut(() => SignInScreenController());
    Get.lazyPut(() => SignUpScreenController());
    Get.lazyPut(() => VerifyOtpScreenController());
    Get.lazyPut(() => ResetPasswordScreenController());
    Get.lazyPut(() => ProfileScreenController(), fenix: true);
    Get.lazyPut(() => EnumsController(), fenix: true);
    Get.lazyPut(() => EditProfileScreenController(), fenix: true);
    Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => FaqScreenController());
    Get.lazyPut(() => FitnessScreenController());
    Get.lazyPut(() => MealPlanScreenController());
    Get.lazyPut(() => RulerController());
    Get.lazyPut(() => SliderButtonController());
    Get.lazyPut(() => InformationGatherController());

    Get.lazyPut(
      () => OnboardingAgePickerScreenController(
        itemWidth: 60,
        minValue: 1,
        maxValue: 100,
      ),
    );
  }
}
