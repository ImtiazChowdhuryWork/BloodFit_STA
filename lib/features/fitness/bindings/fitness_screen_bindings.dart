import 'package:get/get.dart';

import '../../../controllers/fitness_screen_controller.dart';

class FitnessScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FitnessScreenController());
  }
}