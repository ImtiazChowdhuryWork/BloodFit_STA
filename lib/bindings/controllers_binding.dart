import 'package:bloodfit/controllers/sign_up_screen_controller.dart';
import 'package:get/get.dart';

import '../controllers/choose_from_our_suggested_meal_controller.dart';
import '../controllers/edit_profile_screen_controller.dart';
import '../controllers/enums_controller.dart';
import '../controllers/faq_screen_controller.dart';
import '../controllers/fitness_screen_controller.dart';
import '../controllers/calendar_controller.dart';
import '../controllers/home_screen_controller.dart';
import '../controllers/ig_current_body_type_controller.dart';
import '../controllers/ig_desired_weight_controller.dart';
import '../controllers/ig_prefered_activity_level_controller.dart';
import '../controllers/ig_select_blood_grop_controller.dart';
import '../controllers/ig_select_gender_screen_controller.dart';
import '../controllers/ig_whats_your_activity_level_controller.dart';
import '../controllers/ig_workout_focus_area_controller.dart';
import '../controllers/ig_workout_main_goal_controller.dart';
import '../controllers/information_gather_screen_controller.dart';
import '../controllers/information_gather_work_out_controller.dart';
import '../controllers/meal_plan_screen_controller.dart';
import '../controllers/onboarding_age_picker_screen_controller.dart';
import '../controllers/onboarding_screen_controller.dart';
import '../controllers/otp_validation_controller.dart';
import '../controllers/profile_screen_controller.dart';
import '../controllers/read_more_controller.dart';
import '../controllers/reset_password_screen_controller.dart';
import '../controllers/ruler_controller.dart';
import '../controllers/select_height_screen_controller.dart';
import '../controllers/sign_in_screen_controller.dart';
import '../controllers/sign_out_controller.dart';
import '../controllers/slider_button_controller.dart';
import '../controllers/weight_picker_widget_controller.dart';
import '../controllers/work_out_screen_controller.dart';
import '../repositories/sign_up_repository.dart';
import '../services/auth_service.dart';

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
    Get.lazyPut(() => CalandarController(), fenix: true);
    Get.lazyPut(() => ChooseFromOurSuggestedMealController(), fenix: true);
    Get.lazyPut(() => FaqScreenController());
    Get.lazyPut(() => FitnessScreenController());
    Get.lazyPut(() => MealPlanScreenController());
    // Get.lazyPut(() => RulerController());
    // Get.lazyPut(() => SliderButtonController());
    Get.lazyPut(() => InformationGatherMealPlanController());
    Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => WorkOutScreenController(), fenix: true);
    Get.lazyPut(() => IgCurrentBodyTypeController(), fenix: true);
    Get.lazyPut(() => InformationGatherWorkOutController(), fenix: true);
    Get.lazyPut(() => IgPreferedActivityLevelController(), fenix: true);
    Get.lazyPut(() => IgWorkoutMainGoalController(), fenix: true);
    Get.lazyPut(() => IgDesiredWeightController(), fenix: true);
    Get.lazyPut(() => IgWorkoutFocusAreaController(), fenix: true);
    Get.lazyPut(() => IgSelectBloodGropController(), fenix: true);
    Get.lazyPut(() => IgSelectGenderScreenController(), fenix: true);
    Get.lazyPut(() => IgWhatsYourActivityLevelController(), fenix: true);

    // Add WeightController bindings with tags
    Get.lazyPut(() => WeightController(), tag: 'current_weight');
    Get.lazyPut(() => WeightController(), tag: 'desired_weight');

    // Add SliderButtonController bindings with tags
    Get.lazyPut(() => SliderButtonController(), tag: 'current_weight_unit');
    Get.lazyPut(() => SliderButtonController(), tag: 'desired_weight_unit');

    // Add tagged bindings for height controllers
    Get.lazyPut(() => WeightController(), tag: 'current_height');
    Get.lazyPut(() => SliderButtonController(), tag: 'current_height_unit');
    Get.lazyPut(() => SelectHeightScreenController(), fenix: true);
    Get.lazyPut(() => SignOutController(), fenix: true);

    ///Repositiories
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => SignUpRepository(), fenix: true);

    Get.lazyPut(
      () => IgAgePickerScreenController(
        itemWidth: 60,
        minValue: 1,
        maxValue: 100,
      ),
    );
  }
}
