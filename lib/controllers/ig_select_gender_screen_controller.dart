import 'package:bloodfit/controllers/information_gather_screen_controller.dart';
import 'package:get/get.dart';

import '../constants/app_constant_text.dart';
import '../features/information_gather_meal_plan/presentation/widgets/select_gender/model/gender_model.dart';
import '../gen/assets.gen.dart';
import '../helper/di.dart';
import '../helper/logger_util.dart';

class IgSelectGenderScreenController extends GetxController {
  RxList<GenderModel> genderWithIconList = [
    GenderModel(iconPath: Assets.icons.maleIcon, title: "Male"),
    GenderModel(iconPath: Assets.icons.femaleIcon, title: "Female"),
  ].obs;

  RxInt selectedGenderIndex = (-1).obs;
  RxString selectedGender = ''.obs;

  void setSelectedGenderIndex({required int newValue}) {
    selectedGenderIndex.value = newValue;
    selectedGender.value =
        genderWithIconList[newValue].title; // Store only the title
  }

  @override
  void onInit() {
    super.onInit();
    loadSavedGender();
  }

  void loadSavedGender() {
    try {
      final savedGender = appData.read(kKeyGender) as String?;
      if (savedGender != null) {
        // Find index of gender with matching title
        for (int i = 0; i < genderWithIconList.length; i++) {
          if (genderWithIconList[i].title == savedGender) {
            setSelectedGenderIndex(newValue: i);
            LoggerUtils.debug("Loaded saved gender: $savedGender");
            break;
          }
        }
      }
    } catch (e) {
      LoggerUtils.error("Error loading gender: $e");
    }
  }

  void saveGender() {
    if (selectedGender.value.isNotEmpty) {
      appData.write(kKeyGender, selectedGender.value);

      ///----------->>> Update the controller
      Get.find<InformationGatherMealPlanController>().triggerButtonUpdate();
      LoggerUtils.debug("Saved gender: ${selectedGender.value}");
    }
  }
}
