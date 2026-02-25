
import 'package:bloodfit/features/progress/presentation/widget/infotile_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class OverAllProgressShowingWidget extends StatefulWidget {
  final double overAllProgress;
  final String inforTypeOne;
  final double infoTypeOneProgress;
  final String infoTypeTwo;
  final double infoTypeTwoProgress;

  const OverAllProgressShowingWidget({
    super.key,
    required this.overAllProgress,
    required this.inforTypeOne,
    required this.infoTypeOneProgress,
    required this.infoTypeTwo,
    required this.infoTypeTwoProgress,
  });

  @override
  State<OverAllProgressShowingWidget> createState() =>
      _OverAllProgressShowingWidgetState();
}

class _OverAllProgressShowingWidgetState
    extends State<OverAllProgressShowingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.overAllProgress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant OverAllProgressShowingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.overAllProgress != widget.overAllProgress) {
      _progressAnimation =
          Tween<double>(
            begin: oldWidget.overAllProgress,
            end: widget.overAllProgress,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: BoxDecoration(
        color: AppColors.c262626,
        borderRadius: BorderRadius.circular(16.r),
      ),
      width: 1.sw,
      child: Column(
        children: [
          ///----------<>>>>> Section : Almost There
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Motivation Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Almost There!',
                    style: TextFontStyle.headline18w500cfefefeStylePoppins,
                  ),
                  UIHelper.verticalSpace(6.h),
                  Text(
                    'Just Little Bit More, Let’s Keep Going.',
                    style: TextFontStyle.headline12w500c999999StylePoppins,
                  ),
                ],
              ),

              SizedBox(
                width: 127.w,
                height: 127.h,
                child: AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (_, __) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: _progressAnimation.value,
                            strokeWidth: 10,
                            backgroundColor: AppColors.c000000,
                            color: AppColors.cb20000,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(_progressAnimation.value * 100).toStringAsFixed(0)}%',
                              style: TextFontStyle
                                  .headline20w500cfefefeStylePoppins,
                            ),
                            UIHelper.verticalSpace(6.h),
                            Text(
                              'Complete',
                              style: TextFontStyle
                                  .headline12w400cfefefeStylePoppins,
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          UIHelper.verticalSpace(10.h),
          Divider(color: AppColors.c727272, thickness: 1),
          UIHelper.verticalSpace(10.h),

          ///----------<>>>>>> Section : Meal Plan Data
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoTileWidget(
                progressValue: widget.infoTypeOneProgress,
                infoType: widget.inforTypeOne,
              ),
              InfoTileWidget(
                progressValue: widget.infoTypeTwoProgress,
                infoType: widget.infoTypeTwo,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
