import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Category word model
class CategoryWord {
  final String german;
  final String english;
  final String? meaning;

  CategoryWord({
    required this.german,
    required this.english,
    this.meaning,
  });
}

/// Category Screen - displays words from a specific category
/// Uses the same card design as learn.dart
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

class _CategoryScreenState extends State<CategoryScreen> {
  final ThemeService themeService = Get.find<ThemeService>();
  final TtsService ttsService = Get.find<TtsService>();
  int _currentWordIndex = 0;

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

      return Scaffold(
        backgroundColor: const Color(0xFF0B0F14),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0F14),
          title: Text(
            widget.categoryName,
            style: TextStyle(
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: screenWidth > 600 ? 24 : 20,
            ),
          ),
          actions: [
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
                child: Column(
                  children: [
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    _buildTopBar(isSmallScreen),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildCategoryHeader(isSmallScreen),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildMainCard(isSmallScreen),
                            SizedBox(height: isSmallScreen ? 20 : 24),
                            _buildExternalNavigationControls(isSmallScreen),
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

  Widget _buildTopBar(bool isSmallScreen) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.chevron_left,
              color: Colors.white70,
              size: isSmallScreen ? 20 : 22,
            ),
            tooltip: 'Back',
            padding: isSmallScreen ? const EdgeInsets.all(6) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHeader(bool isSmallScreen) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  widget.categoryName,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 1.0,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
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
              '${_currentWordIndex + 1}/${widget.words.length}',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 11,
                color: Colors.white.withOpacity(0.6),
                fontFamily: GoogleFonts.patrickHand().fontFamily,
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
                        ? Colors.white.withOpacity(0.7)
                        : index < 2
                            ? Colors.white.withOpacity(0.3)
                            : Colors.white.withOpacity(0.15),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainCard(bool isSmallScreen) {
    final currentWord = widget.words[_currentWordIndex];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: Colors.white.withOpacity(0.02),
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
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                        color: Colors.white.withOpacity(0.05),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: isSmallScreen ? 5 : 6,
                            height: isSmallScreen ? 5 : 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 3 : 4),
                          Text(
                            widget.categoryName.toUpperCase(),
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 11,
                              color: Colors.white.withOpacity(0.7),
                              fontFamily: GoogleFonts.patrickHand().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    Text(
                      currentWord.german,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                        fontFamily: GoogleFonts.patrickHand().fontFamily,
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
                  color: Colors.white.withOpacity(0.05),
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
              color: Colors.white.withOpacity(0.03),
            ),
            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        currentWord.english,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 15,
                          color: Colors.white.withOpacity(0.9),
                          fontFamily: GoogleFonts.patrickHand().fontFamily,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 6 : 8,
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      child: IconButton(
                        onPressed: _playCurrentWord,
                        icon: Icon(
                          ttsService.isTextPlaying(currentWord.german)
                              ? Icons.volume_up
                              : Icons.volume_up_outlined,
                          size: isSmallScreen ? 16 : 18,
                          color: ttsService.isTextPlaying(currentWord.german)
                              ? const Color(0xFF10B981)
                              : Colors.white.withOpacity(0.8),
                        ),
                        padding: isSmallScreen ? const EdgeInsets.all(4) : null,
                      ),
                    ),
                  ],
                ),
                if (currentWord.meaning != null) ...[
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    currentWord.meaning!,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: Colors.white.withOpacity(0.6),
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
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
              color: Colors.white.withOpacity(0.05),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentWordIndex + 1) / widget.words.length,
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
    );
  }

  Widget _buildExternalNavigationControls(bool isSmallScreen) {
    final currentWord = widget.words[_currentWordIndex];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _previousWord,
              icon: Icon(
                Icons.chevron_left,
                size: isSmallScreen ? 28 : 32,
                color: Colors.white.withOpacity(0.9),
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
                  color: Colors.white.withOpacity(0.05),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: _playCurrentWord,
                  icon: Icon(
                    ttsService.isTextPlaying(currentWord.german)
                        ? Icons.stop
                        : Icons.volume_up,
                    size: isSmallScreen ? 36 : 42,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                ),
              ),
              if (ttsService.isTextPlaying(currentWord.german))
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
              color: Colors.white.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _nextWord,
              icon: Icon(
                Icons.chevron_right,
                size: isSmallScreen ? 28 : 32,
                color: Colors.white.withOpacity(0.9),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            ),
          ),
        ],
      ),
    );
  }
}

