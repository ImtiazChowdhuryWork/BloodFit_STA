import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:get/get.dart';

import '../../sign_up/data/controller/sign_up_screen_controller.dart';
import '../../sign_up/data/repository/sign_up_repository.dart';
import '../data/repository/sign_in_repository.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInRepository>(() => SignInRepository(Get.find()));
    Get.lazyPut<SignInScreenController>(
      () => SignInScreenController(Get.find()),
    );

    Get.lazyPut<SignUpRepository>(() => SignUpRepository(Get.find()));
    Get.lazyPut<SignUpScreenController>(
      () => SignUpScreenController(Get.find()),
    );
  }
}
