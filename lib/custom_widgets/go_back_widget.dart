import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../gen/colors.gen.dart';

class CustomBackButton extends StatelessWidget {
  final void Function()? onTap;
  const CustomBackButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Get.back();
          },
      child: Icon(Icons.arrow_back_ios_rounded, color: AppColors.cFFFFFF),
    );
  }
}
