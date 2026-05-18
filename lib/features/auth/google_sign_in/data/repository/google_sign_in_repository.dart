import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInRepository {
  final NetworkCaller _networkCaller;
  GoogleSignInRepository(this._networkCaller);

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<NetworkResponse> googleSignInRepository() async {
    // Step 1: Open Google's account picker
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Sign-in cancelled',
      );
    }

    // Step 2: Get the idToken Google issues for this user
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final String? idToken = googleAuth.idToken;

    if (idToken == null) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Failed to retrieve Google token',
      );
    }

    // Step 3: Send idToken to backend — backend verifies it and returns our JWT
    return _networkCaller.postRequest(
      Endpoints.googleSignIn(),
      body: {'idToken': idToken},
    );
  }
}
