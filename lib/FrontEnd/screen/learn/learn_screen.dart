import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondaryTextColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Learn',
            style: TextStyle(
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
              onPressed: () => themeService.toggleDarkMode(),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.palette, color: textColor),
              onSelected: (value) {
                final index = int.parse(value);
                themeService.changeScheme(index);
              },
              itemBuilder: (context) => ThemeService.colorSchemes
                  .asMap()
                  .entries
                  .map(
                    (entry) => PopupMenuItem(
                      value: entry.key.toString(),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: entry.value.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(entry.value.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Learning Path',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose a level to start learning',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 24),
                _buildLevelsList(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildLevelsList() {
    final levels = LevelModel.mockLevels;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: levels[index].ontap,
            child: LevelCard(level: levels[index]),
          ),
        );
      },
    );
  }
}
