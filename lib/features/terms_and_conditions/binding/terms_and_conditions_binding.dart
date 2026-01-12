import 'package:get/get.dart';

import '../data/controller/terms_and_conditions_screen_controller.dart';
import '../data/repository/terms_and_conditions_repository.dart';

class TermsAndConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsAndConditionsRepository>(
      () => TermsAndConditionsRepository(Get.find()),
    );
    Get.lazyPut<TermsAndConditionsScreenController>(
      () => TermsAndConditionsScreenController(Get.find()),
    );
  }
}
