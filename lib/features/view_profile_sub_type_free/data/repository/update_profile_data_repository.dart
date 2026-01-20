import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class UpdateProfileDataRepository {
  final NetworkCaller _networkCaller;
  UpdateProfileDataRepository(this._networkCaller);

  Future<NetworkResponse> updateProfileDataRepository({
    String? firstName,
    String? lastName,
    String? email,
    String? contactNumber,
  }) async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';
    Map<String, dynamic> data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
    };
    return _networkCaller.patchRequest(
      Endpoints.updateProfileData(),
      body: data,
      headers: authToken.isNotEmpty
          ? {'Authorization': 'Bearer $authToken'}
          : null,
    );
  }
}
