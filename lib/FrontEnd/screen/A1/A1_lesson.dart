import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:ductuch_master/services/theme_service.dart'; // Import the theme service

class A1LessonScreen extends StatelessWidget {
  final String moduleId;

  A1LessonScreen({super.key, required this.moduleId});

  final LessonController lessonController = Get.find<LessonController>();
  final ThemeService themeService =
      Get.find<ThemeService>(); // Get theme service

  Map<String, dynamic> get lessonData {
    // Get topics for this module (Level → Module → Topic)
    final topics = LearningPathData.moduleTopics[moduleId] ?? [];
    ModuleInfo? module;
    try {
      module = LearningPathData.levelInfo.values
          .expand((level) => level.modules)
          .firstWhere((m) => m.ID == moduleId);
    } catch (e) {
      // Module not found, use default
      module = null;
    }

    return {
      moduleId: {
        'title': module?.title ?? 'Module',
        'topics': topics.map((topicTitle) {
          final index = topics.indexOf(topicTitle);
          return {
            'id': '$moduleId-T${index + 1}',
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
    final moduleData = data[moduleId];
    final String moduleTitle = moduleData?['title'] ?? 'Module Not Found';
    final List<dynamic> topics = moduleData?['topics'] ?? [];

    return Obx(() {
      // Use Obx to react to theme changes
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;

      // Get colors based on current theme mode
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
      final textPrimaryColor = isDark
          ? scheme.textPrimaryDark
          : scheme.textPrimary;
      final textSecondaryColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;

      final secondaryTextColor = textSecondaryColor.withOpacity(0.7);
      final borderColor = primaryColor.withOpacity(0.2);
      final surfaceColorWithOpacity = surfaceColor.withOpacity(0.5);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: borderColor),
                        color: surfaceColor,
                      ),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.chevron_left,
                          color: textPrimaryColor,
                          size: 22,
                        ),
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        moduleTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textPrimaryColor,
                          fontFamily: GoogleFonts.patrickHand().fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Topics list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: topics.length,
                  itemBuilder: (context, index) {
                    final topic = topics[index];

                    // Use Obx only for the specific widget that needs to react to changes
                    return Obx(() {
                      final isCompleted = lessonController.isLessonCompleted(
                        topic['id'],
                      );

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isCompleted
                                ? primaryColor.withOpacity(0.5)
                                : borderColor,
                            width: isCompleted ? 2 : 1,
                          ),
                          color: surfaceColorWithOpacity,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: _getTopicLeading(
                            context,
                            topic,
                            isCompleted,
                            primaryColor,
                            surfaceColor,
                          ),
                          title: Text(
                            topic['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textPrimaryColor,
                              fontFamily: GoogleFonts.patrickHand().fontFamily,
                              decoration: isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: isCompleted
                              ? null
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      topic['content'],
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                        fontFamily: GoogleFonts.patrickHand()
                                            .fontFamily,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryColor.withOpacity(
                                              0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: primaryColor.withOpacity(
                                                0.4,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            topic['type'],
                                            style: TextStyle(
                                              color: primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  GoogleFonts.patrickHand()
                                                      .fontFamily,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          topic['duration'],
                                          style: TextStyle(
                                            color: secondaryTextColor,
                                            fontSize: 12,
                                            fontFamily:
                                                GoogleFonts.patrickHand()
                                                    .fontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          trailing: SizedBox(
                            width: 28,
                            height: 28,
                            child: Checkbox(
                              value: isCompleted,
                              onChanged:
                                  null, // auto-checked via listening action
                              shape: const CircleBorder(),
                              side: BorderSide(
                                color: secondaryTextColor.withOpacity(0.4),
                              ),
                              checkColor: textPrimaryColor,
                              fillColor: WidgetStateProperty.resolveWith((
                                states,
                              ) {
                                if (isCompleted) return primaryColor;
                                return Colors.transparent;
                              }),
                            ),
                          ),
                          onTap: () {
                            Get.to(
                              () => PhraseScreen(
                                topicId: topic['id'],
                                topicTitle: topic['title'],
                              ),
                            );
                          },
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _getTopicLeading(
    BuildContext context,
    Map<String, dynamic> topic,
    bool isCompleted,
    Color primaryColor,
    Color surfaceColor,
  ) {
    if (isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor.withOpacity(0.4)),
        ),
        child: Icon(Icons.check, color: primaryColor),
      );
    }
    return _getTopicIcon(context, topic['type'], primaryColor, surfaceColor);
  }

  Widget _getTopicIcon(
    BuildContext context,
    String type,
    Color primaryColor,
    Color surfaceColor,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Icon(_getIconForType(type), color: primaryColor, size: 20),
    );
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
        return Icons.private_connectivity_rounded;
      case 'quiz':
        return Icons.quiz;
      default:
        return Icons.article;
    }
  }
}
