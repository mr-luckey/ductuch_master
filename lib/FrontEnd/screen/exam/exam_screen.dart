import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

/// Question model for exam
class ExamQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;

  ExamQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
  });
}

/// Exam screen with 4 levels (A1, A2, B1, B2)
/// Each level has 150+ questions, countdown timer, score display, and correct answers
class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  String? selectedLevel;
  List<ExamQuestion> currentQuestions = [];
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  Map<int, int> userAnswers = {};
  bool isExamStarted = false;
  bool isExamCompleted = false;
  Timer? countdownTimer;
  int remainingSeconds = 3600; // 1 hour default
  int score = 0;
  late final LessonController _lessonController;

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void _startExam(String level) {
    setState(() {
      selectedLevel = level;
      currentQuestions = _getQuestionsForLevel(level);
      currentQuestionIndex = 0;
      selectedAnswerIndex = null;
      userAnswers = {};
      isExamStarted = true;
      isExamCompleted = false;
      remainingSeconds = _getTimeForLevel(level);
      score = 0;
    });
    _startCountdown();
  }

  int _getTimeForLevel(String level) {
    switch (level) {
      case 'A1':
        return 3600; // 1 hour
      case 'A2':
        return 3600; // 1 hour
      case 'B1':
        return 4200; // 70 minutes
      case 'B2':
        return 4800; // 80 minutes
      default:
        return 3600;
    }
  }

  void _startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        _submitExam();
      }
    });
  }

  void _selectAnswer(int index) {
    setState(() {
      selectedAnswerIndex = index;
      userAnswers[currentQuestionIndex] = index;
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < currentQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = userAnswers[currentQuestionIndex];
      });
    }
  }

  void _previousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
        selectedAnswerIndex = userAnswers[currentQuestionIndex];
      });
    }
  }

  void _submitExam() {
    countdownTimer?.cancel();

    // Calculate score
    int correctCount = 0;
    for (int i = 0; i < currentQuestions.length; i++) {
      if (userAnswers[i] == currentQuestions[i].correctAnswerIndex) {
        correctCount++;
      }
    }

    setState(() {
      score = correctCount;
      isExamCompleted = true;
      isExamStarted = false;
    });

    // Mark level as passed if >= 70%
    final totalQuestions = currentQuestions.length;
    if (selectedLevel != null && totalQuestions > 0) {
      final percentage = (score / totalQuestions * 100).round();
      if (percentage >= 70) {
        _lessonController.markLevelPassed(selectedLevel!);
      }
    }
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Map<String, List<ExamQuestion>> _examQuestions = {};
  bool _isLoadingQuestions = false;
  String? _pendingAutoStartLevel;

  @override
  void initState() {
    super.initState();
    _lessonController = Get.find<LessonController>();
    _loadExamQuestions();

    // Auto-start exam if level is provided via arguments
    final args = Get.arguments;
    final levelArg = (args is Map) ? (args['level']?.toString()) : null;
    if (levelArg != null && levelArg.isNotEmpty) {
      final level = levelArg.toUpperCase();
      if (_examQuestions.isNotEmpty) {
        _startExam(level);
      } else {
        _pendingAutoStartLevel = level;
      }
    }
  }

  Future<void> _loadExamQuestions() async {
    setState(() {
      _isLoadingQuestions = true;
    });
    final loadedQuestions = await DataLoader.loadExamQuestions();
    setState(() {
      _examQuestions = loadedQuestions;
      _isLoadingQuestions = false;
    });

    // If an auto-start was pending, start now
    if (_pendingAutoStartLevel != null) {
      _startExam(_pendingAutoStartLevel!);
      _pendingAutoStartLevel = null;
    }
  }

  List<ExamQuestion> _getQuestionsForLevel(String level) {
    // Get questions from loaded JSON data
    final questions = _examQuestions[level] ?? [];

    // If we have questions, return them. Otherwise, generate sample questions
    if (questions.isNotEmpty) {
      // For now, return the loaded questions. In production, you might want to
      // expand this to 150+ questions by duplicating or loading more from JSON
      return questions;
    }

    // Fallback: Generate sample questions if JSON doesn't have enough
    List<ExamQuestion> fallbackQuestions = [];
    for (int i = 0; i < 150; i++) {
      fallbackQuestions.add(
        ExamQuestion(
          question:
              'Question ${i + 1} for level $level: What is the correct answer?',
          options: ['Option A', 'Option B', 'Option C', 'Option D'],
          correctAnswerIndex: i % 4,
          explanation: 'This is the explanation for question ${i + 1}',
        ),
      );
    }

    return fallbackQuestions;
  }

  void _resetExam() {
    setState(() {
      selectedLevel = null;
      currentQuestions = [];
      currentQuestionIndex = 0;
      selectedAnswerIndex = null;
      userAnswers = {};
      isExamStarted = false;
      isExamCompleted = false;
      remainingSeconds = 3600;
      score = 0;
    });
    countdownTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          title: Text(
            'Exam',
            style: TextStyle(
              fontFamily: Theme.of(context).textTheme.headlineSmall?.fontFamily,
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
            ),
          ),
          actions: [
            if (isExamStarted)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    _formatTime(remainingSeconds),
                    style: TextStyle(
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.fontFamily,
                      color: remainingSeconds < 300 ? Colors.red : textColor,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            TtsSpeedDropdown(),
          ],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth > 500
                      ? 500
                      : constraints.maxWidth,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth > 500 ? 20 : 16,
                  vertical: constraints.maxWidth > 500 ? 30 : 20,
                ),
                child: _buildContent(context, isSmallScreen, scheme, isDark),
              );
            },
          ),
        ),
      );
    });
  }

  Widget _buildContent(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    if (isExamCompleted) {
      return _buildResultsScreen(context, isSmallScreen, scheme, isDark);
    }

    if (isExamStarted) {
      return _buildExamScreen(context, isSmallScreen, scheme, isDark);
    }

    return _buildLevelSelectionScreen(context, isSmallScreen, scheme, isDark);
  }

  Widget _buildLevelSelectionScreen(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final levels = ['A1', 'A2', 'B1', 'B2'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isSmallScreen ? 4 : 6),
        Text(
          'Select Exam Level',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: Theme.of(context).textTheme.headlineMedium?.fontFamily,
          ),
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Text(
          'Choose a level to start your exam',
          style: TextStyle(
            fontSize: isSmallScreen ? 12 : 14,
            color: textColor.withOpacity(0.6),
            fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
          ),
        ),
        SizedBox(height: isSmallScreen ? 20 : 24),
        Expanded(
          child: ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                child: _buildLevelCard(
                  context,
                  levels[index],
                  isSmallScreen,
                  scheme,
                  isDark,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String level,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: textColor.withOpacity(0.1)),
        color: surfaceColor.withOpacity(0.02),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _startExam(level),
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 50 : 60,
                  height: isSmallScreen ? 50 : 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: textColor.withOpacity(0.1)),
                    color: primaryColor.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Text(
                      level,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontFamily: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.fontFamily,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 16 : 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Level $level Exam',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: Theme.of(
                            context,
                          ).textTheme.titleMedium?.fontFamily,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '150+ questions • ${_getTimeForLevel(level) ~/ 60} minutes',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: textColor.withOpacity(0.6),
                          fontFamily: Theme.of(
                            context,
                          ).textTheme.bodySmall?.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textColor.withOpacity(0.5),
                  size: isSmallScreen ? 16 : 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExamScreen(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final currentQuestion = currentQuestions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / currentQuestions.length;

    return Column(
      children: [
        // Progress bar
        Container(
          height: isSmallScreen ? 4 : 6,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            color: surfaceColor.withOpacity(0.05),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: primaryColor.withOpacity(0.5),
              ),
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),

        // Question counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${currentQuestions.length}',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: textColor.withOpacity(0.6),
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
              ),
            ),
            Text(
              '${((progress * 100).round())}%',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: textColor.withOpacity(0.6),
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),

        // Question card
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                border: Border.all(color: textColor.withOpacity(0.1)),
                color: surfaceColor.withOpacity(0.02),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentQuestion.question,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.titleLarge?.fontFamily,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  ...currentQuestion.options.asMap().entries.map((entry) {
                    final index = entry.key;
                    final option = entry.value;
                    final isSelected = selectedAnswerIndex == index;

                    return Padding(
                      padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                      child: _buildOptionCard(
                        context,
                        option,
                        index,
                        isSelected,
                        isSmallScreen,
                        scheme,
                        isDark,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 16 : 20),

        // Navigation buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                border: Border.all(color: textColor.withOpacity(0.1)),
                color: surfaceColor.withOpacity(0.05),
              ),
              child: IconButton(
                onPressed: currentQuestionIndex > 0 ? _previousQuestion : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: currentQuestionIndex > 0
                      ? textColor.withOpacity(0.9)
                      : textColor.withOpacity(0.3),
                  size: isSmallScreen ? 28 : 32,
                ),
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                border: Border.all(color: textColor.withOpacity(0.1)),
                color: primaryColor.withOpacity(0.2),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _submitExam,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 20 : 24,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    child: Text(
                      'Submit Exam',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                        fontFamily: Theme.of(
                          context,
                        ).textTheme.titleMedium?.fontFamily,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                border: Border.all(color: textColor.withOpacity(0.1)),
                color: surfaceColor.withOpacity(0.05),
              ),
              child: IconButton(
                onPressed: currentQuestionIndex < currentQuestions.length - 1
                    ? _nextQuestion
                    : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: currentQuestionIndex < currentQuestions.length - 1
                      ? textColor.withOpacity(0.9)
                      : textColor.withOpacity(0.3),
                  size: isSmallScreen ? 28 : 32,
                ),
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String option,
    int index,
    bool isSelected,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final backgroundColor = isDark ? scheme.backgroundDark : scheme.background;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(
          color: isSelected
              ? primaryColor.withOpacity(0.5)
              : textColor.withOpacity(0.1),
        ),
        color: isSelected
            ? primaryColor.withOpacity(0.1)
            : surfaceColor.withOpacity(0.03),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _selectAnswer(index),
          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 24 : 28,
                  height: isSmallScreen ? 24 : 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? primaryColor
                          : textColor.withOpacity(0.3),
                      width: 2,
                    ),
                    color: isSelected ? primaryColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: isSmallScreen ? 16 : 18,
                          color: backgroundColor,
                        )
                      : null,
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Text(
                    '${String.fromCharCode(65 + index)}. $option',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: textColor,
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final totalQuestions = currentQuestions.length;
    final percentage = (score / totalQuestions * 100).round();

    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 20 : 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
            border: Border.all(color: textColor.withOpacity(0.1)),
            color: surfaceColor.withOpacity(0.02),
          ),
          padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
          child: Column(
            children: [
              Text(
                'Exam Results',
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.fontFamily,
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              Container(
                width: isSmallScreen ? 120 : 140,
                height: isSmallScreen ? 120 : 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 4,
                  ),
                ),
                child: Center(
                  child: Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 36 : 42,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.headlineLarge?.fontFamily,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              Text(
                'Score: $score / $totalQuestions',
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  color: textColor.withOpacity(0.9),
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.titleLarge?.fontFamily,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: isSmallScreen ? 20 : 24),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Correct Answers',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.titleLarge?.fontFamily,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                ...currentQuestions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  final userAnswer = userAnswers[index];
                  final isCorrect = userAnswer == question.correctAnswerIndex;

                  return Padding(
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
                    child: _buildAnswerCard(
                      context,
                      index + 1,
                      question,
                      userAnswer,
                      isCorrect,
                      isSmallScreen,
                      scheme,
                      isDark,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
            border: Border.all(color: textColor.withOpacity(0.1)),
            color: primaryColor.withOpacity(0.1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _resetExam,
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Center(
                  child: Text(
                    'Take Another Exam',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      fontFamily: Theme.of(
                        context,
                      ).textTheme.titleMedium?.fontFamily,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerCard(
    BuildContext context,
    int questionNumber,
    ExamQuestion question,
    int? userAnswer,
    bool isCorrect,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(
          color: isCorrect
              ? primaryColor.withOpacity(0.5)
              : Colors.red.withOpacity(0.5),
        ),
        color: isCorrect
            ? primaryColor.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
      ),
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? primaryColor : Colors.red,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Text(
                  'Q$questionNumber: ${question.question}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.titleMedium?.fontFamily,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'Correct Answer: ${String.fromCharCode(65 + question.correctAnswerIndex)}. ${question.options[question.correctAnswerIndex]}',
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 14,
              color: primaryColor,
              fontFamily: Theme.of(context).textTheme.bodyMedium?.fontFamily,
            ),
          ),
          if (userAnswer != null && !isCorrect)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 4 : 6),
              child: Text(
                'Your Answer: ${String.fromCharCode(65 + userAnswer)}. ${question.options[userAnswer]}',
                style: TextStyle(
                  fontSize: isSmallScreen ? 13 : 14,
                  color: Colors.red,
                  fontFamily: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.fontFamily,
                ),
              ),
            ),
          if (question.explanation != null) ...[
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              'Explanation: ${question.explanation}',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 13,
                color: textColor.withOpacity(0.7),
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
