import 'package:bloodfit/features/privacy_policy/data/model/privacy_policy_model.dart';
import 'package:bloodfit/features/privacy_policy/data/repository/privacy_policy_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  final PrivacyPolicyRepository _privacyPolicyRepository;
  Rxn<PrivacyPolicyScreenModel> model = Rxn<PrivacyPolicyScreenModel>();
  PrivacyPolicyController(this._privacyPolicyRepository);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> getTermsAndConditionsApi() async {
    clearErrorMessage();
    isLoading.value = true;

    final response = await _privacyPolicyRepository.privacyPolicyRepository();

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        model.value = PrivacyPolicyScreenModel.fromJson(response.jsonResponse!);

        if (model.value?.data?.description != null) {
          LoggerUtils.debug("😇😇😇Privacy Policy api hit success!");
        }
      } catch (e) {
        errorMessage.value = e.toString();
        LoggerUtils.error("Something Went Wrong!");
      } finally {
        isLoading.value = false;
      }
    } else {
      LoggerUtils.error("🤯🤯🤯🤯🤯Failed to Get Privacy Policy!");
      LoggerUtils.error(
        "🤯🤯🤯🤯🤯Privacy Policy Error : ${errorMessage.value}",
      );
    }
  }

  String get privacyPolicyDescription => model.value?.data?.description ?? '';
}
