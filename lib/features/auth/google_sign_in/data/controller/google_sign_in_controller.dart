import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/google_sign_in/data/repository/google_sign_in_repository.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/routes/routes.dart';
import 'package:get/get.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignInRepository _googleSignInRepository;
  GoogleSignInController(this._googleSignInRepository);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  void clearError() => errorMessage.value = '';

  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    clearError();

    try {
      final response = await _googleSignInRepository.googleSignInRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        final json = response.jsonResponse!;

        // token and user fields are both inside "data"
        final data = json['data'] as Map<String, dynamic>?;
        final token = data?['token'] as String?;

        if (token != null && token.isNotEmpty) {
          final firstName = data?['firstName'] as String? ?? '';
          final lastName = data?['lastName'] as String? ?? '';
          final fullName = '$firstName $lastName'.trim();

          appData.write(kKeyAccessToken, token);
          appData.write(kKeyUserName, fullName);
          appData.write(kKeyEmail, data?['email'] ?? '');
          appData.write(kKeyUserID, data?['id'] ?? '');

          LoggerUtils.info('[Google Sign-In] Success — token stored');

          final hasHealthDetails = data?['healthDetails'] as bool? ?? false;

          if (hasHealthDetails) {
            Get.offAllNamed(Routes.navigationScreen);
          } else {
            Get.offAllNamed(Routes.informationGatherMealScreen);
          }
        } else {
          errorMessage.value = 'Google sign-in failed. Please try again.';
          LoggerUtils.error('[Google Sign-In] Token missing in response');
        }
      } else {
        if (response.errorMessage != 'Sign-in cancelled') {
          errorMessage.value =
              response.errorMessage ?? 'Google sign-in failed. Please try again.';
        }
        LoggerUtils.error(
          '[Google Sign-In] Failed — ${response.statusCode} | ${response.errorMessage}',
        );
      }
    } catch (e) {
      errorMessage.value = 'Google sign-in failed. Please try again.';
      LoggerUtils.error('[Google Sign-In] Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
