import 'package:acl_application/theme/theme_helper.dart';
import 'package:flutter/material.dart';

extension TextStyleExtensions on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}

class CustomTextStyles {

  static TextStyle get bodySmallBlueGray300 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray300,
        fontSize: 12.0,
      );

  static TextStyle get bodySmallGray50 =>
      theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray50,
      );

  // Label text styles
  static TextStyle get labelLargeBlueGray300 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray300,
      );

  static TextStyle get labelLargeBlueGray300Medium =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray300,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelLargeMedium =>
      theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w500,
      );

  static TextStyle get labelLargePrimary =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get labelLargeSecondaryContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      );

  static TextStyle get labelSmallBlueGray700 =>
      theme.textTheme.labelSmall!.copyWith(
        color: appTheme.blueGray700,
      );

  static TextStyle get labelSmallPrimary =>
      theme.textTheme.labelSmall!.copyWith(
        color: theme.colorScheme.primary,
      );

  static TextStyle get titleLargePoppins =>
      theme.textTheme.titleLarge!.poppins;

  static TextStyle get titleSmallBold =>
      theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleSmallInter =>
      theme.textTheme.titleSmall!.inter.copyWith(
        fontWeight: FontWeight.w700,
      );

  static TextStyle get titleSmallInterBlueGray780 =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: appTheme.blueGray700,
        fontWeight: FontWeight.w700,
      );
}
