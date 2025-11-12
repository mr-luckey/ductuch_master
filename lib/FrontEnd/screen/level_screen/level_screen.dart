import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/FrontEnd/screen/level_screen/widget/module_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/FrontEnd/screen/exam/exam_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/level_screen/level_congrats_screen.dart';

class LevelScreen extends StatefulWidget {
  final String level;

  const LevelScreen({super.key, this.level = ''});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _hasShownCongrats = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: ThemeService.slowAnimationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final lessonController = Get.find<LessonController>();
    // Get level from constructor or route arguments
    String currentLevelKey = widget.level;
    if (currentLevelKey.isEmpty) {
      final args = Get.arguments;
      if (args is String) {
        currentLevelKey = args;
      } else if (args is Map) {
        currentLevelKey = args['level']?.toString() ?? '';
      }
    }

    // Normalize to lowercase for lookup
    currentLevelKey = currentLevelKey.toLowerCase();

    // Get the level info, default to 'a1' if not found
    final currentLevel =
        LearningPathData.levelInfo[currentLevelKey] ??
        LearningPathData.levelInfo['a1']!;

    final levelCodeUpper = currentLevelKey.toUpperCase();

    return Obx(() {
      final progressPercent = lessonController.levelProgressPercent(
        levelCodeUpper,
      );
      final allDone = progressPercent >= 100;
      final isLevelPassed = lessonController.isLevelPassed(levelCodeUpper);

      if (isLevelPassed && !_hasShownCongrats) {
        _hasShownCongrats = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Get.to(() => LevelCongratsScreen(level: levelCodeUpper));
        });
      }

      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
      final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: <Widget>[
                // Animated Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: ThemeService.defaultAnimationDuration,
                      curve: ThemeService.springCurve,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Back button and title row
                                Row(
                                  children: [
                                    Hero(
                                      tag: 'back_button_$currentLevelKey',
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            gradient: themeService
                                                .getCardGradient(isDark),
                                            border: Border.all(
                                              color: primaryColor.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                            boxShadow:
                                                ThemeService.getCardShadow(
                                                  isDark,
                                                ),
                                          ),
                                          child: IconButton(
                                            onPressed: () => Get.back(),
                                            icon: Icon(
                                              Icons.chevron_left,
                                              color: textColor,
                                              size: 24,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Hero(
                                            tag: 'level_title_$currentLevelKey',
                                            child: Material(
                                              color: Colors.transparent,
                                              child: ShaderMask(
                                                shaderCallback: (bounds) =>
                                                    LinearGradient(
                                                      colors: [
                                                        textColor,
                                                        primaryColor,
                                                      ],
                                                    ).createShader(bounds),
                                                child: Text(
                                                  currentLevel.title,
                                                  style: themeService
                                                      .getHeadlineSmallStyle(
                                                        color: Colors.white,
                                                      )
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          // Animated Progress Bar
                                          TweenAnimationBuilder<double>(
                                            tween: Tween(
                                              begin: 0.0,
                                              end: (progressPercent / 100)
                                                  .clamp(0.0, 1.0),
                                            ),
                                            duration: ThemeService
                                                .slowAnimationDuration,
                                            curve: Curves.easeOutCubic,
                                            builder: (context, progressValue, child) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      height: 8,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        color: surfaceColor
                                                            .withOpacity(0.1),
                                                      ),
                                                      child: FractionallySizedBox(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        widthFactor:
                                                            progressValue,
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            gradient:
                                                                LinearGradient(
                                                                  colors: [
                                                                    primaryColor,
                                                                    secondaryColor,
                                                                  ],
                                                                ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  4,
                                                                ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: primaryColor
                                                                    .withOpacity(
                                                                      0.5,
                                                                    ),
                                                                blurRadius: 4,
                                                                spreadRadius: 1,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                    '$progressPercent%',
                                                    style: themeService
                                                        .getLabelSmallStyle(
                                                          color: textColor
                                                              .withOpacity(0.8),
                                                        ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          if (currentLevel
                                              .description
                                              .isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              currentLevel.description,
                                              style: themeService
                                                  .getBodyMediumStyle(
                                                    color: textColor
                                                        .withOpacity(0.7),
                                                  ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Modules list or empty state
                if (currentLevel.modules.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: ThemeService.defaultAnimationDuration,
                        curve: ThemeService.bounceCurve,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.3),
                                          secondaryColor.withOpacity(0.2),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                        width: 3,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.construction,
                                      size: 50,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Coming Soon',
                                    style: themeService
                                        .getHeadlineSmallStyle(color: textColor)
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'This level is under development',
                                    style: themeService.getBodyMediumStyle(
                                      color: textColor.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final module = currentLevel.modules[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          curve: ThemeService.springCurve,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(30 * (1 - value), 0),
                              child: Opacity(
                                opacity: value.clamp(0.0, 1.0),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: ModuleCard(
                                    moduleInfo: module,
                                    onTap: () {
                                      // Determine the route based on the module's level prefix
                                      String route = '/lesson/a1';
                                      final moduleLevel = module.ID
                                          .split('-')
                                          .first
                                          .toUpperCase();

                                      switch (moduleLevel) {
                                        case 'A1':
                                          route = '/lesson/a1';
                                          break;
                                        case 'A2':
                                          route = '/lesson/a2';
                                          break;
                                        case 'B1':
                                          route = '/lesson/b1';
                                          break;
                                        case 'B2':
                                          route = '/lesson/b2';
                                          break;
                                        case 'C1':
                                          route = '/lesson/c1';
                                          break;
                                        case 'C2':
                                          route = '/lesson/c2';
                                          break;
                                        default:
                                          route = '/lesson/a1';
                                      }

                                      Get.toNamed(
                                        route,
                                        arguments: {'moduleId': module.ID},
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }, childCount: currentLevel.modules.length),
                    ),
                  ),
                // Exam button if all done but not yet passed
                if (allDone && !isLevelPassed)
                  SliverToBoxAdapter(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: ThemeService.defaultAnimationDuration,
                      curve: ThemeService.bounceCurve,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                24,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.2),
                                      secondaryColor.withOpacity(0.15),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        () => const ExamScreen(),
                                        arguments: {'level': levelCodeUpper},
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    splashColor: primaryColor.withOpacity(0.2),
                                    highlightColor: primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 16,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  primaryColor,
                                                  secondaryColor,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.assignment_turned_in,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Take Exam',
                                                  style: themeService
                                                      .getTitleMediumStyle(
                                                        color: textColor,
                                                      )
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Test your knowledge for $levelCodeUpper',
                                                  style: themeService
                                                      .getBodySmallStyle(
                                                        color: textColor
                                                            .withOpacity(0.7),
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: primaryColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (isLevelPassed)
                  SliverToBoxAdapter(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: ThemeService.defaultAnimationDuration,
                      curve: ThemeService.defaultCurve,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 16 * (1 - value)),
                          child: Opacity(
                            opacity: value.clamp(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                16,
                                24,
                                24,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      scheme.accentTeal.withOpacity(0.25),
                                      primaryColor.withOpacity(0.2),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: scheme.accentTeal.withOpacity(0.5),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: scheme.accentTeal.withOpacity(0.3),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              scheme.accentTeal,
                                              primaryColor,
                                            ],
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.emoji_events,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Level Completed! 🎉',
                                              style: themeService
                                                  .getTitleMediumStyle(
                                                    color: textColor,
                                                  )
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'You passed the $levelCodeUpper exam with flying colors. Keep exploring the next level!',
                                              style: themeService
                                                  .getBodySmallStyle(
                                                    color: textColor
                                                        .withOpacity(0.75),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
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
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ),
      );
    });
  }
}
