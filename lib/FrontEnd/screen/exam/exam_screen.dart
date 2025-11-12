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

class _ExamScreenState extends State<ExamScreen>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _lessonController = Get.find<LessonController>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeService.slowAnimationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
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
    _animationController.forward();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    _animationController.dispose();
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
  String? _pendingAutoStartLevel;

  Future<void> _loadExamQuestions() async {
    final loadedQuestions = await DataLoader.loadExamQuestions();
    setState(() {
      _examQuestions = loadedQuestions;
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
          elevation: 0,
          title: Hero(
            tag: 'exam_title',
            child: Material(
              color: Colors.transparent,
              child: Text(
                'Exam',
                style: themeService
                    .getTitleLargeStyle(color: textColor)
                    .copyWith(fontWeight: FontWeight.bold, shadows: null),
              ),
            ),
          ),
          actions: [
            if (isExamStarted)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 500),
                    curve: ThemeService.springCurve,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              colors: remainingSeconds < 300
                                  ? [
                                      Colors.red.withOpacity(0.2),
                                      Colors.red.withOpacity(0.1),
                                    ]
                                  : [
                                      primaryColor.withOpacity(0.2),
                                      primaryColor.withOpacity(0.1),
                                    ],
                            ),
                            border: Border.all(
                              color: remainingSeconds < 300
                                  ? Colors.red.withOpacity(0.5)
                                  : primaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            _formatTime(remainingSeconds),
                            style: themeService
                                .getBodyLargeStyle(
                                  color: remainingSeconds < 300
                                      ? Colors.red
                                      : primaryColor,
                                )
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  shadows: null,
                                ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const TtsSpeedDropdown(),
          ],
        ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
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
    final themeService = Get.find<ThemeService>();
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final levels = ['A1', 'A2', 'B1', 'B2'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isSmallScreen ? 4 : 6),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: ThemeService.defaultAnimationDuration,
          curve: ThemeService.springCurve,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [textColor, primaryColor],
                  ).createShader(bounds),
                  child: Text(
                    'Select Exam Level',
                    style: themeService
                        .getHeadlineSmallStyle(color: Colors.white)
                        .copyWith(fontWeight: FontWeight.bold, shadows: null),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400),
          curve: ThemeService.springCurve,
          builder: (context, value, child) {
            return Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Text(
                'Choose a level to start your exam',
                style: themeService.getBodyMediumStyle(
                  color: textColor.withOpacity(0.6),
                ),
              ),
            );
          },
        ),
        SizedBox(height: isSmallScreen ? 20 : 24),
        Expanded(
          child: ListView.builder(
            itemCount: levels.length,
            itemBuilder: (context, index) {
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
                        padding: EdgeInsets.only(
                          bottom: isSmallScreen ? 12 : 16,
                        ),
                        child: _buildLevelCard(
                          context,
                          levels[index],
                          isSmallScreen,
                          scheme,
                          isDark,
                        ),
                      ),
                    ),
                  );
                },
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
    final themeService = Get.find<ThemeService>();
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _startExam(level),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: themeService.getCardGradient(isDark),
            border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
            boxShadow: ThemeService.getCardShadow(isDark),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _startExam(level),
              borderRadius: BorderRadius.circular(20),
              splashColor: primaryColor.withOpacity(0.2),
              highlightColor: primaryColor.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Row(
                  children: [
                    Container(
                      width: isSmallScreen ? 60 : 70,
                      height: isSmallScreen ? 60 : 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          level,
                          style: themeService
                              .getHeadlineSmallStyle(color: Colors.white)
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                shadows: null,
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
                            style: themeService
                                .getTitleMediumStyle(color: textColor)
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  shadows: null,
                                ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '150+ questions • ${_getTimeForLevel(level) ~/ 60} minutes',
                            style: themeService.getBodySmallStyle(
                              color: textColor.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: primaryColor,
                      size: isSmallScreen ? 18 : 20,
                    ),
                  ],
                ),
              ),
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
    final themeService = Get.find<ThemeService>();
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
    final currentQuestion = currentQuestions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / currentQuestions.length;

    return Column(
      children: [
        // Animated Progress bar
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: progress),
          duration: ThemeService.slowAnimationDuration,
          curve: Curves.easeOutCubic,
          builder: (context, progressValue, child) {
            return Container(
              height: isSmallScreen ? 6 : 8,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: textColor.withOpacity(0.1),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressValue,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
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
        SizedBox(height: isSmallScreen ? 12 : 16),

        // Question counter
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${currentQuestions.length}',
              style: themeService.getLabelSmallStyle(
                color: textColor.withOpacity(0.6),
              ),
            ),
            Text(
              '${((progress * 100).round())}%',
              style: themeService.getLabelSmallStyle(
                color: textColor.withOpacity(0.6),
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 16 : 20),

        // Question card with animation
        Expanded(
          child: SingleChildScrollView(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: ThemeService.defaultAnimationDuration,
              curve: ThemeService.springCurve,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: themeService.getCardGradient(isDark),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: ThemeService.getCardShadow(isDark),
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQuestion.question,
                            style: themeService
                                .getTitleLargeStyle(color: textColor)
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  shadows: null,
                                ),
                          ),
                          SizedBox(height: isSmallScreen ? 20 : 24),
                          ...currentQuestion.options.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final option = entry.value;
                            final isSelected = selectedAnswerIndex == index;

                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(
                                milliseconds: 200 + (index * 50),
                              ),
                              curve: ThemeService.springCurve,
                              builder: (context, optionValue, child) {
                                return Transform.translate(
                                  offset: Offset(20 * (1 - optionValue), 0),
                                  child: Opacity(
                                    opacity: optionValue.clamp(0.0, 1.0),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: isSmallScreen ? 12 : 16,
                                      ),
                                      child: _buildOptionCard(
                                        context,
                                        option,
                                        index,
                                        isSelected,
                                        isSmallScreen,
                                        scheme,
                                        isDark,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 16 : 20),

        // Navigation buttons with animations
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: themeService.getCardGradient(isDark),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: ThemeService.getCardShadow(isDark),
                    ),
                    child: IconButton(
                      onPressed: currentQuestionIndex > 0
                          ? _previousQuestion
                          : null,
                      icon: Icon(
                        Icons.chevron_left,
                        color: currentQuestionIndex > 0
                            ? textColor
                            : textColor.withOpacity(0.3),
                        size: isSmallScreen ? 22 : 26,
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    ),
                  ),
                );
              },
            ),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
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
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _submitExam,
                        borderRadius: BorderRadius.circular(16),
                        splashColor: primaryColor.withOpacity(0.3),
                        highlightColor: primaryColor.withOpacity(0.2),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 20 : 24,
                            vertical: isSmallScreen ? 12 : 16,
                          ),
                          child: Text(
                            'Submit Exam',
                            style: themeService
                                .getTitleSmallStyle(color: primaryColor)
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  shadows: null,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: themeService.getCardGradient(isDark),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: ThemeService.getCardShadow(isDark),
                    ),
                    child: IconButton(
                      onPressed:
                          currentQuestionIndex < currentQuestions.length - 1
                          ? _nextQuestion
                          : null,
                      icon: Icon(
                        Icons.chevron_right,
                        color:
                            currentQuestionIndex < currentQuestions.length - 1
                            ? textColor
                            : textColor.withOpacity(0.3),
                        size: isSmallScreen ? 22 : 26,
                      ),
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                    ),
                  ),
                );
              },
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
    final themeService = Get.find<ThemeService>();
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: ThemeService.defaultAnimationDuration,
          curve: ThemeService.defaultCurve,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.2),
                      secondaryColor.withOpacity(0.15),
                    ],
                  )
                : themeService.getCardGradient(isDark),
            border: Border.all(
              color: isSelected
                  ? primaryColor.withOpacity(0.5)
                  : textColor.withOpacity(0.1),
              width: isSelected ? 2 : 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : ThemeService.getCardShadow(isDark),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _selectAnswer(index),
              borderRadius: BorderRadius.circular(16),
              splashColor: primaryColor.withOpacity(0.2),
              highlightColor: primaryColor.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: ThemeService.defaultAnimationDuration,
                      curve: ThemeService.defaultCurve,
                      width: isSmallScreen ? 28 : 32,
                      height: isSmallScreen ? 28 : 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [primaryColor, secondaryColor],
                              )
                            : null,
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : textColor.withOpacity(0.3),
                          width: 2,
                        ),
                        color: isSelected ? null : Colors.transparent,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.5),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              size: isSmallScreen ? 18 : 20,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Text(
                        '${String.fromCharCode(65 + index)}. $option',
                        style: themeService
                            .getBodyLargeStyle(
                              color: isSelected ? primaryColor : textColor,
                            )
                            .copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              shadows: null,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
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
                style: ThemeService()
                    .getHeadlineMediumStyle(color: textColor)
                    .copyWith(
                      fontSize: isSmallScreen ? 24 : 28,
                      fontWeight: FontWeight.bold,
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
                    style: ThemeService()
                        .getHeadlineLargeStyle(color: primaryColor)
                        .copyWith(
                          fontSize: isSmallScreen ? 36 : 42,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 24),
              Text(
                'Score: $score / $totalQuestions',
                style: ThemeService()
                    .getTitleLargeStyle(color: textColor.withOpacity(0.9))
                    .copyWith(fontSize: isSmallScreen ? 18 : 20),
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
                  style: ThemeService()
                      .getTitleLargeStyle(color: textColor)
                      .copyWith(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.w600,
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
                      ThemeService(),
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
                    style: ThemeService()
                        .getTitleMediumStyle(color: primaryColor)
                        .copyWith(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
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
    ThemeService themeService,
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
                  style: themeService
                      .getTitleMediumStyle(color: textColor)
                      .copyWith(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            'Correct Answer: ${String.fromCharCode(65 + question.correctAnswerIndex)}. ${question.options[question.correctAnswerIndex]}',
            style: themeService
                .getBodyMediumStyle(color: primaryColor)
                .copyWith(fontSize: isSmallScreen ? 13 : 14),
          ),
          if (userAnswer != null && !isCorrect)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 4 : 6),
              child: Text(
                'Your Answer: ${String.fromCharCode(65 + userAnswer)}. ${question.options[userAnswer]}',
                style: themeService
                    .getBodyMediumStyle(color: Colors.red)
                    .copyWith(fontSize: isSmallScreen ? 13 : 14),
              ),
            ),
          if (question.explanation != null) ...[
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              'Explanation: ${question.explanation}',
              style: themeService
                  .getBodySmallStyle(color: textColor.withOpacity(0.7))
                  .copyWith(fontSize: isSmallScreen ? 12 : 13),
            ),
          ],
        ],
      ),
    );
  }
}
