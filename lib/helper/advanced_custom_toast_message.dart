// // utils/custom_toast.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// import '../networks/exception_handler/data_source.dart';

// // UI-specific toast types - for presentation layer
// enum ToastType { success, error, warning, info }

// class CustomToast {
//   // ==================== UI-DRIVEN TOASTS ====================

//   /// Show toast with UI-specific type
//   static void show({
//     required String message,
//     required ToastType type,
//     int duration = 3,
//   }) {
//     final (backgroundColor, textColor, icon) = _getToastStyleFromType(type);
//     _showToast(message, backgroundColor, textColor, icon, duration);
//   }

//   // Quick methods for common UI use cases
//   static void success(String message, {int duration = 3}) {
//     show(message: message, type: ToastType.success, duration: duration);
//   }

//   static void error(String message, {int duration = 4}) {
//     show(message: message, type: ToastType.error, duration: duration);
//   }

//   static void warning(String message, {int duration = 3}) {
//     show(message: message, type: ToastType.warning, duration: duration);
//   }

//   static void info(String message, {int duration = 3}) {
//     show(message: message, type: ToastType.info, duration: duration);
//   }

//   // ==================== API-DRIVEN TOASTS ====================

//   /// Show toast mapped from DataSource (for API errors)
//   static void showFromDataSource({
//     required String message,
//     required DataSource dataSource,
//     int duration = 3,
//   }) {
//     final ToastType toastType = _mapDataSourceToToastType(dataSource);
//     final (backgroundColor, textColor, icon) = _getToastStyleFromType(
//       toastType,
//     );
//     _showToast(message, backgroundColor, textColor, icon, duration);
//   }

//   /// Show toast directly from Failure object
//   static void showFromFailure(Failure failure, {int duration = 4}) {
//     final DataSource dataSource = _inferDataSourceFromFailure(failure);
//     final ToastType toastType = _mapDataSourceToToastType(dataSource);
//     final (backgroundColor, textColor, icon) = _getToastStyleFromType(
//       toastType,
//     );

//     _showToast(
//       failure.responseMessage,
//       backgroundColor,
//       textColor,
//       icon,
//       duration,
//     );
//   }

//   // ==================== PRIVATE IMPLEMENTATION ====================

//   static void _showToast(
//     String message,
//     Color backgroundColor,
//     Color textColor,
//     IconData icon,
//     int duration,
//   ) {
//     final context = Get.context;
//     if (context == null) return;

//     // Remove any existing toast
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();

//     // Show custom snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         behavior: SnackBarBehavior.floating,
//         margin: EdgeInsets.only(bottom: 100.h, left: 20.w, right: 20.w),
//         duration: Duration(seconds: duration),
//         content: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//           decoration: BoxDecoration(
//             color: backgroundColor,
//             borderRadius: BorderRadius.circular(12.r),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10.r,
//                 spreadRadius: 1.r,
//                 offset: const Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: textColor, size: 24.sp),
//               SizedBox(width: 12.w),
//               Expanded(
//                 child: Text(
//                   message,
//                   style: TextStyle(
//                     color: textColor,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               GestureDetector(
//                 onTap: () {
//                   ScaffoldMessenger.of(context).hideCurrentSnackBar();
//                 },
//                 child: Icon(Icons.close, color: textColor, size: 20.sp),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ==================== STYLE MAPPING ====================

//   /// Map ToastType to visual styling
//   static (Color, Color, IconData) _getToastStyleFromType(ToastType type) {
//     switch (type) {
//       case ToastType.success:
//         return (Colors.green, Colors.white, Icons.check_circle);
//       case ToastType.error:
//         return (Colors.red, Colors.white, Icons.error);
//       case ToastType.warning:
//         return (Colors.orange, Colors.white, Icons.warning);
//       case ToastType.info:
//         return (Colors.blue, Colors.white, Icons.info);
//     }
//   }

//   /// Map DataSource to ToastType
//   static ToastType _mapDataSourceToToastType(DataSource dataSource) {
//     switch (dataSource) {
//       case DataSource.SUCCESS:
//       case DataSource.NO_CONTENT:
//         return ToastType.success;

