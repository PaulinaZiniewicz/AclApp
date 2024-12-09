import 'package:flutter/material.dart';

String _currentTheme = "lightCode";

LightCodeColors get appTheme => ThemeHelper().themeColors();
ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {
  LightCodeColors themeColors() => LightCodeColors();

  ThemeData themeData() {
    var colorScheme = ColorSchemes.lightCodeColorScheme;

    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.gray50,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.blueGray700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
          return states.contains(WidgetState.selected) ? colorScheme.primary : Colors.transparent;
        }),
        side: BorderSide(
          color: appTheme.blueGray300,
          width: 1,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: appTheme.blueGray300,
      ),
    );
  }
}

class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
    bodySmall: TextStyle(
      color: appTheme.blueGray700,
      fontSize: 8.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      color: appTheme.blueGray700,
      fontSize: 12.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      color: colorScheme.secondaryContainer,
      fontSize: 8.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
    ),
    titleLarge: TextStyle(
      color: appTheme.gray50,
      fontSize: 20.0,
      fontFamily: 'Inter',
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      color: appTheme.blueGray700,
      fontSize: 16.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w700,
    ),
    titleSmall: TextStyle(
      color: appTheme.gray50,
      fontSize: 15.0,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
    ),
  );
}

class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFFF55022),
    secondaryContainer: Color(0xFF7C8A98),
    onPrimary: Color(0xFF1C274C),
    onPrimaryContainer: Color(0xFFDBDFE2),
  );
}

class LightCodeColors {

  Color get black90019 => const Color(0x19000000);
  Color get blueGray100 => const Color(0xFFC6D1DB);
  Color get blueGray10001 => const Color(0xFFD6DBE0);
  Color get blueGray200 => const Color(0xFFA9BDCE);
  Color get blueGray300 => const Color(0xFF869FB5);
  Color get blueGray50 => const Color(0xFFECEFF2);
  Color get blueGray70001 => const Color(0xFF3B4E5F);
  Color get blueGray700 => const Color(0xFF3C536C);
  Color get deepOrange50 => const Color(0xFFF4BFAC);
  Color get deepOrange100 => const Color(0xFFFAE4D6);
  Color get gray50 => const Color(0xFFFCFCFC);
}

