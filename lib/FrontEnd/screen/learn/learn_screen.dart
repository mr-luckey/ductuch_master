import 'package:ductuch_master/FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/FrontEnd/screen/Levels/levels_overview_screen.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  final LessonController lessonController = Get.find<LessonController>();

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
    final padding = ResponsiveHelper.getPadding(context);
    final spacing = ResponsiveHelper.getSpacing(context);

    return Obx(() {
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final totalTopics = _totalTopicsCount();
      final completedTopics = lessonController.completedLessons.length;
      final progressFraction = totalTopics == 0
          ? 0.0
          : (completedTopics / totalTopics).clamp(0.0, 1.0);
      final nextLesson = _nextLessonToContinue();

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: _buildAnimatedAppBar(
          context: context,
          themeService: themeService,
          progressFraction: progressFraction,
          completedTopics: completedTopics,
          totalTopics: totalTopics,
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.getMaxContentWidth(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacing * 0.6),
                    if (nextLesson != null) ...[
                      _buildNextLessonCard(
                        context: context,
                        themeService: themeService,
                        nextLesson: nextLesson,
                      ),
                      SizedBox(height: spacing),
                    ],
                    _buildStatsRow(
                      themeService: themeService,
                      primaryColor: primaryColor,
                      textColor: textColor,
                      progressFraction: progressFraction,
                    ),
                    SizedBox(height: spacing),
                    _buildLevelsCallout(
                      context: context,
                      themeService: themeService,
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

  PreferredSizeWidget _buildAnimatedAppBar({
    required BuildContext context,
    required ThemeService themeService,
    required double progressFraction,
    required int completedTopics,
    required int totalTopics,
  }) {
    final appBarHeight = ResponsiveHelper.isDesktop(context) ? 220.0 : ResponsiveHelper.isTablet(context) ? 220.0 : 255.0;
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final primary = isDark ? scheme.primaryDark : scheme.primary;
    final secondary = isDark ? scheme.secondaryDark : scheme.secondary;
    final accent = scheme.accentTeal;
    final completedModules = _completedModuleCount();
    final totalModules = _totalModulesCount();
    final percentage = (progressFraction * 100).round();

    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primary.withOpacity(isDark ? 0.85 : 0.9),
              accent.withOpacity(isDark ? 0.75 : 0.85),
              secondary.withOpacity(isDark ? 0.7 : 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ResponsiveHelper.getBorderRadius(context) * 1.6),
            bottomRight: Radius.circular(ResponsiveHelper.getBorderRadius(context) * 1.6),
          ),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.getHorizontalPadding(context),
              vertical: ResponsiveHelper.getVerticalPadding(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: 'learn_title',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Learn',
                                style: themeService
                                    .getHeadlineSmallStyle(color: Colors.white)
                                    .copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.6,
                                    ),
                              ),
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                          AnimatedSwitcher(
                            duration: ThemeService.defaultAnimationDuration,
                            child: Text(
                              'You have completed $completedTopics of $totalTopics lessons',
                              key: ValueKey<int>(completedTopics),
                              style: themeService.getBodyMediumStyle(
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.7),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: IconButton(
                        onPressed: themeService.toggleDarkMode,
                        tooltip: 'Toggle theme',
                        icon: Icon(
                          isDark ? Icons.wb_sunny : Icons.nightlight_round,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.75),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: progressFraction),
                  duration: ThemeService.slowAnimationDuration,
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.7),
                      child: SizedBox(
                        height: ResponsiveHelper.getProgressBarHeight(context) * 1.5,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.12),
                                    Colors.white.withOpacity(0.08),
                                  ],
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.7),
                                      Colors.white.withOpacity(0.4),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.45),
                                      blurRadius: 12,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                Wrap(
                  spacing: ResponsiveHelper.getSpacing(context) * 0.5,
                  runSpacing: ResponsiveHelper.getSpacing(context) * 0.375,
                  children: [
                    _buildBadgeChip(
                      themeService: themeService,
                      icon: Icons.rocket_launch,
                      label: '$percentage% complete',
                    ),
                    _buildBadgeChip(
                      themeService: themeService,
                      icon: Icons.extension,
                      label: '$completedModules / $totalModules modules',
                    ),
                    _buildBadgeChip(
                      themeService: themeService,
                      icon: Icons.access_time,
                      label: '${_timeInvestedEstimate(completedTopics)} mins',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeChip({
    required ThemeService themeService,
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: ResponsiveHelper.getButtonPadding(context),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: ResponsiveHelper.getSmallIconSize(context), color: Colors.white),
          SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.375),
          Text(
            label,
            style: themeService
                .getLabelSmallStyle(color: Colors.white)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildNextLessonCard({
    required BuildContext context,
    required ThemeService themeService,
    required Map<String, String> nextLesson,
  }) {
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final accentColor = scheme.accentTeal;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: ThemeService.defaultAnimationDuration,
      curve: ThemeService.springCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          final topicTitle = nextLesson['topicTitle'] ?? '';
          final topicId = nextLesson['topicId'] ?? '';
          if (topicId.isEmpty) return;
          NavigationHelper.pushWithBottomNav(
            context,
            PhraseScreen(topicId: topicId, topicTitle: topicTitle),
            arguments: {'topicId': topicId, 'topicTitle': topicTitle},
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 1.2),
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.15),
                accentColor.withOpacity(0.12),
              ],
            ),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
            boxShadow: ThemeService.getCardShadow(isDark),
          ),
          child: Row(
            children: [
              Container(
                width: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 62 : 56,
                height: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 62 : 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.3),
                      primaryColor.withOpacity(0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.9),
                  border: Border.all(
                    color: accentColor.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.35),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_circle_fill,
                  color: accentColor,
                  size: ResponsiveHelper.getIconSize(context),
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context) * 1.125),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Continue learning',
                      style: themeService.getLabelLargeStyle(
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                    Text(
                      nextLesson['topicTitle'] ?? 'Next topic',
                      style: themeService
                          .getTitleMediumStyle(color: textColor)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                    Text(
                      'Tap to pick up right where you left off',
                      style: themeService.getBodySmallStyle(
                        color: textColor.withOpacity(0.65),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
              Icon(Icons.arrow_forward_ios, color: accentColor, size: ResponsiveHelper.getSmallIconSize(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow({
    required ThemeService themeService,
    required Color primaryColor,
    required Color textColor,
    required double progressFraction,
  }) {
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final secondaryText = isDark
        ? scheme.textSecondaryDark
        : scheme.textSecondary;
    final completedModules = _completedModuleCount();
    final totalModules = _totalModulesCount();
    final modulesLabel = '$completedModules of $totalModules modules completed';
    final completedLessons = lessonController.completedLessons.length;
    final estimatedHours = (completedLessons * 6 / 60).toStringAsFixed(1);

    final stats = [
      _StatCardData(
        icon: Icons.bubble_chart,
        title: 'Overall Progress',
        value: '${(progressFraction * 100).round()}%',
        description: 'Learning journey so far',
      ),
      _StatCardData(
        icon: Icons.layers,
        title: 'Modules',
        value: '$completedModules/$totalModules',
        description: modulesLabel,
      ),
      _StatCardData(
        icon: Icons.timer,
        title: 'Practice Time',
        value: '${estimatedHours}h',
        description: 'Approx. time invested',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 720;
        final spacing = ResponsiveHelper.getSpacing(context);

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: stats
              .map(
                (stat) => SizedBox(
                  width: isWide
                      ? (constraints.maxWidth -
                                (spacing * (stats.length - 1))) /
                            stats.length
                      : constraints.maxWidth,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 1.1),
                      gradient: themeService.getCardGradient(isDark),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.18),
                        width: 1.5,
                      ),
                      boxShadow: ThemeService.getCardShadow(isDark),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.22),
                                scheme.accentTeal.withOpacity(0.18),
                              ],
                            ),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.25),
                            ),
                          ),
                          child: Icon(
                            stat.icon,
                            color: scheme.accentTeal,
                            size: ResponsiveHelper.getIconSize(context),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.75),
                        Text(
                          stat.title,
                          style: themeService.getLabelLargeStyle(
                            color: secondaryText.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                        Text(
                          stat.value,
                          style: themeService
                              .getTitleLargeStyle(color: textColor)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                        Text(
                          stat.description,
                          style: themeService.getBodySmallStyle(
                            color: secondaryText.withOpacity(0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildLevelsCallout({
    required BuildContext context,
    required ThemeService themeService,
  }) {
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final secondary = isDark ? scheme.textSecondaryDark : scheme.textSecondary;
    final primary = isDark ? scheme.primaryDark : scheme.primary;
    final accent = scheme.accentTeal;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: ThemeService.defaultAnimationDuration,
      curve: ThemeService.springCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          NavigationHelper.pushWithBottomNav(
            context,
            const LevelsOverviewScreen(),
            arguments: const {'origin': 'learn'},
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context) * 1.1),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 1.3),
            gradient: LinearGradient(
              colors: [primary.withOpacity(0.15), accent.withOpacity(0.12)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: primary.withOpacity(0.3), width: 2),
            boxShadow: ThemeService.getCardShadow(isDark),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: ResponsiveHelper.isDesktop(context) ? 72 : ResponsiveHelper.isTablet(context) ? 68 : 60,
                height: ResponsiveHelper.isDesktop(context) ? 72 : ResponsiveHelper.isTablet(context) ? 68 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      accent.withOpacity(0.35),
                      primary.withOpacity(0.25),
                    ],
                  ),
                  border: Border.all(color: accent.withOpacity(0.45), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.35),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_graph,
                  size: ResponsiveHelper.getIconSize(context),
                  color: accent,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore all levels',
                      style: themeService
                          .getTitleMediumStyle(color: textColor)
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                    Text(
                      'Jump into tailored modules for every proficiency stage.',
                      style: themeService.getBodyMediumStyle(
                        color: secondary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.arrow_forward_rounded, color: accent, size: 26),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String>? _nextLessonToContinue() {
    final moduleEntries = LearningPathData.moduleTopics.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (final entry in moduleEntries) {
      final moduleId = entry.key;
      final topics = entry.value;
      for (var index = 0; index < topics.length; index++) {
        final topicId = '$moduleId-T${index + 1}';
        if (!lessonController.isLessonCompleted(topicId)) {
          return {
            'moduleId': moduleId,
            'topicId': topicId,
            'topicTitle': topics[index],
          };
        }
      }
    }
    return null;
  }

  int _totalTopicsCount() {
    return LearningPathData.moduleTopics.values.fold<int>(
      0,
      (previousValue, topics) => previousValue + topics.length,
    );
  }

  int _completedModuleCount() {
    int count = 0;
    LearningPathData.moduleTopics.forEach((moduleId, topics) {
      if (topics.isEmpty) return;
      final allCompleted = List.generate(
        topics.length,
        (index) =>
            lessonController.isLessonCompleted('$moduleId-T${index + 1}'),
      ).every((element) => element);
      if (allCompleted) count++;
    });
    return count;
  }

  int _totalModulesCount() {
    return LearningPathData.moduleTopics.length;
  }

  int _timeInvestedEstimate(int completedTopics) {
    return completedTopics * 6;
  }
}

class _StatCardData {
  final IconData icon;
  final String title;
  final String value;
  final String description;

  const _StatCardData({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
  });
}
