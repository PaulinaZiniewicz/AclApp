import 'package:acl_application/core/utils/size_utils.dart';
import 'package:flutter/material.dart';
import '../theme/custom_text_style.dart';


// ignore_for_file: must_be_immutable
class CustomCheckboxButton extends StatelessWidget {
  CustomCheckboxButton({
    super.key,
    required this.onChange,
    this.decoration,
    this.alignment,
    this.isRightCheck,
    this.iconSize,
    this.value,
    this.text,
    this.width,
    this.padding,
    this.textStyle,
    this.overflow,
    this.textAlignment,
    this.isExpandedText = false,
  });

  final BoxDecoration? decoration;
  final Alignment? alignment;
  final bool? isRightCheck;
  final double? iconSize;
  bool? value;
  final Function(bool) onChange;
  final String? text;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextOverflow? overflow;
  final TextAlign? textAlignment;
  final bool isExpandedText;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment ?? Alignment.center,
      child: buildCheckBoxWidget,
    )
        : buildCheckBoxWidget;
  }

  Widget get buildCheckBoxWidget => GestureDetector(
    onTap: () {
      value = !(value!);
      onChange(value!);
    },
    child: Container(
      decoration: decoration,
      width: width,
      padding: padding,
      child: (isRightCheck ?? false) ? rightSideCheckbox : leftSideCheckbox,
    ),
  );

  Widget get leftSideCheckbox => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      checkboxWidget,
      SizedBox(width: text != null && text!.isNotEmpty ? 8 : 0),
      isExpandedText ? Expanded(child: textWidget) : textWidget,
    ],
  );

  Widget get rightSideCheckbox => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      isExpandedText ? Expanded(child: textWidget) : textWidget,
      SizedBox(width: text != null && text!.isNotEmpty ? 8 : 0),
      checkboxWidget,
    ],
  );

  Widget get textWidget => Text(
    text ?? "",
    textAlign: textAlignment ?? TextAlign.start,
    overflow: overflow,
    style: textStyle ?? CustomTextStyles.labelSmallBlueGray700,
  );

  Widget get checkboxWidget => SizedBox(
    height: iconSize ?? 14.h,
    width: iconSize ?? 14.h,
    child: Checkbox(
      visualDensity: const VisualDensity(
        vertical: -4,
        horizontal: -4,
      ),
      value: value ?? false,
      onChanged: (value) {
        onChange(value!);
      },
    ),
  );
}