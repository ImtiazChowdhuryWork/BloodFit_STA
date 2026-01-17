import 'package:get/get.dart';
import 'package:bloodfit/helper/di.dart'; // Add this import
import 'package:bloodfit/constants/app_constant_text.dart'; // Add this import
import 'package:bloodfit/helper/logger_util.dart'; // Add this import

class IgSelectBloodGropController extends GetxController {
  RxList bloodGroups = ["A", "B", "O", "AB"].obs;
  RxString selectedBloodType = ''.obs;
  RxInt selectedIndex = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved blood group when controller initializes
    loadSavedBloodGroup();
  }

  void loadSavedBloodGroup() {
    try {
      final savedBloodGroup = appData.read(kKeyBloodGroup);
      if (savedBloodGroup != null && bloodGroups.contains(savedBloodGroup)) {
        final index = bloodGroups.indexOf(savedBloodGroup);
        getSelectedIndex(newValue: index);
        LoggerUtils.debug("Loaded saved blood group: $savedBloodGroup");
      }
    } catch (e) {
      LoggerUtils.error("Error loading blood group: $e");
    }
  }

  void getSelectedIndex({required int newValue}) {
    selectedIndex.value = newValue;
    selectedBloodType.value = bloodGroups[newValue];
  }
}
