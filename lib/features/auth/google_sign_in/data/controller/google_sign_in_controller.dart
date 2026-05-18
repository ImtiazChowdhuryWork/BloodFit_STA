import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/google_sign_in/data/repository/google_sign_in_repository.dart';
import 'package:bloodfit/features/auth/sign_in/data/model/sign_model.dart';
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
      final response =
          await _googleSignInRepository.googleSignInRepository();

      if (response.statusCode == 200 && response.isSuccess) {
        final model = SignInModel.fromJson(response.jsonResponse!);
        final token = model.data?.token;

        if (token != null && token.isNotEmpty) {
          appData.write(kKeyAccessToken, token);
          appData.write(kKeyUserName, model.data?.user?.name ?? '');
          appData.write(kKeyEmail, model.data?.user?.email ?? '');
          appData.write(kKeyUserID, model.data?.user?.id ?? '');

          LoggerUtils.info('[Google Sign-In] Success — token stored');

          final hasHealthDetails =
              model.data?.user?.healthDetails ?? false;

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
        // User cancelled returns isSuccess:false with no statusCode — don't show error
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
