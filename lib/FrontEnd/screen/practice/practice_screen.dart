import 'package:ductuch_master/Utilities/Services/tts_service.dart';
import 'package:ductuch_master/Utilities/Widgets/tts_speed_dropdown.dart';
import 'package:ductuch_master/Data/data_loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// Practice item model
class PracticeItem {
  final String german;
  final String english;
  final String? meaning;
  final String type; // 'verb', 'noun', 'sentence', etc.
  final List<String>? examples; // For verbs

  PracticeItem({
    required this.german,
    required this.english,
    this.meaning,
    required this.type,
    this.examples,
  });
}

/// Practice Screen - allows users to practice questions without time limits
/// Uses the same card design as learn.dart
class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final TtsService ttsService = Get.find<TtsService>();
  int _currentItemIndex = 0;
  Map<int, bool> _expandedExamples = {};
  List<PracticeItem> _practiceItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPracticeItems();
  }

  Future<void> _loadPracticeItems() async {
    final loadedItems = await DataLoader.loadPracticeItems();
    setState(() {
      _practiceItems = loadedItems;
      _isLoading = false;
    });
  }


  void _toggleExamples(int index) {
    setState(() {
      _expandedExamples[index] = !(_expandedExamples[index] ?? false);
    });
  }

  void _nextItem() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentItemIndex = (_currentItemIndex + 1) % _practiceItems.length;
    });
  }

  void _previousItem() {
    if (ttsService.isPlaying) {
      ttsService.stop();
    }
    setState(() {
      _currentItemIndex = (_currentItemIndex - 1) % _practiceItems.length;
      if (_currentItemIndex < 0) {
        _currentItemIndex = _practiceItems.length - 1;
      }
    });
  }

  Future<void> _playCurrentItem() async {
    final currentItem = _practiceItems[_currentItemIndex];
    await ttsService.speak(currentItem.german);
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
          title: Text(
            'Practice',
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
                    _buildPracticeHeader(isSmallScreen),
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
        // Back button (if needed)
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

  Widget _buildPracticeHeader(bool isSmallScreen) {
    return Row(
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Practice Mode',
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
              '${_currentItemIndex + 1}/${_practiceItems.length}',
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
    final currentItem = _practiceItems[_currentItemIndex];
    final isVerb = currentItem.type == 'verb';
    final isExamplesExpanded = _expandedExamples[_currentItemIndex] ?? false;

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
                            currentItem.type.toUpperCase(),
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
                      currentItem.german,
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
                        currentItem.english,
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
                      child: Obx(() => IconButton(
                        onPressed: _playCurrentItem,
                        icon: Icon(
                          ttsService.isTextPlaying(currentItem.german)
                              ? Icons.volume_up
                              : Icons.volume_up_outlined,
                          size: isSmallScreen ? 16 : 18,
                          color: ttsService.isTextPlaying(currentItem.german)
                              ? const Color(0xFF10B981)
                              : Colors.white.withOpacity(0.8),
                        ),
                        padding: isSmallScreen ? const EdgeInsets.all(4) : null,
                      )),
                    ),
                  ],
                ),
                if (currentItem.meaning != null) ...[
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    currentItem.meaning!,
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
          if (isVerb && currentItem.examples != null) ...[
            SizedBox(height: isSmallScreen ? 12 : 16),
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
                      onTap: () => _toggleExamples(_currentItemIndex),
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
                        children: currentItem.examples!.map((example) {
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
          ],
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
              widthFactor: (_currentItemIndex + 1) / _practiceItems.length,
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
              onPressed: _previousItem,
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
                child: Obx(() => IconButton(
                  onPressed: _playCurrentItem,
                  icon: Icon(
                    ttsService.isTextPlaying(_practiceItems[_currentItemIndex].german)
                        ? Icons.stop
                        : Icons.volume_up,
                    size: isSmallScreen ? 36 : 42,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                )),
              ),
              Obx(() => ttsService.isTextPlaying(_practiceItems[_currentItemIndex].german)
                  ? Positioned(
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
                    )
                  : const SizedBox.shrink()),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              color: Colors.white.withOpacity(0.05),
            ),
            child: IconButton(
              onPressed: _nextItem,
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

