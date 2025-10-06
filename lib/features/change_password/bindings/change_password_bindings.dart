// lib/bindings/change_password_binding.dart

import 'package:get/get.dart';

import '../../../controllers/change_password_screen_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangePasswordScreenController());
  }
}
