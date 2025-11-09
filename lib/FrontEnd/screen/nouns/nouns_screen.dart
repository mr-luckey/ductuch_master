import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NounsScreen extends StatefulWidget {
  const NounsScreen({super.key});

  @override
  State<NounsScreen> createState() => _NounsScreenState();
}

class _NounsScreenState extends State<NounsScreen> {
  FlutterTts flutterTts = FlutterTts();
  bool _isPlaying = false;
  String? _currentPlayingText;

  @override
  void initState() {
    super.initState();
    _initTTS();
  }

  Future<void> _initTTS() async {
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.setLanguage('de-DE');
    
    flutterTts.setCompletionHandler(() {
      setState(() {
        _isPlaying = false;
        _currentPlayingText = null;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        _isPlaying = false;
        _currentPlayingText = null;
      });
    });
  }

  Future<void> _speak(String text) async {
    if (_isPlaying && _currentPlayingText == text) {
      await flutterTts.stop();
      setState(() {
        _isPlaying = false;
        _currentPlayingText = null;
      });
      return;
    }

    setState(() {
      _isPlaying = true;
      _currentPlayingText = text;
    });

    try {
      await flutterTts.speak(text);
    } catch (e) {
      setState(() {
        _isPlaying = false;
        _currentPlayingText = null;
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 16.0;
    final titleSize = isTablet ? 36.0 : 28.0;
    final subtitleSize = isTablet ? 18.0 : 16.0;

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

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Nouns',
            style: TextStyle(
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: isTablet ? 24 : 20,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: textColor,
              ),
              onPressed: () => themeService.toggleDarkMode(),
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.palette, color: textColor),
              onSelected: (value) {
                final index = int.parse(value);
                themeService.changeScheme(index);
              },
              itemBuilder: (context) => ThemeService.colorSchemes
                  .asMap()
                  .entries
                  .map(
                    (entry) => PopupMenuItem(
                      value: entry.key.toString(),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: entry.value.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(entry.value.name),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(padding),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isTablet ? 800 : double.infinity,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'German Nouns',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Learn essential German nouns with their articles',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: secondaryTextColor,
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                  SizedBox(height: 24),
                _buildNounCard(
                  context,
                  'der Mann',
                  'the man',
                  'masculine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  context,
                  'die Frau',
                  'the woman',
                  'feminine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  context,
                  'das Kind',
                  'the child',
                  'neuter',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  context,
                  'der Tisch',
                  'the table',
                  'masculine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  context,
                  'die Tür',
                  'the door',
                  'feminine',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildNounCard(
                  context,
                  'das Buch',
                  'the book',
                  'neuter',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNounCard(
    BuildContext context,
    String german,
    String english,
    String gender,
    scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 20.0;
    final iconSize = isTablet ? 60.0 : 50.0;
    final titleSize = isTablet ? 24.0 : 20.0;
    final subtitleSize = isTablet ? 16.0 : 14.0;

    Color genderColor;
    switch (gender) {
      case 'masculine':
        genderColor = Colors.blue;
        break;
      case 'feminine':
        genderColor = Colors.pink;
        break;
      case 'neuter':
        genderColor = Colors.green;
        break;
      default:
        genderColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: isDark
            ? scheme.surfaceDark.withOpacity(0.5)
            : scheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? scheme.primaryDark.withOpacity(0.2)
              : scheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: genderColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                gender[0].toUpperCase(),
                style: TextStyle(
                  color: genderColor,
                  fontWeight: FontWeight.bold,
                  fontSize: titleSize * 0.8,
                ),
              ),
            ),
          ),
          SizedBox(width: isTablet ? 20 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  german,
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  english,
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: secondaryTextColor,
                    fontFamily: GoogleFonts.patrickHand().fontFamily,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              _isPlaying && _currentPlayingText == german
                  ? Icons.volume_up
                  : Icons.volume_down,
              color: _isPlaying && _currentPlayingText == german
                  ? (isDark ? scheme.primaryDark : scheme.primary)
                  : secondaryTextColor,
              size: isTablet ? 28 : 24,
            ),
            onPressed: () => _speak(german),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 14 : 12,
              vertical: isTablet ? 8 : 6,
            ),
            decoration: BoxDecoration(
              color: genderColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              gender,
              style: TextStyle(
                color: genderColor,
                fontSize: subtitleSize * 0.85,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
