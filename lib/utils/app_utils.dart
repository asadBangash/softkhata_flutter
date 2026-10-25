import 'package:flutter/material.dart';
import 'package:soft_khata_flutter/theme/ThemeColors.dart';

class AppUtils {
  static Color black() {
    return ThemeMode.dark == null ? ThemeColors.COLOR_BLACK : ThemeColors.COLOR_WHITE;
  }

  static Color white() {
    return ThemeMode.dark == null ? ThemeColors.COLOR_WHITE : ThemeColors.COLOR_BLACK;
  }

}
