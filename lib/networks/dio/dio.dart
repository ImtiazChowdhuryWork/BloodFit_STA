// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import '../../constants/app_constant_text.dart';
// import '../../endpoints.dart';
// import '../../helper/di.dart';
// import 'log.dart';

// final class DioSingleton {
//   static final DioSingleton _singleton = DioSingleton._internal();
//   static CancelToken cancelToken = CancelToken();
//   DioSingleton._internal();

//   static DioSingleton get instance => _singleton;

//   late Dio dio;

//   void create() {
//     BaseOptions options = BaseOptions(
//       baseUrl: url,
//       connectTimeout: const Duration(milliseconds: 100000),
//       receiveTimeout: const Duration(milliseconds: 100000),
//       headers: {
//         NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
//         // NetworkConstants.ACCEPT_LANGUAGE:
//         //     appData.read(kKeyCountryCode) ?? "en",
//         NetworkConstants.AUTHORIZATION:
//             "Bearer ${appData.read(kKeyAccessToken)}",
//       },
//     );
//     dio = Dio(options)..interceptors.add(Logger());
//   }

//   void update() {
//     if (kDebugMode) {
//       debugPrint("Dio update");
//     }
//     BaseOptions options = BaseOptions(
//       baseUrl: url,
//       responseType: ResponseType.json,
//       headers: {
//         NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
//         NetworkConstants.AUTHORIZATION:
//             "Bearer ${appData.read(kKeyAccessToken)}",
//         // NetworkConstants.ACCEPT_LANGUAGE: appData.read(kKeyLanguage) ?? "pt",
//         // NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
//       },
//       connectTimeout: const Duration(milliseconds: 100000),
//       receiveTimeout: const Duration(milliseconds: 100000),
//     );
//     dio = Dio(options)..interceptors.add(Logger());
//   }
// }

// Future<Response> postHttp(String path, [dynamic data]) => DioSingleton
//     .instance
//     .dio
//     .post(path, data: data, cancelToken: DioSingleton.cancelToken);

// Future<Response> putHttp(String path, [dynamic data]) => DioSingleton
//     .instance
//     .dio
//     .put(path, data: data, cancelToken: DioSingleton.cancelToken);

// Future<Response> getHttp(String path, [dynamic data]) =>
//     DioSingleton.instance.dio.get(path, cancelToken: DioSingleton.cancelToken);

// Future<Response> deleteHttp(String path, [dynamic data]) => DioSingleton
//     .instance
//     .dio
//     .delete(path, data: data, cancelToken: DioSingleton.cancelToken);

import 'package:dio/dio.dart' as dio_package;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import '../../constants/app_constant_text.dart';
import '../../endpoints.dart';
import '../../helper/di.dart';
import '../../routes/routes.dart';
import 'log.dart';

