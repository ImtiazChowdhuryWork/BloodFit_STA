import 'package:bloodfit/controllers/sign_in_screen_controller.dart';
import 'package:bloodfit/repositories/sign_in_repository.dart';
import 'package:get/get.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInRepository>(() => SignInRepository());
    Get.lazyPut<SignInScreenController>(() => SignInScreenController());
  }
}
