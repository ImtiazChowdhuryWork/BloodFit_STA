import 'package:get/get.dart';

import '../../../../../../../constants/app_constant_text.dart';
import '../../../../../../../constants/app_list.dart';
import '../../../../../../../helper/di.dart';
import '../../../../../../../helper/logger_util.dart';

class InformationGatherWorkoutCurrentBodyShapeMainGoalController extends GetxController{

  // Observable to track selected body type index
  final selectedBodyTypeIndex = RxInt(
    -1,
  ); // -1 means nothing selected initially
  RxString selectedBodyTypeTobeSaved = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved body shape when controller initializes
    loadSavedBodyShape();
  }

  void loadSavedBodyShape() {
    try {
      final savedBodyShape = appData.read(kKeyCurrentBodyShape);
      if (savedBodyShape != null) {
        final index = AppList.bodyTypeList.indexWhere(
          (element) => element.enumValue == savedBodyShape,
        );
        if (index != -1) {
          selectedBodyTypeIndex.value = index;
          selectedBodyTypeTobeSaved.value = savedBodyShape;
          LoggerUtils.debug("Loaded saved body shape: $savedBodyShape");
        }
      }
    } catch (e) {
      LoggerUtils.error("Error loading body shape: $e");
    }
  }

  // Method to handle body type selection
  void selectBodyType(int index) {
    if (selectedBodyTypeIndex.value == index) {
      // If same item is tapped again, deselect it
      selectedBodyTypeIndex.value = -1;
      selectedBodyTypeTobeSaved.value = '';
    } else {
      // Select the new item
      selectedBodyTypeIndex.value = index;
      if (index >= 0 && index < AppList.bodyTypeList.length) {
        selectedBodyTypeTobeSaved.value =
            AppList.bodyTypeList[selectedBodyTypeIndex.value].enumValue;
      } else {
        selectedBodyTypeTobeSaved.value = '';
      }
    }
  }

  // Check if a specific index is selected
  bool isSelected(int index) {
    return selectedBodyTypeIndex.value == index;
  }

  // Get the selected body type (optional)
  String? get selectedBodyType {
    if (selectedBodyTypeIndex.value >= 0 &&
        selectedBodyTypeIndex.value < AppList.bodyTypeList.length) {
      return AppList.bodyTypeList[selectedBodyTypeIndex.value].enumValue;
    }
    return null;
  }
}

