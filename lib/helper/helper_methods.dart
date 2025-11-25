import 'dart:io';

import 'package:bloodfit/helper/di.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constant_text.dart';
import '../constants/text_font_style.dart';
import '../custom_widgets/custom_button.dart';
import '../gen/colors.gen.dart';

Future<void> setInitValue() async {
  appData.writeIfNull(kKeyfirstTime, true);
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
