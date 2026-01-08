// lib/bindings/change_password_binding.dart

import 'package:bloodfit/features/change_password/data/repository/change_password_repository.dart';
import 'package:get/get.dart';

import '../data/controller/change_password_screen_controller.dart';

class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangePasswordRepository>(
      () => ChangePasswordRepository(Get.find()),
    );
    Get.lazyPut<ChangePasswordScreenController>(
      () => ChangePasswordScreenController(Get.find()),
    );
  }
}
