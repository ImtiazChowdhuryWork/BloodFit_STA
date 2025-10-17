import 'package:bloodfit/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import '../features/home/presentation/widgets/calender_container_widget.dart';

class CustomCalenderWidget extends StatelessWidget {
  const CustomCalenderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CalenderContainerWidget(
          iconPath: Assets.icons.fireWhite,
          dayName: "Stu",
        ),
      ],
    );
  }
}
