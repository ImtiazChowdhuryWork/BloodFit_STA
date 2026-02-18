import 'package:flutter/material.dart';

import '../../constants/app_enums.dart';

class AppSnackBarConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final IconData icon;

  const AppSnackBarConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.icon,
  });
}

AppSnackBarConfig getSnackBarConfig(AppSnackBarType type) {
  switch (type) {
    case AppSnackBarType.success:
      return const AppSnackBarConfig(
        backgroundColor: Color(0xFFE8F5E9),
        borderColor: Color(0xFF2E7D32),
        textColor: Color(0xFF2E7D32),
        icon: Icons.check_circle,
      );
    case AppSnackBarType.error:
      return const AppSnackBarConfig(
        backgroundColor: Color(0xFFFDECEA),
        borderColor: Color(0xFFD32F2F),
        textColor: Color(0xFFD32F2F),
        icon: Icons.error,
      );
    case AppSnackBarType.warning:
      return const AppSnackBarConfig(
        backgroundColor: Color(0xFFFFF8E1),
        borderColor: Color(0xFFF9A825),
        textColor: Color(0xFFF9A825),
        icon: Icons.warning,
      );
    case AppSnackBarType.info:
      return const AppSnackBarConfig(
        backgroundColor: Color(0xFFE3F2FD),
        borderColor: Color(0xFF1565C0),
        textColor: Color(0xFF1565C0),
        icon: Icons.info,
      );
  }
}
