import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Blank',
            style: TextStyle(
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
            ),
          ),
        ),
        body: Center(
          child: Text(
            'Blank Screen',
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              color: textColor,
              fontFamily: GoogleFonts.patrickHand().fontFamily,
            ),
          ),
        ),
      );
    });
  }
}


