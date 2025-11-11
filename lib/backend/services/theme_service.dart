import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Font configuration class for centralized font management
class FontScheme {
  final String primaryFont;
  final String secondaryFont;

  // Font styles for different text sizes
  final TextStyle headline;
  final TextStyle headlineLarge;
  final TextStyle headlineMedium;
  final TextStyle headlineSmall;
  final TextStyle title;
  final TextStyle titleLarge;
  final TextStyle titleMedium;
  final TextStyle titleSmall;
  final TextStyle body;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle label;
  final TextStyle labelLarge;
  final TextStyle labelMedium;
  final TextStyle labelSmall;
  final TextStyle button;

  FontScheme({
    this.primaryFont = 'Comfortaa', // Kid-friendly, rounded, playful font
    this.secondaryFont = 'Comfortaa',
    this.headline = const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    this.headlineLarge = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
    ),
    this.headlineMedium = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    this.headlineSmall = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    this.title = const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    this.titleLarge = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    this.body = const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    this.label = const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
    this.button = const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  });

  // Get font style with color applied
  TextStyle getHeadlineStyle({Color? color}) =>
      headline.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getHeadlineLargeStyle({Color? color}) =>
      headlineLarge.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getHeadlineMediumStyle({Color? color}) =>
      headlineMedium.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getHeadlineSmallStyle({Color? color}) =>
      headlineSmall.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getTitleStyle({Color? color}) =>
      title.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getTitleLargeStyle({Color? color}) =>
      titleLarge.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getTitleMediumStyle({Color? color}) =>
      titleMedium.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getTitleSmallStyle({Color? color}) =>
      titleSmall.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getBodyStyle({Color? color}) =>
      body.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getBodyLargeStyle({Color? color}) =>
      bodyLarge.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getBodyMediumStyle({Color? color}) =>
      bodyMedium.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getBodySmallStyle({Color? color}) =>
      bodySmall.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getLabelStyle({Color? color}) =>
      label.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getLabelLargeStyle({Color? color}) =>
      labelLarge.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getLabelMediumStyle({Color? color}) =>
      labelMedium.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getLabelSmallStyle({Color? color}) =>
      labelSmall.copyWith(color: color, fontFamily: primaryFont);

  TextStyle getButtonStyle({Color? color}) =>
      button.copyWith(color: color, fontFamily: primaryFont);

  // Generic style getter
  TextStyle getStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
    double? letterSpacing,
  }) => TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    fontFamily: primaryFont,
    height: height,
    letterSpacing: letterSpacing,
  );
}

class ColorSchemeData {
  final String name;
  final Color primary;
  final Color secondary;
  final Color surface;
  final Color background;
  final Color textPrimary;
  final Color textSecondary;
  final LinearGradient gradient;

  // Dark mode colors
  final Color primaryDark;
  final Color secondaryDark;
  final Color surfaceDark;
  final Color backgroundDark;
  final Color textPrimaryDark;
  final Color textSecondaryDark;

  // Nouns theme colors
  final Color nounsSurface;
  final Color accentTeal;

  ColorSchemeData({
    required this.name,
    required this.primary,
    required this.secondary,
    required this.surface,
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
    required this.gradient,
    required this.primaryDark,
    required this.secondaryDark,
    required this.surfaceDark,
    required this.backgroundDark,
    required this.textPrimaryDark,
    required this.textSecondaryDark,
    required this.nounsSurface,
    required this.accentTeal,
  });
}

class ThemeService extends GetxController {
  static ThemeService get to => Get.find();

  final RxInt selectedSchemeIndex = 0.obs;
  final RxBool isDarkMode = false.obs;

  // Centralized font scheme
  late FontScheme fontScheme = FontScheme();

