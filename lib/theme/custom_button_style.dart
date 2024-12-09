import 'package:acl_application/theme/theme_helper.dart';
import 'package:flutter/material.dart';

class CustomButtonStyles {
  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
    backgroundColor: theme.colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    elevation: 0,
    padding: EdgeInsets.zero,
  );
}
