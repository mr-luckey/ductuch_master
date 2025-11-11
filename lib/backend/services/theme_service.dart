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
  });
}

class ThemeService extends GetxController {
  static ThemeService get to => Get.find();

  final RxInt selectedSchemeIndex = 0.obs;
  final RxBool isDarkMode = true.obs;
  static const Color _nounsBackground = Color(0xFF0B0F14);
  static const Color _nounsSurface = Color(0xFF11161C);
  static const Color _accentTeal = Color(0xFF10B981);

  static final List<ColorSchemeData> colorSchemes = [
    // 1. German Flag (Black-Red-Gold)
    ColorSchemeData(
      name: 'German Flag',
      primary: const Color(0xFF000000), // Black
      secondary: const Color(0xFFDD0000), // Red
      surface: const Color(0xFFFFF8E1), // Light gold tint
      background: const Color(0xFFFFFDE7), // Very light gold
      textPrimary: const Color(0xFF000000), // Black
      textSecondary: const Color(0xFF5D4037), // Dark brown
      gradient: const LinearGradient(
        colors: [Color(0xFF000000), Color(0xFFDD0000), Color(0xFFFFCE00)],
        stops: [0.0, 0.5, 1.0],
      ),
      primaryDark: const Color(0xFFFFCE00), // Gold becomes primary in dark
      secondaryDark: const Color(0xFFDD0000), // Red
      surfaceDark: const Color(0xFF1A1A1A), // Dark surface
      backgroundDark: const Color(0xFF000000), // Black background
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFFFCE00), // Gold text
    ),

