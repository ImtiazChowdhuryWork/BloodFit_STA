// import 'dart:developer';

// import 'package:bloodfit/features/information_gather/presentation/widgets/select_age/presentation/select_age_screen_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_blood_group/presentation/select_blood_group_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_country/presentation/select_country_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_diet/presentation/select_diet_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_dislike_foods/presentation/select_dislike_foods_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_food_allergies/presentation/select_foood_allergies_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_gender/presentation/select_gender_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_height/presentation/select_height_screen_widget.dart';
// import 'package:bloodfit/features/information_gather/presentation/widgets/select_weight/presentation/select_weight_screen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../../custom_widgets/custom_elevated_button.dart';
// import '../../../custom_widgets/go_back_widget.dart';
// import '../../../gen/colors.gen.dart';
// import '../../../routes/routes.dart';

// class InformationGatherScreen extends StatelessWidget {
//   const InformationGatherScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBackgroundColor,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ///Section : Custom Back Button
//                 CustomBackButton(),
//                 UIHelper.verticalSpace(26.h),

//                 ///Section : -----///Onboarding -> Blood Group Selection///----------------
//                 SelectBloodGroupWidget(),

//                 ///Section : -----///Onboarding -> Gender Selection///----------
//                 SelectGenderWidget(),

//                 ///Section : -----///Onboarding -> Age Selection///----------
//                 SelectAgeScreenWidgt(),

//                 ///Section : -----///Onboarding -> Weight Selection///----------
//                 SelectWeightScreen(),

//                 ///Section : -----///Onboarding -> Weight Selection///----------
//                 SelectHeightScreenWidget(),

//                 ///Section : -----///Onboarding -> Country Selection///----------
//                 SelectCountryWidget(),

//                 ///Section : -----///Onboarding -> Diet Selection///----------
//                 SelectDietWidget(),

//                 ///Section : -----///Onboarding -> Food Allergies Selection///----------
//                 SelectFooodAllergiesWidget(),

//                 ///Section : -----///Onboarding -> Food Dislikes Selection///----------
//                 SelectDislikeFoodsWidget(),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.only(
//           left: UIHelper.kDefaulutPadding(),
//           right: UIHelper.kDefaulutPadding(),
//           bottom: 40.h,
//         ),
//         child: CustomElevatedButton(
//           onTap: () {
//             log("Continue Button Taped!");
//           },
//           buttonTitle: "Continue",
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/page_indicator.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_age/presentation/select_age_screen_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_blood_group/presentation/select_blood_group_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_country/presentation/select_country_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_diet/presentation/select_diet_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_dislike_foods/presentation/select_dislike_foods_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_food_allergies/presentation/select_foood_allergies_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_gender/presentation/select_gender_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_height/presentation/select_height_screen_widget.dart';
import 'package:bloodfit/features/information_gather/presentation/widgets/select_weight/presentation/select_weight_screen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/information_gather_screen_controller.dart';
import '../../../custom_widgets/go_back_widget.dart';
import '../../../gen/colors.gen.dart';
import '../../../routes/routes.dart';

class InformationGatherScreen extends StatelessWidget {
  const InformationGatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InformationGatherController controller = Get.put(
      InformationGatherController(),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top bar (Back button only)
              const CustomBackButton(),

              /// Page Indicators
              PageIndicator(controller: controller),

              /// PageView section
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: controller.updateCurrentIndex,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SelectBloodGroupWidget(),
                    SelectGenderWidget(),
                    SelectAgeScreenWidgt(),
                    SelectWeightScreen(),
                    SelectHeightScreenWidget(),
                    SelectCountryWidget(),
                    SelectDietWidget(),
                    SelectFooodAllergiesWidget(),
                    SelectDislikeFoodsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        width: 1.sw,
        height: 100.h,
        padding: EdgeInsets.only(
          left: UIHelper.kDefaulutPadding(),
          right: UIHelper.kDefaulutPadding(),
          bottom: 40.h,
        ),
        decoration: BoxDecoration(color: AppColors.scaffoldBackgroundColor),
        child: Obx(() {
          final isLastPage =
              controller.currentIndex.value == controller.totalPages - 1;
          return CustomElevatedButton(
            onTap: () {
              if (isLastPage) {
                // Finish onboarding or navigate to next screen
                log("Information Gathering Completed!");
                // Example navigation:
                Get.toNamed(Routes.dailyCaloriesIntakeScreen);
              } else {
                // Go to next page
                controller.nextPage();
              }
            },
            buttonTitle: isLastPage ? "Finish" : "Continue",
            buttonHeight: 60.h,
          );
        }),
      ),
    );
  }
}
