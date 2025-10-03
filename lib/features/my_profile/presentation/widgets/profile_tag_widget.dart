import 'package:flutter/material.dart';

import '../../../../constants/text_font_style.dart';

class ProfileTagWidget extends StatelessWidget {
  final String title;
  const ProfileTagWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: TextFontStyle.headline14w500c999999StylePoppins);
  }
}
