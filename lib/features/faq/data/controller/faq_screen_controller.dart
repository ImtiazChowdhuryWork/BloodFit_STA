// 📁 faq_screen_controller.dart
import 'package:bloodfit/features/faq/data/model/faq_screen_model.dart';
import 'package:bloodfit/features/faq/data/reqository/faq_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class FaqScreenController extends GetxController {
  ///-------->>> Import the Faq Repository
  final FaqRepository _faqRepository;
  FaqScreenController(this._faqRepository);
  // Rxn<FaqScreenModel> model = Rxn<FaqScreenModel>();

  /// Holds the index of the currently expanded FAQ (-1 means none)
  final RxInt expandedIndex = (-1).obs;

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // collapse if tapped again
    } else {
      expandedIndex.value = index; // open new one
    }
  }

  ///----->>> Faq Screen Api Implementation Starts here
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  void clearErrorMessage() {
    errorMessage.value = '';
  }

  Future<void> getFaqScreenApi() async {
    clearErrorMessage();

    isLoading.value = true;
    final response = await _faqRepository.faqRepository();

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        LoggerUtils.debug("😇😇😇😇😇😇Fetched FAQ Data Successfully!");
      } catch (e) {
        errorMessage.value = e.toString();
        LoggerUtils.error("Error Catched : ${errorMessage.value}");
      } finally {
        isLoading.value = false;
        LoggerUtils.error(
          "🥴🥴🥴🥴🥴🥴🥴Something Went Wrong : ${errorMessage.value}",
        );
      }
    } else {
      isLoading.value = false;
      errorMessage.value = response.errorMessage.toString();
      LoggerUtils.error(
        "😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫😵‍💫Failed to Get Faq Data!",
      );
    }
  }
}
