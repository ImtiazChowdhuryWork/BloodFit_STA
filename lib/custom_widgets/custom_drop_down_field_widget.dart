// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../constants/text_font_style.dart';
// import '../gen/colors.gen.dart';

// final class CustomDropdownField<T> extends StatelessWidget {
//   final String? labelText;
//   final String? hintText;
//   final List<DropdownMenuItem<T>> items;
//   final T? value;
//   final ValueChanged<T?>? onChanged;
//   final FormFieldValidator<T>? validator;
//   final bool validation;
//   final EdgeInsetsGeometry? padding;
//   final double? fieldHeight;
//   final double? borderRadius;
//   final Color? borderColor;
//   final TextStyle? labelStyle;
//   final TextStyle? hintStyle;
//   final bool isEnabled;

//   const CustomDropdownField({
//     super.key,
//     this.labelText,
//     this.hintText,
//     required this.items,
//     this.value,
//     this.onChanged,
//     this.validator,
//     this.validation = false,
//     this.padding,
//     this.fieldHeight,
//     this.borderRadius,
//     this.borderColor,
//     this.labelStyle,
//     this.hintStyle,
//     this.isEnabled = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: padding ?? EdgeInsets.zero,
//       height: fieldHeight,
//       child: DropdownButtonFormField<T>(
//         value: value,
//         onChanged: isEnabled ? onChanged : null,
//         validator: validator,
//         autovalidateMode: validation
//             ? AutovalidateMode.always
//             : AutovalidateMode.onUserInteraction,
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.transparent,
//           contentPadding: const EdgeInsets.symmetric(
//             horizontal: 16,
//             vertical: 20,
//           ),
//           labelText: labelText,
//           labelStyle:
//               labelStyle ?? TextFontStyle.headline14w400cFFFFFFStylePoppins,
//           // hintText: hintText,
//           // hintStyle:
//           //     hintStyle ?? TextFontStyle.headline14w400cFFFFFFStylePoppins,
//           // hintStyle:
//           //     hintStyle ?? TextFontStyle.headline14w400cfefefeStylePoppins,
//           errorStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
//           focusedErrorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: borderColor ?? AppColors.ce7e5df),
//             borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: borderColor ?? AppColors.cfefefe),
//             borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
//           ),
//           disabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: borderColor ?? AppColors.cb4b4b4),
//             borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.red),
//             borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: borderColor ?? AppColors.cb4b4b4),
//             borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
//           ),
//         ),
//         hint: hintText != null
//             ? Text(
//                 hintText!,
//                 style:
//                     hintStyle ??
//                     TextFontStyle.headline14w400cFFFFFFStylePoppins,
//               )
//             : null,
//         items: items,
//         style: TextFontStyle.headline14w400cfefefeStylePoppins,
//         dropdownColor: AppColors.c3c3c3c, // match your theme
//         icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/text_font_style.dart';
import '../gen/colors.gen.dart';

final class CustomDropdownField<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final bool validation;
  final EdgeInsetsGeometry? padding;
  final double? fieldHeight;
  final double? borderRadius;
  final Color? borderColor;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool isEnabled;

  const CustomDropdownField({
    super.key,
    this.labelText,
    this.hintText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.validation = false,
    this.padding,
    this.fieldHeight,
    this.borderRadius,
    this.borderColor,
    this.labelStyle,
    this.hintStyle,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.zero,
      height: fieldHeight,
      child: DropdownButtonFormField<T>(
        value: value,
        onChanged: isEnabled ? onChanged : null,
        validator: validator,
        autovalidateMode: validation
            ? AutovalidateMode.always
            : AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          labelText: value != null
              ? labelText
              : null, // show label only if value is selected
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle:
              labelStyle ?? TextFontStyle.headline14w400cFFFFFFStylePoppins,
          hintText: value == null
              ? hintText
              : null, // show hint only if value is null
          hintStyle:
              hintStyle ?? TextFontStyle.headline14w400cFFFFFFStylePoppins,
          errorStyle: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.ce7e5df),
            borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.cfefefe),
            borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.cb4b4b4),
            borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? AppColors.cb4b4b4),
            borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
          ),
        ),
        hint: hintText != null && value == null
            ? Text(
                hintText!,
                style:
                    hintStyle ??
                    TextFontStyle.headline14w400cFFFFFFStylePoppins,
              )
            : null,
        items: items,
        style: TextFontStyle.headline14w400cfefefeStylePoppins,
        dropdownColor: AppColors.c3c3c3c, // match your theme
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      ),
    );
  }
}
