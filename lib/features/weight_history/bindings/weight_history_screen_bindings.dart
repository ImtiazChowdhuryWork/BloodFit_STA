import 'package:bloodfit/features/weight_history/data/controller/weight_history_screen_controller.dart';
import 'package:bloodfit/features/weight_history/data/repository/update_current_weight_repository.dart';
import 'package:get/get.dart';

class WeightHistoryScreenBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UpdateCurrentWeightRepository(Get.find()));
    Get.lazyPut(() => WeightHistoryScreenController(Get.find()));
  }
}
