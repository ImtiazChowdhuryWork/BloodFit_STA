// import 'dart:developer';

// import 'package:bloodfit/features/onboarding/presentation/widgets/onboarding_widget.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:bloodfit/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../controllers/onboarding_screen_controller.dart';

// class OnboardingScreen extends StatelessWidget {
//   OnboardingScreen({super.key});

//   final OnboardingScreenController controller =
//       Get.find<OnboardingScreenController>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Obx(() {
//           final data = controller.onboardingList[controller.currentIndex.value];
//           return Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: UIHelper.kDefaulutPadding(),
//             ),
//             child: OnboardingWidget(
//               index: controller.currentIndex.value,
//               myList: controller.onboardingList,
//               title: data.title,
//               subTitle: data.subTitle,
//               imagePath: data.imagePath,
//               onTap: () {
//                 if (controller.currentIndex.value <
//                     controller.onboardingList.length - 1) {
//                   log(
//                     "----------///Onboarding ${controller.currentIndex.value}///----------------",
//                   );
//                   log("Title : ${data.title}");
//                   log("SubTitle : ${data.subTitle}");
//                   log("ImagePath : ${data.imagePath}");
//                   log(
//                     "----------///Onboarding ${controller.currentIndex.value} data Finished///----------------",
//                   );
//                   controller.showScreenData();
//                 } else {
//                   log("Onboarding Finised");
//                   Get.toNamed(Routes.signInScreen);
//                 }
//               },
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

import 'dart:developer';

import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/features/onboarding/presentation/widgets/onboarding_widget.dart';
import 'package:bloodfit/features/onboarding/presentation/widgets/page_indicator_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constants/text_font_style.dart';
import '../../../controllers/onboarding_screen_controller.dart';
import '../../../custom_widgets/custom_elevated_button.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingScreenController controller =
      Get.find<OnboardingScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  itemCount: controller.onboardingList.length,
                  onPageChanged: controller.onPageChanged,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final data = controller.onboardingList[index];
                    return OnboardingWidget(
                      index: index,
                      myList: controller.onboardingList,
                      title: data.title,
                      subTitle: data.subTitle,
                      imagePath: data.imagePath,
                      // onTap: () {
                      //   if (index < controller.onboardingList.length - 1) {
                      //     log(
                      //       "----------///Onboarding $index///----------------",
                      //     );
                      //     log("Title : ${data.title}");
                      //     log("SubTitle : ${data.subTitle}");
                      //     log("ImagePath : ${data.imagePath}");
                      //     log(
                      //       "----------///Onboarding $index data Finished///----------------",
                      //     );
                      //     controller.goToNextPage();
                      //   } else {
                      //     log("Onboarding Finished");
                      //     Get.toNamed(Routes.signInScreen);
                      //   }
                      // },
                    );
                  },
                ),
              ),

              ///Section : -------------///Indicator///--------------
              Obx(() {
                return PageIndicatorWidget(
                  index: controller.currentIndex.value,
                  myList: controller.onboardingList,
                );
              }),

              /// Section: ---------------///ElevatedButton///---------------------
              Obx(() {
                return CustomElevatedButton(
                  onTap: () {
                    controller.currentIndex <=
                            controller.onboardingList.length - 1
                        ? controller.goToNextPage()
                        : Get.toNamed(Routes.signInScreen);
                  },
                  buttonTitle:
                      controller.currentIndex.value <=
                          controller.onboardingList.length - 2
                      ? "Next"
                      : "Finish",
                );
              }),

              UIHelper.verticalSpace(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
