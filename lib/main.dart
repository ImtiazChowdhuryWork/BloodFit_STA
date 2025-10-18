import 'package:bloodfit/bindings/controllers_binding.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await diSetup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(375, 812),
      designSize: const Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          // home: WorkCompletedDetailsScreen(),
          debugShowCheckedModeBanner: false,

          // initialRoute: Routes.welcomeScreen,
          initialRoute: Routes.navigationScreen,
          //initialRoute: Routes.navigationScreen,
          getPages: Routes.appRoutes,
          initialBinding: ControllerBindings(),
        );
      },
    );
  }
}
