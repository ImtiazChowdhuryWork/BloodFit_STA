// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class ProfileImageShowingWidget extends StatelessWidget {
//   final String? imagePath;
//   final String defualtImagePath;
//   final String editIconPath;
//   final double shapeHeight;
//   final double shapeWidth;
//   final void Function()? onTap;

//   const ProfileImageShowingWidget({
//     super.key,
//     required this.imagePath,
//     required this.defualtImagePath,
//     required this.editIconPath,
//     required this.shapeHeight,
//     required this.shapeWidth,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         showGeneralDialog(
//           context: context,
//           barrierDismissible: true,
//           barrierLabel: '',
//           barrierColor: Colors.transparent,
//           pageBuilder: (context, _, __) {
//             return Center(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(4.r),
//                 child: Container(
//                   width: 0.9.sw,
//                   height: 0.3.sh,
//                   color: Colors.white,
//                   padding: EdgeInsets.all(10.sp),
//                   child: InteractiveViewer(
//                     child:
//                         imagePath != null &&
//                             imagePath!.isNotEmpty &&
//                             File(imagePath!).existsSync()
//                         ? Image.file(fit: BoxFit.contain, File(imagePath!))
//                         : Image.asset(defualtImagePath),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//       child: Container(
//         height: shapeHeight,
//         width: shapeWidth,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: imagePath != null && imagePath!.isNotEmpty
//                 ? FileImage(File(imagePath!))
//                 : AssetImage(defualtImagePath),
//           ),
//         ),
//         child: Stack(
//           children: [
//             Positioned(
//               bottom: 5.h,
//               right: 5.w,
//               child: InkWell(
//                 onTap: onTap,
//                 child: SvgPicture.asset(editIconPath),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
