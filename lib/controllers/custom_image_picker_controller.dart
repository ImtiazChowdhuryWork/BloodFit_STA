import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxString pickedImagePath = ''.obs;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024.w,
        maxHeight: 1024.h,
        imageQuality: 85,
      );

      if (image != null) {
        pickedImagePath.value = image.path;
      } else {
        Get.snackbar("Canceled", "No image selected.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }
}
