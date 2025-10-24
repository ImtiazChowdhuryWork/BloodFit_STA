import 'package:bloodfit/constants/app_enums.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxInt mealCalanderSelectableDays = 3.obs;
  List<WeekDayEnum> weekDayList = WeekDayEnum.values;
  RxList<WeekDayEnum> selectedDaysList = <WeekDayEnum>[].obs; // Keep as RxList

  void toggleDaySelection(WeekDayEnum day) {
    if (selectedDaysList.contains(day)) {
      selectedDaysList.remove(day);
    } else {
      if (selectedDaysList.length < mealCalanderSelectableDays.value) {
        selectedDaysList.add(day);
      } else {
        Get.snackbar(
          'Limit Reached',
          'You can only select ${mealCalanderSelectableDays.value} days',
        );
      }
    }
    // No need for update() with RxList + Obx
  }

  bool isDaySelected(WeekDayEnum day) {
    return selectedDaysList.contains(day);
  }
}
