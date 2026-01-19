import 'package:bloodfit/features/my_profile/data/controller/profile_screen_controller.dart';
import 'package:get/get.dart';

import '../../../controllers/custom_image_picker_controller.dart';
import '../data/repository/my_profile_repository.dart';

class MyProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomImagePickerController());
    Get.lazyPut(() => MyProfileRepository(Get.find()));
    Get.lazyPut(() => ProfileScreenController(Get.find()));
  }
}
