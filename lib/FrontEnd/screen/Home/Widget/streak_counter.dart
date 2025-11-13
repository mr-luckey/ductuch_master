import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
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
    
    final iconSize = size == StreakSize.large 
        ? ResponsiveHelper.isDesktop(context) ? 36.0 : ResponsiveHelper.isTablet(context) ? 32.0 : 28.0
        : ResponsiveHelper.getSmallIconSize(context);
    
    return Obx(() {
      final textStyle = size == StreakSize.large
          ? themeService.getHeadlineSmallStyle().copyWith(
              fontWeight: FontWeight.bold,
            )
          : themeService.getBodyLargeStyle().copyWith(
              fontWeight: FontWeight.bold,
            );

      return Container(
        padding: ResponsiveHelper.getButtonPadding(context),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
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
            SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
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
