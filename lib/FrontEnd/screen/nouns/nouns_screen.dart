import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Noun model with singular and plural forms
class NounData {
  final String singular; // e.g., "Der Hund"
  final String plural; // e.g., "Die Hunde"
  final String english;
  final String? meaning;

  NounData({
    required this.singular,
    required this.plural,
    required this.english,
    this.meaning,
  });
}

/// Nouns Screen - displays German nouns with singular and plural forms
/// Uses the same card design as learn.dart
class NounsScreen extends StatefulWidget {
  const NounsScreen({super.key});

  @override
  State<NounsScreen> createState() => _NounsScreenState();
}

class _NounsScreenState extends State<NounsScreen> {
  final TtsService ttsService = Get.find<TtsService>();
  int _currentNounIndex = 0;
  List<NounData> _nouns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNouns();
  }

  Future<void> _loadNouns() async {
    final loadedNouns = await DataLoader.loadNouns();
    setState(() {
      _nouns = loadedNouns;
      _isLoading = false;
    });
  }


  void _nextNoun() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentNounIndex = (_currentNounIndex + 1) % _nouns.length;
    });
  }

  void _previousNoun() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentNounIndex = (_currentNounIndex - 1) % _nouns.length;
      if (_currentNounIndex < 0) {
        _currentNounIndex = _nouns.length - 1;
      }
    });
  }

  Future<void> _playSingular() async {
    final currentNoun = _nouns[_currentNounIndex];
    await ttsService.speak(currentNoun.singular);
  }

  Future<void> _playPlural() async {
    final currentNoun = _nouns[_currentNounIndex];
    await ttsService.speak(currentNoun.plural);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B0F14),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
        backgroundColor: const Color(0xFF0B0F14),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0F14),
          centerTitle: false,
          title: const Text(
            'Nouns',
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            const TtsSpeedDropdown(),
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
                    _buildNounHeader(isSmallScreen),
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

  Widget _buildNounHeader(bool isSmallScreen) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'German Nouns',
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
              '${_currentNounIndex + 1}/${_nouns.length}',
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
    final currentNoun = _nouns[_currentNounIndex];

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
                            'NOUN',
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
                    // Singular form
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            currentNoun.singular,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 20 : 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              height: 1.2,
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
                            onPressed: _playSingular,
                            icon: Icon(
                              ttsService.isTextPlaying(currentNoun.singular)
                                  ? Icons.volume_up
                                  : Icons.volume_up_outlined,
                              size: isSmallScreen ? 16 : 18,
                              color: ttsService.isTextPlaying(currentNoun.singular)
                                  ? const Color(0xFF10B981)
                                  : Colors.white.withOpacity(0.8),
                            ),
                            padding: isSmallScreen ? const EdgeInsets.all(4) : null,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 8 : 12),
                    // Plural form
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            currentNoun.plural,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.2,
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
                            onPressed: _playPlural,
                            icon: Icon(
                              ttsService.isTextPlaying(currentNoun.plural)
                                  ? Icons.volume_up
                                  : Icons.volume_up_outlined,
                              size: isSmallScreen ? 16 : 18,
                              color: ttsService.isTextPlaying(currentNoun.plural)
                                  ? const Color(0xFF10B981)
                                  : Colors.white.withOpacity(0.8),
                            ),
                            padding: isSmallScreen ? const EdgeInsets.all(4) : null,
                          ),
                        ),
                      ],
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
                Text(
                  currentNoun.english,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 15,
                    color: Colors.white.withOpacity(0.9),
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                if (currentNoun.meaning != null) ...[
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    currentNoun.meaning!,
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
              widthFactor: (_currentNounIndex + 1) / _nouns.length,
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
    final currentNoun = _nouns[_currentNounIndex];

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
              onPressed: _previousNoun,
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
                  onPressed: _playSingular,
                  icon: Icon(
                    ttsService.isTextPlaying(currentNoun.singular)
                        ? Icons.stop
                        : Icons.volume_up,
                    size: isSmallScreen ? 36 : 42,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                ),
              ),
              if (ttsService.isTextPlaying(currentNoun.singular))
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
              onPressed: _nextNoun,
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
