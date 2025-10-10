import 'package:flutter/material.dart';

import '../../../constants/text_font_style.dart';

class PaymentInfoRowWidget extends StatelessWidget {
  final String title;
  final double price;
  const PaymentInfoRowWidget({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextFontStyle.headline16w500cFFFFFFStylePoppins,
          ),
        ),
        Text(
          "£${price.toString()}",
          style: TextFontStyle.headline16w500cc6c6c6StylePoppins,
        ),
      ],
    );
  }
}