final class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  static dio_package.CancelToken cancelToken = dio_package.CancelToken();
  DioSingleton._internal();

  static DioSingleton get instance => _singleton;

  late dio_package.Dio dio;
  bool _isRefreshing = false;

  void create() {
    dio_package.BaseOptions options = dio_package.BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.AUTHORIZATION:
            "Bearer ${appData.read(kKeyAccessToken)}",
      },
    );

    dio = dio_package.Dio(options)
      ..interceptors.add(Logger())
      ..interceptors.add(_createTokenRefreshInterceptor());
  }

  dio_package.Interceptor _createTokenRefreshInterceptor() {
    return dio_package.InterceptorsWrapper(
      onError: (error, handler) async {
        // Check if it's a 401 Unauthorized error
        if (error.response?.statusCode == 401 && !_isRefreshing) {
          _isRefreshing = true;

          try {
            // Get new tokens using refresh token
            final newTokens = await _refreshTokens();

            if (newTokens != null) {
              // Update the failed request with new token
              error.requestOptions.headers[NetworkConstants.AUTHORIZATION] =
                  "Bearer ${newTokens['accessToken']}";

              // Create new request with updated token
              final opts = dio_package.Options(
                method: error.requestOptions.method,
                headers: error.requestOptions.headers,
              );

              // Retry the original request
              final response = await dio.request(
                error.requestOptions.path,
                data: error.requestOptions.data,
                queryParameters: error.requestOptions.queryParameters,
                options: opts,
              );

              return handler.resolve(response);
            } else {
              // Refresh failed - logout user
              _logoutUser();
              return handler.reject(error);
            }
          } catch (refreshError) {
            // Refresh failed - logout user
            _logoutUser();
            return handler.reject(error);
          } finally {
            _isRefreshing = false;
          }
        }

        return handler.reject(error);
      },
    );
  }

  Future<Map<String, String>?> _refreshTokens() async {
    try {
      final refreshToken = appData.read(kKeyRefreshToken);

      if (refreshToken == null) {
        debugPrint("❌ No refresh token available");
        throw Exception('No refresh token available');
      }

      debugPrint("🔄 Attempting token refresh...");

      // Call refresh endpoint with refresh token in header
      final response = await dio.post(
        Endpoints.refreshToken(),
        options: dio_package.Options(
          headers: {
            NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
            NetworkConstants.AUTHORIZATION: "Bearer $refreshToken",
          },
        ),
      );

      debugPrint("📥 Refresh response status: ${response.statusCode}");
      debugPrint("📥 Refresh response headers: ${response.headers}");

      if (response.statusCode == 200) {
        // Extract tokens from response headers
        final newAccessToken = response.headers['access-token']?.first;
        final newRefreshToken = response.headers['refresh-token']?.first;

        debugPrint(
          "🔑 New Access Token: ${newAccessToken != null ? '✓' : '✗'}",
        );
        debugPrint(
          "🔄 New Refresh Token: ${newRefreshToken != null ? '✓' : '✗'}",
        );

        if (newAccessToken != null) {
          // Store new tokens
          appData.write(kKeyAccessToken, newAccessToken);

          if (newRefreshToken != null) {
            appData.write(kKeyRefreshToken, newRefreshToken);
          }

          debugPrint("✅ Tokens refreshed successfully!");
          return {
            'accessToken': newAccessToken,
            'refreshToken': newRefreshToken ?? refreshToken,
          };
        } else {
          debugPrint("❌ No access token found in response headers");
          return null;
        }
      } else {
        debugPrint(
          "❌ Refresh endpoint returned status: ${response.statusCode}",
        );
        return null;
      }
    } catch (error) {
      debugPrint("❌ Token refresh failed: $error");
      return null;
    }
  }

  void _logoutUser() {
    // Clear tokens
    appData.remove(kKeyAccessToken);
    appData.remove(kKeyRefreshToken);

    // Navigate to login screen safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(Routes.signInScreen);
    });

    debugPrint("🔒 Token refresh failed - User logged out");
  }

  void update() {
    if (kDebugMode) {
      debugPrint(
        "Dio update - Token: ${appData.read(kKeyAccessToken)?.substring(0, 20)}...",
      );
    }

    // Clear previous interceptors and recreate
    dio.interceptors.clear();

    dio_package.BaseOptions options = dio_package.BaseOptions(
      baseUrl: url,
      responseType: dio_package.ResponseType.json,
      headers: {
        NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
        NetworkConstants.AUTHORIZATION:
            "Bearer ${appData.read(kKeyAccessToken)}",
      },
      connectTimeout: const Duration(milliseconds: 100000),
      receiveTimeout: const Duration(milliseconds: 100000),
    );

    dio = dio_package.Dio(options)
      ..interceptors.add(Logger())
      ..interceptors.add(_createTokenRefreshInterceptor());
  }
}

// HTTP method helpers
Future<dio_package.Response> postHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.post(
      path,
      data: data,
      cancelToken: DioSingleton.cancelToken,
    );

Future<dio_package.Response> putHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.put(
      path,
      data: data,
      cancelToken: DioSingleton.cancelToken,
    );

Future<dio_package.Response> getHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.get(path, cancelToken: DioSingleton.cancelToken);

Future<dio_package.Response> deleteHttp(String path, [dynamic data]) =>
    DioSingleton.instance.dio.delete(
      path,
      data: data,
      cancelToken: DioSingleton.cancelToken,
    );
