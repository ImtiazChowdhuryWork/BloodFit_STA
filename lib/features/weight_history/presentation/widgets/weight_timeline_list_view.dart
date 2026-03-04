// import 'package:bloodfit/constants/text_font_style.dart';
// import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
// import 'package:bloodfit/gen/colors.gen.dart';
// import 'package:bloodfit/helper/ui_helpers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:intl/intl.dart';

// /// A scrollable list version of the weight timeline for displaying many entries
// /// Use this when you have more than 6 weight entries from API
// class WeightTimelineListView extends StatelessWidget {
//   final List<WeightEntry> entries;
//   final VoidCallback? onRefresh;

//   const WeightTimelineListView({
//     Key? key,
//     required this.entries,
//     this.onRefresh,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (entries.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.history,
//               size: 64.h,
//               color: AppColors.c999999,
//             ),
//             UIHelper.verticalSpace(16.h),
//             Text(
//               'No weight history yet',
//               style: TextFontStyle.headline16w500c999999StylePoppins,
//             ),
//             UIHelper.verticalSpace(8.h),
//             Text(
//               'Start tracking your transformation!',
//               style: TextFontStyle.headline14w400c999999StylePoppins,
//             ),
//             if (onRefresh != null) ...[
//               UIHelper.verticalSpace(24.h),
//               ElevatedButton.icon(
//                 onPressed: onRefresh,
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Refresh'),
//               ),
//             ],
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       itemCount: entries.length,
//       itemBuilder: (context, index) {
//         final entry = entries[index];
//         final isEven = index % 2 == 0;

//         return Padding(
//           padding: EdgeInsets.only(bottom: 24.h),
//           child: Row(
//             mainAxisAlignment:
//                 isEven ? MainAxisAlignment.start : MainAxisAlignment.end,
//             children: [
//               // Timeline line
//               if (isEven) ...[
//                 // Weight card
//                 Expanded(
//                   flex: 2,
//                   child: _buildWeightCard(entry, isLeft: true),
//                 ),
//                 // Center line with dot
//                 Expanded(
//                   flex: 1,
//                   child: Center(
//                     child: Container(
//                       width: 16.w,
//                       height: 16.h,
//                       decoration: BoxDecoration(
//                         color: AppColors.cb20000,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: AppColors.cFFFFFF,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Empty space
//                 Expanded(flex: 2, child: const SizedBox()),
//               ] else ...[
//                 // Empty space
//                 Expanded(flex: 2, child: const SizedBox()),
//                 // Center line with dot
//                 Expanded(
//                   flex: 1,
//                   child: Center(
//                     child: Container(
//                       width: 16.w,
//                       height: 16.h,
//                       decoration: BoxDecoration(
//                         color: AppColors.cb20000,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: AppColors.cFFFFFF,
//                           width: 2,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Weight card
//                 Expanded(
//                   flex: 2,
//                   child: _buildWeightCard(entry, isLeft: false),
//                 ),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildWeightCard(WeightEntry entry, {required bool isLeft}) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       margin: EdgeInsets.symmetric(horizontal: 16.w),
//       decoration: BoxDecoration(
//         color: AppColors.c282828,
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: AppColors.cb20000.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment:
//             isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//         children: [
//           Text(
//             '${entry.weight.toStringAsFixed(1)} kg',
//             style: const TextStyle(
//               color: Color(0xFFFEFEFE),
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               fontFamily: 'Poppins',
//             ),
//           ),
//           UIHelper.verticalSpace(4.h),
//           Text(
//             _formatDate(entry.date),
//             style: const TextStyle(
//               color: Color(0xFF999999),
//               fontSize: 12,
//               fontWeight: FontWeight.w400,
//               fontFamily: 'Poppins',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final formatter = DateFormat('dd MMM yyyy');
//     return formatter.format(date);
//   }
// }



import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// A scrollable list version of the weight timeline for displaying many entries
/// Use this when you have more than 6 weight entries from API
class WeightTimelineListView extends StatelessWidget {
  final List<WeightEntry> entries;
  final VoidCallback? onRefresh;

  const WeightTimelineListView({
    Key? key,
    required this.entries,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64.h,
              color: AppColors.c999999,
            ),
            UIHelper.verticalSpace(16.h),
            Text(
              'No weight history yet',
              style: TextFontStyle.headline16w500c999999StylePoppins,
            ),
            UIHelper.verticalSpace(8.h),
            Text(
              'Start tracking your transformation!',
              style: TextFontStyle.headline14w400c999999StylePoppins,
            ),
            if (onRefresh != null) ...[
              UIHelper.verticalSpace(24.h),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isEven = index % 2 == 0;

        return Padding(
          padding: EdgeInsets.only(bottom: 24.h),
          child: Row(
            mainAxisAlignment:
                isEven ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              // Timeline line
              if (isEven) ...[
                // Weight card
                Expanded(
                  flex: 2,
                  child: _buildWeightCard(entry, isLeft: true),
                ),
                // Center line with dot
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.cb20000,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cFFFFFF,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                // Empty space
                Expanded(flex: 2, child: const SizedBox()),
              ] else ...[
                // Empty space
                Expanded(flex: 2, child: const SizedBox()),
                // Center line with dot
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: BoxDecoration(
                        color: AppColors.cb20000,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.cFFFFFF,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                // Weight card
                Expanded(
                  flex: 2,
                  child: _buildWeightCard(entry, isLeft: false),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeightCard(WeightEntry entry, {required bool isLeft}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.c282828,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.cb20000.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            '${entry.weight.toStringAsFixed(1)} kg',
            style: const TextStyle(
              color: Color(0xFFFEFEFE),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          UIHelper.verticalSpace(4.h),
          Text(
            _formatDate(entry.date),
            style: const TextStyle(
              color: Color(0xFF999999),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date);
  }
}