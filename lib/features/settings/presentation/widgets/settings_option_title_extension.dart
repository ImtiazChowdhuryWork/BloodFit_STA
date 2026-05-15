import 'package:bloodfit/constants/app_enums.dart';
import 'package:get/get.dart';

extension SettingsOptionTitleExtension on SettingsOptionTitle {
  String get label {
    switch (this) {
      case SettingsOptionTitle.language:
        return 'language'.tr;
      case SettingsOptionTitle.changePassword:
        return 'change_password'.tr;
      case SettingsOptionTitle.termsAndConditions:
        return 'terms_conditions'.tr;
      case SettingsOptionTitle.privacyPolicy:
        return 'privacy_policy'.tr;
      case SettingsOptionTitle.reportAProblem:
        return 'report_problem'.tr;
      case SettingsOptionTitle.faq:
        return 'faq'.tr;
      case SettingsOptionTitle.deleteAccount:
        return 'delete_account'.tr;
    }
  }
}
