import 'package:get/get.dart';

class IgWhatsYourActivityLevelController extends GetxController {
  // holds selected index
  RxInt selectedActivityLevel = 0.obs;

  void setSelectedActivityLevel({required int newValue}) {
    selectedActivityLevel.value = newValue;
  }
}
