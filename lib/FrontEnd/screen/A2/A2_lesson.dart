import 'package:ductuch_master/Data/learning_path_data.dart';
import 'package:ductuch_master/FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/FrontEnd/screen/controller/lesson_controller.dart';
import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class A2LessonScreen extends StatelessWidget {
  final String moduleId;

  A2LessonScreen({super.key, required this.moduleId});

  final LessonController lessonController = Get.find<LessonController>();

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

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
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
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.chevron_left,
                        color: Colors.white70,
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
                        color: Colors.white,
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
                              ? const Color(0xFF10B981).withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                          width: isCompleted ? 2 : 1,
                        ),
                        color: Colors.white.withOpacity(0.02),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        leading: _getTopicLeading(topic, isCompleted),
                        title: Text(
                          topic['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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
                                      color: Colors.white.withOpacity(0.7),
                                      fontFamily:
                                          GoogleFonts.patrickHand().fontFamily,
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
                                          color: _getTypeColor(
                                            topic['type'],
                                          ).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: _getTypeColor(
                                              topic['type'],
                                            ).withOpacity(0.4),
                                          ),
                                        ),
                                        child: Text(
                                          topic['type'],
                                          style: TextStyle(
                                            color: _getTypeColor(topic['type']),
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
                                          color: Colors.white.withOpacity(0.6),
                                          fontSize: 12,
                                          fontFamily: GoogleFonts.patrickHand()
                                              .fontFamily,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                        trailing: isCompleted
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF10B981),
                                size: 24,
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white.withOpacity(0.5),
                              ),
                        onTap: () {
                          Get.to(
                            () => PhraseScreen(),
                            // TopicDetailScreen(topic: topic, moduleId: moduleId),
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
  }

  Widget _getTopicLeading(Map<String, dynamic> topic, bool isCompleted) {
    if (isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
        ),
        child: const Icon(Icons.check, color: Color(0xFF10B981)),
      );
    }
    return _getTopicIcon(topic['type']);
  }

  Widget _getTopicIcon(String type) {
    final color = _getTypeColor(type);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(_getIconForType(type), color: color, size: 20),
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
      case 'writing':
        return Icons.edit;
      default:
        return Icons.article;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'vocabulary':
        return Colors.blue;
      case 'grammar':
        return Colors.green;
      case 'conversation':
        return Colors.orange;
      case 'practice':
        return Colors.purple;
      case 'quiz':
        return Colors.red;
      case 'writing':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}
