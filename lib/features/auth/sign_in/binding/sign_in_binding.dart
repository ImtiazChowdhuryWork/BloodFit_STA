import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:get/get.dart';

import '../data/repository/sign_in_repository.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInRepository>(() => SignInRepository(Get.find()));
    Get.lazyPut<SignInScreenController>(
      () => SignInScreenController(Get.find()),
    );
  }
}
