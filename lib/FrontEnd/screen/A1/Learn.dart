import 'dart:math' as math;
import 'package:ductuch_master/Data/lesson_content_data.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';

class PhraseData {
  final String phrase;
  final String translation;
  final String meaning;
  final String languageCode;
  final String level;
  final bool isFavorite;

  PhraseData({
    required this.phrase,
    required this.translation,
    required this.meaning,
    required this.languageCode,
    required this.level,
    this.isFavorite = false,
  });

  PhraseData copyWith({
    String? phrase,
    String? translation,
    String? meaning,
    String? languageCode,
    String? level,
    bool? isFavorite,
  }) {
    return PhraseData(
      phrase: phrase ?? this.phrase,
      translation: translation ?? this.translation,
      meaning: meaning ?? this.meaning,
      languageCode: languageCode ?? this.languageCode,
      level: level ?? this.level,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class PhraseScreen extends StatefulWidget {
  final String? topicId;
  final String? topicTitle;

  const PhraseScreen({super.key, this.topicId, this.topicTitle});

  @override
  State<PhraseScreen> createState() => _PhraseScreenState();
}

class _PhraseScreenState extends State<PhraseScreen> {
  int _currentPhraseIndex = 0;
  final Set<int> _visitedIndices = <int>{};
  double _currentRate = 0.8;
  bool _repeatOn = false;
  bool _isPlaying = false;
  late FlutterTts _flutterTts;
  late List<PhraseData> _phrases;
  String _topicId = 'A1-M1-T1';
  late final LessonController _lessonController;

  bool get _lessonCompleted =>
      _phrases.isNotEmpty && _visitedIndices.length >= _phrases.length;

  double get _lessonProgress =>
      _phrases.isEmpty ? 0.0 : (_visitedIndices.length / _phrases.length);

  @override
  void initState() {
    super.initState();
    // Get topic ID from widget or route arguments
    final topicId =
        widget.topicId ??
        (Get.arguments is Map ? Get.arguments['topicId'] : null) ??
        'A1-M1-T1';
    _topicId = topicId;

    // Load phrases from JSON repository (fallback to in-code data)
    _phrases =
        LessonContentData.getByTopicId(topicId) ??
        LessonContentData.topicContent[topicId] ??
        [
          PhraseData(
            phrase: "Guten Tag!",
            translation: "Good day!",
            meaning: "A common greeting.",
            languageCode: "de-DE",
            level: "A1",
          ),
        ];

    _lessonController = Get.find<LessonController>();
    _initTTS();
    _initializeProgress();
  }

  String get _topicTitle {
    return widget.topicTitle ??
        (Get.arguments is Map ? Get.arguments['topicTitle'] : null) ??
        'Lesson';
  }

  void _initTTS() async {
    _flutterTts = FlutterTts();

    // Set TTS parameters
    await _flutterTts.setSpeechRate(_currentRate);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);

    // Set completion handler
    _flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
      });

      if (_repeatOn) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _playCurrentPhrase();
        });
        return;
      }

      // Mark phrase as listened in controller (but don't auto-advance)
      _lessonController.markPhraseListened(
        topicId: _topicId,
        phraseIndex: _currentPhraseIndex,
        totalPhrases: _phrases.length,
      );
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isPlaying = false;
      });
      print("TTS Error: $msg");
    });
  }

  void _initializeProgress() {
    int? firstIncomplete;
    for (var i = 0; i < _phrases.length; i++) {
      if (_lessonController.isPhraseListened(_topicId, i)) {
        _visitedIndices.add(i);
      } else {
        firstIncomplete ??= i;
      }
    }

    if (_phrases.isNotEmpty) {
      if (firstIncomplete != null) {
        _currentPhraseIndex = firstIncomplete;
      } else {
        _currentPhraseIndex = math.min(
          _currentPhraseIndex,
          _phrases.length - 1,
        );
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final added = _markCurrentAsConsumedInternal();
      if (added) {
        setState(() {});
      }
    });
  }

  bool _markCurrentAsConsumedInternal() {
    if (_phrases.isEmpty) return false;
    final added = _visitedIndices.add(_currentPhraseIndex);
    if (added) {
      _lessonController.markPhraseListened(
        topicId: _topicId,
        phraseIndex: _currentPhraseIndex,
        totalPhrases: _phrases.length,
      );
    }
    return added;
  }

  void _navigateToNextLesson() {
    final parts = _topicId.split('-');
    if (parts.length < 3) return;
    final moduleId = '${parts[0]}-${parts[1]}';
    final topics = LearningPathData.moduleTopics[moduleId];
    if (topics == null || topics.isEmpty) return;

    final currentTopicNumber =
        int.tryParse(parts.last.replaceAll(RegExp(r'[^0-9]'), '')) ?? 1;
    final nextIndex = currentTopicNumber; // zero-based
    if (nextIndex >= topics.length) return;

    final nextTopicId = '$moduleId-T${nextIndex + 1}';
    final nextTopicTitle = topics[nextIndex];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      NavigationHelper.pushReplacementWithBottomNav(
        context,
        PhraseScreen(topicId: nextTopicId, topicTitle: nextTopicTitle),
        withNavBar: true,
      );
    });
  }

  void _toggleFavorite() {
    setState(() {
      _phrases[_currentPhraseIndex] = _phrases[_currentPhraseIndex].copyWith(
        isFavorite: !_phrases[_currentPhraseIndex].isFavorite,
      );
    });
  }

  void _changeRate(double rate) {
    setState(() {
      _currentRate = rate;
    });
    _flutterTts.setSpeechRate(rate);
  }

  void _toggleRepeat() {
    setState(() {
      _repeatOn = !_repeatOn;
    });
  }

  Future<void> _playPhrase(String text, String lang) async {
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() {
        _isPlaying = false;
      });
      return;
    }

    setState(() {
      _isPlaying = true;
    });

    try {
      await _flutterTts.setLanguage(lang);
      await _flutterTts.speak(text);
    } catch (e) {
      setState(() {
        _isPlaying = false;
      });
      print("TTS Error: $e");
    }
  }

  void _playCurrentPhrase() {
    final currentPhrase = _phrases[_currentPhraseIndex];
    _playPhrase(currentPhrase.phrase, currentPhrase.languageCode);
  }

  void _nextPhrase() {
    if (_phrases.isEmpty) return;
    if (_isPlaying) {
      _flutterTts.stop();
    }
    final isLastPhrase = _currentPhraseIndex >= _phrases.length - 1;
    setState(() {
      _currentPhraseIndex = (_currentPhraseIndex + 1) % _phrases.length;
      _isPlaying = false;
      _markCurrentAsConsumedInternal();
    });
    if (isLastPhrase && _lessonCompleted) {
      _navigateToNextLesson();
    }
  }

  void _previousPhrase() {
    if (_phrases.isEmpty) return;
    if (_isPlaying) {
      _flutterTts.stop();
    }
    setState(() {
      _currentPhraseIndex =
          (_currentPhraseIndex - 1 + _phrases.length) % _phrases.length;
      _isPlaying = false;
      _markCurrentAsConsumedInternal();
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPhrase = _phrases[_currentPhraseIndex];
    final isSmallScreen = ResponsiveHelper.isMobile(context);

    final themeService = Get.find<ThemeService>();
    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondaryTextColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;

      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          if (didPop) {
            // Stop TTS if playing when back is pressed
            if (_isPlaying) {
              await _flutterTts.stop();
            }
          }
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
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
                    horizontal: ResponsiveHelper.getHorizontalPadding(context),
                    vertical: ResponsiveHelper.getVerticalPadding(context),
                  ),
                  child: Column(
                    children: [
                      // Status spacer
                      SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.25),

                      // Top bar
                      _buildTopBar(
                        isSmallScreen,
                        textColor,
                        secondaryTextColor,
                      ),

                      SizedBox(height: ResponsiveHelper.getSpacing(context)),

                      // Lesson header
                      _buildLessonHeader(
                        isSmallScreen,
                        textColor,
                        secondaryTextColor,
                        themeService,
                      ),

                      SizedBox(height: ResponsiveHelper.getSpacing(context)),

                      // Main card
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildMainCard(
                                currentPhrase,
                                isSmallScreen,
                                textColor,
                                secondaryTextColor,
                                isDark,
                                scheme,
                                themeService,
                              ),
                              SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.5),

                              // External Navigation Controls
                              _buildExternalNavigationControls(
                                isSmallScreen,
                                textColor,
                                isDark,
                                scheme,
                              ),

                              SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.25),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom navigation
          // bottomNavigationBar: _buildBottomNav(isSmallScreen),
        ),
      );
    });
  }

  Widget _buildTopBar(
    bool isSmallScreen,
    Color textColor,
    Color secondaryTextColor,
  ) {
    return Row(
      children: [
        // Back button
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.4),
            border: Border.all(color: textColor.withOpacity(0.1)),
          ),
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.chevron_left,
              color: secondaryTextColor,
              size: ResponsiveHelper.getIconSize(context),
            ),
            tooltip: 'Back',
            padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) * 0.375),
          ),
        ),

        // User avatar
      ],
    );
  }

  Widget _buildLessonHeader(
    bool isSmallScreen,
    Color textColor,
    Color secondaryTextColor,
    ThemeService themeService,
  ) {
    final totalPhrases = _phrases.length;
    final learnedCount = totalPhrases == 0
        ? 0
        : math.min(_visitedIndices.length, totalPhrases);
    final filledDots = totalPhrases == 0
        ? 0
        : (_lessonProgress * 4).clamp(0.0, 4.0).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      _topicTitle,
                      style: themeService.getStyle(
                        fontSize: ResponsiveHelper.getSmallSize(context),
                        color: secondaryTextColor.withOpacity(0.8),
                        letterSpacing: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
                  Text(
                    '•',
                    style: themeService.getStyle(
                      fontSize: ResponsiveHelper.getSmallSize(context),
                      color: secondaryTextColor.withOpacity(0.3),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.25),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  '$learnedCount/$totalPhrases',
                  style: themeService.getStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    color: secondaryTextColor,
                  ),
                ),
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.5),
                Row(
                  children: List.generate(4, (index) {
                    final isFilled = index < filledDots;
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: ResponsiveHelper.getSpacing(context) * 0.0625,
                      ),
                      width: index == 0
                          ? ResponsiveHelper.getSpacing(context)
                          : ResponsiveHelper.getSpacing(context) * 0.5,
                      height: ResponsiveHelper.getSpacing(context) * 0.375,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.1),
                        color: isFilled
                            ? textColor.withOpacity(0.8 - (index * 0.12))
                            : textColor.withOpacity(0.18),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: ThemeService.defaultAnimationDuration,
          child: _lessonCompleted
              ? Padding(
                  padding: EdgeInsets.only(top: ResponsiveHelper.getSpacing(context) * 0.5),
                  child: _buildCompletionChip(themeService, isSmallScreen),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildCompletionChip(ThemeService themeService, bool isSmallScreen) {
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final primary = isDark ? scheme.primaryDark : scheme.primary;
    final accent = scheme.accentTeal;

    return Container(
      padding: ResponsiveHelper.getButtonPadding(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.2), accent.withOpacity(0.18)],
        ),
        border: Border.all(color: primary.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.emoji_events,
            size: ResponsiveHelper.getSmallIconSize(context),
            color: accent,
          ),
          SizedBox(width: isSmallScreen ? 6 : 8),
          Text(
            'Lesson completed',
            style: themeService
                .getLabelSmallStyle(color: primary)
                .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.4),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCard(
    PhraseData phrase,
    bool isSmallScreen,
    Color textColor,
    Color secondaryTextColor,
    bool isDark,
    dynamic scheme,
    ThemeService themeService,
  ) {
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: ThemeService.defaultAnimationDuration,
      curve: ThemeService.springCurve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                gradient: themeService.getCardGradient(isDark),
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: ThemeService.getCardShadow(isDark),
              ),
              padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with tag and favorite
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Daily phrase tag with animation
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: ThemeService.defaultAnimationDuration,
                              curve: ThemeService.springCurve,
                              builder: (context, tagValue, child) {
                                return Transform.scale(
                                  scale: tagValue,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ResponsiveHelper.getSpacing(context) * 0.625,
                                      vertical: ResponsiveHelper.getSpacing(context) * 0.375,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.2),
                                          secondaryColor.withOpacity(0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.5),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: ResponsiveHelper.getSpacing(context) * 0.5,
                                          height: ResponsiveHelper.getSpacing(context) * 0.5,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                primaryColor,
                                                secondaryColor,
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.375),
                                        Text(
                                          'Daily Phrase',
                                          style: themeService
                                              .getLabelSmallStyle(
                                                color: primaryColor,
                                              )
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                            // Main phrase with Hero animation
                            Hero(
                              tag: 'phrase_${phrase.phrase}',
                              child: Material(
                                color: Colors.transparent,
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [textColor, primaryColor],
                                  ).createShader(bounds),
                                  child: Text(
                                    phrase.phrase,
                                    style: themeService
                                        .getTitleLargeStyle(color: Colors.white)
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: ResponsiveHelper.getTitleSize(context),
                                          height: 1.2,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Favorite button with animation
                      // TweenAnimationBuilder<double>(
                      //   tween: Tween(
                      //     begin: 0.0,
                      //     end: phrase.isFavorite ? 1.0 : 0.0,
                      //   ),
                      //   duration: ThemeService.defaultAnimationDuration,
                      //   curve: ThemeService.bounceCurve,
                      //   builder: (context, favValue, child) {
                      //     return Transform.scale(
                      //       scale: 1.0 + (favValue * 0.2),
                      //       child: Container(
                      //         decoration: BoxDecoration(
                      //           gradient: LinearGradient(
                      //             colors: [
                      //               Colors.red.withOpacity(0.2 * favValue),
                      //               Colors.pink.withOpacity(0.15 * favValue),
                      //             ],
                      //           ),
                      //           borderRadius: BorderRadius.circular(
                      //             isSmallScreen ? 12 : 14,
                      //           ),
                      //           border: Border.all(
                      //             color: Colors.red.withOpacity(0.4 * favValue),
                      //             width: 2,
                      //           ),
                      //         ),
                      //         child: IconButton(
                      //           onPressed: _toggleFavorite,
                      //           icon: Icon(
                      //             phrase.isFavorite
                      //                 ? Icons.favorite
                      //                 : Icons.favorite_border,
                      //             color: phrase.isFavorite
                      //                 ? Colors.red
                      //                 : secondaryTextColor,
                      //             size: isSmallScreen ? 22 : 24,
                      //           ),
                      //           padding: isSmallScreen
                      //               ? const EdgeInsets.all(8)
                      //               : null,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),

                  // IPA and language tags
                  Wrap(
                    spacing: ResponsiveHelper.getSpacing(context) * 0.5,
                    runSpacing: ResponsiveHelper.getSpacing(context) * 0.375,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getSpacing(context) * 0.375,
                          vertical: ResponsiveHelper.getSpacing(context) * 0.125,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.2),
                          border: Border.all(color: textColor.withOpacity(0.1)),
                          color: isDark
                              ? scheme.surfaceDark.withOpacity(0.05)
                              : scheme.surface.withOpacity(0.05),
                        ),
                        child: Text(
                          'DE',
                          style: themeService.getStyle(
                            fontSize: ResponsiveHelper.getSmallSize(context),
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveHelper.getSpacing(context) * 0.375,
                          vertical: ResponsiveHelper.getSpacing(context) * 0.125,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.2),
                          border: Border.all(color: textColor.withOpacity(0.1)),
                          color: isDark
                              ? scheme.surfaceDark.withOpacity(0.05)
                              : scheme.surface.withOpacity(0.05),
                        ),
                        child: Text(
                          phrase.level,
                          style: themeService.getStyle(
                            fontSize: ResponsiveHelper.getSmallSize(context),
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.75),

                  // Translation card with animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 400),
                    curve: ThemeService.springCurve,
                    builder: (context, transValue, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - transValue)),
                        child: Opacity(
                          opacity: transValue.clamp(0.0, 1.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.08),
                                  secondaryColor.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context) * 0.875),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        phrase.translation,
                                        style: themeService
                                            .getBodySmallStyle(
                                              color: textColor.withOpacity(0.9),
                                            )
                                            .copyWith(
                                              fontSize: ResponsiveHelper.getBodySize(context),
                                            ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.4),
                                        border: Border.all(
                                          color: textColor.withOpacity(0.1),
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () => _playPhrase(
                                          phrase.translation,
                                          'en-US',
                                        ),
                                        icon: Icon(
                                          Icons.volume_up,
                                          size: ResponsiveHelper.getSmallIconSize(context),
                                          color: secondaryTextColor.withOpacity(
                                            0.8,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) * 0.25),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.25),
                                Text(
                                  phrase.meaning,
                                  style: themeService.getStyle(
                                    fontSize: ResponsiveHelper.getSmallSize(context),
                                    color: secondaryTextColor.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: ResponsiveHelper.getSpacing(context)),

                  // Play controls (only rate controls and repeat, no navigation)
                  _buildRateControls(
                    isSmallScreen,
                    textColor,
                    secondaryTextColor,
                    themeService,
                  ),

                  SizedBox(height: ResponsiveHelper.getSpacing(context)),

                  // Animated Progress bar
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0.0,
                      end: _lessonProgress.clamp(0.0, 1.0),
                    ),
                    duration: ThemeService.slowAnimationDuration,
                    curve: Curves.easeOutCubic,
                    builder: (context, progressValue, child) {
                      return Container(
                        height: ResponsiveHelper.getProgressBarHeight(context),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.2),
                          color: textColor.withOpacity(0.1),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progressValue,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryColor, scheme.accentTeal],
                              ),
                              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.2),
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
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRateControls(
    bool isSmallScreen,
    Color textColor,
    Color secondaryTextColor,
    ThemeService themeService,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRateButton(
          0.5,
          isSmallScreen,
          textColor,
          secondaryTextColor,
          themeService,
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
        _buildRateButton(
          0.8,
          isSmallScreen,
          textColor,
          secondaryTextColor,
          themeService,
        ),
        SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
        _buildRepeatButton(
          isSmallScreen,
          textColor,
          secondaryTextColor,
          themeService,
        ),
      ],
    );
  }

  Widget _buildExternalNavigationControls(
    bool isSmallScreen,
    Color textColor,
    bool isDark,
    dynamic scheme,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getPadding(context) * 1.25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                border: Border.all(color: textColor.withOpacity(0.1)),
                color: textColor.withOpacity(0.08),
              ),
              child: IconButton(
                onPressed: _previousPhrase,
                icon: Icon(
                  Icons.chevron_left,
                  size: ResponsiveHelper.getIconSize(context),
                  color: textColor.withOpacity(0.9),
                ),
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
              ),
            ),
          ),

          SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),

          // Main play button with pulse animation
          Flexible(
            child: Builder(
              builder: (context) {
                final primaryColor = isDark
                    ? scheme.primaryDark
                    : scheme.primary;
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: _isPlaying ? 1.0 : 0.0),
                  duration: Duration(milliseconds: 1000),
                  builder: (context, pulseValue, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pulsing ring
                        if (_isPlaying)
                          Container(
                            width:
                                (ResponsiveHelper.isDesktop(context) ? 76 : ResponsiveHelper.isTablet(context) ? 70 : 64) + (pulseValue * 16),
                            height:
                                (ResponsiveHelper.isDesktop(context) ? 76 : ResponsiveHelper.isTablet(context) ? 70 : 64) + (pulseValue * 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  primaryColor.withOpacity(
                                    0.3 * (1 - pulseValue),
                                  ),
                                  primaryColor.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                            gradient: LinearGradient(
                              colors: [
                                primaryColor.withOpacity(0.2),
                                scheme.accentTeal.withOpacity(0.15),
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
                          child: IconButton(
                            onPressed: _playCurrentPhrase,
                            icon: Icon(
                              _isPlaying ? Icons.stop : Icons.volume_up,
                              size: ResponsiveHelper.getIconSize(context),
                              color: primaryColor,
                            ),
                            padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
                          ),
                        ),
                        if (_isPlaying)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 500),
                              curve: ThemeService.bounceCurve,
                              builder: (context, dotValue, child) {
                                return Transform.scale(
                                  scale: dotValue,
                                  child: Container(
                                    width: isSmallScreen ? 12 : 14,
                                    height: isSmallScreen ? 12 : 14,
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
                                          color: primaryColor.withOpacity(0.8),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),

          // Next button
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                border: Border.all(color: textColor.withOpacity(0.1)),
                color: textColor.withOpacity(0.08),
              ),
              child: IconButton(
                onPressed: _nextPhrase,
                icon: Icon(
                  Icons.chevron_right,
                  size: ResponsiveHelper.getIconSize(context),
                  color: textColor.withOpacity(0.9),
                ),
                padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateButton(
    double rate,
    bool isSmallScreen,
    Color textColor,
    Color secondaryTextColor,
    ThemeService themeService,
  ) {
    final isSelected = _currentRate == rate;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: textColor.withOpacity(0.1)),
        color: isSelected
            ? textColor.withOpacity(0.12)
            : textColor.withOpacity(0.06),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _changeRate(rate),
          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            child: Text(
              '${rate}x',
              style: themeService.getStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? textColor : secondaryTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatButton(
    bool isSmallScreen,
    Color textColor,
    Color secondaryTextColor,
    ThemeService themeService,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: textColor.withOpacity(0.1)),
        color: _repeatOn
            ? textColor.withOpacity(0.12)
            : textColor.withOpacity(0.06),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleRepeat,
          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 6 : 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.repeat,
                  size: isSmallScreen ? 16 : 18,
                  color: _repeatOn ? textColor : secondaryTextColor,
                ),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Text(
                  'Repeat',
                  style: themeService.getStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    color: _repeatOn ? textColor : secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
