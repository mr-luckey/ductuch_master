import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/backend/data/learning_path_data.dart';
// import '../models/level_model.dart';

class ModuleCard extends StatelessWidget {
  final ModuleInfo moduleInfo;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.moduleInfo, this.onTap});

  @override
  Widget build(BuildContext context) {
    final lessonController = Get.find<LessonController>();
    final themeService = Get.find<ThemeService>();
    final moduleId = moduleInfo.ID.toString();

    return Obx(() {
      final totalTopics =
          LearningPathData.moduleTopics[moduleId]?.length ??
          moduleInfo.lessonCount;
      final completedTopics = lessonController.completedLessons
          .where((t) => t.startsWith('$moduleId-'))
          .length;
      final double progress = totalTopics == 0
          ? 0
          : (completedTopics / totalTopics).clamp(0.0, 1.0);
      final bool isCompleted =
          totalTopics > 0 && completedTopics >= totalTopics;

      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final borderColor = isDark
          ? scheme.textPrimaryDark.withOpacity(0.1)
          : scheme.textPrimary.withOpacity(0.1);
      final containerColor = isDark
          ? scheme.textPrimaryDark.withOpacity(0.02)
          : scheme.textPrimary.withOpacity(0.02);

      return MouseRegion(
        cursor: moduleInfo.isLocked
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: moduleInfo.isLocked ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..translate(0.0, moduleInfo.isLocked ? 0.0 : -2.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: moduleInfo.isLocked
                      ? borderColor.withOpacity(0.5)
                      : borderColor,
                ),
                color: moduleInfo.isLocked
                    ? containerColor.withOpacity(0.5)
                    : containerColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: moduleInfo.isLocked
                                ? Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.2)
                                : (isCompleted
                                      ? Colors.green.withOpacity(0.2)
                                      : Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.2)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            moduleInfo.isLocked
                                ? Icons.lock
                                : (isCompleted ? Icons.check : moduleInfo.icon),
                            color: _getIconColor(
                              isCompleted,
                              moduleInfo.isLocked,
                              textColor,
                            ),
                            size: 24,
                          ),
                        ),
                        // Status indicator
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: scheme.accentTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: scheme.accentTeal,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 16,
                                  color: scheme.accentTeal,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: scheme.accentTeal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.patrickHand().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (moduleInfo.isLocked)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: textColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: textColor, width: 1),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.lock, size: 16, color: textColor),
                                const SizedBox(width: 4),
                                Text(
                                  'Locked',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        GoogleFonts.patrickHand().fontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Title
                    Text(
                      moduleInfo.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontFamily: GoogleFonts.patrickHand().fontFamily,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Progress Text
                    Text(
                      '$completedTopics/$totalTopics topics completed',
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor.withOpacity(0.6),
                        fontFamily: GoogleFonts.patrickHand().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    if (!moduleInfo.isLocked)
                      Column(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: textColor.withOpacity(0.05),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: _getProgressColor(isCompleted),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${(progress * 100).round()}%',
                              style: TextStyle(
                                fontSize: 12,
                                color: textColor.withOpacity(0.6),
                                fontFamily:
                                    GoogleFonts.patrickHand().fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Color _getProgressColor(bool isCompleted) {
    final themeService = Get.find<ThemeService>();
    if (isCompleted) {
      return themeService.currentScheme.accentTeal;
    } else {
      return themeService.currentScheme.accentTeal.withOpacity(0.6);
    }
  }

  Color _getIconColor(bool isCompleted, bool isLocked, Color textColor) {
    final themeService = Get.find<ThemeService>();

    // Determine the background color for the icon container
    final bgColor = isLocked
        ? Theme.of(Get.context!).colorScheme.onSurface.withOpacity(0.2)
        : (isCompleted
              ? themeService.currentScheme.accentTeal.withOpacity(0.2)
              : Theme.of(Get.context!).colorScheme.primary.withOpacity(0.2));

    // Use high contrast color based on luminance - lighter backgrounds get dark text, darker get light text
    if (bgColor.computeLuminance() > 0.5) {
      // Light background - use dark text color
      return Colors.black;
    } else {
      // Dark background - use light text color (textColor works well here)
      return textColor;
    }
  }
}
