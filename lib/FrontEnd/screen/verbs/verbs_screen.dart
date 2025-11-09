import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:ductuch_master/Utilities/Services/tts_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
/// Uses the same card design as learn.dart
class VerbsScreen extends StatefulWidget {
  const VerbsScreen({super.key});

  @override
  State<VerbsScreen> createState() => _VerbsScreenState();
}

class _VerbsScreenState extends State<VerbsScreen> {
  final ThemeService themeService = Get.find<ThemeService>();
  final TtsService ttsService = Get.find<TtsService>();
  int _currentVerbIndex = 0;
  Map<int, bool> _expandedExamples = {};

  // Sample verbs - in production, load from data source
  final List<VerbData> _verbs = [
    VerbData(
      infinitive: 'sein',
      english: 'to be',
      conjugation: 'ich bin, du bist, er/sie/es ist',
      examples: [
        'Ich bin müde. (I am tired.)',
        'Du bist hier. (You are here.)',
        'Er ist ein Lehrer. (He is a teacher.)',
        'Wir sind Freunde. (We are friends.)',
        'Sie sind glücklich. (They are happy.)',
      ],
    ),
    VerbData(
      infinitive: 'haben',
      english: 'to have',
      conjugation: 'ich habe, du hast, er/sie/es hat',
      examples: [
        'Ich habe ein Auto. (I have a car.)',
        'Du hast Zeit. (You have time.)',
        'Er hat Hunger. (He is hungry.)',
        'Wir haben Spaß. (We have fun.)',
        'Sie haben Recht. (They are right.)',
      ],
    ),
    VerbData(
      infinitive: 'gehen',
      english: 'to go',
      conjugation: 'ich gehe, du gehst, er/sie/es geht',
      examples: [
        'Ich gehe zur Schule. (I go to school.)',
        'Du gehst nach Hause. (You go home.)',
        'Er geht ins Kino. (He goes to the cinema.)',
        'Wir gehen spazieren. (We go for a walk.)',
        'Sie gehen einkaufen. (They go shopping.)',
      ],
    ),
    VerbData(
      infinitive: 'kommen',
      english: 'to come',
      conjugation: 'ich komme, du kommst, er/sie/es kommt',
      examples: [
        'Ich komme aus Deutschland. (I come from Germany.)',
        'Du kommst zu spät. (You come too late.)',
        'Er kommt heute. (He comes today.)',
        'Wir kommen morgen. (We come tomorrow.)',
        'Sie kommen zusammen. (They come together.)',
      ],
    ),
    VerbData(
      infinitive: 'machen',
      english: 'to make/do',
      conjugation: 'ich mache, du machst, er/sie/es macht',
      examples: [
        'Ich mache Hausaufgaben. (I do homework.)',
        'Du machst einen Fehler. (You make a mistake.)',
        'Er macht Sport. (He does sports.)',
        'Wir machen eine Pause. (We take a break.)',
        'Sie machen Musik. (They make music.)',
      ],
    ),
    VerbData(
      infinitive: 'sagen',
      english: 'to say',
      conjugation: 'ich sage, du sagst, er/sie/es sagt',
      examples: [
        'Ich sage die Wahrheit. (I tell the truth.)',
        'Du sagst nichts. (You say nothing.)',
        'Er sagt "Hallo". (He says "Hello".)',
        'Wir sagen "Danke". (We say "Thank you".)',
        'Sie sagen immer "Ja". (They always say "Yes".)',
      ],
    ),
  ];

  void _toggleExamples(int index) {
    setState(() {
      _expandedExamples[index] = !(_expandedExamples[index] ?? false);
    });
  }

  void _nextVerb() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentVerbIndex = (_currentVerbIndex + 1) % _verbs.length;
    });
  }

  void _previousVerb() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentVerbIndex = (_currentVerbIndex - 1) % _verbs.length;
      if (_currentVerbIndex < 0) {
        _currentVerbIndex = _verbs.length - 1;
      }
    });
  }

  Future<void> _playCurrentVerb() async {
    final currentVerb = _verbs[_currentVerbIndex];
    await ttsService.speak(currentVerb.infinitive);
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
            'Verbs',
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
                    _buildVerbHeader(isSmallScreen),
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

  Widget _buildVerbHeader(bool isSmallScreen) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'German Verbs',
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
              '${_currentVerbIndex + 1}/${_verbs.length}',
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
    final currentVerb = _verbs[_currentVerbIndex];
    final isExamplesExpanded = _expandedExamples[_currentVerbIndex] ?? false;

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
                            'VERB',
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
                      currentVerb.infinitive,
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
                        currentVerb.english,
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
                        onPressed: _playCurrentVerb,
                        icon: Icon(
                          ttsService.isTextPlaying(currentVerb.infinitive)
                              ? Icons.volume_up
                              : Icons.volume_up_outlined,
                          size: isSmallScreen ? 16 : 18,
                          color: ttsService.isTextPlaying(currentVerb.infinitive)
                              ? const Color(0xFF10B981)
                              : Colors.white.withOpacity(0.8),
                        ),
                        padding: isSmallScreen ? const EdgeInsets.all(4) : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white.withOpacity(0.02),
                  ),
                  child: Text(
                    currentVerb.conjugation,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      color: Colors.white.withOpacity(0.7),
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          // Examples button and expandable section
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.03),
            ),
            child: Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _toggleExamples(_currentVerbIndex),
                    borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Examples',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: GoogleFonts.patrickHand().fontFamily,
                            ),
                          ),
                          Icon(
                            isExamplesExpanded
                                ? Icons.expand_less
                                : Icons.expand_more,
                            color: Colors.white.withOpacity(0.7),
                            size: isSmallScreen ? 20 : 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (isExamplesExpanded)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isSmallScreen ? 12 : 16,
                      0,
                      isSmallScreen ? 12 : 16,
                      isSmallScreen ? 12 : 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: currentVerb.examples.map((example) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
                          child: Text(
                            example,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 13 : 14,
                              color: Colors.white.withOpacity(0.8),
                              fontFamily: GoogleFonts.patrickHand().fontFamily,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
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
              widthFactor: (_currentVerbIndex + 1) / _verbs.length,
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
    final currentVerb = _verbs[_currentVerbIndex];

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
              onPressed: _previousVerb,
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
                  onPressed: _playCurrentVerb,
                  icon: Icon(
                    ttsService.isTextPlaying(currentVerb.infinitive)
                        ? Icons.stop
                        : Icons.volume_up,
                    size: isSmallScreen ? 36 : 42,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                ),
              ),
              if (ttsService.isTextPlaying(currentVerb.infinitive))
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
              onPressed: _nextVerb,
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
