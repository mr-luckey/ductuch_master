import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'progress_circle.dart';
import 'streak_counter.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;

    return Obx(() {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Welcome Message and Button
              _buildWelcomeSection(context, scheme, isDark),
              const SizedBox(height: 20),
              // Progress and Streak
              _buildProgressSection(context, scheme, isDark),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildWelcomeSection(BuildContext context, scheme, bool isDark) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final secondaryTextColor = isDark
        ? scheme.textSecondaryDark
        : scheme.textSecondary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final buttonTextColor = isDark
        ? scheme.textPrimaryDark
        : scheme.textPrimary;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back! 👋',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.fontFamily,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Keep your streak going and continue your German journey',
                style: TextStyle(
                  fontSize: 14,
                  color: secondaryTextColor,
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Navigate to levels
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: buttonTextColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, size: 20),
                    const SizedBox(width: 8),
                    Text('Continue Learning'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context, scheme, bool isDark) {
    final secondaryTextColor = isDark
        ? scheme.textSecondaryDark
        : scheme.textSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              'Daily Goal',
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            ProgressCircle(progress: 60, size: 80),
          ],
        ),
        Column(
          children: [
            Text(
              'Streak',
              style: TextStyle(
                fontSize: 12,
                color: secondaryTextColor,
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
              ),
            ),
            const SizedBox(height: 8),
            StreakCounter(days: 12, size: StreakSize.large),
          ],
        ),
      ],
    );
  }
}
