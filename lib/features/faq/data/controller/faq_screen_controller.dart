// 📁 faq_screen_controller.dart
import 'package:bloodfit/features/faq/data/model/faq_screen_model.dart';
import 'package:bloodfit/features/faq/data/reqository/faq_repository.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class FaqScreenController extends GetxController {
  ///-------->>> Import the Faq Repository
  final FaqRepository _faqRepository;
  FaqScreenController(this._faqRepository);

  // Store the complete API response model
  Rxn<FaqScreenModel> faqResponseModel = Rxn<FaqScreenModel>();

  // Store just the list of FAQs for easy UI access
  RxList<Datum> faqList = <Datum>[].obs;

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

    try {
      final response = await _faqRepository.faqRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        // Parse the complete model
        final model = FaqScreenModel.fromJson(response.jsonResponse!);

        // Store the complete model
        faqResponseModel.value = model;

        // Extract and store just the FAQ list
        faqList.value = model.data ?? []; // ← CORRECT: Extract .data!

        LoggerUtils.debug(
          "✅ Fetched FAQ Data Successfully! Found ${faqList.length} FAQs",
        );

        // Optional: Log server message
        if (model.message != null) {
          LoggerUtils.debug("Server message: ${model.message}");
        }
      } else {
        errorMessage.value = response.errorMessage.toString();
        LoggerUtils.error("❌ Failed to Get Faq Data: ${errorMessage.value}");
      }
    } catch (e) {
      errorMessage.value = e.toString();
      LoggerUtils.error("🚨 Error: ${errorMessage.value}");
    } finally {
      isLoading.value = false;
    }
  }
}
