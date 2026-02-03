import 'dart:io';

import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../constants/app_constant_text.dart';
import '../constants/text_font_style.dart';
import '../controllers/select_height_screen_controller.dart';
import '../controllers/weight_picker_widget_controller.dart';
import '../custom_widgets/custom_button.dart';
import '../gen/colors.gen.dart';

Future<void> setInitValue() async {
  appData.writeIfNull(kKeyfirstTime, true);
  appData.writeIfNull(kKeySignUpToken, '');
  appData.writeIfNull(kKeyForgotPasswordToken, '');
  // appData.writeIfNull(kKeyIsMealPlanSubmitted, false);
  // Only set isLoggedIn to false if no access token exists
  // This ensures logout state persists
  if (!appData.hasData(kKeyAccessToken)) {
    await appData.writeIfNull(kKeyIsLoggedIn, false);
  }

  // this is a temporary token. which should be removed

  // DioSingleton.instance.update(
  //     "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL21vbGxpZS5taW5kYm9zc2NvYWNoaW5nLmNvbS9hcGkvbG9naW4iLCJpYXQiOjE3MjM0MzMwMTQsImV4cCI6MTcyNDAzNzgxNCwibmJmIjoxNzIzNDMzMDE0LCJqdGkiOiJQUlVxOHFoN2JnR0hyUEwyIiwic3ViIjoiMTYiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.SDEYU_UyYKWdDRW1NHQbbbmEgqAM64HE-b4_PVbSLoM");
  //lisbon
  // appData.writeIfNull(kKeySelectedLat, 38.74631383626653);
  // appData.writeIfNull(kKeySelectedLng, -9.130169921874991);
  //codemen

  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    appData.writeIfNull(
      kKeyDeviceID,
      iosDeviceInfo.identifierForVendor,
    ); // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo =
        await deviceInfo.androidInfo; // unique ID on Android
    appData.writeIfNull(kKeyDeviceID, androidDeviceInfo.id);
    // log('deviceInof $androidDeviceInfo');
  }
  await Future.delayed(const Duration(seconds: 2));
}

void setInitialLanguagePreference() {
  appData.writeIfNull(kKeyEnglish, true);
  appData.writeIfNull(kKeySouthKorean, false);
}

void showMaterialDialog(BuildContext context) {
  showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        "Do you want to exit the app?",
        textAlign: TextAlign.center,
        //
        style: TextFontStyle.headline12w500cfefefeStylePoppins,
      ),
      actions: <Widget>[
        CustomButton(
          text: "No",
          onTap: () {
            Navigator.of(context).pop(false);
          },
          height: 30.sp,
          minWidth: .3.sw,
          borderRadius: 30.r,
          color: AppColors.cF0F0F0,
          //
          textStyle: TextFontStyle.headline12w500cfefefeStylePoppins,
        ),
        CustomButton(
          text: "Yes",
          onTap: () {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else if (Platform.isIOS) {
              exit(0);
            }
          },
          height: 30.sp,
          minWidth: .3.sw,
          borderRadius: 30.r,
          color: AppColors.cb20000,
          //
          textStyle: TextFontStyle.headline12w500cfefefeStylePoppins,
        ),
      ],
    ),
  );
}

void rotation() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(80, 0, 0, 0),
      statusBarIconBrightness: Brightness.light,
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

bool removeAllSavedDataToLocalStorageForInformationGatherMealPlan() {
  try {
    ///---------->>> Remove the saved data after api hit is successfull

    ///--------->>> Remove Blood Group
    appData.remove(kKeyBloodGroup);

    ///--------->>> Remove Gender
    appData.remove(kKeyGender);

    ///--------->>> Remove User Age
    appData.remove(kKeyUserAge);

    ///--------->>> Remove User Weight (with unit)
    appData.remove(kKeyUserWeight);

    ///--------->>> Remove User Weight (without unit)
    appData.remove(kKeyUserWeightWithoutUnit);

    ///--------->>> Remove User Weight Unit
    appData.remove('${kKeyUserWeight}_unit');

    ///--------->>> Remove User Height (with unit)
    appData.remove(kKeyUserHeight);

    ///--------->>> Remove User Height (without unit)
    appData.remove(kKeyUserHeightWithoutUnit);

    ///--------->>> Remove User Height Unit
    appData.remove('${kKeyUserHeight}_unit');

    ///--------->>> Remove User Country Name
    appData.remove(kKeyUserCountryName);

    ///--------->>> Remove User Diet Type
    appData.remove(kKeyUserDietType);

    ///--------->>> Remove Food Allergies List
    appData.remove(kKeyUserFoodAlergisList);

    ///--------->>> Remove Food Dislike List
    appData.remove(kKeyUserDislLikeFoodList);

    ///---------->>> Remove Desired Weight (With Unit)
    appData.remove(kKeyDesiredWeight);

    ///--------->>> Remove Expected Body Shape
    appData.remove(kKeyExpectedBodyShape);

    ///--------->>> Remove Desired Weight (Withhout Unit)
    appData.remove(kKeyDesiredWeightWithoutUnit);

    // Reset interaction flags in controllers if they exist
    try {
      final weightController = Get.find<WeightController>(
        tag: 'current_weight',
      );
      weightController.hasUserInteracted.value = false;
    } catch (e) {
      LoggerUtils.debug("Weight controller not found for reset: $e");
    }

    try {
      final heightController = Get.find<SelectHeightScreenController>(
        tag: 'select_height_controller',
      );
      heightController.hasUserInteracted.value = false;
    } catch (e) {
      LoggerUtils.debug("Height controller not found for reset: $e");
    }

    // Verify all data is removed
    final isAllRemoved =
        appData.read(kKeyBloodGroup) == null &&
        appData.read(kKeyGender) == null &&
        appData.read(kKeyUserAge) == null &&
        appData.read(kKeyUserWeight) == null &&
        appData.read(kKeyUserWeightWithoutUnit) == null &&
        appData.read('${kKeyUserWeight}_unit') == null &&
        appData.read(kKeyUserHeight) == null &&
        appData.read(kKeyUserHeightWithoutUnit) == null &&
        appData.read('${kKeyUserHeight}_unit') == null &&
        appData.read(kKeyUserCountryName) == null &&
        appData.read(kKeyUserDietType) == null &&
        appData.read(kKeyUserFoodAlergisList) == null &&
        appData.read(kKeyUserDislLikeFoodList) == null &&
        appData.read(kKeyDesiredWeight) == null &&
        appData.read(kKeyExpectedBodyShape) == null &&
        appData.read('${kKeyDesiredWeightWithoutUnit}_unit') == null;

    LoggerUtils.debug("All data removed successfully: $isAllRemoved");

    return isAllRemoved;
  } catch (e) {
    LoggerUtils.error("Error removing data: $e");
    return false;
  }
}
