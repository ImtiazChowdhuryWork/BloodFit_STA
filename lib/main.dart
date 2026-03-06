/**
import 'package:bloodfit/bindings/controllers_binding.dart';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/firebase_options.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/helper_methods.dart';
import 'package:bloodfit/loading_screen.dart';
import 'package:bloodfit/localization/presentation/languages.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  await diSetup();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    setInitialLanguagePreference(); // Ensure language preferences are set
    return LayoutBuilder(
      builder: (context, constraints) {
        return UtilScreenMobile();
      },
    );
  }
}

class UtilScreenMobile extends StatelessWidget {
  const UtilScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(375, 812),
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) async {
            showMaterialDialog(context);
          },
          child: GetMaterialApp(
            // home: WorkCompletedDetailsScreen(),
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: (appData.read(kKeyEnglish) ?? false)
                ? Locale('en', 'US')
                : (appData.read(kKeySouthKorean) ?? false)
                ? Locale('ko', 'KR')
                : Locale('en', 'US'),
            builder: (context, widget) {
              return MediaQuery(data: MediaQuery.of(context), child: widget!);
            },

            // initialRoute: Routes.welcomeScreen,
            // initialRoute: Routes.selectHeightScreenWidget,
            //initialRoute: Routes.navigationScreen,
            getPages: Routes.appRoutes,
            initialBinding: ControllerBindings(),
            home: Loading(),
            // home: SelectHeightScreenWidget(),
          ),
        );
      },
    );
  }
}
*/





///
///
///
///
/// todo:: keeping the new update for the langula loalization
///
///
///
///
///





import 'package:bloodfit/bindings/controllers_binding.dart';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/firebase_options.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/helper_methods.dart';
import 'package:bloodfit/loading_screen.dart';
import 'package:bloodfit/localization/presentation/languages.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'localization/presentation/language_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init(); // ✅ Initialize storage
  await diSetup();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    rotation();
    setInitValue();
    // ✅ Language preference is now handled in UtilScreenMobile via GetMaterialApp.locale
    return LayoutBuilder(
      builder: (context, constraints) {
        return const UtilScreenMobile();
      },
    );
  }
}

class UtilScreenMobile extends StatelessWidget {
  const UtilScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, _) async {
            showMaterialDialog(context);
          },
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,

            // 🌍 Translation Setup
            translations: Languages(),

            // ✅ Load saved locale from persistent storage
            locale: LanguagePreference.getSavedLocale(),
            fallbackLocale: const Locale('en', 'US'),

            // ✅ Save locale when it changes (persists across app restarts)
            builder: (context, widget) {
              // Listen to locale changes and save to storage
              if (Get.locale != null) {
                LanguagePreference.saveLocale(Get.locale!);
              }
              return MediaQuery(
                data: MediaQuery.of(context),
                child: widget!,
              );
            },

            getPages: Routes.appRoutes,
            initialBinding: ControllerBindings(),
            home: const Loading(),
          ),
        );
      },
    );
  }
}