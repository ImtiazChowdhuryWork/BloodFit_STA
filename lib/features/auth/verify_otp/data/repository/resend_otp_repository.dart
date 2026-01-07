import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class ResendOtpRepository {
  final NetworkCaller _networkCaller;
  ResendOtpRepository(this._networkCaller);

  Future<NetworkResponse> resendOtpRepository({required String email}) async {
    final Map<String, dynamic> body = {'email': email};

    return _networkCaller.postRequest(Endpoints.resendOtp(), body: body);
  }
}
