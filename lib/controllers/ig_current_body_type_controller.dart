import 'package:get/get.dart';

import '../constants/app_list.dart';

class IgCurrentBodyTypeController extends GetxController {
  // Observable to track selected body type index
  final selectedBodyTypeIndex = RxInt(
    -1,
  ); // -1 means nothing selected initially

  // Method to handle body type selection
  void selectBodyType(int index) {
    if (selectedBodyTypeIndex.value == index) {
      // If same item is tapped again, deselect it
      selectedBodyTypeIndex.value = -1;
    } else {
      // Select the new item
      selectedBodyTypeIndex.value = index;
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
      return AppList.bodyTypeList[selectedBodyTypeIndex.value].bodyType;
    }
    return null;
  }
}
