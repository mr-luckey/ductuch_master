import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class C2LessonScreen extends StatefulWidget {
  final String moduleId;

  C2LessonScreen({super.key, required this.moduleId});

  @override
  State<C2LessonScreen> createState() => _C2LessonScreenState();
}

class _C2LessonScreenState extends State<C2LessonScreen>
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Hero(
                        tag: 'back_button_${widget.moduleId}',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: themeService.getCardGradient(isDark),
                              border: Border.all(color: borderColor),
                              boxShadow: ThemeService.getCardShadow(isDark),
                            ),
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.chevron_left,
                                color: textPrimaryColor,
                                size: 24,
                              ),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
            borderRadius: BorderRadius.circular(20),
            splashColor: primaryColor.withOpacity(0.2),
            highlightColor: primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primaryColor.withOpacity(0.25),
                                    scheme.accentTeal.withOpacity(0.2),
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
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                          const SizedBox(height: 6),
                          Text(
                            topic['content'],
                            style: themeService.getBodySmallStyle(
                              color: secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
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
                                  borderRadius: BorderRadius.circular(10),
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
                              const SizedBox(width: 10),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: secondaryTextColor,
                              ),
                              const SizedBox(width: 4),
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
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                scheme.accentTeal,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.5 * value),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
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