//       case DataSource.BAD_REQUEST:
//       case DataSource.UNAUTORISED:
//       case DataSource.NOT_FOUND:
//       case DataSource.CACHE_ERROR:
//       case DataSource.CONFLICT:
//         return ToastType.error;

//       case DataSource.INTERNAL_SERVER_ERROR:
//       case DataSource.CONNECT_TIMEOUT:
//       case DataSource.RECIEVE_TIMEOUT:
//       case DataSource.SEND_TIMEOUT:
//         return ToastType.warning;

//       case DataSource.CANCEL:
//       case DataSource.NO_INTERNET_CONNECTION:
//       case DataSource.OTP_VERIFY:
//       case DataSource.DEFAULT:
//         return ToastType.info;
//     }
//   }

//   /// Infer DataSource from Failure (fallback mechanism)
//   static DataSource _inferDataSourceFromFailure(Failure failure) {
//     final message = failure.responseMessage.toLowerCase();

//     if (message.contains('timeout')) {
//       return DataSource.CONNECT_TIMEOUT;
//     } else if (message.contains('network') || message.contains('internet')) {
//       return DataSource.NO_INTERNET_CONNECTION;
//     } else if (message.contains('unauthorized') || message.contains('auth')) {
//       return DataSource.UNAUTORISED;
//     } else if (message.contains('not found') || message.contains('404')) {
//       return DataSource.NOT_FOUND;
//     } else if (message.contains('server error') || message.contains('500')) {
//       return DataSource.INTERNAL_SERVER_ERROR;
//     } else if (message.contains('bad request') || message.contains('400')) {
//       return DataSource.BAD_REQUEST;
//     } else if (message.contains('Invalid password') ||
//         message.contains('409')) {
//       return DataSource.CONFLICT;
//     } else {
//       return DataSource.DEFAULT;
//     }
//   }
// }

// utils/custom_toast.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../networks/exception_handler/data_source.dart';
import '../networks/exception_handler/error_response.dart';

// UI-specific toast types - for presentation layer
enum ToastType { success, error, warning, info }

class CustomToast {
  // ==================== UI-DRIVEN TOASTS ====================

  /// Show toast with UI-specific type
  static void show({
    required String message,
    required ToastType type,
    int duration = 3,
  }) {
    final (backgroundColor, textColor, icon) = _getToastStyleFromType(type);
    _showToast(message, backgroundColor, textColor, icon, duration);
  }

  // Quick methods for common UI use cases
  static void success(String message, {int duration = 3}) {
    show(message: message, type: ToastType.success, duration: duration);
  }

  static void error(String message, {int duration = 4}) {
    show(message: message, type: ToastType.error, duration: duration);
  }

  static void warning(String message, {int duration = 3}) {
    show(message: message, type: ToastType.warning, duration: duration);
  }

  static void info(String message, {int duration = 3}) {
    show(message: message, type: ToastType.info, duration: duration);
  }

  // ==================== API-DRIVEN TOASTS ====================

  /// Show toast mapped from DataSource (for API errors)
  static void showFromDataSource({
    required String message,
    required DataSource dataSource,
    int duration = 3,
  }) {
    final ToastType toastType = _mapDataSourceToToastType(dataSource);
    final (backgroundColor, textColor, icon) = _getToastStyleFromType(
      toastType,
    );
    _showToast(message, backgroundColor, textColor, icon, duration);
  }

  /// Show toast directly from Failure object
  static void showFromFailure(Failure failure, {int duration = 4}) {
    // 🆕 ADD DEBUG LOGGING
    log("🔍 CustomToast - Failure received:");
    log("🔍   Response Code: ${failure.resonseCode}");
    log("🔍   Response Message: ${failure.responseMessage}");

    final DataSource dataSource = _inferDataSourceFromFailure(failure);
    log("🔍   Inferred DataSource: $dataSource");

    final ToastType toastType = _mapDataSourceToToastType(dataSource);
    log("🔍   Mapped ToastType: $toastType");

    final (backgroundColor, textColor, icon) = _getToastStyleFromType(
      toastType,
    );
    log("🔍   Final Colors: BG=$backgroundColor, Text=$textColor");

    _showToast(
      failure.responseMessage,
      backgroundColor,
      textColor,
      icon,
      duration,
    );
  }

