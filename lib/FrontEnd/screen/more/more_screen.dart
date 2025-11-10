import 'package:ductuch_master/FrontEnd/screen/exam/exam_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/practice/practice_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/categories/categories_list_screen.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// More Screen - displays Exam, Practice, and Categories options
/// Uses the same card design as learn.dart
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      return Scaffold(
        backgroundColor: const Color(0xFF0B0F14),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0F14),
          title: Text(
            'More',
            style: TextStyle(
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
            ),
          ),
          actions: [TtsSpeedDropdown()],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 500
                      ? 500
                      : constraints.maxWidth,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 500 ? 20 : 16,
                  vertical: constraints.maxWidth > 500 ? 30 : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      'More Options',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: GoogleFonts.patrickHand().fontFamily,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    Text(
                      'Explore additional learning features',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: Colors.white.withOpacity(0.6),
                        fontFamily: GoogleFonts.patrickHand().fontFamily,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 20 : 24),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildOptionCard(
                            'Exam',
                            'Test your knowledge with timed exams',
                            Icons.quiz,
                            () => Get.to(() => const ExamScreen()),
                            isSmallScreen,
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          _buildOptionCard(
                            'Practice',
                            'Practice without time limits',
                            Icons.park_rounded,
                            () => Get.to(() => const PracticeScreen()),
                            isSmallScreen,
                          ),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          _buildOptionCard(
                            'Categories',
                            'Learn words by category',
                            Icons.category,
                            () => Get.to(() => const CategoriesListScreen()),
                            isSmallScreen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildOptionCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isSmallScreen,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: Colors.white.withOpacity(0.02),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 50 : 60,
                  height: isSmallScreen ? 50 : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    color: Colors.white.withOpacity(0.05),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white.withOpacity(0.9),
                    size: isSmallScreen ? 24 : 28,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 16 : 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: GoogleFonts.patrickHand().fontFamily,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: Colors.white.withOpacity(0.6),
                          fontFamily: GoogleFonts.patrickHand().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.5),
                  size: isSmallScreen ? 16 : 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
