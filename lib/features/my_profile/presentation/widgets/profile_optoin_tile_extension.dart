import 'package:bloodfit/constants/app_enums.dart';

extension ProfileOptoinTileExtension on ProfileOptionsTitle {
  String get label {
    switch (this) {
      case ProfileOptionsTitle.viewProfile:
        return "View Profile";

      case ProfileOptionsTitle.mealPlan:
        return "Mealplan";

      case ProfileOptionsTitle.fitNess:
        return "Fitness";

      case ProfileOptionsTitle.setTings:
        return "Settings";

      case ProfileOptionsTitle.subscriptoinType:
        return "Subscription: Starter";
    }
  }
}
