import 'package:bloodfit/features/auth/forgot_password/data/controller/forgot_password_controller.dart';
import 'package:get/get.dart';

import '../data/repository/forgot_password_repository.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordRepository>(
      () => ForgotPasswordRepository(Get.find()),
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(Get.find()),
    );
  }
}
