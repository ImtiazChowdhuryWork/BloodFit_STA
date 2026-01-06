import 'package:bloodfit/features/auth/sign_up/data/controller/sign_up_screen_controller.dart';
import 'package:get/get.dart';

import '../data/repository/sign_up_repository.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpRepository>(() => SignUpRepository(Get.find()));
    Get.lazyPut<SignUpScreenController>(
      () => SignUpScreenController(Get.find()),
    );
  }
}
