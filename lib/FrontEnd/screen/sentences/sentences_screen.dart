import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Sentence model
class SentenceData {
  final String german;
  final String english;
  final String? meaning;

  SentenceData({required this.german, required this.english, this.meaning});
}

/// Sentences Screen - displays German sentences with TTS
/// Uses the same card design as learn.dart
class SentencesScreen extends StatefulWidget {
  const SentencesScreen({super.key});

  @override
  State<SentencesScreen> createState() => _SentencesScreenState();
}

class _SentencesScreenState extends State<SentencesScreen>
    with SingleTickerProviderStateMixin {
  final TtsService ttsService = Get.find<TtsService>();
  final LessonController lessonController = Get.find<LessonController>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<SentenceData> _sentences = [];
  bool _isLoading = true;

  int get _currentSentenceIndex => lessonController.sentencesIndex.value;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadSentences();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadSentences() async {
    final loadedSentences = await DataLoader.loadSentences();
    setState(() {
      _sentences = loadedSentences;
      _isLoading = false;
    });
    if (_sentences.isNotEmpty && _currentSentenceIndex < _sentences.length) {
      _animationController.forward();
    }
  }

  void _nextSentence() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    _animationController.reset();
    final newIndex = (_currentSentenceIndex + 1) % _sentences.length;
    lessonController.updateSentencesIndex(newIndex);
    _animationController.forward();
  }

  void _previousSentence() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    _animationController.reset();
    final newIndex = _currentSentenceIndex - 1;
    lessonController.updateSentencesIndex(
      newIndex < 0 ? _sentences.length - 1 : newIndex,
    );
    _animationController.forward();
  }

  Future<void> _playCurrentSentence() async {
    final currentSentence = _sentences[_currentSentenceIndex];
    await ttsService.speak(currentSentence.german);
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
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

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: false,
          title: const Text(
            'Sentences',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [const TtsSpeedDropdown()],
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
                child: Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    _buildTopBar(context, isSmallScreen, scheme, isDark),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildSentenceHeader(
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
    final borderColor = isDark
        ? scheme.textPrimaryDark.withOpacity(0.1)
        : scheme.textPrimary.withOpacity(0.1);

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: borderColor),
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.chevron_left,
              color: textColor.withOpacity(0.7),
              size: isSmallScreen ? 20 : 22,
            ),
            tooltip: 'Back',
            padding: isSmallScreen ? const EdgeInsets.all(6) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSentenceHeader(
    BuildContext context,
    bool isSmallScreen,
    scheme,
    bool isDark,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Small Sentences',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    color: textColor.withOpacity(0.5),
                    letterSpacing: 1.0,
                    fontFamily: Theme.of(
                      context,
                    ).textTheme.bodySmall?.fontFamily,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Row(
          children: [
            Text(
              '${_currentSentenceIndex + 1}/${_sentences.length}',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 11,
                color: textColor.withOpacity(0.6),
                fontFamily: Theme.of(context).textTheme.bodySmall?.fontFamily,
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
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final currentSentence = _sentences[_currentSentenceIndex];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
          border: Border.all(color: textColor.withOpacity(0.1)),
          color: surfaceColor.withOpacity(0.02),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with tag
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 3 : 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: textColor.withOpacity(0.1)),
                          color: surfaceColor.withOpacity(0.05),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: isSmallScreen ? 5 : 6,
                              height: isSmallScreen ? 5 : 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 3 : 4),
                            Text(
                              'SENTENCE',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 10 : 11,
                                color: textColor.withOpacity(0.7),
                                fontFamily: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Text(
                        currentSentence.german,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          height: 1.2,
                          fontFamily: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Wrap(
              spacing: isSmallScreen ? 6 : 8,
              runSpacing: isSmallScreen ? 4 : 6,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 4 : 6,
                    vertical: isSmallScreen ? 1 : 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    color: surfaceColor.withOpacity(0.05),
                  ),
                  child: Text(
                    'DE',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10 : 11,
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                color: surfaceColor.withOpacity(0.03),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          currentSentence.english,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 15,
                            color: textColor.withOpacity(0.9),
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontFamily,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 6 : 8,
                          ),
                          border: Border.all(color: textColor.withOpacity(0.1)),
                        ),
                        child: IconButton(
                          onPressed: _playCurrentSentence,
                          icon: Icon(
                            ttsService.isTextPlaying(currentSentence.german)
                                ? Icons.volume_up
                                : Icons.volume_up_outlined,
                            size: isSmallScreen ? 16 : 18,
                            color:
                                ttsService.isTextPlaying(currentSentence.german)
                                ? primaryColor
                                : textColor.withOpacity(0.8),
                          ),
                          padding: isSmallScreen
                              ? const EdgeInsets.all(4)
                              : null,
                        ),
                      ),
                    ],
                  ),
                  if (currentSentence.meaning != null) ...[
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      currentSentence.meaning!,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 13,
                        color: textColor.withOpacity(0.6),
                        fontFamily: Theme.of(
                          context,
                        ).textTheme.bodySmall?.fontFamily,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Container(
              height: isSmallScreen ? 4 : 6,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: surfaceColor.withOpacity(0.05),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (_currentSentenceIndex + 1) / _sentences.length,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ],
        ),
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
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
    final currentSentence = _sentences[_currentSentenceIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: surfaceColor.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _previousSentence,
              icon: Icon(
                Icons.chevron_left,
                size: isSmallScreen ? 28 : 32,
                color: textColor.withOpacity(0.9),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            ),
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 20 : 24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  color: surfaceColor.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: textColor.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _playCurrentSentence,
                  icon: Icon(
                    ttsService.isTextPlaying(currentSentence.german)
                        ? Icons.stop
                        : Icons.volume_up,
                    size: isSmallScreen ? 36 : 42,
                    color: textColor,
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                ),
              ),
              if (ttsService.isTextPlaying(currentSentence.german))
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: isSmallScreen ? 10 : 12,
                    height: isSmallScreen ? 10 : 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: surfaceColor.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _nextSentence,
              icon: Icon(
                Icons.chevron_right,
                size: isSmallScreen ? 28 : 32,
                color: textColor.withOpacity(0.9),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            ),
          ),
        ],
      ),
    );
  }
}
