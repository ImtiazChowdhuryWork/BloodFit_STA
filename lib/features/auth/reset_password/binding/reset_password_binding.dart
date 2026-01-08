import 'package:bloodfit/features/auth/reset_password/data/controller/reset_password_screen_controller.dart';
import 'package:bloodfit/features/auth/reset_password/data/repository/reset_password_repository.dart';
import 'package:get/get.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordRepository>(
      () => ResetPasswordRepository(Get.find()),
    );
    Get.lazyPut<ResetPasswordScreenController>(
      () => ResetPasswordScreenController(Get.find()),
    );
  }
}
