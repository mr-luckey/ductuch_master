import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomStylee {
  static TextStyle getMainStyle(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    return themeService.getTitleMediumStyle(
      color: isDark ? scheme.textPrimaryDark : scheme.textPrimary,
    ).copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle getSubheadStyle(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    return themeService.getBodySmallStyle(
      color: isDark ? scheme.textSecondaryDark : scheme.textSecondary,
    );
  }

  static TextStyle getMainHeadingStyle(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    return themeService.getHeadlineMediumStyle(
      color: isDark ? scheme.textPrimaryDark : scheme.textPrimary,
    );
  }
}
