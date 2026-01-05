import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:bloodfit/controllers/verify_user_otp_screen_controller.dart';
import 'package:bloodfit/features/auth/sign_in/data/repository/sign_in_repository.dart';
import 'package:get/get.dart';

class VerifyUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyUserOtpScreenController>(
      () => VerifyUserOtpScreenController(),
    );
    // Get.lazyPut<VerifyUserRepository>(() => VerifyUserRepository());

    Get.lazyPut<SignInScreenController>(() => SignInScreenController());
    // Get.lazyPut<SignInRepository>(() => SignInRepository());
  }
}
