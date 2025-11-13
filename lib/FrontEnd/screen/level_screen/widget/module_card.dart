import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/backend/data/learning_path_data.dart';

class ModuleCard extends StatefulWidget {
  final ModuleInfo moduleInfo;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.moduleInfo, this.onTap});

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: ThemeService.springCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lessonController = Get.find<LessonController>();
    final themeService = Get.find<ThemeService>();
    final moduleId = widget.moduleInfo.ID.toString();

    return Obx(() {
      final totalTopics =
          LearningPathData.moduleTopics[moduleId]?.length ??
          widget.moduleInfo.lessonCount;
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
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
      final successColor = scheme.accentTeal;

      return MouseRegion(
        cursor: widget.moduleInfo.isLocked
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!widget.moduleInfo.isLocked) {
            setState(() => _isHovered = true);
            _animationController.forward();
          }
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: GestureDetector(
          onTap: widget.moduleInfo.isLocked ? null : widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: ThemeService.defaultAnimationDuration,
              curve: ThemeService.springCurve,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                      gradient: themeService.getCardGradient(isDark),
                      boxShadow: ThemeService.getCardShadow(isDark),
                      border: Border.all(
                        color: widget.moduleInfo.isLocked
                            ? textColor.withOpacity(0.2)
                            : isCompleted
                                ? successColor.withOpacity(0.4)
                                : primaryColor.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.moduleInfo.isLocked ? null : widget.onTap,
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                        splashColor: primaryColor.withOpacity(0.2),
                        highlightColor: primaryColor.withOpacity(0.1),
                        child: Padding(
                          padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon and Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Animated Icon Container
                                  TweenAnimationBuilder<double>(
                                    tween: Tween(
                                      begin: 0.0,
                                      end: _isHovered ? 1.0 : 0.0,
                                    ),
                                    duration: ThemeService.defaultAnimationDuration,
                                    curve: ThemeService.bounceCurve,
                                    builder: (context, value, child) {
                                      return Transform.rotate(
                                        angle: value * 0.1,
                                        child: Transform.scale(
                                          scale: 1.0 + (value * 0.1),
                                          child: Container(
                                            width: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                                            height: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  widget.moduleInfo.isLocked
                                                      ? textColor
                                                          .withOpacity(0.2)
                                                      : isCompleted
                                                          ? successColor
                                                              .withOpacity(0.3)
                                                          : primaryColor
                                                              .withOpacity(0.3),
                                                  widget.moduleInfo.isLocked
                                                      ? textColor
                                                          .withOpacity(0.1)
                                                      : isCompleted
                                                          ? successColor
                                                              .withOpacity(0.2)
                                                          : secondaryColor
                                                              .withOpacity(0.2),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                                              border: Border.all(
                                                color: widget.moduleInfo.isLocked
                                                    ? textColor.withOpacity(0.3)
                                                    : isCompleted
                                                        ? successColor
                                                            .withOpacity(0.5)
                                                        : primaryColor
                                                            .withOpacity(0.4),
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
                                              widget.moduleInfo.isLocked
                                                  ? Icons.lock
                                                  : (isCompleted
                                                      ? Icons.check_circle
                                                      : widget.moduleInfo.icon),
                                              color: widget.moduleInfo.isLocked
                                                  ? textColor.withOpacity(0.7)
                                                  : isCompleted
                                                      ? successColor
                                                      : primaryColor,
                                              size: ResponsiveHelper.isDesktop(context) ? 32 : ResponsiveHelper.isTablet(context) ? 30 : 28,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  // Status indicator
                                  if (isCompleted)
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.0, end: 1.0),
                                      duration: ThemeService.defaultAnimationDuration,
                                      curve: ThemeService.bounceCurve,
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: value,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  successColor.withOpacity(0.2),
                                                  successColor.withOpacity(0.1),
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                                              border: Border.all(
                                                color: successColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  size: ResponsiveHelper.getSmallIconSize(context),
                                                  color: successColor,
                                                ),
                                                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
                                                Text(
                                                  'Completed',
                                                  style: themeService.getLabelSmallStyle(
                                                    color: successColor,
                                                  ).copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  else if (widget.moduleInfo.isLocked)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: textColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: textColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.lock,
                                            size: 16,
                                            color: textColor.withOpacity(0.7),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Locked',
                                            style: themeService.getLabelSmallStyle(
                                              color: textColor.withOpacity(0.7),
                                            ).copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(height: ResponsiveHelper.getSpacing(context)),
                              // Title with Hero animation
                              Hero(
                                tag: 'module_title_${widget.moduleInfo.ID}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    widget.moduleInfo.title,
                                    style: themeService
                                        .getTitleLargeStyle(color: textColor)
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                              // Progress Text
                              Text(
                                '$completedTopics/$totalTopics topics completed',
                                style: themeService
                                    .getBodyMediumStyle(
                                      color: textColor.withOpacity(0.6),
                                    ),
                              ),
                              SizedBox(height: ResponsiveHelper.getSpacing(context)),
                              // Animated Progress Bar
                              if (!widget.moduleInfo.isLocked)
                                Column(
                                  children: [
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(begin: 0.0, end: progress),
                                      duration: ThemeService.slowAnimationDuration,
                                      curve: Curves.easeOutCubic,
                                      builder: (context, progressValue, child) {
                                        return Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.2),
                                            color: textColor.withOpacity(0.1),
                                          ),
                                          child: FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: progressValue,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    isCompleted
                                                        ? successColor
                                                        : primaryColor,
                                                    isCompleted
                                                        ? successColor
                                                            .withOpacity(0.8)
                                                        : secondaryColor,
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.2),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: (isCompleted
                                                            ? successColor
                                                            : primaryColor)
                                                        .withOpacity(0.5),
                                                    blurRadius: 4,
                                                    spreadRadius: 1,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '${(progress * 100).round()}%',
                                        style: themeService.getLabelSmallStyle(
                                          color: textColor.withOpacity(0.6),
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
              },
            ),
          ),
        ),
      );
    });
  }
}
