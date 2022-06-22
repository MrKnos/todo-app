import 'package:flutter/material.dart';

enum SupportedTheme { light }

abstract class AppTheme {
  AppTheme();

  late final ThemeMode mode;
  late final ThemeData material;
}
