import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerbsScreen extends StatelessWidget {
  const VerbsScreen({super.key});

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
            'Verbs',
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
                  'German Verbs',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Master essential German verbs and their conjugations',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 24),
                _buildVerbCard(
                  'sein',
                  'to be',
                  'ich bin, du bist, er/sie/es ist',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  'haben',
                  'to have',
                  'ich habe, du hast, er/sie/es hat',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  'gehen',
                  'to go',
                  'ich gehe, du gehst, er/sie/es geht',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  'kommen',
                  'to come',
                  'ich komme, du kommst, er/sie/es kommt',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  'machen',
                  'to make/do',
                  'ich mache, du machst, er/sie/es macht',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  'sagen',
                  'to say',
                  'ich sage, du sagst, er/sie/es sagt',
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

  Widget _buildVerbCard(
    String infinitive,
    String english,
    String conjugation,
    scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? scheme.primaryDark.withOpacity(0.2)
                      : scheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: isDark ? scheme.primaryDark : scheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infinitive,
                      style: TextStyle(
                        fontSize: 22,
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
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? scheme.backgroundDark : scheme.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              conjugation,
              style: TextStyle(
                fontSize: 14,
                color: secondaryTextColor,
                fontFamily: GoogleFonts.patrickHand().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
