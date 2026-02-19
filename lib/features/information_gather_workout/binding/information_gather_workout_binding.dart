import 'package:get/get.dart';

import '../data/controller/information_gather_work_out_controller.dart';


class InformationGatherWorkoutBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => InformationGatherWorkOutController(),);
  }
}