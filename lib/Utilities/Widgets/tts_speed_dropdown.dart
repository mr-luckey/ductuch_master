import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// TTS Speed Dropdown Widget
/// Displays a dropdown menu in the app bar for controlling global TTS speed
class TtsSpeedDropdown extends StatelessWidget {
  const TtsSpeedDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final ttsService = Get.find<TtsService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Obx(() {
      final currentSpeed = ttsService.globalSpeed;
      
      return PopupMenuButton<double>(
        tooltip: 'Voice Speed',
        onSelected: (speed) {
          ttsService.setGlobalSpeed(speed);
        },
        itemBuilder: (context) => [
          _buildSpeedMenuItem(0.5, currentSpeed, '0.5x'),
          _buildSpeedMenuItem(0.8, currentSpeed, '0.8x'),
          _buildSpeedMenuItem(1.0, currentSpeed, '1x'),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.speed,
                color: Colors.white.withOpacity(0.9),
                size: isTablet ? 20 : 18,
              ),
              SizedBox(width: 4),
              Text(
                '${currentSpeed}x',
                style: TextStyle(
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                  color: Colors.white.withOpacity(0.9),
                  fontSize: isTablet ? 14 : 12,
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
  ) {
    final isSelected = speed == currentSpeed;
    
    return PopupMenuItem<double>(
      value: speed,
      child: Row(
        children: [
          if (isSelected)
            Icon(
              Icons.check,
              size: 18,
              color: Colors.blue,
            )
          else
            SizedBox(width: 18),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

