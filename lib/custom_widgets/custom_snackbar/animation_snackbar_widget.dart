import 'package:bloodfit/custom_widgets/custom_snackbar/app_snackbar_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/app_enums.dart';

class AnimatedSnackBar extends StatefulWidget {
  final String message;
  final AppSnackBarType type;
  final AppSnackBarPosition position;

  const AnimatedSnackBar({
    super.key,
    required this.message,
    required this.type,
    required this.position,
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTop = widget.position == AppSnackBarPosition.top;

    return SafeArea(
      child: Align(
        alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            top: isTop ? 16 : 0,
            bottom: isTop ? 0 : 24,
          ),
          child: SlideTransition(
            position: _animation,
            child: Material(
              color: Colors.transparent,
              child: AppSnackBarWidget(
                message: widget.message,
                type: widget.type,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
