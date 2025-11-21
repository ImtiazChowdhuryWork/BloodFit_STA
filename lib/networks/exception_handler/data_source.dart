// // ignore_for_file: constant_identifier_names
// import 'dart:developer';
// import 'package:bloodfit/networks/exception_handler/error_response.dart';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;

// enum DataSource {
//   SUCCESS,
//   NO_CONTENT,
//   BAD_REQUEST,
//   UNAUTORISED,
//   NOT_FOUND,
//   INTERNAL_SERVER_ERROR,
//   CONNECT_TIMEOUT,
//   CANCEL,
//   RECIEVE_TIMEOUT,
//   SEND_TIMEOUT,
//   CACHE_ERROR,
//   NO_INTERNET_CONNECTION,
//   OTP_VERIFY,
//   DEFAULT,
//   CONFLICT,
// }

// extension DataSourceExtension on DataSource {
//   Failure getFailure() {
//     switch (this) {
//       case DataSource.SUCCESS:
//         return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
//       case DataSource.NO_CONTENT:
//         return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
//       case DataSource.BAD_REQUEST:
//         return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
//       case DataSource.UNAUTORISED:
//         return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
//       case DataSource.NOT_FOUND:
//         return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
//       case DataSource.INTERNAL_SERVER_ERROR:
//         return Failure(
//           ResponseCode.INTERNAL_SERVER_ERROR,
//           ResponseMessage.INTERNAL_SERVER_ERROR,
//         );
//       case DataSource.CONNECT_TIMEOUT:
//         return Failure(
//           ResponseCode.CONNECT_TIMEOUT,
//           ResponseMessage.CONNECT_TIMEOUT,
//         );
//       case DataSource.CANCEL:
//         return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
//       case DataSource.RECIEVE_TIMEOUT:
//         return Failure(
//           ResponseCode.RECIEVE_TIMEOUT,
//           ResponseMessage.RECIEVE_TIMEOUT,
//         );
//       case DataSource.SEND_TIMEOUT:
//         return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
//       case DataSource.CACHE_ERROR:
//         return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
//       case DataSource.NO_INTERNET_CONNECTION:
//         return Failure(
//           ResponseCode.NO_INTERNET_CONNECTION,
//           ResponseMessage.NO_INTERNET_CONNECTION,
//         );
//       case DataSource.OTP_VERIFY:
//         return Failure(ResponseCode.OTP_VERIFY, ResponseMessage.OTP_VERIFY);
//       case DataSource.CONFLICT:
//         return Failure(ResponseCode.CONFLICT, ResponseMessage.CONFLICT);
//       case DataSource.DEFAULT:
//         return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
//     }
//   }
// }

// final class Failure {
//   final int resonseCode;
//   final String responseMessage;

//   Failure(this.resonseCode, this.responseMessage);
// }

// final class ErrorHandler implements Exception {
//   late Failure failure;

//   ErrorHandler.handle(dynamic error) {
//     if (error is DioException) {
//       failure = _handleError(error);
//     } else {
//       log(error.toString());
//       failure = DataSource.DEFAULT.getFailure();
//     }
//   }

//   Failure _handleError(DioException error) {
//     switch (error.type) {
//       case DioExceptionType.connectionTimeout:
//         return DataSource.CONNECT_TIMEOUT.getFailure();
//       case DioExceptionType.sendTimeout:
//         return DataSource.SEND_TIMEOUT.getFailure();
//       case DioExceptionType.receiveTimeout:
//         return DataSource.RECIEVE_TIMEOUT.getFailure();
//       case DioExceptionType.badResponse:
//         return _handleBadResponse(error);
//       case DioExceptionType.cancel:
//         return DataSource.CANCEL.getFailure();
//       default:
//         return DataSource.DEFAULT.getFailure();
//     }
//   }

//   Failure _handleBadResponse(DioException error) {
//     if (error.response == null) {
//       return DataSource.DEFAULT.getFailure();
//     }

