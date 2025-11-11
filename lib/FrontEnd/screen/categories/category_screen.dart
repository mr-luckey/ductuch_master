import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Category word model
class CategoryWord {
  final String german;
  final String english;
  final String? meaning;

  CategoryWord({required this.german, required this.english, this.meaning});
}

/// Category Screen - displays words from a specific category
class CategoryScreen extends StatefulWidget {
  final String categoryName;
  final List<CategoryWord> words;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    required this.words,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  final ThemeService themeService = Get.find<ThemeService>();
  final TtsService ttsService = Get.find<TtsService>();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  int _currentWordIndex = 0;

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

  void _nextWord() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentWordIndex = (_currentWordIndex + 1) % widget.words.length;
    });
  }

  void _previousWord() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentWordIndex = (_currentWordIndex - 1) % widget.words.length;
      if (_currentWordIndex < 0) {
        _currentWordIndex = widget.words.length - 1;
      }
    });
  }

  Future<void> _playCurrentWord() async {
    final currentWord = widget.words[_currentWordIndex];
    await ttsService.speak(currentWord.german);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) async {
          if (didPop && ttsService.isPlaying) {
            await ttsService.stop();
          }
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            title: Hero(
              tag: 'category_title_${widget.categoryName}',
              child: Material(
                color: Colors.transparent,
                child: Text(
                  widget.categoryName,
                  style: themeService.getTitleLargeStyle(color: textColor)
                      .copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            actions: [const TtsSpeedDropdown()],
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
                    child: Column(
                      children: [
                        SizedBox(height: isSmallScreen ? 4 : 6),
                        _buildTopBar(context, isSmallScreen, scheme, isDark),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        _buildCategoryHeader(
                          context,
                          isSmallScreen,
                          scheme,
                          isDark,
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildMainCard(
                                  context,
                                  isSmallScreen,
                                  scheme,
                                  isDark,
                                ),
                                SizedBox(height: isSmallScreen ? 20 : 24),
                                _buildExternalNavigationControls(
                                  context,
                                  isSmallScreen,
                                  scheme,
                                  isDark,
                                ),
                                SizedBox(height: isSmallScreen ? 16 : 20),
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
          ),
        ),
      );
    });
  }

  Widget _buildTopBar(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

    return Row(
      children: [
        Hero(
          tag: 'category_back_${widget.categoryName}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: themeService.getCardGradient(isDark),
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                ),
                boxShadow: ThemeService.getCardShadow(isDark),
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.chevron_left,
                  color: textColor,
                  size: isSmallScreen ? 20 : 24,
                ),
                padding: isSmallScreen ? const EdgeInsets.all(8) : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

    return Row(
      children: [
        Flexible(
          child: Text(
            widget.categoryName,
            style: themeService.getLabelSmallStyle(
              color: textColor.withOpacity(0.5),
            ).copyWith(
              letterSpacing: 1.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              '${_currentWordIndex + 1}/${widget.words.length}',
              style: themeService.getLabelSmallStyle(
                color: textColor.withOpacity(0.6),
              ),
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),
            Row(
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 0.5 : 1,
                  ),
                  width: index == 0
                      ? (isSmallScreen ? 12 : 16)
                      : (isSmallScreen ? 6 : 8),
                  height: isSmallScreen ? 4 : 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: index == 0
                        ? textColor.withOpacity(0.7)
                        : index < 2
                            ? textColor.withOpacity(0.3)
                            : textColor.withOpacity(0.15),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainCard(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
    final currentWord = widget.words[_currentWordIndex];

    return TweenAnimationBuilder<double>(
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
                  // Header with animated tag
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: ThemeService.defaultAnimationDuration,
                              curve: ThemeService.bounceCurve,
                              builder: (context, tagValue, child) {
                                return Transform.scale(
                                  scale: tagValue,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 8 : 10,
                                      vertical: isSmallScreen ? 5 : 6,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          primaryColor.withOpacity(0.2),
                                          secondaryColor.withOpacity(0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.4),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: isSmallScreen ? 6 : 8,
                                          height: isSmallScreen ? 6 : 8,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [primaryColor, secondaryColor],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: isSmallScreen ? 4 : 6),
                                        Text(
                                          widget.categoryName.toUpperCase(),
                                          style: themeService
                                              .getLabelSmallStyle(color: primaryColor)
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
                            SizedBox(height: isSmallScreen ? 8 : 12),
                            // Main text with Hero animation
                            Hero(
                              tag: 'category_word_${currentWord.german}',
                              child: Material(
                                color: Colors.transparent,
                                child: ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [textColor, primaryColor],
                                  ).createShader(bounds),
                                  child: Text(
                                    currentWord.german,
                                    style: themeService
                                        .getTitleLargeStyle(color: Colors.white)
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 22 : 28,
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  // Language tag
                  Wrap(
                    spacing: isSmallScreen ? 6 : 8,
                    runSpacing: isSmallScreen ? 4 : 6,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.15),
                              secondaryColor.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'DE',
                          style: themeService.getLabelSmallStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
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
                              borderRadius: BorderRadius.circular(16),
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
                            padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        currentWord.english,
                                        style: themeService.getBodyLargeStyle(
                                          color: textColor.withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(
                                          colors: [
                                            primaryColor.withOpacity(0.2),
                                            secondaryColor.withOpacity(0.15),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: primaryColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Obx(
                                        () => IconButton(
                                          onPressed: _playCurrentWord,
                                          icon: Icon(
                                            ttsService.isTextPlaying(currentWord.german)
                                                ? Icons.volume_up
                                                : Icons.volume_up_outlined,
                                            size: isSmallScreen ? 18 : 20,
                                            color: ttsService.isTextPlaying(currentWord.german)
                                                ? primaryColor
                                                : textColor.withOpacity(0.8),
                                          ),
                                          padding: isSmallScreen
                                              ? const EdgeInsets.all(6)
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (currentWord.meaning != null) ...[
                                  SizedBox(height: isSmallScreen ? 6 : 8),
                                  Text(
                                    currentWord.meaning!,
                                    style: themeService.getBodyMediumStyle(
                                      color: textColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  // Animated Progress bar
                  TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: 0.0,
                      end: (_currentWordIndex + 1) / widget.words.length,
                    ),
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
                                colors: [primaryColor, scheme.accentTeal],
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExternalNavigationControls(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
    final successColor = scheme.accentTeal;
    final currentWord = widget.words[_currentWordIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
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
                    onPressed: _previousWord,
                    icon: Icon(
                      Icons.chevron_left,
                      size: isSmallScreen ? 22 : 26,
                      color: textColor,
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  ),
                ),
              );
            },
          ),
          // Main play button with pulse animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Obx(
                  () {
                    final isPlaying = ttsService.isTextPlaying(currentWord.german);
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: isPlaying ? 1.0 : 0.0),
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeOutCubic,
                      builder: (context, pulseValue, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsing ring
                            if (isPlaying)
                              Container(
                                width: (isSmallScreen ? 64 : 76) + (pulseValue * 16),
                                height: (isSmallScreen ? 64 : 76) + (pulseValue * 16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.3 * (1 - pulseValue)),
                                      primaryColor.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            Container(
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
                              child: IconButton(
                                onPressed: _playCurrentWord,
                                icon: Icon(
                                  isPlaying ? Icons.stop : Icons.volume_up,
                                  size: isSmallScreen ? 28 : 32,
                                  color: primaryColor,
                                ),
                                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                              ),
                            ),
                            if (isPlaying)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: isSmallScreen ? 12 : 14,
                                  height: isSmallScreen ? 12 : 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [primaryColor, successColor],
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
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
          // Next button
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
                    onPressed: _nextWord,
                    icon: Icon(
                      Icons.chevron_right,
                      size: isSmallScreen ? 22 : 26,
                      color: textColor,
                    ),
                    padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
