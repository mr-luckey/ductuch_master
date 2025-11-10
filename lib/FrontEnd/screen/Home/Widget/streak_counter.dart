import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum StreakSize { small, large }

class StreakCounter extends StatelessWidget {
  final int days;
  final StreakSize size;

  const StreakCounter({super.key, required this.days, required this.size});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    
    final iconSize = size == StreakSize.large ? 32.0 : 24.0;
    
    return Obx(() {
      final textStyle = size == StreakSize.large
          ? TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.headlineSmall?.fontFamily,
            )
          : TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.bodyLarge?.fontFamily,
            );

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              color: primaryColor,
              size: iconSize,
            ),
            const SizedBox(width: 4),
            Text(
              '$days',
              style: textStyle.copyWith(color: primaryColor),
            ),
          ],
        ),
      );
    });
  }
}
