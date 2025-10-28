import 'dart:developer';

import 'package:bloodfit/constants/app_enums.dart';
import 'package:bloodfit/controllers/enums_controller.dart';
import 'package:bloodfit/controllers/work_out_screen_controller.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../controllers/profile_screen_controller.dart';
import '../../../../custom_widgets/custom_elevated_button.dart';

class ShowUserTypeButtons extends StatelessWidget {
  ShowUserTypeButtons({super.key});

  final ProfileScreenController controller =
      Get.find<ProfileScreenController>();

  final EnumsController enumsController = Get.find<EnumsController>();
  final WorkOutScreenController workOutScreenController =
      Get.find<WorkOutScreenController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User Type Buttons",
          style: TextFontStyle.headline16w500cfefefeStylePoppins,
        ),
        UIHelper.verticalSpace(10.h),

        Row(
          children: [
            ///Section : Button -> Free User
            ///Section : Button -> Starter User
            Column(
              children: [
                ///Section : Button -> Free User
                Obx(() {
                  return CustomElevatedButton(
                    onTap: () {
                      log("Free User Button Taped!");
                      controller.setSubscriptionTypeFree();
                      enumsController.setMealPlanAvailable();
                    },
                    buttonHeight: 40.h,
                    buttonWidth: 0.15.sh,
                    buttonColor:
                        controller.subscriptionType == UserSubscriptionType.free
                        ? Colors.deepPurpleAccent
                        : null,
                    buttonTitle: "Free User",
                  );
                }),
                UIHelper.verticalSpace(10.h),

                ///Section : Button -> Starter User
                Obx(() {
                  return CustomElevatedButton(
                    onTap: () {
                      log("Starter User Button Taped!");
                      controller.setSubscriptionTypeStarter();
                      enumsController.setMealPlanNotAvailable();
                    },
                    buttonHeight: 40.h,
                    buttonWidth: 0.15.sh,
                    buttonColor:
                        controller.subscriptionType ==
                            UserSubscriptionType.starter
                        ? Colors.deepPurpleAccent
                        : null,
                    buttonTitle: "Starter User",
                  );
                }),
                UIHelper.verticalSpace(10.h),
              ],
            ),
            UIHelper.horizontalSpace(20.w),

            ///Section : Button -> Pro User
            ///Section : Button -> Elite User
            Column(
              children: [
                ///Section : Button -> Pro User
                Obx(() {
                  return CustomElevatedButton(
                    onTap: () {
                      log("Pro User Button Taped!");
                      controller.setSubscriptionTypePro();
                      enumsController.setMealPlanNotAvailable();
                    },
                    buttonHeight: 40.h,
                    buttonWidth: 0.15.sh,
                    buttonColor:
                        controller.subscriptionType == UserSubscriptionType.pro
                        ? Colors.deepPurpleAccent
                        : null,
                    buttonTitle: "Pro User",
                  );
                }),
                UIHelper.verticalSpace(10.h),

                ///Section : Button -> Elite User
                Obx(() {
                  return CustomElevatedButton(
                    onTap: () {
                      log("Elite User Button Taped!");
                      workOutScreenController.setIsSubscriptionTypeElite(
                        newValue: true,
                      );
                      controller.setSubscriptionTypeElite();
                      enumsController.setMealPlanNotAvailable();
                    },
                    buttonHeight: 40.h,
                    buttonWidth: 0.15.sh,
                    buttonColor:
                        controller.subscriptionType ==
                            UserSubscriptionType.elite
                        ? Colors.deepPurpleAccent
                        : null,
                    buttonTitle: "Elite User",
                  );
                }),
                UIHelper.verticalSpace(10.h),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
