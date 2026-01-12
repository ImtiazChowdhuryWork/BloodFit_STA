import 'package:bloodfit/features/terms_and_conditions/data/repository/terms_and_conditions_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

import '../model/terms_and_conditions_screen_model.dart';

class TermsAndConditionsScreenController extends GetxController {
  final TermsAndConditionsRepository _termsAndConditionsRepository;
  TermsAndConditionsScreenController(this._termsAndConditionsRepository);
  Rxn<TermsAndConditionsScreenModel> model =
      Rxn<TermsAndConditionsScreenModel>();

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> getTermsAndConditionsApi() async {
    clearErrorMessage();
    isLoading.value = true;

    final response = await _termsAndConditionsRepository
        .termsAndConditionsRepository();

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        model.value = TermsAndConditionsScreenModel.fromJson(
          response.jsonResponse!,
        );
      } catch (e) {
        errorMessage.value = e.toString();
        LoggerUtils.error("Something Went Wrong : ${errorMessage.value}");
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      errorMessage.value = response.errorMessage.toString();
      LoggerUtils.error("🤡🤡🤡🤡🤡Failed to get Terms And Conditions!");
      LoggerUtils.error(
        "🤐🤐🤐🤐🤐Terms And Conditions Err : ${errorMessage.value}",
      );
    }
  }

  String get termsAndConditions => model.value?.data?.description ?? '';
}
