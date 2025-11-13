import 'package:ductuch_master/app_routes.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelCongratsScreen extends StatelessWidget {
  final String level;

  const LevelCongratsScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.to;
    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final background = isDark ? scheme.backgroundDark : scheme.background;
      final text = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondary = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final accent = scheme.accentTeal;

      return Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: ResponsiveHelper.isDesktop(context) ? 130 : ResponsiveHelper.isTablet(context) ? 120 : 110,
                  height: ResponsiveHelper.isDesktop(context) ? 130 : ResponsiveHelper.isTablet(context) ? 120 : 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accent.withOpacity(0.35),
                        scheme.primary.withOpacity(0.3),
                      ],
                    ),
                    boxShadow: ThemeService.getCardShadow(isDark),
                  ),
                  child: Icon(
                    Icons.emoji_events,
                    size: ResponsiveHelper.isDesktop(context) ? 70 : ResponsiveHelper.isTablet(context) ? 64 : 58,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.75),
                Text(
                  'Congratulations!',
                  style: themeService
                      .getHeadlineMediumStyle(color: text)
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.75),
                Text(
                  'You’ve completed level $level.\nKeep the momentum going!',
                  style: themeService.getBodyLargeStyle(
                    color: secondary.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.mainNavigation);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Main'),
                  style: ElevatedButton.styleFrom(
                    padding: ResponsiveHelper.getButtonPadding(context),
                    textStyle: themeService.getBodyLargeStyle(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
