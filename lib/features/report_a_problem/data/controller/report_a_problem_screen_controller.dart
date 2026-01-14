import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/report_a_problem/data/model/report_a_problem_model.dart';
import 'package:bloodfit/features/report_a_problem/data/repository/report_a_problem_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ReportAProblemScreenController extends GetxController {
  final ReportAProblemRepository _reportAProblemRepository;
  ReportAProblemScreenController(this._reportAProblemRepository);
  Rxn<ReportAProblemModel> model = Rxn<ReportAProblemModel>();
  TextEditingController describedProblemController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString selectedProblemType = ''.obs;
  RxString errorMessage = ''.obs;

  void clearErrorMessage() {
    errorMessage.value = '';
  }

  void clearTheSelectedValues() {
    selectedProblemType.value = '';
    describedProblemController.clear();
  }

  String userName = '';
  String userEmail = '';

  readUserNameAndEmail() {
    userName = appData.read(kKeyUserName);
    userEmail = appData.read(kKeyEmail);
  }

  /// Form validation using external validators
  String? validateForm() {
    readUserNameAndEmail();

    ///----> Validator : Name
    final name = userName;
    if (name.isEmpty) return 'Name is required';

    ///----> Validator : Email
    final email = userEmail;
    if (email.isEmpty) return 'Email is required';

    ///------>>> Problem Type
    final problemType = selectedProblemType.value;
    if (problemType.isEmpty) return 'Problem type is required';

    ///------>>>> Problem Description
    final problemDescription = describedProblemController.text.trim();
    if (problemDescription.isEmpty) return 'Problem description is required';

    return null;
  }

  void setSelectedProblemType({required String problemType}) {
    selectedProblemType.value = problemType;
    LoggerUtils.debug(
      "🤫🤫🤫🤫🤫🤫Selected Problem Type : ${selectedProblemType.value}",
    );
  }

  Future<void> postReportAProblemApi() async {
    clearErrorMessage();

    final error = validateForm();
    if (error != null) {
      errorMessage.value = error;
      return;
    }
    await readUserNameAndEmail();

    LoggerUtils.debug("Name : $userName");
    LoggerUtils.debug("Email : $userEmail");
    LoggerUtils.debug("Selected Problem Type : ${selectedProblemType.value}");
    LoggerUtils.debug(
      "Problem Description : ${describedProblemController.text.trim()}",
    );
    isLoading.value = true;

    final response = await _reportAProblemRepository.reportaproblemrepository(
      name: userName,
      email: userEmail,
      problem: selectedProblemType.value,
      message: describedProblemController.text.trim(),
    );

    if (response.statusCode == 200 && response.isSuccess) {
      try {
        model.value = ReportAProblemModel.fromJson(response.jsonResponse!);
        if (model.value?.status == 200 && response.isSuccess) {
          LoggerUtils.info(
            "🥳🥳🥳🥳🥳🥳🥳Success : At submiting Report a problem ",
          );
          clearTheSelectedValues();
        }
      } catch (e) {
        errorMessage.value = e.toString();
        LoggerUtils.error(
          "🥴🥴🥴🥴🥴🥴🥴Failed : While submiting : Described Problem!",
        );
        LoggerUtils.error("Failed Error : ${errorMessage.value}");
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
      errorMessage.value = response.errorMessage.toString();
      LoggerUtils.error("🤐🤐🤐🤐🤐Failed to submit Problem!");
      LoggerUtils.error(
        "Report a Problem Submission Error : ${errorMessage.value}",
      );
    }
  }
}
