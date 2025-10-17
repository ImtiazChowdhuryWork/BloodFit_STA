import 'package:bloodfit/features/onboarding/model/onboarding_model.dart';
import 'package:get/get.dart';

import '../constants/app_list.dart';

class OnboardingScreenController extends GetxController {
  RxInt currentIndex = 0.obs;

  List<OnboardingModel> get onboardingList => AppList.onboardingList;

  void showScreenData() {
    if (currentIndex.value < onboardingList.length - 1) {
      currentIndex.value++;
    }
  }
}
