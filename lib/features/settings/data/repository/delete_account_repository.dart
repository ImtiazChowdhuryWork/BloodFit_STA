import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class DeleteAccountRepository {
  final NetworkCaller _networkCaller;
  DeleteAccountRepository(this._networkCaller);

  Future<NetworkResponse> deleteAccountRepository() async {
    ///--------->>> Read Saved Values
    String userId = appData.read(kKeyUserID);
    String? accessToken = appData.read(kKeyAccessToken) ?? '';

    ///--------->>> Log the saved values
    LoggerUtils.debug("User ID : $userId");
    LoggerUtils.debug("Access Token: $accessToken");

    return _networkCaller.deleteRequest(
      Endpoints.deleteAccount(userId: userId),
      headers: accessToken.isNotEmpty
          ? {'Authorization': 'Bearer $accessToken'}  // Fixed: Removed extra space and colon
          : null,
    );
  }
}
