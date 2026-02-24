import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/information_gather_workout/data/controller/information_gather_work_out_controller.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class IgPreferedActivityLevelController extends GetxController {
  RxInt selectedIndex = (-1).obs; // -1 = none selected

  @override
  void onInit() {
    super.onInit();
    // Load saved preferred workout level enum value from localStorage
    final savedEnumValue = appData.read(kKeyPreffredWorkout);
    if (savedEnumValue != null) {
      // Find the index by matching the saved titleEnum value
      final index = AppList.preferedWorkoutLevelList.indexWhere(
        (item) => item.titleEnum == savedEnumValue,
      );
      if (index != -1) {
        selectedIndex.value = index;
        LoggerUtils.debug('Loaded saved preferred workout level: $savedEnumValue (index: $index)');
      } else {
        LoggerUtils.debug('Saved preferred workout level not found in list: $savedEnumValue');
      }
    } else {
      LoggerUtils.debug('No saved preferred workout level found, using default: no selection');
    }
  }

  void selectLevel(int index) {
    selectedIndex.value = index;
    // Save the titleEnum value to localStorage
    final enumValue = AppList.preferedWorkoutLevelList[index].titleEnum;
    appData.write(kKeyPreffredWorkout, enumValue);
    LoggerUtils.debug('Saved preferred workout level enum: $enumValue (index: $index)');
    
    ///----------->>> Update the parent controller to enable/disable the continue button
    Get.find<InformationGatherWorkOutController>()
        .triggerButtonUpdate();
  }
}
