import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class IgWorkoutFocusAreaController extends GetxController {
  // Focus area enum values
  static const String arms = 'arms';
  static const String upperBody = 'upper_body';
  static const String abs = 'abs';
  static const String butt = 'butt';
  static const String legs = 'legs';

  ///Section : Body Part -> Arms
  RxBool isArmsSelected = false.obs;
  void setArmsSelection() {
    if (isArmsSelected.value == true) {
      isArmsSelected.value = false;
    } else if (isArmsSelected.value == false) {
      isArmsSelected.value = true;
    } else {
      return;
    }
    _saveFocusAreas();
  }

  ///Section : Body Part -> UpperBody
  RxBool isUpperBodySelected = false.obs;
  void setUpperBodySelection() {
    if (isUpperBodySelected.value == true) {
      isUpperBodySelected.value = false;
    } else if (isUpperBodySelected.value == false) {
      isUpperBodySelected.value = true;
    } else {
      return;
    }
    _saveFocusAreas();
  }

  ///Section : Body Part -> Abs
  RxBool isAbsSelected = false.obs;
  void setAbsSelection() {
    if (isAbsSelected.value == true) {
      isAbsSelected.value = false;
    } else if (isAbsSelected.value == false) {
      isAbsSelected.value = true;
    } else {
      return;
    }
    _saveFocusAreas();
  }

  ///Section : Body Part -> Butt
  RxBool isButtSelected = false.obs;
  void setButtSelection() {
    if (isButtSelected.value == true) {
      isButtSelected.value = false;
    } else if (isButtSelected.value == false) {
      isButtSelected.value = true;
    } else {
      return;
    }
    _saveFocusAreas();
  }

  ///Section : Body Part -> leg
  RxBool isLegSelected = false.obs;
  void setLegSelection() {
    if (isLegSelected.value == true) {
      isLegSelected.value = false;
    } else if (isLegSelected.value == false) {
      isLegSelected.value = true;
    } else {
      return;
    }
    _saveFocusAreas();
  }

  @override
  void onInit() {
    super.onInit();
    _loadFocusAreas();
  }

  /// Save selected focus areas to localStorage as a list of enum values
  void _saveFocusAreas() {
    final selectedAreas = <String>[];
    if (isArmsSelected.value) selectedAreas.add(arms);
    if (isUpperBodySelected.value) selectedAreas.add(upperBody);
    if (isAbsSelected.value) selectedAreas.add(abs);
    if (isButtSelected.value) selectedAreas.add(butt);
    if (isLegSelected.value) selectedAreas.add(legs);

    appData.write(kKeyWorkoutFocusArea, selectedAreas);
    LoggerUtils.debug('Saved workout focus areas: $selectedAreas');
  }

  /// Load saved focus areas from localStorage
  void _loadFocusAreas() {
    final savedAreas = appData.read(kKeyWorkoutFocusArea) as List<dynamic>?;
    if (savedAreas != null) {
      isArmsSelected.value = savedAreas.contains(arms);
      isUpperBodySelected.value = savedAreas.contains(upperBody);
      isAbsSelected.value = savedAreas.contains(abs);
      isButtSelected.value = savedAreas.contains(butt);
      isLegSelected.value = savedAreas.contains(legs);
      LoggerUtils.debug('Loaded workout focus areas: $savedAreas');
    } else {
      LoggerUtils.debug('No saved workout focus areas found');
    }
  }
}
