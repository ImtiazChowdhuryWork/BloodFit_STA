import 'package:bloodfit/features/my_profile/data/controller/profile_screen_controller.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

/// Called on every app launch when the user is already logged in,
/// before navigating to NavigationScreen.
///
/// Awaiting profile data here ensures the profile image is fully loaded
/// before the home screen renders — no default image flash for the user.
Future<void> performPostLoginActions() async {
  LoggerUtils.debug("╔══════════════════════════════════════════════════");
  LoggerUtils.debug("🚀 [POST-LOGIN] performPostLoginActions() started");
  LoggerUtils.debug("╚══════════════════════════════════════════════════");

  try {
    await Get.find<ProfileScreenController>().getMyProfileDataApi();
    LoggerUtils.debug("✅ [POST-LOGIN] getMyProfileDataApi() completed successfully");
  } catch (e) {
    LoggerUtils.error("❌ [POST-LOGIN] getMyProfileDataApi() threw an exception: $e");
  }

  LoggerUtils.debug("✅ [POST-LOGIN] performPostLoginActions() finished — navigating to home");

  // Fetch category, remainders, theme, and quotes data
  // await NotificationService.getToken();
  // await postDeviceTokenRXobj.postDeviceToken();
}
