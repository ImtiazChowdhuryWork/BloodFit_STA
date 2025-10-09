import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../custom_widgets/custom_drop_down_field_widget.dart';
import '../../../../constants/text_font_style.dart';

/// A reusable dropdown widget integrated with GetX.
/// [T] is the type of the dropdown value (String, int, etc.)
class FitnessOptionsDropDownWidget<T> extends StatelessWidget {
  /// Observable selected value from the controller
  final Rx<T?> selectedValue;

  /// List of options for the dropdown
  final List<T> dropDownOptionsList;

  /// Optional label for the dropdown
  final String? labelText;

  /// Optional hint text
  final String? hintText;

  const FitnessOptionsDropDownWidget({
    super.key,
    required this.selectedValue,
    required this.dropDownOptionsList,
    this.labelText,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomDropdownField<T>(
        labelText: labelText,
        hintText: hintText,
        value: selectedValue.value,
        onChanged: (val) {
          selectedValue.value = val;
        },
        items: dropDownOptionsList
            .map(
              (option) => DropdownMenuItem<T>(
                value: option,
                child: Text(
                  option.toString(),
                  style: TextFontStyle.headline14w400c999999StylePoppins,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
