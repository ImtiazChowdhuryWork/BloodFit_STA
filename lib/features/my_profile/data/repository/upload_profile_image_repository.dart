import 'dart:io';
import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class UploadProfileImageRepository {
  final NetworkCaller _networkCaller;
  UploadProfileImageRepository(this._networkCaller);

  Future<NetworkResponse> uploadProfileImageRepository({
    required String imagePath,
  }) async {
    String? authToken = appData.read(kKeyAccessToken) ?? '';

    // Check if file exists
    File imageFile = File(imagePath);
    if (!await imageFile.exists()) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'File does not exist: $imagePath',
      );
    }

    // Prepare headers
    Map<String, String>? headers = authToken.isNotEmpty
        ? {'Authorization': 'Bearer $authToken'}
        : null;

    // Prepare files map
    Map<String, File> files = {
      'profilePicture': imageFile,
    };

    // Use the existing multipartPostRequest method from NetworkCaller
    return _networkCaller.multipartPostRequest(
      Endpoints.uploadProfileImage(),
      files: files,
      headers: headers,
    );
  }
}
