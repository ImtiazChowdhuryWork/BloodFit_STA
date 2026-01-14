import 'package:bloodfit/constants/app_enums.dart';

extension SettingsOptionTitleExtension on SettingsOptionTitle {
  String get label {
    switch (this) {
      case SettingsOptionTitle.changePassword:
        return "Change Password";
      case SettingsOptionTitle.termsAndConditions:
        return "Terms And Conditions";
      case SettingsOptionTitle.privacyPolicy:
        return "Privacy Policy";
      case SettingsOptionTitle.reportAProblem:
        return "Report A Problem";
      case SettingsOptionTitle.faq:
        return "FAQ";
      case SettingsOptionTitle.deleteAccount:
        return "Delete Account";
    }
  }
}
