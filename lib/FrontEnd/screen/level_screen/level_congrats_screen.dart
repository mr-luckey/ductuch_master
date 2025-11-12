import 'package:ductuch_master/app_routes.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
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
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
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
                  child: const Icon(
                    Icons.emoji_events,
                    size: 58,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Congratulations!',
                  style: themeService
                      .getHeadlineMediumStyle(color: text)
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'You’ve completed level $level.\nKeep the momentum going!',
                  style: themeService.getBodyLargeStyle(
                    color: secondary.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.offAllNamed(AppRoutes.mainNavigation);
                  },
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Main'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
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