//     final response = error.response!;
//     final statusCode = response.statusCode ?? 0;

//     // 🆕 EXTRACT CUSTOM MESSAGE FROM RESPONSE
//     final customMessage = _extractCustomErrorMessage(response);

//     // 🆕 DEBUG LOG TO SEE WHAT'S BEING EXTRACTED
//     log("🔍 Error Response Body: ${response.data}");
//     log("🔍 Extracted Message: $customMessage");
//     log("🔍 Status Code: $statusCode");

//     // 🆕 IF WE HAVE A CUSTOM MESSAGE, USE IT WITH THE STATUS CODE
//     if (customMessage.isNotEmpty) {
//       return Failure(statusCode, customMessage);
//     }

//     // 🆕 FALLBACK: MAP STATUS CODE TO APPROPRIATE FAILURE
//     return _mapStatusCodeToFailure(statusCode);
//   }

//   String _extractCustomErrorMessage(Response response) {
//     try {
//       final responseData = response.data;

//       log("🔍 Raw error response: $responseData");

//       if (responseData == null) return "";

//       if (responseData is Map<String, dynamic>) {
//         // 🆕 PRIORITIZE 'message' FIELD OVER 'error' FIELD
//         if (responseData.containsKey('message') &&
//             responseData['message'] != null) {
//           final message = responseData['message'].toString();
//           if (message.isNotEmpty) {
//             log("🔍 Using 'message' field: $message");
//             return message;
//           }
//         }

//         // 🆕 THEN CHECK 'error' FIELD
//         if (responseData.containsKey('error') &&
//             responseData['error'] != null) {
//           final error = responseData['error'].toString();
//           if (error.isNotEmpty) {
//             log("🔍 Using 'error' field: $error");
//             return error;
//           }
//         }

//         // Check other possible fields as fallback
//         final possibleFields = ['detail', 'msg', 'description', 'reason'];
//         for (final field in possibleFields) {
//           if (responseData.containsKey(field) && responseData[field] != null) {
//             final message = responseData[field].toString();
//             if (message.isNotEmpty) {
//               log("🔍 Using '$field' field: $message");
//               return message;
//             }
//           }
//         }
//       }

//       // If response data is a string, use it directly
//       if (responseData is String && responseData.isNotEmpty) {
//         log("🔍 Using string response: $responseData");
//         return responseData;
//       }

//       // Final fallback to status message
//       final statusMessage = response.statusMessage ?? "";
//       log("🔍 Using status message: $statusMessage");
//       return statusMessage;
//     } catch (e) {
//       log("❌ Error extracting custom message: $e");
//       return response.statusMessage ?? "An error occurred";
//     }
//   }

//   Failure _mapStatusCodeToFailure(int statusCode) {
//     switch (statusCode) {
//       case ResponseCode.BAD_REQUEST:
//         return DataSource.BAD_REQUEST.getFailure();
//       case ResponseCode.UNAUTORISED:
//         return DataSource.UNAUTORISED.getFailure();
//       case ResponseCode.NOT_FOUND:
//         return DataSource.NOT_FOUND.getFailure();
//       case ResponseCode.INTERNAL_SERVER_ERROR:
//         return DataSource.INTERNAL_SERVER_ERROR.getFailure();
//       case ResponseCode.CONFLICT:
//         return DataSource.CONFLICT.getFailure();
//       default:
//         return DataSource.DEFAULT.getFailure();
//     }
//   }
// }

// ignore_for_file: constant_identifier_names
import 'dart:developer';
import 'package:bloodfit/networks/exception_handler/error_response.dart';
import 'package:dio/dio.dart';

enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  OTP_VERIFY,
  DEFAULT,
  CONFLICT,
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
          ResponseCode.RECIEVE_TIMEOUT,
          ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.OTP_VERIFY:
        return Failure(ResponseCode.OTP_VERIFY, ResponseMessage.OTP_VERIFY);
      case DataSource.CONFLICT:
        return Failure(ResponseCode.CONFLICT, ResponseMessage.CONFLICT);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}

