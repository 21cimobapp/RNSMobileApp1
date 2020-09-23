import 'package:flutter/material.dart';

enum MyThemeKeys { LIGHT1, LIGHT2, DARK, DARKER }

class MyThemes {
  static final ThemeData lightTheme1 = ThemeData(
    primaryColor: Color(0xFF128C7E),
    accentColor: Color(0xff4bb17b),
    brightness: Brightness.light,
  );

  static final ThemeData lightTheme2 = ThemeData(
    primaryColor: Color(0xff4E11F4),
    accentColor: Color(0xff4E11F4),
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.grey,
    brightness: Brightness.dark,
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.black,
    accentColor: Colors.black,
    brightness: Brightness.dark,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT1:
        return lightTheme1;
      case MyThemeKeys.LIGHT2:
        return lightTheme2;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.DARKER:
        return darkerTheme;
      default:
        return lightTheme1;
    }
  }
}
