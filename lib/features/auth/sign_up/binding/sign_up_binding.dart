import 'package:bloodfit/features/auth/sign_up/data/controller/sign_up_screen_controller.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SignUpRepository>(() => SignUpRepository());
    Get.lazyPut<SignUpScreenController>(() => SignUpScreenController());
  }
}
