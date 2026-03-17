import 'package:bloodfit/features/plan_summery_details/data/repository/summery_details_repository.dart';
import 'package:get/get.dart';

import '../data/controller/plan_summery_details_screen_controller.dart';

class SummeryDetailsScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> PlanSummeryDetailsRepository(Get.find()));
    Get.lazyPut(()=> PlanSummeryDetailsScreenController(Get.find()));
  }
}