  // ==================== PRIVATE IMPLEMENTATION ====================

  static void _showToast(
    String message,
    Color backgroundColor,
    Color textColor,
    IconData icon,
    int duration,
  ) {
    final context = Get.context;
    if (context == null) return;

    // Remove any existing toast
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // Show custom snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100.h, left: 20.w, right: 20.w),
        duration: Duration(seconds: duration),
        content: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10.r,
                spreadRadius: 1.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 24.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: Icon(Icons.close, color: textColor, size: 20.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== STYLE MAPPING ====================

  /// Map ToastType to visual styling
  static (Color, Color, IconData) _getToastStyleFromType(ToastType type) {
    switch (type) {
      case ToastType.success:
        return (Colors.green, Colors.white, Icons.check_circle);
      case ToastType.error:
        return (Colors.red, Colors.white, Icons.error);
      case ToastType.warning:
        return (Colors.orange, Colors.white, Icons.warning);
      case ToastType.info:
        return (Colors.blue, Colors.white, Icons.info);
    }
  }

  /// Map DataSource to ToastType
  static ToastType _mapDataSourceToToastType(DataSource dataSource) {
    switch (dataSource) {
      case DataSource.SUCCESS:
      case DataSource.NO_CONTENT:
        return ToastType.success;

      case DataSource.BAD_REQUEST:
      case DataSource.UNAUTORISED:
      case DataSource.NOT_FOUND:
      case DataSource.CACHE_ERROR:
      case DataSource.CONFLICT:
        return ToastType.error;

      case DataSource.INTERNAL_SERVER_ERROR:
      case DataSource.CONNECT_TIMEOUT:
      case DataSource.RECIEVE_TIMEOUT:
      case DataSource.SEND_TIMEOUT:
        return ToastType.warning;

      case DataSource.CANCEL:
      case DataSource.NO_INTERNET_CONNECTION:
      case DataSource.OTP_VERIFY:
      case DataSource.DEFAULT:
        return ToastType.info;
    }
  }

  /// Infer DataSource from Failure (fallback mechanism)
  static DataSource _inferDataSourceFromFailure(Failure failure) {
    final message = failure.responseMessage.toLowerCase();
    final statusCode = failure.resonseCode;

    log("🔍 Inferring DataSource from:");
    log("🔍   Message: $message");
    log("🔍   Status Code: $statusCode");

    // 🆕 CHECK STATUS CODE FIRST (MOST RELIABLE)
    switch (statusCode) {
      case 400:
        return DataSource.BAD_REQUEST;
      case 401:
        return DataSource.UNAUTORISED;
      case 404:
        return DataSource.NOT_FOUND;
      case 409:
        return DataSource.CONFLICT;
      case 500:
        return DataSource.INTERNAL_SERVER_ERROR;
      case ResponseCode.CONNECT_TIMEOUT:
        return DataSource.CONNECT_TIMEOUT;
      case ResponseCode.CANCEL:
        return DataSource.CANCEL;
      case ResponseCode.NO_INTERNET_CONNECTION:
        return DataSource.NO_INTERNET_CONNECTION;
      default:
        // Fallback to message parsing for unknown codes
        if (message.contains('timeout')) {
          return DataSource.CONNECT_TIMEOUT;
        } else if (message.contains('network') ||
            message.contains('internet')) {
          return DataSource.NO_INTERNET_CONNECTION;
        } else if (message.contains('unauthorized') ||
            message.contains('auth')) {
          return DataSource.UNAUTORISED;
        } else if (message.contains('not found')) {
          return DataSource.NOT_FOUND;
        } else if (message.contains('server error')) {
          return DataSource.INTERNAL_SERVER_ERROR;
        } else if (message.contains('bad request')) {
          return DataSource.BAD_REQUEST;
        } else if (message.contains('invalid password')) {
          return DataSource.CONFLICT;
        } else {
          return DataSource.DEFAULT;
        }
    }
  }
}
