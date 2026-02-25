import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class InfoTileWidget extends StatefulWidget {
  final double progressValue;
  final String infoType;

  const InfoTileWidget({
    super.key,
    required this.progressValue,
    required this.infoType,
  });

  @override
  State<InfoTileWidget> createState() => _InfoTileWidgetState();
}

class _InfoTileWidgetState extends State<InfoTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.progressValue,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant InfoTileWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progressValue != widget.progressValue) {
      _animation = Tween<double>(
        begin: oldWidget.progressValue,
        end: widget.progressValue,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOutCubic,
        ),
      );

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            return SizedBox(
              width: 40.w,
              height: 40.h,
              child: CircularProgressIndicator(
                value: _animation.value,
                strokeWidth: 10,
                backgroundColor: AppColors.c999999,
                color: AppColors.cFFFFFF,
                strokeCap: StrokeCap.round,
              ),
            );
          },
        ),

        UIHelper.horizontalSpace(12.w),

        Container(
          height: 40.h,
          width: 1.sp,
          color: AppColors.c727272,
        ),

        UIHelper.horizontalSpace(8.w),

        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${(_animation.value * 100).toStringAsFixed(0)}% Complete',
                  style: TextFontStyle.headline12w400cfefefeStylePoppins,
                ),
                UIHelper.verticalSpace(6.h),
                Text(
                  widget.infoType,
                  style: TextFontStyle.headline12w400cfefefeStylePoppins,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}