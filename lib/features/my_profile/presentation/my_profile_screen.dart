import 'package:bloodfit/constants/app_list.dart';
import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/my_profile/data/controller/profile_screen_controller.dart';
import 'package:bloodfit/custom_widgets/go_back_widget.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/log_out_button.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/profile_data_showing_list.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/profile_tags_showing_widget.dart';
import 'package:bloodfit/features/my_profile/presentation/widgets/show_user_type_buttons.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/custom_image_picker_controller.dart';
import '../../../custom_widgets/card_tile_option_widget.dart';
import '../../../custom_widgets/custom_image_picker_widget.dart';
import '../../../utils/image_picker_handler.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  final CustomImagePickerController imageController =
  Get.find<CustomImagePickerController>();

  late final ImagePickerHandler pickerHandler;

  final ProfileScreenController controller =
  Get.find<ProfileScreenController>();

  @override
  void initState() {
    super.initState();
    pickerHandler = ImagePickerHandler(imageController);

    // Set up image picker callback
    imageController.onImagePicked = () {
      Future.delayed(const Duration(milliseconds: 100), () {
        controller.postUploadProfileImage();
      });
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getMyProfileDataApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: const CustomBackButton(),
        title: Text(
          'my_profile'.tr,
          style: TextFontStyle.headline24w700cFFFFFFStylePoppins,
        ),
        actions: [
          // Language Toggle Switch in AppBar
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: _buildLanguageToggleSwitch(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// User Type Buttons
              ShowUserTypeButtons(),
              UIHelper.verticalSpace(10.h),

              /// Profile Image Picker
              CustomImagePickerWidget(
                controller: imageController,
                handler: pickerHandler,
                defaultImagePath: Assets.images.profileAvatarDefaultImage.path,
                editIconPath: Assets.icons.cameraIcon,
                shapeHeight: 120.h,
                shapeWidth: 120.w,
              ),
              UIHelper.verticalSpace(10.h),

              /// User Name
              Obx(() {
                return Text(
                  controller.reactiveFullName.value,
                  style: TextFontStyle.headline16w500cfefefeStylePoppins,
                );
              }),
              UIHelper.verticalSpace(5.h),

              /// Profile Tags (only for non-free users)
              Obx(() {
                return !controller.isFreeUser
                    ? Column(
                  children: [
                    ProfileTagShowingWidget(
                      dietType: 'classic_diet'.tr,
                      weightGainOrLooseTarget: 'lose_weight'.tr,
                    ),
                    UIHelper.verticalSpace(24.h),
                  ],
                )
                    : const SizedBox.shrink();
              }),

              /// Profile Data (only for non-free users)
              Obx(() {
                return !controller.isFreeUser
                    ? ProfileDataShowingWidget(myList: AppList.personalDataList)
                    : const SizedBox.shrink();
              }),

              UIHelper.verticalSpace(32.h),

              /// Profile Tiles based on subscription type
              Obx(() {
                final tiles = controller.isFreeUser
                    ? AppList.freeUserProfileTileList
                    : AppList.premimumUserProfileTileList;

                return ListView.separated(
                  itemCount: tiles.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) =>
                      UIHelper.verticalSpace(16.h),
                  itemBuilder: (context, index) {
                    final data = tiles[index];
                    return CardTileOptionWidget(
                      onTap: () => Get.toNamed(data.route),
                      imagePath: data.imagePath,
                      title: _getTranslatedTitle(data.title),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LogoutButton(
        onTap: () {
          _showLogoutDialog();
        },
        buttonTitle: 'logout'.tr,
      ),
    );
  }

  /// Language Toggle Switch Widget
  Widget _buildLanguageToggleSwitch() {
    return GestureDetector(
      onTap: _toggleLanguage,
      child: Container(
        width: 80.w,
        height: 32.h,
        decoration: BoxDecoration(
          color: AppColors.c2f772f.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.cFFFFFF.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Animated sliding background
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Get.locale?.languageCode == 'ko'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 36.w,
                height: 28.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: AppColors.c2f772f,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
            // Text labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'EN',
                      style: TextStyle(
                        color: Get.locale?.languageCode != 'ko'
                            ? AppColors.cFFFFFF
                            : AppColors.cFFFFFF.withOpacity(0.6),
                        fontWeight:
                        Get.locale?.languageCode != 'ko'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'KO',
                      style: TextStyle(
                        color: Get.locale?.languageCode == 'ko'
                            ? AppColors.cFFFFFF
                            : AppColors.cFFFFFF.withOpacity(0.6),
                        fontWeight:
                        Get.locale?.languageCode == 'ko'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 11.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleLanguage() {
    final currentLang = Get.locale?.languageCode ?? 'en';
    final newLocale = currentLang == 'ko'
        ? const Locale('en', 'US')
        : const Locale('ko', 'KR');

    Get.updateLocale(newLocale);

    // Show feedback
    Get.snackbar(
      'language'.tr,
      newLocale.languageCode == 'ko'
          ? 'korean_selected'.tr
          : 'english_selected'.tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.c2f772f,
      colorText: AppColors.cFFFFFF,
      duration: const Duration(seconds: 1),
      margin: EdgeInsets.all(10.w),
    );
  }

  /// Helper method to get translated titles
  String _getTranslatedTitle(String englishTitle) {
    // Map English titles to translation keys
    const Map<String, String> titleToKeyMap = {
      'Create Plan': 'create_plan',
      'My Progress': 'my_progress',
      'Settings': 'settings',
      'Help & Support': 'help_support',
      'My Dashboard': 'my_dashboard',
      'My Workouts': 'my_workouts',
      'Nutrition Plan': 'nutrition_plan',
      'Blood Analytics': 'blood_analytics',
      'Achievements': 'achievements',
      'Community': 'community',
    };

    final key = titleToKeyMap[englishTitle];
    return key != null ? key.tr : englishTitle;
  }

  /// Logout Dialog
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.c2f772f,
        title: Text(
          'logout'.tr,
          style: const TextStyle(color: AppColors.cFFFFFF),
        ),
        content: Text(
          'logout_confirmation'.tr,
          style: TextStyle(color: AppColors.cFFFFFF.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'cancel'.tr,
              style: const TextStyle(color: AppColors.c2f772f),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.logOutHelper();
            },
            child: Text(
              'confirm'.tr,
              style: const TextStyle(color: AppColors.c2f772f),
            ),
          ),
        ],
      ),
    );
  }
}