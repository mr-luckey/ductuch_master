import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 16.0;
    final titleSize = isTablet ? 36.0 : 28.0;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(children: [_buildContentSection(context, scheme, isDark, textColor, padding, titleSize, isTablet)]),
          ),
        ),
      );
    });
  }

  Widget _buildContentSection(BuildContext context, scheme, bool isDark, Color textColor, double padding, double titleSize, bool isTablet) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: isTablet ? 24 : 20),
          Text(
            'Your Learning Path',
            style: TextStyle(
              fontSize: titleSize,
              color: textColor,
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isTablet ? 20 : 16),
          _buildLevelsGrid(),
        ],
      ),
    );
  }

  Widget _buildLevelsGrid() {
    final levels = LevelModel.mockLevels;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: levels[index].ontap,
          child: LevelCard(level: levels[index]),
        );
      },
    );
  }
}
