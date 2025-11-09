import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SentencesScreen extends StatelessWidget {
  const SentencesScreen({super.key});

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
            'Small Sentences',
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
                  'Small Sentences Book',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Practice with common German phrases and sentences',
                  style: TextStyle(
                    fontSize: 16,
                    color: secondaryTextColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                const SizedBox(height: 24),
                _buildSentenceCard(
                  'Guten Morgen!',
                  'Good morning!',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Wie geht es dir?',
                  'How are you?',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Ich heiße Maria.',
                  'My name is Maria.',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Wo ist die Toilette?',
                  'Where is the bathroom?',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Ich verstehe nicht.',
                  'I don\'t understand.',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Kannst du das wiederholen?',
                  'Can you repeat that?',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Entschuldigung!',
                  'Excuse me!',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildSentenceCard(
                  'Vielen Dank!',
                  'Thank you very much!',
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

  Widget _buildSentenceCard(
    String german,
    String english,
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
                      ? scheme.secondaryDark.withOpacity(0.2)
                      : scheme.secondary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chat_bubble,
                  color: isDark ? scheme.secondaryDark : scheme.secondary,
                  size: 24,
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
                    const SizedBox(height: 8),
                    Text(
                      english,
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryTextColor,
                        fontFamily: GoogleFonts.patrickHand().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