final class Failure {
  final int resonseCode;
  final String responseMessage;

  Failure(this.resonseCode, this.responseMessage);
}

final class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      log(error.toString());
      failure = DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.CONNECT_TIMEOUT.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.SEND_TIMEOUT.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.RECIEVE_TIMEOUT.getFailure();
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return DataSource.CANCEL.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }

  Failure _handleBadResponse(DioException error) {
    if (error.response == null) {
      return DataSource.DEFAULT.getFailure();
    }

    final response = error.response!;
    final statusCode = response.statusCode ?? 0;

    // 🆕 EXTRACT CUSTOM MESSAGE FROM RESPONSE
    final customMessage = _extractCustomErrorMessage(response);

    // 🆕 DEBUG LOG TO SEE WHAT'S BEING EXTRACTED
    log("🔍 Error Response Body: ${response.data}");
    log("🔍 Extracted Message: $customMessage");
    log("🔍 Status Code: $statusCode");

    // 🆕 FOR 409 CONFLICT ERRORS, RETURN CUSTOM MESSAGE WITH STATUS CODE
    if (statusCode == 409 && customMessage.isNotEmpty) {
      return Failure(statusCode, customMessage);
    }

    // 🆕 IF WE HAVE A CUSTOM MESSAGE, USE IT WITH THE STATUS CODE
    if (customMessage.isNotEmpty) {
      return Failure(statusCode, customMessage);
    }

    // 🆕 FALLBACK: MAP STATUS CODE TO APPROPRIATE FAILURE
    return _mapStatusCodeToFailure(statusCode);
  }

  String _extractCustomErrorMessage(Response response) {
    try {
      final responseData = response.data;

      log("🔍 Raw error response: $responseData");

      if (responseData == null) return "";

      if (responseData is Map<String, dynamic>) {
        // 🆕 PRIORITIZE 'message' FIELD OVER 'error' FIELD
        if (responseData.containsKey('message') &&
            responseData['message'] != null) {
          final message = responseData['message'].toString();
          if (message.isNotEmpty) {
            log("🔍 Using 'message' field: $message");
            return message;
          }
        }

        // 🆕 THEN CHECK 'error' FIELD
        if (responseData.containsKey('error') &&
            responseData['error'] != null) {
          final error = responseData['error'].toString();
          if (error.isNotEmpty) {
            log("🔍 Using 'error' field: $error");
            return error;
          }
        }

        // Check other possible fields as fallback
        final possibleFields = ['detail', 'msg', 'description', 'reason'];
        for (final field in possibleFields) {
          if (responseData.containsKey(field) && responseData[field] != null) {
            final message = responseData[field].toString();
            if (message.isNotEmpty) {
              log("🔍 Using '$field' field: $message");
              return message;
            }
          }
        }
      }

      // If response data is a string, use it directly
      if (responseData is String && responseData.isNotEmpty) {
        log("🔍 Using string response: $responseData");
        return responseData;
      }

      // Final fallback to status message
      final statusMessage = response.statusMessage ?? "";
      log("🔍 Using status message: $statusMessage");
      return statusMessage;
    } catch (e) {
      log("❌ Error extracting custom message: $e");
      return response.statusMessage ?? "An error occurred";
    }
  }

  Failure _mapStatusCodeToFailure(int statusCode) {
    switch (statusCode) {
      case ResponseCode.BAD_REQUEST:
        return DataSource.BAD_REQUEST.getFailure();
      case ResponseCode.UNAUTORISED:
        return DataSource.UNAUTORISED.getFailure();
      case ResponseCode.NOT_FOUND:
        return DataSource.NOT_FOUND.getFailure();
      case ResponseCode.INTERNAL_SERVER_ERROR:
        return DataSource.INTERNAL_SERVER_ERROR.getFailure();
      case ResponseCode.CONFLICT:
        return DataSource.CONFLICT.getFailure();
      default:
        return DataSource.DEFAULT.getFailure();
    }
  }
}
