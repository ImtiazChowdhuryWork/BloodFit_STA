import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../gen/colors.gen.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.cFFFFFF),
    );
  }
}
