import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../gen/assets.gen.dart';

class ProfileImageShowingWidget extends StatelessWidget {
  const ProfileImageShowingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      width: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(Assets.images.profileAvatarDefaultImage.path),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 5.h,
            right: 5.w,
            child: SvgPicture.asset(Assets.icons.cameraIcon),
          ),
        ],
      ),
    );
  }
}
