import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerbsScreen extends StatefulWidget {
  const VerbsScreen({super.key});

  @override
  State<VerbsScreen> createState() => _VerbsScreenState();
}

class _VerbsScreenState extends State<VerbsScreen> {
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
            'Verbs',
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
                    'German Verbs',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Master essential German verbs and their conjugations',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: secondaryTextColor,
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                  SizedBox(height: 24),
                _buildVerbCard(
                  context,
                  'sein',
                  'to be',
                  'ich bin, du bist, er/sie/es ist',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  context,
                  'haben',
                  'to have',
                  'ich habe, du hast, er/sie/es hat',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  context,
                  'gehen',
                  'to go',
                  'ich gehe, du gehst, er/sie/es geht',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  context,
                  'kommen',
                  'to come',
                  'ich komme, du kommst, er/sie/es kommt',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  context,
                  'machen',
                  'to make/do',
                  'ich mache, du machst, er/sie/es macht',
                  scheme,
                  isDark,
                  textColor,
                  secondaryTextColor,
                ),
                const SizedBox(height: 12),
                _buildVerbCard(
                  context,
                  'sagen',
                  'to say',
                  'ich sage, du sagst, er/sie/es sagt',
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

  Widget _buildVerbCard(
    BuildContext context,
    String infinitive,
    String english,
    String conjugation,
    scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 20.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final titleSize = isTablet ? 26.0 : 22.0;
    final subtitleSize = isTablet ? 16.0 : 14.0;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 14 : 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? scheme.primaryDark.withOpacity(0.2)
                      : scheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: isDark ? scheme.primaryDark : scheme.primary,
                  size: iconSize,
                ),
              ),
              SizedBox(width: isTablet ? 20 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infinitive,
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
                  _isPlaying && _currentPlayingText == infinitive
                      ? Icons.volume_up
                      : Icons.volume_down,
                  color: _isPlaying && _currentPlayingText == infinitive
                      ? (isDark ? scheme.primaryDark : scheme.primary)
                      : secondaryTextColor,
                  size: iconSize,
                ),
                onPressed: () => _speak(infinitive),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 20 : 16),
          Container(
            padding: EdgeInsets.all(isTablet ? 14 : 12),
            decoration: BoxDecoration(
              color: isDark ? scheme.backgroundDark : scheme.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              conjugation,
              style: TextStyle(
                fontSize: subtitleSize,
                color: secondaryTextColor,
                fontFamily: GoogleFonts.patrickHand().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
