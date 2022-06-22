import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/themes/app_theme.dart' as app_theme;

class LightTheme extends app_theme.AppTheme {
  LightTheme() : super() {
    material = ThemeData(
      textTheme: const TextTheme(
        headline1: _headline1,
        headline2: _headline2,
        headline3: _headline3,
        bodyText1: _bodyText1,
        subtitle1: _subtitle1,
        button: _button,
        overline: _overLine,
        caption: _caption,
      ),
      colorScheme: const ColorScheme.light(
        primary: Colors.amber,
        secondary: Colors.amber,
      ),
      iconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      backgroundColor: Colors.grey.shade200,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: _overLine,
        unselectedLabelStyle: _overLine,
        type: BottomNavigationBarType.fixed,
      ),
      appBarTheme: const AppBarTheme(
        titleSpacing: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
        ),
      ),
    );

    mode = ThemeMode.light;
  }

  static const String _defaultFontFamily = 'LemonMilk';

  static const TextStyle _headline1 = TextStyle(
    color: Colors.black,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _headline2 = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _headline3 = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _bodyText1 = TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _subtitle1 = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _button = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _overLine = TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontFamily: _defaultFontFamily,
  );
  static const TextStyle _caption = TextStyle(
    color: Colors.grey,
    fontSize: 10,
    fontFamily: _defaultFontFamily,
  );
}