    // 2. Ocean Breeze (Blue-Cyan)
    ColorSchemeData(
      name: 'Ocean Breeze',
      primary: const Color(0xFF2196F3),
      secondary: const Color(0xFF00BCD4),
      surface: const Color(0xFFE3F2FD),
      background: const Color(0xFFF5F9FF),
      textPrimary: const Color(0xFF1565C0),
      textSecondary: const Color(0xFF546E7A),
      gradient: const LinearGradient(
        colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
      ),
      primaryDark: const Color(0xFF64B5F6),
      secondaryDark: const Color(0xFF4DD0E1),
      surfaceDark: const Color(0xFF1E3A5F),
      backgroundDark: const Color(0xFF0D1B2A),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFB0BEC5),
    ),

    // 3. Forest Green (Green-Emerald)
    ColorSchemeData(
      name: 'Forest Green',
      primary: const Color(0xFF10B981),
      secondary: const Color(0xFF34D399),
      surface: const Color(0xFFD1FAE5),
      background: const Color(0xFFF0FDF4),
      textPrimary: const Color(0xFF047857),
      textSecondary: const Color(0xFF6B7280),
      gradient: const LinearGradient(
        colors: [Color(0xFF10B981), Color(0xFF34D399)],
      ),
      primaryDark: const Color(0xFF6EE7B7),
      secondaryDark: const Color(0xFFA7F3D0),
      surfaceDark: const Color(0xFF064E3B),
      backgroundDark: const Color(0xFF022C22),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFD1D5DB),
    ),

    // 4. Sunset Orange (Orange-Pink)
    ColorSchemeData(
      name: 'Sunset Orange',
      primary: const Color(0xFFF59E0B),
      secondary: const Color(0xFFEC4899),
      surface: const Color(0xFFFEF3C7),
      background: const Color(0xFFFFFBEB),
      textPrimary: const Color(0xFFD97706),
      textSecondary: const Color(0xFF78716C),
      gradient: const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFEC4899)],
      ),
      primaryDark: const Color(0xFFFBBF24),
      secondaryDark: const Color(0xFFF472B6),
      surfaceDark: const Color(0xFF78350F),
      backgroundDark: const Color(0xFF451A03),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFFCD34D),
    ),

    // 5. Purple Dream (Purple-Violet)
    ColorSchemeData(
      name: 'Purple Dream',
      primary: const Color(0xFF8B5CF6),
      secondary: const Color(0xFFA78BFA),
      surface: const Color(0xFFEDE9FE),
      background: const Color(0xFFF5F3FF),
      textPrimary: const Color(0xFF6D28D9),
      textSecondary: const Color(0xFF6B7280),
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      ),
      primaryDark: const Color(0xFFA78BFA),
      secondaryDark: const Color(0xFFC4B5FD),
      surfaceDark: const Color(0xFF4C1D95),
      backgroundDark: const Color(0xFF1E1B4B),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFDDD6FE),
    ),

    // 6. Rose Gold (Rose-Pink)
    ColorSchemeData(
      name: 'Rose Gold',
      primary: const Color(0xFFEC4899),
      secondary: const Color(0xFFF472B6),
      surface: const Color(0xFFFCE7F3),
      background: const Color(0xFFFDF2F8),
      textPrimary: const Color(0xFFBE185D),
      textSecondary: const Color(0xFF9F1239),
      gradient: const LinearGradient(
        colors: [Color(0xFFEC4899), Color(0xFFF472B6)],
      ),
      primaryDark: const Color(0xFFF472B6),
      secondaryDark: const Color(0xFFF9A8D4),
      surfaceDark: const Color(0xFF831843),
      backgroundDark: const Color(0xFF500724),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFFBCFE8),
    ),

    // 7. Teal Serenity (Teal-Cyan)
    ColorSchemeData(
      name: 'Teal Serenity',
      primary: const Color(0xFF14B8A6),
      secondary: const Color(0xFF2DD4BF),
      surface: const Color(0xFFCCFBF1),
      background: const Color(0xFFF0FDFA),
      textPrimary: const Color(0xFF0D9488),
      textSecondary: const Color(0xFF475569),
      gradient: const LinearGradient(
        colors: [Color(0xFF14B8A6), Color(0xFF2DD4BF)],
      ),
      primaryDark: const Color(0xFF5EEAD4),
      secondaryDark: const Color(0xFF99F6E4),
      surfaceDark: const Color(0xFF134E4A),
      backgroundDark: const Color(0xFF042F2E),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFCCFBF1),
    ),

    // 8. Crimson Red (Red-Pink)
    ColorSchemeData(
      name: 'Crimson Red',
      primary: const Color(0xFFEF4444),
      secondary: const Color(0xFFF87171),
      surface: const Color(0xFFFEE2E2),
      background: const Color(0xFFFEF2F2),
      textPrimary: const Color(0xFFDC2626),
      textSecondary: const Color(0xFF991B1B),
      gradient: const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFF87171)],
      ),
      primaryDark: const Color(0xFFF87171),
      secondaryDark: const Color(0xFFFCA5A5),
      surfaceDark: const Color(0xFF991B1B),
      backgroundDark: const Color(0xFF7F1D1D),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFFECACA),
    ),

    // 9. Indigo Night (Indigo-Blue)
    ColorSchemeData(
      name: 'Indigo Night',
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFF818CF8),
      surface: const Color(0xFFE0E7FF),
      background: const Color(0xFFEEF2FF),
      textPrimary: const Color(0xFF4338CA),
      textSecondary: const Color(0xFF4B5563),
      gradient: const LinearGradient(
        colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
      ),
      primaryDark: const Color(0xFF818CF8),
      secondaryDark: const Color(0xFFA5B4FC),
      surfaceDark: const Color(0xFF312E81),
      backgroundDark: const Color(0xFF1E1B4B),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFC7D2FE),
    ),
  ];

  ColorSchemeData get currentScheme => colorSchemes[selectedSchemeIndex.value];

  // Unified app theme (matches Nouns screen aesthetics)
  ThemeData get appTheme {
    final baseDark = ThemeData(brightness: Brightness.dark);
    final text = baseDark.textTheme;
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _nounsBackground,
      primaryColor: _accentTeal,
      colorScheme: const ColorScheme.dark(
        primary: _accentTeal,
        secondary: _accentTeal,
        surface: _nounsSurface,
        background: _nounsBackground,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _nounsBackground,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
      cardTheme: CardThemeData(
        color: Colors.white.withOpacity(0.03),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.white.withOpacity(0.06),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.05),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.03),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _accentTeal),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      textTheme: GoogleFonts.patrickHandTextTheme(
        text,
      ).apply(bodyColor: Colors.white, displayColor: Colors.white),
    );
  }

  ThemeData get lightTheme {
    final scheme = currentScheme;
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: scheme.background,
      colorScheme: ColorScheme.light(
        primary: scheme.primary,
        secondary: scheme.secondary,
        surface: scheme.surface,
        background: scheme.background,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.textPrimary,
      ),
    );
  }

  ThemeData get darkTheme {
    final scheme = currentScheme;
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: scheme.primaryDark,
      scaffoldBackgroundColor: scheme.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: scheme.primaryDark,
        secondary: scheme.secondaryDark,
        surface: scheme.surfaceDark,
        background: scheme.backgroundDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
    );
  }

  void changeScheme(int index) {
    selectedSchemeIndex.value = index;
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
  }
}
