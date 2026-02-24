import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/information_gather_workout/data/controller/information_gather_work_out_controller.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class IgWhatsYourActivityLevelController extends GetxController {
  // holds selected index (-1 means no selection)
  RxInt selectedActivityLevel = (-1).obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved activity level enum value from localStorage
    final savedEnumValue = appData.read(kKeyActivityLevel);
    if (savedEnumValue != null) {
      // Find the index by matching the saved titleEnum value
      final index = AppList.activityLevelList.indexWhere(
        (item) => item.titleEnum == savedEnumValue,
      );
      if (index != -1) {
        selectedActivityLevel.value = index;
        LoggerUtils.debug('Loaded saved activity level: $savedEnumValue (index: $index)');
      } else {
        LoggerUtils.debug('Saved activity level not found in list: $savedEnumValue');
      }
    } else {
      LoggerUtils.debug('No saved activity level found, using default: no selection');
    }
  }

  void setSelectedActivityLevel({required int newValue}) {
    selectedActivityLevel.value = newValue;
    // Save the titleEnum value to localStorage
    final enumValue = AppList.activityLevelList[newValue].titleEnum;
    appData.write(kKeyActivityLevel, enumValue);
    LoggerUtils.debug('Saved activity level enum: $enumValue (index: $newValue)');
    
    ///----------->>> Update the parent controller to enable/disable the continue button
    Get.find<InformationGatherWorkOutController>()
        .triggerButtonUpdate();
  }
}
