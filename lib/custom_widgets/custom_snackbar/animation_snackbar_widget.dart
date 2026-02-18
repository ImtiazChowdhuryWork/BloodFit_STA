
import 'package:bloodfit/custom_widgets/custom_snackbar/app_snackbar_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/app_enums.dart';

class AnimatedSnackBar extends StatefulWidget {
  final String message;
  final AppSnackBarType type;
  final AppSnackBarPosition position;
  final VoidCallback onClose;

  const AnimatedSnackBar({
    required this.message,
    required this.type,
    required this.position,
    required this.onClose,
  });

  @override
  State<AnimatedSnackBar> createState() => _AnimatedSnackBarState();
}

class _AnimatedSnackBarState extends State<AnimatedSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final beginOffset =
        widget.position == AppSnackBarPosition.top
            ? const Offset(0, -1)
            : const Offset(0, 1);

    _animation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.position == AppSnackBarPosition.top ? 40 : null,
      bottom: widget.position == AppSnackBarPosition.bottom ? 40 : null,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _animation,
        child: AppSnackBarWidget(
          message: widget.message,
          type: widget.type,
          onClose: widget.onClose,
        ),
      ),
    );
  }
}
