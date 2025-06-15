import 'package:flutter/material.dart';

class ThemeColorOption {
  final String name;
  final Color color;

  ThemeColorOption(this.name, this.color);
}

class ThemePreference {
  final ThemeMode themeMode;
  final Color primaryColor;

  ThemePreference({
    required this.themeMode,
    required this.primaryColor,
  });
}
