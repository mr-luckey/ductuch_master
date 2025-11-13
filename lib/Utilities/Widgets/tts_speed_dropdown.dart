import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// TTS Speed Dropdown Widget
/// Displays a dropdown menu in the app bar for controlling global TTS speed
class TtsSpeedDropdown extends StatelessWidget {
  const TtsSpeedDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final ttsService = Get.find<TtsService>();
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final currentSpeed = ttsService.globalSpeed;
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final accentColor = scheme.accentTeal;

      return PopupMenuButton<double>(
        tooltip: 'Voice Speed',
        onSelected: (speed) {
          ttsService.setGlobalSpeed(speed);
        },
        itemBuilder: (context) => [
          _buildSpeedMenuItem(
            context,
            0.5,
            currentSpeed,
            '0.5x',
            textColor,
            accentColor,
            themeService,
          ),
          _buildSpeedMenuItem(
            context,
            0.8,
            currentSpeed,
            '0.8x',
            textColor,
            accentColor,
            themeService,
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.getSpacing(context) * 0.5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.speed,
                color: textColor.withOpacity(0.9),
                size: ResponsiveHelper.getSmallIconSize(context),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
              Text(
                '${currentSpeed.toStringAsFixed(1)}x',
                style: themeService.getStyle(
                  fontSize: ResponsiveHelper.getSmallSize(context),
                  color: textColor.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  PopupMenuItem<double> _buildSpeedMenuItem(
    BuildContext context,
    double speed,
    double currentSpeed,
    String label,
    Color textColor,
    Color accentColor,
    ThemeService themeService,
  ) {
    final isSelected = speed == currentSpeed;

    return PopupMenuItem<double>(
      value: speed,
      child: Row(
        children: [
          if (isSelected)
            Icon(
              Icons.check,
              size: ResponsiveHelper.getSmallIconSize(context),
              color: accentColor,
            )
          else
            SizedBox(width: ResponsiveHelper.getSpacing(context) * 1.125),
          SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
          Text(
            label,
            style: themeService.getStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: ResponsiveHelper.getSmallSize(context),
            ),
          ),
        ],
      ),
    );
  }
}
