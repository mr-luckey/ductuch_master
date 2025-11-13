import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class A1LessonScreen extends StatefulWidget {
  final String moduleId;

  A1LessonScreen({super.key, required this.moduleId});

  @override
  State<A1LessonScreen> createState() => _A1LessonScreenState();
}

class _A1LessonScreenState extends State<A1LessonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
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

  Map<String, dynamic> get lessonData {
    final topics = LearningPathData.moduleTopics[widget.moduleId] ?? [];
    ModuleInfo? module;
    try {
      module = LearningPathData.levelInfo.values
          .expand((level) => level.modules)
          .firstWhere((m) => m.ID == widget.moduleId);
    } catch (e) {
      module = null;
    }

    return {
      widget.moduleId: {
        'title': module?.title ?? 'Module',
        'topics': topics.map((topicTitle) {
          final index = topics.indexOf(topicTitle);
          return {
            'id': '${widget.moduleId}-T${index + 1}',
            'title': topicTitle,
            'content': 'Learn about $topicTitle',
            'type': _getTopicType(topicTitle),
            'duration': '${5 + index * 2} min',
          };
        }).toList(),
      },
    };
  }

  String _getTopicType(String title) {
    if (title.toLowerCase().contains('verb') ||
        title.toLowerCase().contains('pronoun') ||
        title.toLowerCase().contains('article') ||
        title.toLowerCase().contains('tense') ||
        title.toLowerCase().contains('case') ||
        title.toLowerCase().contains('clause')) {
      return 'grammar';
    } else if (title.toLowerCase().contains('practice') ||
        title.toLowerCase().contains('exercise') ||
        title.toLowerCase().contains('quiz')) {
      return 'practice';
    } else if (title.toLowerCase().contains('writing') ||
        title.toLowerCase().contains('essay') ||
        title.toLowerCase().contains('email')) {
      return 'writing';
    } else {
      return 'vocabulary';
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = lessonData;
    final moduleData = data[widget.moduleId];
    final String moduleTitle = moduleData?['title'] ?? 'Module Not Found';
    final List<dynamic> topics = moduleData?['topics'] ?? [];

    return Obx(() {
      final themeService = Get.find<ThemeService>();
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;

      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textPrimaryColor = isDark
          ? scheme.textPrimaryDark
          : scheme.textPrimary;
      final textSecondaryColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;

      final secondaryTextColor = textSecondaryColor.withOpacity(0.7);
      final borderColor = primaryColor.withOpacity(0.2);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                // Top bar with Hero animation
                Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.getPadding(context)),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'back_button_${widget.moduleId}',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.6),
                              gradient: themeService.getCardGradient(isDark),
                              border: Border.all(color: borderColor),
                              boxShadow: ThemeService.getCardShadow(isDark),
                            ),
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.chevron_left,
                                color: textPrimaryColor,
                                size: ResponsiveHelper.getIconSize(context),
                              ),
                              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) * 0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
                      Expanded(
                        child: Hero(
                          tag: 'module_title_${widget.moduleId}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              moduleTitle,
                              style: themeService.getTitleLargeStyle(
                                color: textPrimaryColor,
                              ).copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Topics list with staggered animations
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getHorizontalPadding(context)),
                    itemCount: topics.length,
                    itemBuilder: (context, index) {
                      final topic = topics[index];
                      return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(
                          milliseconds: 300 + (index * 100),
                        ),
                        curve: ThemeService.springCurve,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(30 * (1 - value), 0),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: _buildTopicCard(
                                topic,
                                index,
                                isDark,
                                scheme,
                                primaryColor,
                                textPrimaryColor,
                                secondaryTextColor,
                                borderColor,
                                themeService,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTopicCard(
    Map<String, dynamic> topic,
    int index,
    bool isDark,
    dynamic scheme,
    Color primaryColor,
    Color textPrimaryColor,
    Color secondaryTextColor,
    Color borderColor,
    ThemeService themeService,
  ) {
    final lessonController = Get.find<LessonController>();
    
    return Obx(() {
      final isCompleted = lessonController.isLessonCompleted(topic['id']);

      return Container(
        margin: EdgeInsets.only(bottom: ResponsiveHelper.getSpacing(context) * 0.75),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
          gradient: themeService.getCardGradient(isDark),
          border: Border.all(
            color: isCompleted
                ? primaryColor.withOpacity(0.6)
                : borderColor,
            width: isCompleted ? 2.5 : 1.5,
          ),
          boxShadow: ThemeService.getCardShadow(isDark),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              NavigationHelper.pushWithBottomNav(
                context,
                PhraseScreen(
                  topicId: topic['id'],
                  topicTitle: topic['title'],
                ),
              );
            },
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
            splashColor: primaryColor.withOpacity(0.2),
            highlightColor: primaryColor.withOpacity(0.1),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(ResponsiveHelper.getPadding(context)),
                  child: Row(
                    children: [
                      // Animated Icon
                      Hero(
                        tag: 'topic_icon_${topic['id']}',
                        child: Material(
                          color: Colors.transparent,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: isCompleted ? 1.0 : 0.0),
                            duration: ThemeService.defaultAnimationDuration,
                            curve: ThemeService.bounceCurve,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: 1.0 + (value * 0.2),
                                child: Container(
                                  width: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                                  height: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        primaryColor.withOpacity(0.25),
                                        scheme.accentTeal.withOpacity(0.2),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                                    border: Border.all(
                                      color: primaryColor.withOpacity(0.4),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3 * value),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isCompleted
                                        ? Icons.check_circle
                                        : _getIconForType(topic['type']),
                                    color: primaryColor,
                                    size: ResponsiveHelper.isDesktop(context) ? 32 : ResponsiveHelper.isTablet(context) ? 30 : 28,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveHelper.getSpacing(context)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'topic_title_${topic['id']}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  topic['title'],
                                  style: themeService.getTitleMediumStyle(
                                    color: textPrimaryColor,
                                  ).copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                            if (!isCompleted) ...[
                              SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.375),
                              Text(
                                topic['content'],
                                style: themeService.getBodySmallStyle(
                                  color: secondaryTextColor,
                                ),
                              ),
                              SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.2),
                                          scheme.accentTeal.withOpacity(0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.5),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                      ),
                                    ),
                                    child: Text(
                                      topic['type'],
                                      style: themeService.getLabelSmallStyle(
                                        color: primaryColor,
                                      ).copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.625),
                                  Icon(
                                    Icons.access_time,
                                    size: ResponsiveHelper.getSmallSize(context),
                                    color: secondaryTextColor,
                                  ),
                                  SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
                                  Text(
                                    topic['duration'],
                                    style: themeService.getBodySmallStyle(
                                      color: secondaryTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Checkbox with animation
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: isCompleted ? 1.0 : 0.0),
                        duration: ThemeService.defaultAnimationDuration,
                        curve: ThemeService.bounceCurve,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor.withOpacity(0.2 + (0.3 * value)),
                                    scheme.accentTeal.withOpacity(0.15 + (0.2 * value)),
                                  ],
                                ),
                                border: Border.all(
                                  color: isCompleted
                                      ? primaryColor
                                      : textPrimaryColor.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                isCompleted ? Icons.check : Icons.play_arrow,
                                size: ResponsiveHelper.getSmallIconSize(context),
                                color: isCompleted ? Colors.white : primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: ThemeService.defaultAnimationDuration,
                      curve: ThemeService.defaultCurve,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(0, (1 - value) * -6),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.6),
                                gradient: LinearGradient(
                                  colors: [primaryColor, scheme.accentTeal],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: ResponsiveHelper.getSmallIconSize(context),
                                  ),
                                  SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.375),
                                  Text(
                                    'Completed',
                                    style: themeService.getLabelSmallStyle(
                                      color: Colors.white,
                                    ).copyWith(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'vocabulary':
        return Icons.book;
      case 'grammar':
        return Icons.auto_stories;
      case 'conversation':
        return Icons.chat;
      case 'practice':
        return Icons.quiz;
      default:
        return Icons.article;
    }
  }
}
