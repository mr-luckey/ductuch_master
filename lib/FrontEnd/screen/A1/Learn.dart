import 'package:ductuch_master/Data/lesson_content_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PhraseData {
  final String phrase;
  // final String ipa;
  final String translation;
  final String meaning;
  final String languageCode;
  final String level;
  final bool isFavorite;

  PhraseData({
    required this.phrase,
    // required this.ipa,
    required this.translation,
    required this.meaning,
    required this.languageCode,
    required this.level,
    this.isFavorite = false,
  });

  PhraseData copyWith({
    String? phrase,
    String? ipa,
    String? translation,
    String? meaning,
    String? languageCode,
    String? level,
    bool? isFavorite,
  }) {
    return PhraseData(
      phrase: phrase ?? this.phrase,
      // ipa: ipa ?? this.ipa,
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
  double _currentRate = 1.0;
  bool _repeatOn = false;
  bool _isPlaying = false;
  late FlutterTts _flutterTts;
  late List<PhraseData> _phrases;

  @override
  void initState() {
    super.initState();
    // Get topic ID from widget or route arguments
    final topicId =
        widget.topicId ??
        (Get.arguments is Map ? Get.arguments['topicId'] : null) ??
        'A1-M1-T1';

    // Load phrases from JSON repository (fallback to in-code data)
    _phrases = LessonContentData.getByTopicId(topicId) ??
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

    _initTTS();
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
      }
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        _isPlaying = false;
      });
      print("TTS Error: $msg");
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
    if (_isPlaying) {
      _flutterTts.stop();
    }
    setState(() {
      _currentPhraseIndex = (_currentPhraseIndex + 1) % _phrases.length;
      _isPlaying = false;
    });
  }

  void _previousPhrase() {
    if (_isPlaying) {
      _flutterTts.stop();
    }
    setState(() {
      _currentPhraseIndex = (_currentPhraseIndex - 1) % _phrases.length;
      if (_currentPhraseIndex < 0) {
        _currentPhraseIndex = _phrases.length - 1;
      }
      _isPlaying = false;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
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
                  // Status spacer
                  SizedBox(height: isSmallScreen ? 4 : 6),

                  // Top bar
                  _buildTopBar(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 12 : 16),

                  // Lesson header
                  _buildLessonHeader(isSmallScreen),

                  SizedBox(height: isSmallScreen ? 12 : 16),

                  // Main card
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildMainCard(currentPhrase, isSmallScreen),
                          SizedBox(height: isSmallScreen ? 20 : 24),

                          // External Navigation Controls
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

      // Bottom navigation
      // bottomNavigationBar: _buildBottomNav(isSmallScreen),
    );
  }

  Widget _buildTopBar(bool isSmallScreen) {
    return Row(
      children: [
        // Back button
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

        // User avatar
      ],
    );
  }

  Widget _buildLessonHeader(bool isSmallScreen) {
    return Row(
      children: [
        // Lesson info
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  _topicTitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    color: Colors.white.withOpacity(0.5),
                    letterSpacing: 1.0,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: isSmallScreen ? 2 : 4),
              Text(
                '•',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.2),
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
              SizedBox(width: isSmallScreen ? 2 : 4),
              // Flexible(
              //   child: Text(
              //     'Listening Practice',
              //     style: TextStyle(
              //       fontSize: isSmallScreen ? 10 : 11,
              //       color: Colors.white.withOpacity(0.6, fontFamily: GoogleFonts.patrickHand().fontFamily),
              //     ),
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
            ],
          ),
        ),

        const Spacer(),

        // Progress
        Row(
          children: [
            Text(
              '${_currentPhraseIndex + 1}/${_phrases.length}',
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 11,
                color: Colors.white.withOpacity(0.6),
                fontFamily: GoogleFonts.patrickHand().fontFamily,
              ),
            ),
            SizedBox(width: isSmallScreen ? 6 : 8),

            // Progress dots
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

  Widget _buildMainCard(PhraseData phrase, bool isSmallScreen) {
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
          // Header with tag and favorite
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily phrase tag
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
                            'Daily Phrase',
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
                    // Main phrase
                    Text(
                      phrase.phrase,
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

              // Favorite button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: IconButton(
                  onPressed: _toggleFavorite,
                  icon: Icon(
                    phrase.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: phrase.isFavorite
                        ? const Color(0xFFF43F5E)
                        : Colors.white70,
                    size: isSmallScreen ? 20 : 22,
                  ),
                  padding: isSmallScreen ? const EdgeInsets.all(6) : null,
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 6 : 8),

          // IPA and language tags
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
                  phrase.level,
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

          // Translation card
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
                        phrase.translation,
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
                        onPressed: () =>
                            _playPhrase(phrase.translation, 'en-US'),
                        icon: Icon(
                          Icons.volume_up,
                          size: isSmallScreen ? 16 : 18,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        padding: isSmallScreen ? const EdgeInsets.all(4) : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  phrase.meaning,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 13,
                    color: Colors.white.withOpacity(0.6),
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 16),

          // Play controls (only rate controls and repeat, no navigation)
          _buildRateControls(isSmallScreen),

          SizedBox(height: isSmallScreen ? 12 : 16),

          // Progress bar
          Container(
            height: isSmallScreen ? 4 : 6,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white.withOpacity(0.05),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: (_currentPhraseIndex + 1) / _phrases.length,
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

  Widget _buildRateControls(bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRateButton(0.8, isSmallScreen),
        SizedBox(width: isSmallScreen ? 8 : 12),
        _buildRateButton(1.0, isSmallScreen),
        SizedBox(width: isSmallScreen ? 8 : 12),
        _buildRepeatButton(isSmallScreen),
      ],
    );
  }

  Widget _buildExternalNavigationControls(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _previousPhrase,
              icon: Icon(
                Icons.chevron_left,
                size: isSmallScreen ? 28 : 32,
                color: Colors.white.withOpacity(0.9),
              ),
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            ),
          ),

          // Main play button
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
                  onPressed: _playCurrentPhrase,
                  icon: Icon(
                    _isPlaying ? Icons.stop : Icons.volume_up,
                    size: isSmallScreen ? 36 : 42,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                ),
              ),
              if (_isPlaying)
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

          // Next button
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _nextPhrase,
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

  Widget _buildRateButton(double rate, bool isSmallScreen) {
    final isSelected = _currentRate == rate;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: isSelected
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.03),
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
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                fontFamily: GoogleFonts.patrickHand().fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRepeatButton(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: _repeatOn
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.03),
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
                  color: _repeatOn
                      ? Colors.white
                      : Colors.white.withOpacity(0.8),
                ),
                SizedBox(width: isSmallScreen ? 4 : 6),
                Text(
                  'Repeat',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    color: _repeatOn
                        ? Colors.white
                        : Colors.white.withOpacity(0.7),
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        color: const Color(0xFF0B0F14).withOpacity(0.9),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _buildNavItem(Icons.home, 'Home', isSmallScreen, isActive: true),
            _buildNavItem(Icons.headphones, 'Listen', isSmallScreen),
            _buildNavItem(Icons.menu_book, 'Review', isSmallScreen),
            _buildNavItem(Icons.person, 'Profile', isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSmallScreen, {
    bool isActive = false,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 8 : 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: isSmallScreen ? 18 : 20,
                  color: isActive ? Colors.white : Colors.white70,
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 11,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.white70,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
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
