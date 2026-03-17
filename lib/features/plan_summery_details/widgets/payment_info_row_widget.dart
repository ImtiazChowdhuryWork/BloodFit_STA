import 'package:flutter/material.dart';

import '../../../constants/text_font_style.dart';

class PaymentInfoRowWidget extends StatelessWidget {
  final String title;
  final double price;
  final TextStyle? textStyle;
  const PaymentInfoRowWidget({
    super.key,
    required this.title,
    required this.price,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: textStyle ?? TextFontStyle.headline16w500cc6c6c6StylePoppins,
          ),
        ),
        Text(
          "£${price.toString()}",
          style: textStyle ?? TextFontStyle.headline16w500cc6c6c6StylePoppins,
        ),
      ],
    );
  }
}
