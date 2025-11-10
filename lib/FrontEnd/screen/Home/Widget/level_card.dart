import 'package:ductuch_master/backend/models/level_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/FrontEnd/screen/exam/exam_screen.dart';

class LevelCard extends StatelessWidget {
  final LevelModel level;

  const LevelCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final lessonController = Get.find<LessonController>();
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
    final textColor =
        theme.textTheme.titleMedium?.color ?? colorScheme.onSurface;
    final secondaryTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ??
        colorScheme.onSurfaceVariant;
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
        child: Obx(() {
          final progress = lessonController.levelProgressPercent(level.level);
          final isPassed = lessonController.isLevelPassed(level.level);
          final dynamicHeight = (progress == 100 && !isPassed)
              ? cardHeight + 28.0
              : cardHeight;
          return SizedBox(
            height: dynamicHeight,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(padding),
                  child: Obx(() {
                    final innerProgress = lessonController.levelProgressPercent(
                      level.level,
                    );
                    final innerIsPassed = lessonController.isLevelPassed(
                      level.level,
                    );
                    return Column(
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
                          innerProgress,
                        ),
                        if (innerIsPassed) const SizedBox(height: 0),
                      ],
                    );
                  }),
                ),
                if (level.isLocked) _buildLockedOverlay(context, isDark),
                // PASS Tag
                Obx(() {
                  final passed = Get.find<LessonController>().isLevelPassed(
                    level.level,
                  );
                  if (!passed) return const SizedBox.shrink();
                  return Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_offer,
                            size: 14,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'PASSED',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              fontFamily: GoogleFonts.patrickHand().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }),
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
    int dynamicProgress,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final lessonController = Get.find<LessonController>();
    final isPassed = lessonController.isLevelPassed(level.level);
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
                '${dynamicProgress}%',
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
              widthFactor: dynamicProgress / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
        if (dynamicProgress == 100 && !isPassed) ...[
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.35)),
              color: primaryColor.withOpacity(0.10),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Get.to(
                    () => const ExamScreen(),
                    arguments: {'level': level.level},
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_turned_in,
                        color: primaryColor,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Take Exam',
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w700,
                          color: primaryColor,
                          fontFamily: GoogleFonts.patrickHand().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildLockedOverlay(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    final onSurface =
        Theme.of(context).textTheme.titleMedium?.color ?? colorScheme.onSurface;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(isDark ? 0.7 : 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: Icon(Icons.lock, color: onSurface, size: 32)),
    );
  }
}
