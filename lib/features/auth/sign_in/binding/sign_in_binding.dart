import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:bloodfit/features/auth/sign_in/data/repository/sign_in_repository.dart';
import 'package:get/get.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<SignInRepository>(() => SignInRepository());
    Get.lazyPut<SignInScreenController>(() => SignInScreenController());
  }
}
