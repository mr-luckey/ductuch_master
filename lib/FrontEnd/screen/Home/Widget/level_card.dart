import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:flutter/material.dart';
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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = theme.cardColor;
    final borderColor = theme.dividerColor.withOpacity(0.3);
    final textColor = theme.textTheme.titleMedium?.color ?? colorScheme.onSurface;
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? colorScheme.onSurfaceVariant;
    final primaryColor = colorScheme.primary;
    final badgeColor = primaryColor.withOpacity(0.12);
    final badgeBorderColor = primaryColor.withOpacity(0.28);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: theme.cardTheme.elevation ?? (isDark ? 0 : 1.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      color: backgroundColor,
      child: InkWell(
        onTap: level.ontap,
        borderRadius: BorderRadius.circular(16),
        splashColor: primaryColor.withOpacity(0.08),
        highlightColor: primaryColor.withOpacity(0.04),
        child: SizedBox(
          height: cardHeight,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      context,
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
                      context,
                      isDark,
                      textColor,
                      secondaryTextColor,
                      primaryColor,
                      subtitleSize,
                    ),
                  ],
                ),
              ),
              if (level.isLocked) _buildLockedOverlay(context, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
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
    BuildContext context,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    double fontSize,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
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
              color: colorScheme.surfaceVariant.withOpacity(0.35),
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

  Widget _buildLockedOverlay(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface = Theme.of(context).textTheme.titleMedium?.color ?? colorScheme.onSurface;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(isDark ? 0.7 : 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          Icons.lock,
          color: onSurface,
          size: 32,
        ),
      ),
    );
  }
}
