import 'package:bloodfit/features/progress/data/controller/weight_history_controller.dart';
import 'package:bloodfit/features/progress/data/repository/weight_history_repository.dart';
import 'package:get/get.dart';

class WeightHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WeightHistoryRepository(Get.find()));
    Get.lazyPut(() => WeightHistoryController(Get.find()));
  }
}
