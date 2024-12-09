import 'package:acl_application/core/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../theme/theme_helper.dart';


class CustomSwitch extends StatelessWidget {
  CustomSwitch({
    super.key,
    required this.onChange,
    this.alignment,
    this.value,
    this.width,
    this.height,
    this.margin,
  });

  final Alignment? alignment;
  bool? value;
  final Function(bool) onChange;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      child: alignment != null
          ? Align(
          alignment: alignment ?? Alignment.center, child: switchWidget)
          : switchWidget,
    );
  }

  Widget get switchWidget => FlutterSwitch(
    value: value ?? false,
    height: 16.h,
    width: 30.h,
    toggleSize: 10,
    borderRadius: 8.h,
    switchBorder: Border.all(
      color: appTheme.blueGray300,
      width: 1.h,
    ),
    activeColor: appTheme.deepOrange50,
    activeToggleColor: theme.colorScheme.primary,
    inactiveColor: appTheme.blueGray100,
    inactiveToggleColor: appTheme.blueGray700,
    onToggle: (value) {
      onChange(value);
    },
  );
}
