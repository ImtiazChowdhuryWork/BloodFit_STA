import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_enums.dart';
import '../custom_widgets/custom_snackbar/animation_snackbar_widget.dart';

class AppSnackBarController {
  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show({
    required String message,
    AppSnackBarType type = AppSnackBarType.info,
    AppSnackBarPosition position = AppSnackBarPosition.top,
    Duration duration = const Duration(seconds: 3),
  }) {
    _remove();

    final overlay = Overlay.of(Get.overlayContext!);

    _entry = OverlayEntry(
      builder: (_) {
        return AnimatedSnackBar(
          message: message,
          type: type,
          position: position,
          onClose: _remove,
        );
      },
    );

    overlay.insert(_entry!);

    _timer = Timer(duration, _remove);
  }

  static void _remove() {
    _timer?.cancel();
    _timer = null;

    _entry?.remove();
    _entry = null;
  }
}
