import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NounsScreen extends StatelessWidget {
  const NounsScreen({super.key});

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
            'Nouns',
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
                  'German Nouns',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Learn essential German nouns with their articles',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 24),
                _buildNounCard(
                  'der Mann',
                  'the man',
                  'masculine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  'die Frau',
                  'the woman',
                  'feminine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  'das Kind',
                  'the child',
                  'neuter',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  'der Tisch',
                  'the table',
                  'masculine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  'die Tür',
                  'the door',
                  'feminine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  'das Buch',
                  'the book',
                  'neuter',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNounCard(
    String german,
    String english,
    String gender,
    scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    Color genderColor;
    switch (gender) {
      case 'masculine':
        genderColor = Colors.blue;
        break;
      case 'feminine':
        genderColor = Colors.pink;
        break;
      case 'neuter':
        genderColor = Colors.green;
        break;
      default:
        genderColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceDark.withOpacity(0.5)
            : scheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? scheme.primaryDark.withOpacity(0.2)
              : scheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: genderColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                gender[0].toUpperCase(),
                style: TextStyle(
                  color: genderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  german,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  english,
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryTextColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: genderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              gender,
              style: TextStyle(
                color: genderColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
