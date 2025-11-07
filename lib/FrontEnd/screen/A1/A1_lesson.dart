import 'package:ductuch_master/FrontEnd/screen/A1/Learn.dart';
import 'package:ductuch_master/FrontEnd/screen/controller/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class A1LessonScreen extends StatelessWidget {
  final String moduleId;

  A1LessonScreen({super.key, required this.moduleId});

  final LessonController lessonController = Get.find<LessonController>();

  final Map<String, dynamic> lessonData = {
    'A1-L1': {
      'title': 'Basics & Greetings',
      'lessons': [
        {
          'id': 'A1-L1-L1',
          'title': 'Hello & Goodbye',
          'content': 'Learn basic greetings in German',
          'type': 'vocabulary',
          'duration': '5 min',
        },
        {
          'id': 'A1-L1-L2',
          'title': 'Introducing Yourself',
          'content': 'Learn how to introduce yourself',
          'type': 'conversation',
          'duration': '7 min',
        },
        {
          'id': 'A1-L1-L3',
          'title': 'Formal vs Informal',
          'content': 'Understand when to use formal language',
          'type': 'grammar',
          'duration': '6 min',
        },
        {
          'id': 'A1-L1-L4',
          'title': 'Practice Dialogue',
          'content': 'Practice a conversation scenario',
          'type': 'practice',
          'duration': '8 min',
        },
        {
          'id': 'A1-L1-L5',
          'title': 'Review & Quiz',
          'content': 'Test your knowledge',
          'type': 'quiz',
          'duration': '10 min',
        },
      ],
    },
    'A1-L2': {
      'title': 'Numbers & Time',
      'lessons': [
        {
          'id': 'A1-L2-L1',
          'title': 'Numbers 1-20',
          'content': 'Learn basic numbers',
          'type': 'vocabulary',
          'duration': '6 min',
        },
        {
          'id': 'A1-L2-L2',
          'title': 'Telling Time',
          'content': 'Learn how to tell time in German',
          'type': 'vocabulary',
          'duration': '8 min',
        },
        {
          'id': 'A1-L2-L3',
          'title': 'Days of the Week',
          'content': 'Learn the days and months',
          'type': 'vocabulary',
          'duration': '5 min',
        },
        {
          'id': 'A1-L2-L4',
          'title': 'Time Expressions',
          'content': 'Practice using time in sentences',
          'type': 'practice',
          'duration': '7 min',
        },
        {
          'id': 'A1-L2-L5',
          'title': 'Review & Quiz',
          'content': 'Test your time and number knowledge',
          'type': 'quiz',
          'duration': '10 min',
        },
      ],
    },
    'A1-L3': {
      'title': 'Family & People',
      'lessons': [
        {
          'id': 'A1-L3-L1',
          'title': 'Family Members',
          'content': 'Learn family vocabulary',
          'type': 'vocabulary',
          'duration': '6 min',
        },
        {
          'id': 'A1-L3-L2',
          'title': 'Describing People',
          'content': 'Learn adjectives for people',
          'type': 'vocabulary',
          'duration': '7 min',
        },
        {
          'id': 'A1-L3-L3',
          'title': 'Possessive Pronouns',
          'content': 'Learn to express possession',
          'type': 'grammar',
          'duration': '8 min',
        },
        {
          'id': 'A1-L3-L4',
          'title': 'Family Conversation',
          'content': 'Practice talking about family',
          'type': 'conversation',
          'duration': '9 min',
        },
        {
          'id': 'A1-L3-L5',
          'title': 'Review & Quiz',
          'content': 'Test your family vocabulary',
          'type': 'quiz',
          'duration': '10 min',
        },
      ],
    },
    'A1-L4': {
      'title': 'Food & Dining',
      'lessons': [
        {
          'id': 'A1-L4-L1',
          'title': 'Food Vocabulary',
          'content': 'Learn common food items',
          'type': 'vocabulary',
          'duration': '7 min',
        },
        {
          'id': 'A1-L4-L2',
          'title': 'Ordering Food',
          'content': 'Learn restaurant phrases',
          'type': 'conversation',
          'duration': '8 min',
        },
        {
          'id': 'A1-L4-L3',
          'title': 'Food Preferences',
          'content': 'Express likes and dislikes',
          'type': 'grammar',
          'duration': '6 min',
        },
        {
          'id': 'A1-L4-L4',
          'title': 'Menu Reading',
          'content': 'Practice reading a German menu',
          'type': 'practice',
          'duration': '9 min',
        },
        {
          'id': 'A1-L4-L5',
          'title': 'Review & Quiz',
          'content': 'Test your food vocabulary',
          'type': 'quiz',
          'duration': '10 min',
        },
      ],
    },
    'A1-L5': {
      'title': 'Daily Routine',
      'lessons': [
        {
          'id': 'A1-L5-L1',
          'title': 'Daily Activities',
          'content': 'Learn verbs for daily routines',
          'type': 'vocabulary',
          'duration': '6 min',
        },
        {
          'id': 'A1-L5-L2',
          'title': 'Telling Your Schedule',
          'content': 'Learn to describe your day',
          'type': 'conversation',
          'duration': '7 min',
        },
        {
          'id': 'A1-L5-L3',
          'title': 'Reflexive Verbs',
          'content': 'Learn reflexive verb usage',
          'type': 'grammar',
          'duration': '8 min',
        },
        {
          'id': 'A1-L5-L4',
          'title': 'Daily Routine Practice',
          'content': 'Practice describing your routine',
          'type': 'practice',
          'duration': '9 min',
        },
        {
          'id': 'A1-L5-L5',
          'title': 'Review & Quiz',
          'content': 'Test your routine vocabulary',
          'type': 'quiz',
          'duration': '10 min',
        },
      ],
    },
    'A1-L6': {
      'title': 'City & Directions',
      'lessons': [
        {
          'id': 'A1-L6-L1',
          'title': 'Places in City',
          'content': 'Learn city location vocabulary',
          'type': 'vocabulary',
          'duration': '7 min',
        },
        {
          'id': 'A1-L6-L2',
          'title': 'Asking for Directions',
          'content': 'Learn how to ask for directions',
          'type': 'conversation',
          'duration': '8 min',
        },
        {
          'id': 'A1-L6-L3',
          'title': 'Giving Directions',
          'content': 'Learn how to give directions',
          'type': 'conversation',
          'duration': '8 min',
        },
        {
          'id': 'A1-L6-L4',
          'title': 'Prepositions of Place',
          'content': 'Learn location prepositions',
          'type': 'grammar',
          'duration': '7 min',
        },
        {
          'id': 'A1-L6-L5',
          'title': 'Review & Quiz',
          'content': 'Test your direction skills',
          'type': 'quiz',
          'duration': '10 min',
        },
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final moduleData = lessonData[moduleId];
    final String moduleTitle = moduleData?['title'] ?? 'Module Not Found';
    final List<dynamic> lessons = moduleData?['lessons'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(moduleTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          // Use Obx only for the specific widget that needs to react to changes
          return Obx(() {
            final isCompleted = lessonController.isLessonCompleted(
              lesson['id'],
            );

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: isCompleted ? Colors.green : Colors.grey.shade300,
                  width: isCompleted ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: isCompleted ? 4 : 1,
              child: ListTile(
                leading: _getLessonLeading(lesson, isCompleted),
                title: Text(
                  lesson['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                          Text(lesson['content']),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(lesson['type']),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  lesson['type'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                lesson['duration'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                trailing: isCompleted
                    ? const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      )
                    : const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.to(
                    () => PhraseScreen(),
                    // LessonDetailScreen(lesson: lesson, moduleId: moduleId),
                  );
                },
              ),
            );
          });
        },
      ),
    );
  }

  Widget _getLessonLeading(Map<String, dynamic> lesson, bool isCompleted) {
    if (isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.green),
      );
    }
    return _getLessonIcon(lesson['type']);
  }

  Widget _getLessonIcon(String type) {
    switch (type) {
      case 'vocabulary':
        return const Icon(Icons.book, color: Colors.blue);
      case 'grammar':
        return const Icon(Icons.auto_stories, color: Colors.green);
      case 'conversation':
        return const Icon(Icons.chat, color: Colors.orange);
      case 'practice':
        return const Icon(
          Icons.private_connectivity_rounded,
          color: Colors.purple,
        );
      case 'quiz':
        return const Icon(Icons.quiz, color: Colors.red);
      default:
        return const Icon(Icons.article, color: Colors.grey);
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
      default:
        return Colors.grey;
    }
  }
}

