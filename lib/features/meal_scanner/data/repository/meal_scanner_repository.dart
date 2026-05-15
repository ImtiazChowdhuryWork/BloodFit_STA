import 'dart:io';

import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/endpoints.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/networks/network_caller.dart';
import 'package:bloodfit/networks/network_response.dart';

class MealScannerRepository {
  final NetworkCaller _networkCaller;
  MealScannerRepository(this._networkCaller);

  /// Sends the captured image to the AI scan endpoint.
  /// The backend expects a multipart POST with field name 'image'.
  Future<NetworkResponse> scanFood({required String imagePath}) async {
    final String authToken = appData.read(kKeyAccessToken) ?? '';

    final Map<String, String>? headers = authToken.isNotEmpty
        ? {'Authorization': 'Bearer $authToken'}
        : null;

    return _networkCaller.multipartPostRequest(
      Endpoints.scanFood(),
      files: {'image': File(imagePath)},
      headers: headers,
    );
  }
}
