import 'package:flutter/material.dart';

extension IsDarkMode on BuildContext {
  
  bool get isDarkMode {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.dark;
  }
}