  // Kid-friendly color schemes based on learning psychology
  // Research shows: bright, warm colors (orange, yellow, green) promote engagement
  // Cool colors (blue, purple) promote focus and calm
  // High contrast improves readability for young learners
  static final List<ColorSchemeData> colorSchemes = [
    // 1. Playful Learning - Bright, engaging colors for active learning
    ColorSchemeData(
      name: 'Playful Learning',
      primary: const Color(0xFFFF6B35), // Vibrant orange - promotes energy
      secondary: const Color(0xFFFFB627), // Sunny yellow - promotes happiness
      surface: const Color(0xFFFFF9F0), // Warm cream - soft on eyes
      background: const Color(0xFFFFFDF7), // Almost white with warmth
      textPrimary: const Color(
        0xFF2C3E50,
      ), // Dark blue-gray - excellent readability
      textSecondary: const Color(0xFF7F8C8D), // Medium gray
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF6B35), Color(0xFFFFB627), Color(0xFF4ECDC4)],
      ),
      primaryDark: const Color(0xFFFF8C65), // Lighter orange for dark mode
      secondaryDark: const Color(0xFFFFD54F), // Brighter yellow
      surfaceDark: const Color(0xFF1A1A1A), // Dark surface
      backgroundDark: const Color(0xFF121212), // Very dark background
      textPrimaryDark: const Color(0xFFFFFFFF), // White text
      textSecondaryDark: const Color(0xFFB0B0B0), // Light gray
      nounsSurface: const Color(0xFF2A2A2A), // Slightly lighter dark surface
      accentTeal: const Color(0xFF4ECDC4), // Turquoise - calming yet engaging
    ),
  ];

  ColorSchemeData get currentScheme => colorSchemes[selectedSchemeIndex.value];

  // Unified app theme that switches between light & dark using isDarkMode
  ThemeData get appTheme {
    final isDark = isDarkMode.value;
    final base = isDark
        ? ThemeData(brightness: Brightness.dark)
        : ThemeData(brightness: Brightness.light);
    final text = base.textTheme;

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: isDark
          ? currentScheme.backgroundDark
          : currentScheme.background,
      primaryColor: currentScheme.accentTeal,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: currentScheme.accentTeal,
              secondary: currentScheme.accentTeal,
              surface: currentScheme.nounsSurface,
              background: currentScheme.backgroundDark,
              onBackground: currentScheme.textPrimaryDark,
              onSurface: currentScheme.textPrimaryDark,
            )
          : ColorScheme.light(
              primary: currentScheme.accentTeal,
              secondary: currentScheme.accentTeal,
              surface: currentScheme.surface,
              background: currentScheme.background,
              onBackground: currentScheme.textPrimary,
              onSurface: currentScheme.textPrimary,
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? currentScheme.backgroundDark
            : currentScheme.background,
        elevation: 2,
        foregroundColor: isDark
            ? currentScheme.textPrimaryDark
            : currentScheme.textPrimary,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: isDark
              ? currentScheme.textPrimaryDark
              : currentScheme.textPrimary,
        ),
      ),
      iconTheme: IconThemeData(
        color: isDark
            ? currentScheme.textPrimaryDark
            : currentScheme.textPrimary,
      ),
      dividerColor: isDark
          ? currentScheme.textSecondaryDark.withOpacity(0.3)
          : currentScheme.textSecondary.withOpacity(0.3),
      cardTheme: CardThemeData(
        color: isDark ? currentScheme.surfaceDark : currentScheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? Colors.black : Colors.black26,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark
                ? currentScheme.textSecondaryDark.withOpacity(0.2)
                : currentScheme.textSecondary.withOpacity(0.2),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: currentScheme.accentTeal,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: currentScheme.accentTeal,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? currentScheme.surfaceDark : currentScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark
                ? currentScheme.textSecondaryDark.withOpacity(0.3)
                : currentScheme.textSecondary.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: currentScheme.accentTeal, width: 2),
        ),
        labelStyle: TextStyle(
          color: isDark
              ? currentScheme.textSecondaryDark
              : currentScheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: isDark
              ? currentScheme.textSecondaryDark.withOpacity(0.7)
              : currentScheme.textSecondary.withOpacity(0.7),
        ),
      ),
      textTheme: GoogleFonts.comfortaaTextTheme(text).copyWith(
        bodyLarge: TextStyle(
          color: isDark
              ? currentScheme.textPrimaryDark
              : currentScheme.textPrimary,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: isDark
              ? currentScheme.textPrimaryDark
              : currentScheme.textPrimary,
          fontSize: 14,
        ),
        titleLarge: TextStyle(
          color: isDark
              ? currentScheme.textPrimaryDark
              : currentScheme.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          color: isDark
              ? currentScheme.textPrimaryDark
              : currentScheme.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        labelLarge: TextStyle(
          color: isDark
              ? currentScheme.textPrimaryDark
              : currentScheme.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void changeScheme(int index) {
    if (index >= 0 && index < colorSchemes.length) {
      selectedSchemeIndex.value = index;
    }
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
  }

  // Font helper methods
  String get fontFamily => fontScheme.primaryFont;

  TextStyle getHeadlineStyle({Color? color}) =>
      fontScheme.getHeadlineStyle(color: color);

  TextStyle getHeadlineLargeStyle({Color? color}) =>
      fontScheme.getHeadlineLargeStyle(color: color);

  TextStyle getHeadlineMediumStyle({Color? color}) =>
      fontScheme.getHeadlineMediumStyle(color: color);

  TextStyle getHeadlineSmallStyle({Color? color}) =>
      fontScheme.getHeadlineSmallStyle(color: color);

  TextStyle getTitleStyle({Color? color}) =>
      fontScheme.getTitleStyle(color: color);

  TextStyle getTitleLargeStyle({Color? color}) =>
      fontScheme.getTitleLargeStyle(color: color);

  TextStyle getTitleMediumStyle({Color? color}) =>
      fontScheme.getTitleMediumStyle(color: color);

  TextStyle getTitleSmallStyle({Color? color}) =>
      fontScheme.getTitleSmallStyle(color: color);

  TextStyle getBodyStyle({Color? color}) =>
      fontScheme.getBodyStyle(color: color);

  TextStyle getBodyLargeStyle({Color? color}) =>
      fontScheme.getBodyLargeStyle(color: color);

  TextStyle getBodyMediumStyle({Color? color}) =>
      fontScheme.getBodyMediumStyle(color: color);

  TextStyle getBodySmallStyle({Color? color}) =>
      fontScheme.getBodySmallStyle(color: color);

  TextStyle getLabelStyle({Color? color}) =>
      fontScheme.getLabelStyle(color: color);

  TextStyle getLabelLargeStyle({Color? color}) =>
      fontScheme.getLabelLargeStyle(color: color);

  TextStyle getLabelMediumStyle({Color? color}) =>
      fontScheme.getLabelMediumStyle(color: color);

  TextStyle getLabelSmallStyle({Color? color}) =>
      fontScheme.getLabelSmallStyle(color: color);

  TextStyle getButtonStyle({Color? color}) =>
      fontScheme.getButtonStyle(color: color);

  TextStyle getStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double? height,
    double? letterSpacing,
  }) => fontScheme.getStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );

  // Animation utilities for smooth, engaging interactions
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 200);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve springCurve = Curves.easeInOutBack;

  // Card elevation and shadow helpers
  static List<BoxShadow> getCardShadow(bool isDark) {
    if (isDark) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 6,
        offset: const Offset(0, 2),
        spreadRadius: 0,
      ),
    ];
  }

  // Gradient helpers for beautiful cards
  LinearGradient getCardGradient(bool isDark) {
    final scheme = currentScheme;
    if (isDark) {
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          scheme.primaryDark.withOpacity(0.15),
          scheme.secondaryDark.withOpacity(0.1),
        ],
      );
    }
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        scheme.primary.withOpacity(0.08),
        scheme.secondary.withOpacity(0.05),
      ],
    );
  }

  // Success/Error/Info color helpers
  Color getSuccessColor(bool isDark) {
    return isDark ? const Color(0xFF4CAF50) : const Color(0xFF66BB6A);
  }

  Color getErrorColor(bool isDark) {
    return isDark ? const Color(0xFFEF5350) : const Color(0xFFE57373);
  }

  Color getInfoColor(bool isDark) {
    return isDark ? const Color(0xFF42A5F5) : const Color(0xFF64B5F6);
  }

  Color getWarningColor(bool isDark) {
    return isDark ? const Color(0xFFFFB74D) : const Color(0xFFFFA726);
  }
}
