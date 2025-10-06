import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../custom_widgets/card_tile_option_widget.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helper/ui_helpers.dart';

class LogoutButton extends StatelessWidget {
  final String buttonTitle;
  final void Function()? onTap;
  const LogoutButton({super.key, required this.buttonTitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      color: Colors.transparent,
      padding: EdgeInsets.only(
        bottom: 80.h,
        right: UIHelper.kDefaulutPadding(),
        left: UIHelper.kDefaulutPadding(),
        top: UIHelper.kDefaulutPadding(),
      ),
      child: InkWell(
        onTap: onTap,
        child: CardTileOptionWidget(
          imagePath: Assets.icons.logoutIcon,
          cardColor: AppColors.cb20000,
          suffixColor: AppColors.cFFFFFF,
          title: buttonTitle,
        ),
      ),
    );
  }
}
