// import 'package:bloodfit/features/onboarding/model/onboarding_model.dart';
// import 'package:get/get.dart';

// import '../constants/app_list.dart';

// class OnboardingScreenController extends GetxController {
//   RxInt currentIndex = 0.obs;

//   List<OnboardingModel> get onboardingList => AppList.onboardingList;

//   void showScreenData() {
//     if (currentIndex.value < onboardingList.length - 1) {
//       currentIndex.value++;
//     }
//   }
// }

import 'package:bloodfit/features/onboarding/model/onboarding_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../constants/app_list.dart';
import '../routes/routes.dart';

class OnboardingScreenController extends GetxController {
  RxInt currentIndex = 0.obs;
  final PageController pageController = PageController();

  List<OnboardingModel> get onboardingList => AppList.onboardingList;

  void goToNextPage() {
    if (currentIndex.value < onboardingList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.toNamed(Routes.signInScreen);
    }
  }

  void goToPreviousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  // Remove showScreenData() method as it's no longer needed

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
