import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_enums.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreenController extends GetxController {
  ///Section : -------------///Profile Image Picker///--------------
  final ImagePicker _picker = ImagePicker();
  RxString pickedImagePath = ''.obs;

  Future<void> imagePicker({required ImageSource imagPickerSource}) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: imagPickerSource,
        maxHeight: 1024.h,
        maxWidth: 1024.w,
        imageQuality: 85,
      );

      image != null
          ? pickedImagePath.value = image.path
          : Get.snackbar("Canceled!", "No Image Selected.");
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  ///Check If User Is Free User or Premimum User
  Rx<UserSubscriptionType> subscriptionType =
      AppConstants.defaultSubscriptionType.obs;
  bool get isFreeUser => subscriptionType.value == UserSubscriptionType.free;
}
