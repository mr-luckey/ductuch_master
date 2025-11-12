import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

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
            0.5,
            currentSpeed,
            '0.5x',
            textColor,
            accentColor,
            themeService,
          ),
          _buildSpeedMenuItem(
            0.8,
            currentSpeed,
            '0.8x',
            textColor,
            accentColor,
            themeService,
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.speed,
                color: textColor.withOpacity(0.9),
                size: isTablet ? 20 : 18,
              ),
              SizedBox(width: 4),
              Text(
                '${currentSpeed.toStringAsFixed(1)}x',
                style: themeService.getStyle(
                  fontSize: isTablet ? 14 : 12,
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
            Icon(Icons.check, size: 18, color: accentColor)
          else
            SizedBox(width: 18),
          SizedBox(width: 12),
          Text(
            label,
            style: themeService.getStyle(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
