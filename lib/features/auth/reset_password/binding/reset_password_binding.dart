import 'package:bloodfit/controllers/reset_password_screen_controller.dart';
import 'package:get/get.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<ResetPasswordRepository>(() => ResetPasswordRepository());
    Get.lazyPut<ResetPasswordScreenController>(
      () => ResetPasswordScreenController(),
    );
  }
}
