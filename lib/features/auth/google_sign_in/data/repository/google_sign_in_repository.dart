import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository {
  final NetworkCaller _networkCaller;
  GoogleSignInRepository(this._networkCaller);

  // iOS client ID from GoogleService-Info.plist
  static const String _iosClientId =
      '161567192464-tm4d2b78b552jt399j7613eouah9s5cn.apps.googleusercontent.com';

  // Web client ID — required for the idToken to be populated
  static const String _webClientId =
      '161567192464-afcujudlgqa86qu70b2sgdkm61ennemm.apps.googleusercontent.com';

  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    await GoogleSignIn.instance.initialize(
      clientId: _iosClientId,
      serverClientId: _webClientId,
    );
    _initialized = true;
  }

  Future<NetworkResponse> googleSignInRepository() async {
    try {
      await _ensureInitialized();

      // Step 1: Open Google's account picker
      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      // Step 2: Get the idToken
      final String? idToken = googleUser.authentication.idToken;

      LoggerUtils.debug("🔑 Google idToken: $idToken");

      if (idToken == null) {
        return NetworkResponse(
          isSuccess: false,
          errorMessage: 'Failed to retrieve Google token',
        );
      }

      // Step 3: Send idToken to backend
      return _networkCaller.postRequest(
        Endpoints.googleSignIn(),
        body: {'idToken': idToken},
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return NetworkResponse(
          isSuccess: false,
          errorMessage: 'Sign-in cancelled',
        );
      }
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.description ?? 'Google sign-in failed',
      );
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}
