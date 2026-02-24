import 'package:get/get.dart';

import '../data/controller/information_gather_work_out_controller.dart';
import '../data/repository/information_gather_workout_repository.dart';


class InformationGatherWorkoutBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InformationGatherWorkoutRepository(Get.find()),);
    Get.lazyPut(() => InformationGatherWorkOutController(Get.find()),);
  }
}