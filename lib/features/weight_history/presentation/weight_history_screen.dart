import 'package:bloodfit/constants/text_font_style.dart';
import 'package:bloodfit/features/weight_history/presentation/widgets/transformation_timline_widget.dart';
import 'package:bloodfit/features/weight_history/presentation/widgets/weight_timeline_infinite.dart';
import 'package:bloodfit/gen/colors.gen.dart';
import 'package:bloodfit/helper/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../custom_widgets/current_weight_update_widget.dart';
import '../../home/presentation/widgets/app_bar_section_widget.dart';

class WeightHistoryScreen extends StatefulWidget {
  const WeightHistoryScreen({super.key});

  @override
  State<WeightHistoryScreen> createState() => _WeightHistoryScreenState();
}

class _WeightHistoryScreenState extends State<WeightHistoryScreen> {
  // This will hold your API data
  List<WeightEntry> _weightEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load weight history from API
    _loadWeightHistory();
  }

  Future<void> _loadWeightHistory() async {
    setState(() {
      _isLoading = true;
    });

    // TODO: Replace with your actual API call
    // Example: final response = await weightHistoryRepository.getWeightHistory();
    // For now, using mock data with many entries to test the pattern
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _weightEntries = [
        WeightEntry(weight: 75.0, date: DateTime(2025, 8, 20)),
        WeightEntry(weight: 73.5, date: DateTime(2025, 9, 1)),
        WeightEntry(weight: 71.0, date: DateTime(2025, 9, 10)),
        WeightEntry(weight: 68.5, date: DateTime(2025, 9, 15)),
        WeightEntry(weight: 66.0, date: DateTime(2025, 9, 20)),
        WeightEntry(weight: 65.0, date: DateTime(2025, 9, 25)),
        WeightEntry(weight: 64.5, date: DateTime(2025, 10, 1)),
        WeightEntry(weight: 63.0, date: DateTime(2025, 10, 10)),
        WeightEntry(weight: 777.5, date: DateTime(2025, 10, 20)),
        WeightEntry(weight: 62.0, date: DateTime(2025, 10, 25)),
        WeightEntry(weight: 64.0, date: DateTime(2025, 11, 25)),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(UIHelper.kDefaulutPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Section : ---------------------///AppLogo///-----------
              ///Section : ---------------------///Notification///-----------
              ///Section : ---------------------///Profile///-----------
              AppBarSectionWidget(),
              UIHelper.verticalSpace(20.h),

              ///Section : ----------------///Text -> update your current weight///------------
              ///Section : --------------///Weight Drop Down///----------
              CurrentWeightUpdateWidget(),
              UIHelper.verticalSpace(24.h),

              Text(
                "Your Transformation Timeline",
                style: TextFontStyle.headline20w500cfefefeStylePoppins,
              ),
              UIHelper.verticalSpace(16.h),

              // Show loading or timeline
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                // Use the dynamic timeline that continues the pattern infinitely
                WeightTimelineInfinite(
                  entries: _weightEntries,
                  onRefresh: () => _loadWeightHistory(),
                ),
                UIHelper.verticalSpace(120.h),
              UIHelper.spacerFromBottomNav,
            ],
          ),
        ),
      ),
    );
  }
}
