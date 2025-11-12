import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressCircle extends StatelessWidget {
  final int progress;
  final double size;

  const ProgressCircle({super.key, required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final backgroundColor = isDark ? scheme.surfaceDark : scheme.surface;
    
    return Obx(() {
      return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress / 100,
              strokeWidth: 8,
              backgroundColor: backgroundColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          ),
          Text(
            '$progress%',
            style: themeService.getStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      );
    });
  }
}
