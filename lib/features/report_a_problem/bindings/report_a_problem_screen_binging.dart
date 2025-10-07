import 'package:get/get.dart';

import '../../../controllers/report_a_problem_screen_controller.dart';

class ReportAProblemScreenBinging extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportAProblemScreenController());
  }
}
