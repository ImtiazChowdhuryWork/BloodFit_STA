import 'dart:developer';

import 'package:bloodfit/features/onboarding/presentation/widgets/onboarding_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/onboarding_screen_controller.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  OnboardingScreenController controller = Get.put(OnboardingScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Obx(() {
          final data = controller.onboardingList[controller.currentIndex.value];
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: UIHelper.kDefaulutPadding(),
            ),
            child: OnboardingWidget(
              index: controller.currentIndex.value,
              myList: controller.onboardingList,
              title: data.title,
              subTitle: data.subTitle,
              imagePath: data.imagePath,
              onTap: () {
                if (controller.currentIndex.value <
                    controller.onboardingList.length - 1) {
                  log(
                    "----------///Onboarding ${controller.currentIndex.value}///----------------",
                  );
                  log("Title : ${data.title}");
                  log("SubTitle : ${data.subTitle}");
                  log("ImagePath : ${data.imagePath}");
                  log(
                    "----------///Onboarding ${controller.currentIndex.value} data Finished///----------------",
                  );
                  controller.showScreenData();
                } else {
                  log("Onboarding Finised");
                  Get.toNamed(Routes.signInScreen);
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
