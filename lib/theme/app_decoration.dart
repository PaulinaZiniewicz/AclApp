import 'package:acl_application/theme/theme_helper.dart';
import 'package:flutter/material.dart';


class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
    color: appTheme.blueGray700,
  );

  static BoxDecoration get fillBlueGray50 => BoxDecoration(
    color: appTheme.blueGray50,
  );

  static BoxDecoration get fillDeepOrange => BoxDecoration(
    color: appTheme.deepOrange50,
  );

  static BoxDecoration get fillGray => BoxDecoration(
    color: appTheme.gray50,
  );


  static BoxDecoration get outlineOnPrimaryContainer => BoxDecoration(
    color: appTheme.blueGray50,
    border: Border.all(
      color: appTheme.gray50,
      width: 1.0,
      strokeAlign: BorderSide.strokeAlignCenter,
    ),
  );


  static BoxDecoration get shadowPersonalized => BoxDecoration(
    color: theme.colorScheme.primary,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 4.0,
        spreadRadius: 2.0,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

class BorderRadiusStyle {

  static BorderRadius get circleBorder26 => BorderRadius.circular(
    26.0,
  );

  static BorderRadius get circleBorder30 => BorderRadius.circular(
    30.0,
  );

  static BorderRadius get roundedBorder16 => BorderRadius.circular(
    16.0,
  );
}
