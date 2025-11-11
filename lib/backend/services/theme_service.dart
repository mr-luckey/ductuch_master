import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // High contrast color schemes optimized for readability and focus
  static final List<ColorSchemeData> colorSchemes = [
    // 1. Classic High Contrast - Maximum readability
    // ColorSchemeData(
    //   name: 'Classic High Contrast',
    //   primary: const Color(0xFF000000),
    //   secondary: const Color(0xFF333333),
    //   surface: const Color(0xFFFFFFFF),
    //   background: const Color(0xFFFFFFFF),
    //   textPrimary: const Color(0xFF000000),
    //   textSecondary: const Color(0xFF444444),
    //   gradient: const LinearGradient(
    //     colors: [Color(0xFF000000), Color(0xFF333333)],
    //   ),
    //   primaryDark: const Color(0xFFFFFFFF),
    //   secondaryDark: const Color(0xFFE0E0E0),
    //   surfaceDark: const Color(0xFF121212),
    //   backgroundDark: const Color(0xFF000000),
    //   textPrimaryDark: const Color(0xFFFFFFFF),
    //   textSecondaryDark: const Color(0xFFCCCCCC),
    //   nounsSurface: const Color(0xFF1A1A1A),
    //   accentTeal: const Color(0xFF00B894), // High contrast teal
    // ),

    // 2. Blue Contrast - Calm yet highly readable
    ColorSchemeData(
      name: 'Blue Contrast',
      primary: const Color(0xFF0D47A1),
      secondary: const Color(0xFF1976D2),
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFF5F9FF),
      textPrimary: const Color(0xFF0D47A1),
      textSecondary: const Color(0xFF424242),
      gradient: const LinearGradient(
        colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
      ),
      primaryDark: const Color(0xFF90CAF9),
      secondaryDark: const Color(0xFF64B5F6),
      surfaceDark: const Color(0xFF0D1B36),
      backgroundDark: const Color(0xFF051428),
      textPrimaryDark: const Color(0xFFFFFFFF),
      textSecondaryDark: const Color(0xFFE3F2FD),
      nounsSurface: const Color(0xFF0A1429),
      accentTeal: const Color(0xFF00E5FF), // Bright cyan for contrast
    ),

    // 3. Green Contrast - Soothing for eyes
    ColorSchemeData(
      name: 'Green Contrast',
      primary: const Color(0xFF1B5E20),
      secondary: const Color(0xFF2E7D32),
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFF1F8E9),
      textPrimary: const Color(0xFF1B5E20),
      textSecondary: const Color(0xFF37474F),
      gradient: const LinearGradient(
        colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
      ),
      primaryDark: const Color(0xFF69F0AE),
      secondaryDark: const Color(0xFF4CAF50),
      surfaceDark: const Color(0xFF0D1F0E),
      backgroundDark: const Color(0xFF051405),
      textPrimaryDark: const Color(0xFFFFFFFF),
      textSecondaryDark: const Color(0xFFC8E6C9),
      nounsSurface: const Color(0xFF091309),
      accentTeal: const Color(0xFF00C853), // Bright green
    ),

    // 4. Purple Contrast - Modern and accessible
    ColorSchemeData(
      name: 'Purple Contrast',
      primary: const Color(0xFF4A148C),
      secondary: const Color(0xFF6A1B9A),
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFF3E5F5),
      textPrimary: const Color(0xFF4A148C),
      textSecondary: const Color(0xFF4A4A4A),
      gradient: const LinearGradient(
        colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
      ),
      primaryDark: const Color(0xFFE040FB),
      secondaryDark: const Color(0xFFAB47BC),
      surfaceDark: const Color(0xFF1A0D2A),
      backgroundDark: const Color(0xFF0F0619),
      textPrimaryDark: const Color(0xFFFFFFFF),
      textSecondaryDark: const Color(0xFFE1BEE7),
      nounsSurface: const Color(0xFF140A21),
      accentTeal: const Color(0xFFAA00FF), // Bright purple
    ),

    // 5. Warm Contrast - Easy on the eyes
    ColorSchemeData(
      name: 'Warm Contrast',
      primary: const Color(0xFFBF360C),
      secondary: const Color(0xFFE64A19),
      surface: const Color(0xFFFFFFFF),
      background: const Color(0xFFFFF3E0),
      textPrimary: const Color(0xFFBF360C),
      textSecondary: const Color(0xFF5D4037),
      gradient: const LinearGradient(
        colors: [Color(0xFFBF360C), Color(0xFFE64A19)],
      ),
      primaryDark: const Color(0xFFFF8A65),
      secondaryDark: const Color(0xFFFF7043),
      surfaceDark: const Color(0xFF261914),
      backgroundDark: const Color(0xFF1A100B),
      textPrimaryDark: const Color(0xFFFFFFFF),
      textSecondaryDark: const Color(0xFFFFCCBC),
      nounsSurface: const Color(0xFF21120C),
      accentTeal: const Color(0xFFFF5722), // Bright orange
    ),

    // 6. Professional Dark - High contrast dark mode
    ColorSchemeData(
      name: 'Professional Dark',
      primary: const Color(0xFF1565C0),
      secondary: const Color(0xFF42A5F5),
      surface: const Color(0xFFFAFAFA),
      background: const Color(0xFFFFFFFF),
      textPrimary: const Color(0xFF212121),
      textSecondary: const Color(0xFF757575),
      gradient: const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
      ),
      primaryDark: const Color(0xFF82B1FF),
      secondaryDark: const Color(0xFF448AFF),
      surfaceDark: const Color(0xFF121212),
      backgroundDark: const Color(0xFF000000),
      textPrimaryDark: const Color(0xFFFFFFFF),
      textSecondaryDark: const Color(0xFFE0E0E0),
      nounsSurface: const Color(0xFF1E1E1E),
      accentTeal: const Color(0xFF00B0FF), // Bright blue
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
      textTheme: GoogleFonts.patrickHandTextTheme(text).copyWith(
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
}
