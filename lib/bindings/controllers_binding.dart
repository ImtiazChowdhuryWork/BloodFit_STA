import 'package:get/get.dart';

import '../controllers/calendar_controller.dart';
import '../services/iap_service.dart';
import '../controllers/edit_profile_screen_controller.dart';
import '../controllers/enums_controller.dart';
import '../controllers/fitness_screen_controller.dart';
import '../controllers/ig_desired_weight_controller.dart';
import '../controllers/ig_food_allergies_screen_controller.dart';
import '../controllers/ig_food_dislikes_screen_controller.dart';
import '../controllers/ig_prefered_activity_level_controller.dart';
import '../controllers/ig_select_blood_grop_controller.dart';
import '../controllers/ig_select_gender_screen_controller.dart';
import '../controllers/ig_whats_your_activity_level_controller.dart';
import '../controllers/ig_workout_focus_area_controller.dart';
import '../controllers/ig_workout_main_goal_controller.dart';
import '../controllers/information_gather_screen_controller.dart';
import '../controllers/onboarding_age_picker_screen_controller.dart';
import '../controllers/onboarding_screen_controller.dart';
import '../controllers/read_more_controller.dart';
import '../controllers/select_height_screen_controller.dart';
import '../controllers/select_your_country_screen_controller.dart';
import '../controllers/slider_button_controller.dart';
import '../controllers/weight_picker_widget_controller.dart';
import '../controllers/work_out_screen_controller.dart';
import '../features/information_gather_meal_plan/presentation/widgets/select_desired_body_shape/data/controller/information_gather_body_shape_main_goal_controller.dart';
import '../features/information_gather_meal_plan/presentation/widgets/select_desired_weight/data/controller/ig_select_desired_weight_widget_controller.dart';
import '../features/information_gather_workout/presentation/widgets/current_body_shape/data/controller/information_gather_workout_current_body_shape_main_goal_controller.dart';
import '../features/progress/data/controller/weight_history_controller.dart';
import '../features/progress/data/repository/weight_history_repository.dart';

class ControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReadMoreController());
    Get.lazyPut(() => OnboardingScreenController());
    // Get.lazyPut(() => SignInScreenController(), fenix: true);
    // Get.lazyPut(() => SignUpScreenController());
    // Get.lazyPut(() => OtpValidationScreenController());
    // Get.lazyPut(() => ResetPasswordScreenController());

    ///------>>> Profile Screen Controller
    // Get.lazyPut(() => ProfileScreenController(Get.find()), fenix: true);
    Get.lazyPut(() => EnumsController(), fenix: true);
    Get.lazyPut(() => EditProfileScreenController(), fenix: true);
    Get.lazyPut(() => CalandarController(), fenix: true);
    // Get.lazyPut(() => ChooseFromOurSuggestedMealController(), fenix: true);
    // Get.lazyPut(() => FaqScreenController());
    Get.lazyPut(() => FitnessScreenController());
    // Get.lazyPut(() => MealPlanScreenController());
    // Get.lazyPut(() => RulerController());
    // Get.lazyPut(() => SliderButtonController());
    Get.lazyPut(() => InformationGatherMealPlanController());
    // Get.lazyPut(() => HomeScreenController(), fenix: true);
    Get.lazyPut(() => WorkOutScreenController(), fenix: true);
    // Get.lazyPut(() => IgCurrentBodyTypeController(), fenix: true);
    Get.lazyPut(()=> InformationGatherWorkoutCurrentBodyShapeMainGoalController(), fenix: true);

    Get.lazyPut(() => IgPreferedActivityLevelController(), fenix: true);
    Get.lazyPut(() => IgWorkoutMainGoalController(), fenix: true);
    Get.lazyPut(() => IgDesiredWeightController(), fenix: true);
    Get.lazyPut(() => IgWorkoutFocusAreaController(), fenix: true);
    Get.lazyPut(() => IgSelectBloodGropController(), fenix: true);
    Get.lazyPut(() => IgSelectGenderScreenController(), fenix: true);
    Get.lazyPut(() => IgWhatsYourActivityLevelController(), fenix: true);
    Get.lazyPut(() => IgSelectYourCountryScreenController(), fenix: true);
    Get.lazyPut(() => IgFoodAllergiesScreenController(), fenix: true);
    Get.lazyPut(() => IgFoodDislikesScreenController(), fenix: true);
    Get.lazyPut(() => IgSelectDesiredWeightWidgetController(), fenix: true);
    Get.lazyPut(
      () => InformationGatherBodyShapeMainGoalController(),
      fenix: true,
    );
    // Get.lazyPut(() => ForgotPasswordController(), fenix: true);

    Get.lazyPut(
      () => IgAgePickerScreenController(
        itemWidth: 60,
        minValue: 1,
        maxValue: 100,
      ),
    );

    // Add WeightController bindings with tags
    Get.lazyPut(() => WeightController(), tag: 'current_weight', fenix: true);
    Get.lazyPut(() => WeightController(), tag: 'desired_weight');

    // Add SliderButtonController bindings with tags
    Get.lazyPut(
      () => SliderButtonController(),
      tag: 'current_weight_unit',
      fenix: true,
    );
    Get.lazyPut(
      () => SliderButtonController(),
      tag: 'desired_weight_unit',
      fenix: true,
    );
    // Get.lazyPut(() => SliderButtonController(), tag: 'desired_weight_unit');

    // Add tagged bindings for height controllers
    Get.lazyPut(() => WeightController(), tag: 'current_height');
    Get.lazyPut(
      () => SliderButtonController(),
      tag: 'current_height_unit',
      fenix: true,
    );
    Get.lazyPut(
      () => SelectHeightScreenController(),
      tag: 'select_height_controller',
      fenix: true,
    );
    // Get.lazyPut(() => SignOutController(), fenix: true);

    ///Repositiories
    // Get.lazyPut(() => AuthService(), fenix: true);

    /// Weight History Controllers
    Get.lazyPut(() => WeightHistoryRepository(Get.find()));
    Get.lazyPut(() => WeightHistoryController(Get.find()));

    /// IAP Service — registered eagerly so product fetching starts on app launch
    Get.put(IAPService(), permanent: true);
  }
}
