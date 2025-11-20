import 'package:dio/dio.dart' as dio_package;
import 'package:get/get.dart';

import '../networks/dio/dio.dart';
import '../networks/exception_handler/data_source.dart';

final class ApiService extends GetxService {
  ApiService._internal();
  static final ApiService _singleton = ApiService._internal();

  static ApiService get instance => _singleton;

  @override
  Future<void> onInit() async {
    DioSingleton.instance.create();
    super.onInit();
  }

  dynamic _handleSuccessResponse(dio_package.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'data': response.data,
        'headers': response.headers.map,
        'status-code': response.statusCode,
      };
    } else {
      throw dio_package.DioException(
        response: response,
        requestOptions: response.requestOptions,
        type: dio_package.DioExceptionType.badResponse,
      );
    }
  }

  Future<dynamic> post(String path, [dynamic data]) async {
    try {
      final response = await postHttp(path, data);
      return _handleSuccessResponse(response);
    } catch (error) {
      final handledError = ErrorHandler.handle(error);
      throw handledError.failure;
    }
  }

  Future<dynamic> get(
    String path, [
    Map<String, dynamic>? queryParameters,
  ]) async {
    try {
      final response = await getHttp(path);
      return _handleSuccessResponse(response);
    } catch (error) {
      final handledError = ErrorHandler.handle(error);
      throw handledError.failure;
    }
  }

  Future<dynamic> put(String path, [dynamic data]) async {
    try {
      final response = await putHttp(path, data);
      return _handleSuccessResponse(response);
    } catch (error) {
      final handledError = ErrorHandler.handle(error);
      throw handledError.failure;
    }
  }

  Future<dynamic> delete(String path, [dynamic data]) async {
    try {
      final response = await deleteHttp(path, data);
      return _handleSuccessResponse(response);
    } catch (error) {
      final handledError = ErrorHandler.handle(error);
      throw handledError.failure;
    }
  }

  void updateHeaders() {
    DioSingleton.instance.update();
  }

  void cancelRequests() {
    DioSingleton.cancelToken.cancel('Request cancelled by user');
  }
}
