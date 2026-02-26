import 'package:bloodfit/features/choose_from_our_suggested_meals/data/controller/choose_from_our_suggested_meal_controller.dart';
import 'package:get/get.dart';

import '../data/repository/ai_suggested_meals_job_id_repository.dart';
import '../data/repository/ai_suggested_meals_repository.dart';
import '../data/repository/previously_selected_meals_repository.dart';

class GenerateMealPlanBindings extends Bindings {
  @override
  void dependencies() {
    /// Repositories - lazy loaded
    Get.lazyPut(() => PreviouslySelectedMealsRepository(Get.find()));
    Get.lazyPut(() => AiSuggestedMealsJobIdRepository(Get.find()));
    Get.lazyPut(() => AiSuggestedMealsRepository(Get.find()));
    
    /// Controller - Application scoped (permanent)
    /// Stays alive throughout the app session, destroyed only on app exit
    Get.put(
      ChooseFromOurSuggestedMealController(Get.find(), Get.find(), Get.find()),
      permanent: true,
    );
  }
}
