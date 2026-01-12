import 'package:bloodfit/features/report_a_problem/data/repository/report_a_problem_repository.dart';
import 'package:get/get.dart';
import '../data/controller/report_a_problem_screen_controller.dart';

class ReportAProblemScreenBinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportAProblemRepository>(
      () => ReportAProblemRepository(Get.find()),
    );
    Get.lazyPut<ReportAProblemScreenController>(
      () => ReportAProblemScreenController(Get.find()),
    );
  }
}
