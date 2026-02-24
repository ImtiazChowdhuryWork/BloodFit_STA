import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/information_gather_workout/data/repository/information_gather_workout_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/page_indicator_interface.dart';
import '../../../../helper/logger_util.dart';

class InformationGatherWorkOutController extends GetxController
    implements PageIndicatorInterface {
  ///-------->>> Section : Import Repository
  final InformationGatherWorkoutRepository _informationGatherWorkoutRepository;

  InformationGatherWorkOutController(this._informationGatherWorkoutRepository);
  late PageController pageController;

  @override
  final RxInt currentIndex = 0.obs;

  @override
  final int totalPages = 4; // Updated to match the 4 pages in PageView

  // Reactive variable to trigger button rebuild when data changes
  final RxBool _dataUpdated = false.obs;

  // Method to trigger button update from child widgets
  void triggerButtonUpdate() {
    _dataUpdated.toggle(); // Toggle to trigger Obx rebuild
    LoggerUtils.debug("Workout button update triggered");
  }

  // Getter for the reactive variable (used in Obx)
  RxBool get dataUpdated => _dataUpdated;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void nextPage() {
    if (currentIndex.value < totalPages - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage() {
    pageController.jumpToPage(totalPages - 1);
  }

  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  bool get isFirstPage => currentIndex.value == 0;
  bool get isLastPage => currentIndex.value == totalPages - 1;

  /// Reset the controller state for fresh start
  void reset() {
    currentIndex.value = 0;
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  ///------------<>>>> Section : Information Gather Workout Flow Starts Here

  RxBool isInfoWorkoutFlowLoading = false.obs;
  RxString infoWorkoutFlowErrorMessage = ''.obs;
  void clearInfoWorkoutErrorMessage() {
    infoWorkoutFlowErrorMessage.value = '';
  }

  RxString bodyShape = ''.obs;
  RxString activityLevel = ''.obs;
  RxString prefferedWorkoutLevel = ''.obs;
  RxList<String> focusAreaList = <String>[].obs;

  ///---------->>> Secton : Body Shape Check
  String? userBodyShapeCheck() {
    String? value = appData.read(kKeyCurrentBodyShape);
    if (value == null || value.isEmpty) {
      return '🥴🥴🥴 User Body Shape Not Found!';
    }
    bodyShape.value = value;
    LoggerUtils.debug("✍️✍️✍️✍️ User Body Shpae : ${bodyShape.value}");
    return null;
  }

  ///---------->>> Section : Activity Level
  String? userActivityLevelCheck() {
    String? value = appData.read(kKeyActivityLevel);

    if (value == null || value.isEmpty) {
      return '🥴🥴🥴 User Activity Level Not Found!';
    }
    activityLevel.value = value;
    LoggerUtils.debug("✍️✍️✍️✍️ User Activity Level : ${activityLevel.value}");
    return null;
  }

  ///---------->>> Section : Preffred Workout Level
  String? userPreffredWorkoutLevelCheck() {
    String? value = appData.read(kKeyPreffredWorkout);

    if (value == null || value.isEmpty) {
      return '🥴🥴🥴 User Preffered Workout Level Not Found!';
    }
    prefferedWorkoutLevel.value = value;
    LoggerUtils.debug(
      "✍️✍️✍️✍️ User Preffered Workout Level : ${prefferedWorkoutLevel.value}",
    );
    return null;
  }

  ///---------->>> Section : Focus Area Level
  String? userFocusAreaCheck() {
    List<String>? value = appData.read(kKeyWorkoutFocusArea);

    if (value == null || value.isEmpty) {
      return '🥴🥴🥴 User Focus Area Not Found!';
    }
    focusAreaList.value = value;
    LoggerUtils.debug("✍️✍️✍️✍️ User Focus Area: $focusAreaList");
    return null;
  }

  String? localStorageDataErrorCheck() {
    ///----->>> Section : Current Body-Shape Check
    final bodyShapeError = userBodyShapeCheck();
    if (bodyShapeError != null) return bodyShapeError;

    ///----->>> Section : Activity Level Check
    final activityLevelError = userActivityLevelCheck();
    if (activityLevelError != null) return activityLevelError;

    ///------>>> Section : Prefered Workout Level
    final prefferedWorkoutError = userPreffredWorkoutLevelCheck();
    if (prefferedWorkoutError != null) return prefferedWorkoutError;

    ///---------->>> Section : User Focus Area
    final userFocusAreaError = userFocusAreaCheck();
    if (userFocusAreaError != null) return userFocusAreaError;
  }

  Future<void> postInfoGatherWorkoutApi() async {
    try {
      isInfoWorkoutFlowLoading.value = true;
      clearInfoWorkoutErrorMessage();

      final validationError = localStorageDataErrorCheck();
      if (validationError != null) {
        infoWorkoutFlowErrorMessage.value = validationError;

        LoggerUtils.error(
          "🤬🤬Information Gather Workout Plan -> Validation Error : ${infoWorkoutFlowErrorMessage.value}",
        );
        return;
      }

      final response = await _informationGatherWorkoutRepository
          .informationGatherWorkoutRepository(
            bodyShapeData: bodyShape.value,
            activityLevelData: activityLevel.value,
            preferredWorkoutData: prefferedWorkoutLevel.value,
            focusAreaListData: focusAreaList,
          );

      if(response.statusCode == 200 && response.isSuccess){
        LoggerUtils.debug("😇😇😇😇Workout Information Submission to Api is Success Succes!");

        clearInfoGatherWorkoutData();

        LoggerUtils.debug("🤖🤖🤖🤖Removed Info Gather Workout Local Storage Data");
        Get.offAllNamed(Routes.youAreAllSetScreen);
      }else{
        LoggerUtils.error("Failed to Send Data to Information Workout Gather!");
        infoWorkoutFlowErrorMessage.value = response.errorMessage.toString();
      }
    } catch (error) {
      infoWorkoutFlowErrorMessage.value = error.toString();
      LoggerUtils.error(
        "🤮🤮🤮🤮Error Catched While Submiting Information Gather Workout Data Flow to API",
      );
      LoggerUtils.error("Catched Error : ${infoWorkoutFlowErrorMessage.value}");
    } finally {
      isInfoWorkoutFlowLoading.value = false;
    }
  }

  ///------------<>>>> Section : Information Gather Workout Flow Ends Here
  

  void clearInfoGatherWorkoutData(){
    appData.remove(kKeyCurrentBodyShape);
    appData.remove(kKeyActivityLevel);
    appData.remove(kKeyPreffredWorkout);
    appData.remove(kKeyWorkoutFocusArea);
  }
}
