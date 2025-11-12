import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Verb model with examples
class VerbData {
  final String infinitive;
  final String english;
  final String conjugation;
  final List<String> examples; // 5 example sentences

  VerbData({
    required this.infinitive,
    required this.english,
    required this.conjugation,
    required this.examples,
  });
}

/// Verbs Screen - displays German verbs with Examples button
class VerbsScreen extends StatefulWidget {
  const VerbsScreen({super.key});

  @override
  State<VerbsScreen> createState() => _VerbsScreenState();
}

class _VerbsScreenState extends State<VerbsScreen>
    with SingleTickerProviderStateMixin {
  final TtsService ttsService = Get.find<TtsService>();
  final LessonController lessonController = Get.find<LessonController>();
  final ThemeService themeService = Get.find<ThemeService>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Map<int, bool> _expandedExamples = {};
  List<VerbData> _verbs = [];
  bool _isLoading = true;

  int get _currentVerbIndex => lessonController.verbsIndex.value;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadVerbs();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadVerbs() async {
    final loadedVerbs = await DataLoader.loadVerbs();
    setState(() {
      _verbs = loadedVerbs;
      _isLoading = false;
    });
    // Ensure saved index is within bounds
    if (_verbs.isNotEmpty && _currentVerbIndex >= _verbs.length) {
      lessonController.updateVerbsIndex(0);
    }
    if (_verbs.isNotEmpty && _currentVerbIndex < _verbs.length) {
      _animationController.forward();
    }
  }

  void _toggleExamples(int index) {
    setState(() {
      _expandedExamples[index] = !(_expandedExamples[index] ?? false);
    });
  }

  void _nextVerb() {
    if (_verbs.isEmpty) return;
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    _animationController.reset();
    final newIndex = (_currentVerbIndex + 1) % _verbs.length;
    lessonController.updateVerbsIndex(newIndex);
    setState(() {});
    _animationController.forward();
  }

  void _previousVerb() {
    if (_verbs.isEmpty) return;
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    _animationController.reset();
    final newIndex = _currentVerbIndex - 1;
    lessonController.updateVerbsIndex(
      newIndex < 0 ? _verbs.length - 1 : newIndex,
    );
    setState(() {});
    _animationController.forward();
  }

  Future<void> _playCurrentVerb() async {
    final currentVerb = _verbs[_currentVerbIndex];
    await ttsService.speak(currentVerb.infinitive);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    if (_isLoading) {
      return Obx(() {
        final scheme = themeService.currentScheme;
        final isDark = themeService.isDarkMode.value;
        final backgroundColor = isDark
            ? scheme.backgroundDark
            : scheme.background;
        final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: Center(child: CircularProgressIndicator(color: textColor)),
        );
      });
    }

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return Scaffold(
        backgroundColor: backgroundColor,

        // appBar: AppBar(
        //   backgroundColor: backgroundColor,
        //   elevation: 0,
        //   // title: Hero(
        //   //   tag: 'verbs_title',
        //   //   child: Material(
        //   //     color: Colors.transparent,
        //   //     child: Text(
        //   //       'Verbs',
        //   //       style: themeService
        //   //           .getTitleLargeStyle(color: textColor)
        //   //           .copyWith(fontWeight: FontWeight.bold),
        //   //     ),
        //   //   ),
        //   // ),
        //   actions: [const TtsSpeedDropdown()],
        // ),
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
                child: Column(
                  children: [
                    // SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildVerbHeader(context, isSmallScreen, scheme, isDark),
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
      );
    });
  }

  Widget _buildVerbHeader(
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
            'German Verbs',
            style: themeService
                .getLabelSmallStyle(color: textColor.withOpacity(0.5))
                .copyWith(letterSpacing: 1.0),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              '${_currentVerbIndex + 1}/${_verbs.length}',
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
            TtsSpeedDropdown(),
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
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final currentVerb = _verbs[_currentVerbIndex];
    final isExamplesExpanded = _expandedExamples[_currentVerbIndex] ?? false;

    return FadeTransition(
      opacity: _fadeAnimation,
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
                                                colors: [
                                                  primaryColor,
                                                  secondaryColor,
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: isSmallScreen ? 4 : 6,
                                          ),
                                          Text(
                                            'VERB',
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
                              SizedBox(height: isSmallScreen ? 8 : 12),
                              // Main verb with Hero animation
                              Hero(
                                tag: 'verb_${currentVerb.infinitive}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [textColor, primaryColor],
                                    ).createShader(bounds),
                                    child: Text(
                                      currentVerb.infinitive,
                                      style: themeService
                                          .getTitleLargeStyle(
                                            color: Colors.white,
                                          )
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
                                          currentVerb.english,
                                          style: themeService.getBodyLargeStyle(
                                            color: textColor.withOpacity(0.9),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              primaryColor.withOpacity(0.2),
                                              secondaryColor.withOpacity(0.15),
                                            ],
                                          ),
                                          border: Border.all(
                                            color: primaryColor.withOpacity(
                                              0.3,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Obx(
                                          () => IconButton(
                                            onPressed: _playCurrentVerb,
                                            icon: Icon(
                                              ttsService.isTextPlaying(
                                                    currentVerb.infinitive,
                                                  )
                                                  ? Icons.volume_up
                                                  : Icons.volume_up_outlined,
                                              size: isSmallScreen ? 18 : 20,
                                              color:
                                                  ttsService.isTextPlaying(
                                                    currentVerb.infinitive,
                                                  )
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
                                  SizedBox(height: isSmallScreen ? 8 : 12),
                                  Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 10 : 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          surfaceColor.withOpacity(0.05),
                                          surfaceColor.withOpacity(0.02),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: primaryColor.withOpacity(0.15),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      currentVerb.conjugation,
                                      style: themeService.getBodyMediumStyle(
                                        color: textColor.withOpacity(0.7),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Examples button and expandable section
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            surfaceColor.withOpacity(0.05),
                            surfaceColor.withOpacity(0.02),
                          ],
                        ),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _toggleExamples(_currentVerbIndex),
                              borderRadius: BorderRadius.circular(16),
                              splashColor: primaryColor.withOpacity(0.2),
                              highlightColor: primaryColor.withOpacity(0.1),
                              child: Padding(
                                padding: EdgeInsets.all(
                                  isSmallScreen ? 14 : 16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Examples',
                                      style: themeService
                                          .getTitleSmallStyle(color: textColor)
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    TweenAnimationBuilder<double>(
                                      tween: Tween(
                                        begin: 0.0,
                                        end: isExamplesExpanded ? 1.0 : 0.0,
                                      ),
                                      duration:
                                          ThemeService.defaultAnimationDuration,
                                      curve: ThemeService.springCurve,
                                      builder: (context, rotateValue, child) {
                                        return Transform.rotate(
                                          angle: rotateValue * 3.14159,
                                          child: Icon(
                                            Icons.expand_more,
                                            color: primaryColor,
                                            size: isSmallScreen ? 24 : 28,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (isExamplesExpanded)
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: ThemeService.defaultAnimationDuration,
                              curve: ThemeService.springCurve,
                              builder: (context, expandValue, child) {
                                return Opacity(
                                  opacity: expandValue.clamp(0.0, 1.0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      isSmallScreen ? 14 : 16,
                                      0,
                                      isSmallScreen ? 14 : 16,
                                      isSmallScreen ? 14 : 16,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: currentVerb.examples.asMap().entries.map((
                                        entry,
                                      ) {
                                        final index = entry.key;
                                        final example = entry.value;
                                        return TweenAnimationBuilder<double>(
                                          tween: Tween(begin: 0.0, end: 1.0),
                                          duration: Duration(
                                            milliseconds: 200 + (index * 50),
                                          ),
                                          builder: (context, itemValue, child) {
                                            return Transform.translate(
                                              offset: Offset(
                                                10 * (1 - itemValue),
                                                0,
                                              ),
                                              child: Opacity(
                                                opacity: itemValue.clamp(
                                                  0.0,
                                                  1.0,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: isSmallScreen
                                                        ? 10
                                                        : 12,
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 6,
                                                        height: 6,
                                                        margin: EdgeInsets.only(
                                                          top: 6,
                                                          right: 12,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          gradient:
                                                              LinearGradient(
                                                                colors: [
                                                                  primaryColor,
                                                                  secondaryColor,
                                                                ],
                                                              ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          example,
                                                          style: themeService
                                                              .getBodyMediumStyle(
                                                                color: textColor
                                                                    .withOpacity(
                                                                      0.8,
                                                                    ),
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    // Animated Progress bar
                    TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0.0,
                        end: _verbs.isEmpty
                            ? 0.0
                            : ((_currentVerbIndex + 1) / _verbs.length).clamp(
                                0.0,
                                1.0,
                              ),
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
                            widthFactor: progressValue.clamp(0.0, 1.0),
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
      ),
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
    final currentVerb = _verbs[_currentVerbIndex];

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
                    onPressed: _previousVerb,
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
                child: Obx(() {
                  final isPlaying = ttsService.isTextPlaying(
                    currentVerb.infinitive,
                  );
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
                              width:
                                  (isSmallScreen ? 64 : 76) + (pulseValue * 16),
                              height:
                                  (isSmallScreen ? 64 : 76) + (pulseValue * 16),
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
                              onPressed: _playCurrentVerb,
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
                                    colors: [primaryColor, scheme.accentTeal],
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
                }),
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
                    onPressed: _nextVerb,
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
