import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomStylee {
  static TextStyle getMainStyle(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    return TextStyle(
      fontSize: 20,
      fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
      color: isDark ? scheme.textPrimaryDark : scheme.textPrimary,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getSubheadStyle(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    return TextStyle(
      fontSize: 12,
      color: isDark ? scheme.textSecondaryDark : scheme.textSecondary,
      fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
    );
  }

  static TextStyle getMainHeadingStyle(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    return TextStyle(
      fontSize: 28,
      color: isDark ? scheme.textPrimaryDark : scheme.textPrimary,
      fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
    );
  }
}