// Updated Lesson Detail Screen
class LessonDetailScreen extends StatefulWidget {
  final Map<String, dynamic> lesson;
  final String moduleId;

  const LessonDetailScreen({
    super.key,
    required this.lesson,
    required this.moduleId,
  });

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final LessonController lessonController = Get.find<LessonController>();
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _getLessonSections().length,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      _currentTabIndex = _tabController.index;
    });
  }

  List<Map<String, dynamic>> _getLessonSections() {
    // Mock data - in real app, this would come from your lesson data
    return [
      {
        'title': 'Introduction',
        'type': 'theory',
        'content':
            'Welcome to this lesson! In this section, we will cover the basic concepts and fundamentals that you need to understand before moving forward.',
      },
      {
        'title': 'Vocabulary',
        'type': 'vocabulary',
        'content':
            'Learn essential words and phrases:\n\n• Basic greetings\n• Common expressions\n• Important terminology\n• Practice pronunciation',
      },
      {
        'title': 'Examples',
        'type': 'examples',
        'content':
            'See how it works in practice:\n\n🔹 Example 1: Basic usage\n🔹 Example 2: Common scenarios\n🔹 Example 3: Advanced applications',
      },
      {
        'title': 'Practice',
        'type': 'exercise',
        'content':
            'Test your understanding:\n\n1. Multiple choice questions\n2. Fill in the blanks\n3. Matching exercises\n4. Writing practice',
      },
    ];
  }

  Widget _buildSectionContent(Map<String, dynamic> section) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section['title'],
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: _getTypeColor(section['type']),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              section['content'],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionSpecificContent(section),
        ],
      ),
    );
  }

  Widget _buildSectionSpecificContent(Map<String, dynamic> section) {
    switch (section['type']) {
      case 'vocabulary':
        return PhraseScreen();
      case 'examples':
        return _buildExamplesContent();
      case 'exercise':
        return _buildExerciseContent();
      default:
        return _buildTheoryContent();
    }
  }

  Widget _buildTheoryContent() {
    return Column(
      children: [
        const Text(
          'Key Points:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        _buildKeyPoint(
          'Understand the basic concepts',
          Icons.lightbulb_outline,
        ),
        _buildKeyPoint('Take notes for better retention', Icons.note_add),
        _buildKeyPoint('Review previous sections', Icons.replay),
      ],
    );
  }

  Widget _buildVocabularyContent() {
    return Column(
      children: [
        const Text(
          'Vocabulary List:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        _buildVocabularyItem('Hello', 'A common greeting'),
        _buildVocabularyItem('Thank you', 'Expression of gratitude'),
        _buildVocabularyItem('Please', 'Polite request'),
        _buildVocabularyItem('Goodbye', 'Farewell expression'),
      ],
    );
  }

  Widget _buildExamplesContent() {
    return Column(
      children: [
        const Text(
          'Interactive Examples:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text('Try these examples in your own sentences!'),
        ),
      ],
    );
  }

  Widget _buildExerciseContent() {
    return Column(
      children: [
        const Text(
          'Practice Exercise:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              const Text('Complete the following exercises:'),
              const SizedBox(height: 16),
              _buildExerciseItem('Exercise 1: Multiple Choice'),
              _buildExerciseItem('Exercise 2: Fill in the Blanks'),
              _buildExerciseItem('Exercise 3: True or False'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyPoint(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildVocabularyItem(String word, String meaning) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.record_voice_over, color: Colors.purple),
        title: Text(word, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(meaning),
        trailing: const Icon(Icons.volume_up, color: Colors.blue),
      ),
    );
  }

  Widget _buildExerciseItem(String text) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.assignment, color: Colors.orange),
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Handle exercise tap
        },
      ),
    );
  }

  void _handleNext() {
    if (_currentTabIndex < _getLessonSections().length - 1) {
      _tabController.animateTo(_currentTabIndex + 1);
    }
  }

  void _handlePrevious() {
    if (_currentTabIndex > 0) {
      _tabController.animateTo(_currentTabIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _getLessonSections();
    final isLastTab = _currentTabIndex == sections.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson['title']),
        actions: [
          Obx(() {
            final isCompleted = lessonController.isLessonCompleted(
              widget.lesson['id'],
            );
            return isCompleted
                ? const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.check_circle, color: Colors.green),
                  )
                : const SizedBox.shrink();
          }),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: sections.map((section) {
            return Tab(
              child: Row(
                children: [
                  _getSectionIcon(section['type']),
                  const SizedBox(width: 8),
                  Text(section['title'], style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: sections.map((section) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildSectionContent(section),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Obx(() {
              final isCompleted = lessonController.isLessonCompleted(
                widget.lesson['id'],
              );

              if (isCompleted) {
                return SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Lessons',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              } else {
                return Row(
                  children: [
                    if (_currentTabIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handlePrevious,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                    if (_currentTabIndex > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: isLastTab
                            ? () {
                                lessonController.markLessonCompleted(
                                  widget.lesson['id'],
                                );
                                Get.back();
                              }
                            : _handleNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLastTab
                              ? Colors.green
                              : Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          isLastTab ? 'Mark as Completed' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _getSectionIcon(String type) {
    switch (type) {
      case 'theory':
        return const Icon(Icons.menu_book, size: 16);
      case 'vocabulary':
        return const Icon(Icons.translate, size: 16);
      case 'examples':
        return const Icon(Icons.lightbulb, size: 16);
      case 'exercise':
        return const Icon(Icons.assignment, size: 16);
      default:
        return const Icon(Icons.description, size: 16);
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
      default:
        return Colors.grey;
    }
  }
}
