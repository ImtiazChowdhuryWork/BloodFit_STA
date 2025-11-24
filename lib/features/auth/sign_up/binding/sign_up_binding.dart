import 'package:bloodfit/controllers/sign_up_screen_controller.dart';
import 'package:bloodfit/repositories/sign_up_repository.dart';
import 'package:get/get.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpRepository>(() => SignUpRepository());
    Get.lazyPut<SignUpScreenController>(() => SignUpScreenController());
  }
}
