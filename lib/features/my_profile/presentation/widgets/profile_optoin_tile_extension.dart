import 'package:bloodfit/constants/app_enums.dart';
import 'package:get/get.dart';

extension ProfileOptionTileExtension on ProfileOptionsTitle {
  String get label {
    switch (this) {
      case ProfileOptionsTitle.viewProfile:
        return 'view_profile'.tr; // ✅ Translation key

      case ProfileOptionsTitle.mealPlan:
        return 'meal_plan'.tr; // ✅ Translation key

      case ProfileOptionsTitle.fitNess:
        return 'fitness'.tr; // ✅ Translation key

      case ProfileOptionsTitle.setTings:
        return 'settings'.tr; // ✅ Translation key

      case ProfileOptionsTitle.subscriptoinType:
        return 'subscription_starter'.tr; // ✅ Translation key
    }
  }
}