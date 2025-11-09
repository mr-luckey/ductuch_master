import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LevelCard extends StatelessWidget {
  final LevelModel level;

  const LevelCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardHeight = isTablet ? 200.0 : 180.0;
    final padding = isTablet ? 24.0 : 20.0;
    final badgeSize = isTablet ? 70.0 : 60.0;
    final titleSize = isTablet ? 24.0 : 20.0;
    final subtitleSize = isTablet ? 14.0 : 12.0;

    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      final backgroundColor = isDark
          ? scheme.surfaceDark.withOpacity(0.6)
          : scheme.surface.withOpacity(0.6);
      final borderColor = isDark
          ? scheme.primaryDark.withOpacity(0.3)
          : scheme.primary.withOpacity(0.3);
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondaryTextColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final badgeColor = primaryColor.withOpacity(0.2);
      final badgeBorderColor = primaryColor.withOpacity(0.4);

      return Container(
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    context,
                    scheme,
                    isDark,
                    textColor,
                    secondaryTextColor,
                    primaryColor,
                    badgeColor,
                    badgeBorderColor,
                    badgeSize,
                    titleSize,
                    subtitleSize,
                  ),
                  const Spacer(),
                  _buildFooter(
                    scheme,
                    isDark,
                    textColor,
                    secondaryTextColor,
                    primaryColor,
                    subtitleSize,
                  ),
                ],
              ),
            ),
            if (level.isLocked) _buildLockedOverlay(scheme, isDark),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color badgeColor,
    Color badgeBorderColor,
    double badgeSize,
    double titleSize,
    double subtitleSize,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: badgeSize,
          height: badgeSize,
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: badgeBorderColor),
          ),
          child: Center(
            child: Text(
              level.level,
              style: TextStyle(
                fontSize: titleSize * 0.9,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: GoogleFonts.patrickHand().fontFamily,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level.title,
                style: TextStyle(
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${level.moduleCount} modules · ${level.lessonCount} lessons',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: secondaryTextColor,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
    scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    double fontSize,
  ) {
    return Column(
      children: [
        if (!level.isLocked) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: fontSize,
                  color: secondaryTextColor,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
              Text(
                '${level.progress}%',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: isDark
                  ? scheme.backgroundDark.withOpacity(0.3)
                  : scheme.background.withOpacity(0.3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: level.progress / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
        if (level.progress == 100) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.emoji_events,
                color: primaryColor,
                size: 18,
              ),
              const SizedBox(width: 4),
              Text(
                'Completed!',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: primaryColor,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLockedOverlay(scheme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? scheme.backgroundDark.withOpacity(0.7)
            : scheme.background.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.lock,
          color: isDark ? scheme.textPrimaryDark : scheme.textPrimary,
          size: 32,
        ),
      ),
    );
  }
}
