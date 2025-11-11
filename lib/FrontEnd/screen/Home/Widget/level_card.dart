import 'package:ductuch_master/backend/models/level_model.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/FrontEnd/screen/exam/exam_screen.dart';

class LevelCard extends StatefulWidget {
  final LevelModel level;

  const LevelCard({super.key, required this.level});

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: ThemeService.defaultCurve,
      ),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
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
    final themeService = ThemeService.to;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final cardHeight = isTablet ? 200.0 : 180.0;
    final padding = isTablet ? 24.0 : 20.0;
    final badgeSize = isTablet ? 70.0 : 60.0;
    final titleSize = isTablet ? 24.0 : 20.0;
    final subtitleSize = isTablet ? 14.0 : 12.0;

    return Obx(() {
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;
      final backgroundDarkColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondaryTextColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
      final progress = lessonController.levelProgressPercent(widget.level.level);
      final isPassed = lessonController.isLevelPassed(widget.level.level);
      final dynamicHeight = (progress == 100 && !isPassed)
          ? cardHeight + 28.0
          : cardHeight;

      return MouseRegion(
        cursor: widget.level.isLocked
            ? SystemMouseCursors.basic
            : SystemMouseCursors.click,
        onEnter: (_) {
          if (!widget.level.isLocked) {
            setState(() => _isHovered = true);
            _animationController.forward();
          }
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: GestureDetector(
          onTap: widget.level.isLocked ? null : widget.level.ontap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                height: dynamicHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: themeService.getCardGradient(isDark),
                  boxShadow: ThemeService.getCardShadow(isDark),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Animated background gradient overlay
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
                        duration: ThemeService.defaultAnimationDuration,
                        builder: (context, value, child) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  primaryColor.withOpacity(0.1 * value),
                                  secondaryColor.withOpacity(0.05 * value),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
                              secondaryColor,
                              badgeSize,
                              titleSize,
                              subtitleSize,
                              themeService,
                            ),
                            const Spacer(),
                            _buildFooter(
                              context,
                              isDark,
                              textColor,
                              secondaryTextColor,
                              primaryColor,
                              subtitleSize,
                              progress,
                              isPassed,
                              themeService,
                            ),
                          ],
                        ),
                      ),
                      if (widget.level.isLocked)
                        _buildLockedOverlay(
                          context,
                          isDark,
                          textColor,
                          backgroundDarkColor,
                        ),
                      // PASS Tag with animation
                      Obx(() {
                        final passed = Get.find<LessonController>().isLevelPassed(
                          widget.level.level,
                        );
                        if (!passed) return const SizedBox.shrink();
                        return Positioned(
                          top: 12,
                          right: 12,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: ThemeService.slowAnimationDuration,
                            curve: ThemeService.bounceCurve,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor.withOpacity(0.2),
                                        secondaryColor.withOpacity(0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.emoji_events,
                                        size: 18,
                                        color: primaryColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'PASSED',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                          fontFamily: themeService.fontFamily,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
    Color secondaryColor,
    double badgeSize,
    double titleSize,
    double subtitleSize,
    ThemeService themeService,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Animated Badge
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
          duration: ThemeService.defaultAnimationDuration,
          curve: ThemeService.springCurve,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 1.0 + (value * 0.1),
              child: Transform.rotate(
                angle: value * 0.1,
                child: Container(
                  width: badgeSize,
                  height: badgeSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.25),
                        secondaryColor.withOpacity(0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3 * value),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.level.level,
                      style: TextStyle(
                        fontSize: titleSize * 0.9,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: themeService.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'level_title_${widget.level.level}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    widget.level.title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: themeService.fontFamily,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.level.moduleCount} modules · ${widget.level.lessonCount} lessons',
                style: TextStyle(
                  fontSize: subtitleSize,
                  color: secondaryTextColor,
                  fontFamily: themeService.fontFamily,
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
    bool isPassed,
    ThemeService themeService,
  ) {
    final scheme = themeService.currentScheme;
    final backgroundColor = isDark ? scheme.backgroundDark : scheme.background;

    return Column(
      children: [
        if (!widget.level.isLocked) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: fontSize,
                  color: secondaryTextColor,
                  fontFamily: themeService.fontFamily,
                ),
              ),
              Text(
                '${dynamicProgress}%',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: themeService.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Animated Progress Bar
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: dynamicProgress / 100.0),
            duration: ThemeService.slowAnimationDuration,
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: backgroundColor.withOpacity(0.2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, scheme.accentTeal],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.5),
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
        ],
        if (dynamicProgress == 100 && !isPassed) ...[
          const SizedBox(height: 14),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: ThemeService.defaultAnimationDuration,
            curve: ThemeService.springCurve,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.15),
                        scheme.accentTeal.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: primaryColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () {
                        NavigationHelper.pushWithBottomNav(
                          context,
                          const ExamScreen(),
                          arguments: {'level': widget.level.level},
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_turned_in,
                              color: primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Take Exam',
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontFamily: themeService.fontFamily,
                              ),
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
        ],
      ],
    );
  }

  Widget _buildLockedOverlay(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color backgroundColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.85),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: ThemeService.slowAnimationDuration,
              curve: ThemeService.bounceCurve,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.lock_outline,
                    color: textColor.withOpacity(0.6),
                    size: 48,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              'Locked',
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
