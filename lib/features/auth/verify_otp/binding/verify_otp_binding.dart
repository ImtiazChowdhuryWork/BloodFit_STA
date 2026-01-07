import 'package:bloodfit/features/auth/verify_otp/data/controller/otp_validation_controller.dart';
import 'package:bloodfit/features/auth/verify_otp/data/repository/resend_otp_repository.dart';
import 'package:bloodfit/features/auth/verify_otp/data/repository/verify_otp_repository.dart';
import 'package:get/get.dart';

class VerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyOtpRepository>(() => VerifyOtpRepository(Get.find()));
    Get.lazyPut<ResendOtpRepository>(() => ResendOtpRepository(Get.find()));
    Get.lazyPut<OtpValidationScreenController>(
      () => OtpValidationScreenController(Get.find(), Get.find()),
    );
  }
}
