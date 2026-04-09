import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/custom_widgets/custom_elevated_button.dart';
import 'package:bloodfit/custom_widgets/food_item_data_helper_widget.dart';
import 'package:bloodfit/custom_widgets/meal_network_image_showing_widget.dart';
import 'package:bloodfit/features/home/data/controller/home_screen_controller.dart';
import 'package:bloodfit/features/home/data/model/swap_meal_options_model.dart';
import 'package:bloodfit/gen/assets.gen.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MealSwapOnboardingScreen extends StatefulWidget {
  const MealSwapOnboardingScreen({super.key});

  @override
  State<MealSwapOnboardingScreen> createState() =>
      _MealSwapOnboardingScreenState();
}

class _MealSwapOnboardingScreenState extends State<MealSwapOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final HomeScreenController _homeController;
  late final Alternative _selectedMeal;
  late final String _mealId;
  late final String _originalMealName;
  late final String _originalMealType;

  late final AnimationController _slideController;
  late final Animation<Offset> _oldMealSlide;
  late final Animation<Offset> _newMealSlide;
  late final Animation<double> _oldMealFade;
  late final Animation<double> _newMealFade;

  @override
  void initState() {
    super.initState();

    _homeController = Get.find<HomeScreenController>();

    final args = Get.arguments as Map<String, dynamic>;
    _selectedMeal = args['selectedMeal'] as Alternative;
    _mealId = (args['mealId'] as String?) ?? '';
    _originalMealName = (args['originalMealName'] as String?) ?? '';
    _originalMealType = (args['originalMealType'] as String?) ?? '';

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Old meal: slides out to the left
    _oldMealSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-1.5, 0),
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    // New meal: slides in from the right
    _newMealSlide = Tween<Offset>(
      begin: const Offset(1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));

    // Fade transitions for a cleaner swap feel
    _oldMealFade = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeIn));

    _newMealFade = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Auto-start animation after brief pause so user sees the current meal first
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  bool _isBase64(String? value) {
    if (value == null || value.isEmpty) return false;
    if (value.startsWith('data:image')) return true;
    if (value.startsWith('http://') || value.startsWith('https://')) return false;
    if (value.startsWith('/')) return false;
    if (value.startsWith('iVBORw0KGgo') || value.startsWith('/9j/') || value.startsWith('R0lGOD')) return true;
    return false;
  }

  void _confirmSwap() {
    LoggerUtils.debug("Button Tapped → Confirm Mealplan");

    final List<String> ingredientList = _selectedMeal.ingredients
            ?.map((i) => i.name ?? '')
            .where((n) => n.isNotEmpty)
            .toList() ??
        [];

    final List<Map<String, dynamic>> caloriesCount = [
      {
        'label': 'Carbohydrates',
        'kcal': _selectedMeal.macronutrients?.carbohydrates ?? 0,
      },
      {
        'label': 'Protein',
        'kcal': _selectedMeal.macronutrients?.protein ?? 0,
      },
      {
        'label': 'Fat',
        'kcal': _selectedMeal.macronutrients?.fat ?? 0,
      },
    ];

    // API expects a URL/path reference — never send raw base64 (causes "request entity too large")
    final String imageRef = _isBase64(_selectedMeal.image) ? '' : (_selectedMeal.image ?? '');

    LoggerUtils.debug("===== CONFIRM SWAP → PAYLOAD =====");
    LoggerUtils.debug("Meal ID        : $_mealId");
    LoggerUtils.debug("Description    : ${_selectedMeal.description}");
    LoggerUtils.debug("Ingredients    : $ingredientList");
    LoggerUtils.debug("Image (raw)    : ${_selectedMeal.image?.substring(0, (_selectedMeal.image?.length ?? 0).clamp(0, 80))}... isBase64=${_isBase64(_selectedMeal.image)}");
    LoggerUtils.debug("Image (sent)   : $imageRef");
    LoggerUtils.debug("Calory Count   : $caloriesCount");
    LoggerUtils.debug("==================================");

    _homeController.pathchSwapMealApi(
      mealID: _mealId,
      description: _selectedMeal.description ?? '',
      ingredientList: ingredientList,
      imageUrl: imageRef,
      caloriesCount: caloriesCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UIHelper.verticalSpace(0.05.sh),

              ///Section : Title
              Text(
                "Meal Swap",
                style: TextFontStyle.headline22w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(6.h),
              Text(
                "Swapping to a better option",
                style: TextFontStyle.headline12w500c999999StylePoppins,
              ),
              UIHelper.verticalSpace(34.h),

              ///Section : Animated image — current slides out, new slides in
              SizedBox(
                height: 250.h,
                child: AnimatedBuilder(
                  animation: _slideController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Current meal slides out to the left
                        SlideTransition(
                          position: _oldMealSlide,
                          child: FadeTransition(
                            opacity: _oldMealFade,
                            child: _CurrentMealPlaceholder(
                              mealName: _originalMealName,
                              mealType: _originalMealType,
                            ),
                          ),
                        ),

                        // New meal slides in from the right
                        SlideTransition(
                          position: _newMealSlide,
                          child: FadeTransition(
                            opacity: _newMealFade,
                            child: CustomNetworkImageWidget(
                              imageUrl: _selectedMeal.image ?? '',
                              mealType: _selectedMeal.category ?? '',
                              width: 250.w,
                              height: 250.h,
                              isClipOval: false,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              UIHelper.verticalSpace(30.h),

              ///Section : New Meal Name
              Text(
                _selectedMeal.mealName ?? '',
                style: TextFontStyle.headline18w500cfefefeStylePoppins,
                textAlign: TextAlign.center,
              ),
              UIHelper.verticalSpace(8.h),

              ///Section : Meal Type + Kcal
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FoodItemDataHelperWidget(
                    iconPath: Assets.icons.mealIcon,
                    iconColor: AppColors.cfefefe,
                    title:
                        (_selectedMeal.category ?? '').capitalizeFirst ?? '',
                    value: 0,
                    isValueVisible: false,
                  ),
                  UIHelper.horizontalSpace(20.w),
                  Container(
                    width: 2.sp,
                    height: 20.h,
                    color: AppColors.c282828,
                  ),
                  UIHelper.horizontalSpace(20.w),
                  FoodItemDataHelperWidget(
                    title: "Kcal",
                    iconPath: Assets.icons.fireRed,
                    value: _selectedMeal.totalCalories ?? 0,
                  ),
                ],
              ),
              UIHelper.verticalSpace(8.h),

              ///Section : Description
              Text(
                _selectedMeal.description ?? '',
                textAlign: TextAlign.center,
                style: TextFontStyle.headline14w500c999999StylePoppins,
              ),
              UIHelper.verticalSpace(24.h),

              ///Section : Confirm Button
              Obx(
                () => CustomElevatedButton(
                  isLoading: _homeController.isSwapMealValueLoading.value,
                  onTap: _homeController.isSwapMealValueLoading.value
                      ? null
                      : _confirmSwap,
                  buttonWidth: 1.sw,
                  buttonHeight: 52.h,
                  borderRadius: 24.r,
                  buttonTitle: "Confirm Mealplan",
                ),
              ),
              UIHelper.verticalSpace(32.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder shown for the current (outgoing) meal during animation
// ─────────────────────────────────────────────────────────────────────────────
class _CurrentMealPlaceholder extends StatelessWidget {
  final String mealName;
  final String mealType;

  const _CurrentMealPlaceholder({
    required this.mealName,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            Assets.images.foodLudusImage.path,
            width: 250.w,
            height: 250.h,
            fit: BoxFit.cover,
          ),
          // Dark overlay with meal info
          Container(
            width: 250.w,
            height: 250.h,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  mealName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  mealType.capitalizeFirst ?? '',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
