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



class ColorSchemes {
  static const lightCodeColorScheme = ColorScheme.light(
    primary: Color(0xFFF65123),
  );
}

class LightCodeColors {

  Color get orange => const Color(0xFFF65123);
  Color get blueGray100 => const Color(0xFFC6D1DB);
  Color get blueGray300 => const Color(0xFF869FB5);
  Color get blueGray50 => const Color(0xFFECEFF2);
  Color get blueGray700 => const Color(0xFF3C536C);
  Color get deepOrange50 => const Color(0xFFF4BFAC);
  Color get gray50 => const Color(0xFFFCFCFC);
}

