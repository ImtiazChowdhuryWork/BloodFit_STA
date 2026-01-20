import 'package:bloodfit/features/view_profile_sub_type_free/data/repository/update_profile_data_repository.dart';
import 'package:get/get.dart';

import '../../../controllers/custom_image_picker_controller.dart';
import '../data/controller/view_profile_subscription_type_free_screen_controller.dart';
import '../../my_profile/data/repository/my_profile_repository.dart';
import '../../my_profile/data/repository/upload_profile_image_repository.dart';

class ViewProfileSubTypeFreeBinding extends Bindings {
  @override
  void dependencies() {
    ////------->>> Added this later
    Get.lazyPut(() => CustomImagePickerController());
    Get.lazyPut(() => UpdateProfileDataRepository(Get.find()));
    Get.lazyPut(() => MyProfileRepository(Get.find()));
    Get.lazyPut(() => UploadProfileImageRepository(Get.find()));
    // Get.lazyPut(() => ProfileScreenController(Get.find(), Get.find()));

    Get.lazyPut<ViewProfileSubscriptionTypeFreeScreenController>(
      () => ViewProfileSubscriptionTypeFreeScreenController(
        Get.find(),
        Get.find(),
      ),
    );
  }
}
