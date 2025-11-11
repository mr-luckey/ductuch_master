// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ColorSchemeData {
//   final String name;
//   final Color primary;
//   final Color secondary;
//   final Color surface;
//   final Color background;
//   final Color textPrimary;
//   final Color textSecondary;
//   final LinearGradient gradient;

//   // Dark mode colors
//   final Color primaryDark;
//   final Color secondaryDark;
//   final Color surfaceDark;
//   final Color backgroundDark;
//   final Color textPrimaryDark;
//   final Color textSecondaryDark;

//   // Nouns theme colors
//   // final Color nounsBackground;
//   final Color nounsSurface;
//   final Color accentTeal;

//   ColorSchemeData({
//     required this.name,
//     required this.primary,
//     required this.secondary,
//     required this.surface,
//     required this.background,
//     required this.textPrimary,
//     required this.textSecondary,
//     required this.gradient,
//     required this.primaryDark,
//     required this.secondaryDark,
//     required this.surfaceDark,
//     required this.backgroundDark,
//     required this.textPrimaryDark,
//     required this.textSecondaryDark,
//     // required this.nounsBackground,
//     required this.nounsSurface,
//     required this.accentTeal,
//   });
// }

// class ThemeService extends GetxController {
//   static ThemeService get to => Get.find();

//   final RxInt selectedSchemeIndex = 0.obs;
//   final RxBool isDarkMode = true.obs;

//   static final List<ColorSchemeData> colorSchemes = [
//     ColorSchemeData(
//       name: 'Indigo Night',
//       primary: const Color(0xFF6366F1),
//       secondary: const Color(0xFF818CF8),
//       surface: const Color(0xFFE0E7FF),
//       background: const Color(0xFFEEF2FF),
//       textPrimary: const Color(0xFF4338CA),
//       textSecondary: const Color(0xFF4B5563),
//       gradient: const LinearGradient(
//         colors: [Color(0xFF6366F1), Color(0xFF818CF8)],
//       ),
//       primaryDark: const Color(0xFF818CF8),
//       secondaryDark: const Color(0xFFA5B4FC),
//       surfaceDark: const Color(0xFF312E81),
//       backgroundDark: const Color(0xFF1E1B4B),
//       textPrimaryDark: Colors.white,
//       textSecondaryDark: const Color(0xFFC7D2FE),
//       // nounsBackground: const Color(0xFF1E1B4B),
//       nounsSurface: const Color(0xFF11161C),
//       accentTeal: const Color(0xFF10B981),
//     ),
//   ];

//   ColorSchemeData get currentScheme => colorSchemes[selectedSchemeIndex.value];

//   // Unified app theme (matches Nouns screen aesthetics)
//   ThemeData get appTheme {
//     final baseDark = ThemeData(brightness: Brightness.light);
//     final text = baseDark.textTheme;
//     return ThemeData(
//       brightness: Brightness.dark,
//       scaffoldBackgroundColor: currentScheme.backgroundDark,
//       primaryColor: currentScheme.accentTeal,
//       colorScheme: ColorScheme.dark(
//         primary: currentScheme.accentTeal,
//         secondary: currentScheme.accentTeal,
//         surface: currentScheme.nounsSurface,
//         background: currentScheme.backgroundDark,
//       ),
//       appBarTheme: AppBarTheme(
//         backgroundColor: currentScheme.backgroundDark,
//         elevation: 0,
//         foregroundColor: Colors.white,
//       ),
//       iconTheme: const IconThemeData(color: Colors.white),
//       dividerColor: Colors.white54,
//       cardTheme: CardThemeData(
//         color: Colors.white.withOpacity(0.03),
//         surfaceTintColor: Colors.transparent,
//         shadowColor: Colors.white.withOpacity(0.06),
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(color: Colors.white.withOpacity(0.1)),
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.white.withOpacity(0.05),
//           foregroundColor: Colors.white,
//           elevation: 0,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//             side: BorderSide(color: Colors.white.withOpacity(0.1)),
//           ),
//         ),
//       ),
//       textButtonTheme: TextButtonThemeData(
//         style: TextButton.styleFrom(foregroundColor: Colors.white),
//       ),
//       inputDecorationTheme: InputDecorationTheme(
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.03),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: currentScheme.accentTeal),
//         ),
//         labelStyle: const TextStyle(color: Colors.white70),
//         hintStyle: const TextStyle(color: Colors.white54),
//       ),
//       textTheme: GoogleFonts.patrickHandTextTheme(
//         text,
//       ).apply(bodyColor: Colors.white, displayColor: Colors.white),
//     );
//   }

//   void changeScheme(int index) {
//     selectedSchemeIndex.value = index;
//   }

//   void toggleDarkMode() {
//     isDarkMode.value = !isDarkMode.value;
//   }
// }
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
  final RxBool isDarkMode =
      false.obs; // default to light mode to show light palettes

  // Curated color schemes aimed to improve focus, calmness and playfulness for language learners.
  // Each scheme contains a light and a dark variant and an action/accent color.
  static final List<ColorSchemeData> colorSchemes = [
    ColorSchemeData(
      name: 'Twilight Violet',
      primary: const Color(0xFF8E7FF5), // medium purple
      secondary: const Color(0xFFD8C8FF), // light lavender
      surface: const Color(0xFFFBFAFF),
      background: const Color(0xFFF9F8FF),
      textPrimary: const Color(0xFF2B1F4C),
      textSecondary: const Color(0xFF4A3D6B),
      gradient: const LinearGradient(
        colors: [Color(0xFF8E7FF5), Color(0xFFD8C8FF)],
      ),
      primaryDark: const Color(0xFF6A5CE9),
      secondaryDark: const Color(0xFFB8A1FF),
      surfaceDark: const Color(0xFF140F20),
      backgroundDark: const Color(0xFF0A0512),
      textPrimaryDark: Colors.white,
      textSecondaryDark: const Color(0xFFC8B8FF),
      nounsSurface: const Color(0xFF090514),
      accentTeal: const Color(0xFF1DE9B6), // vibrant teal accent
    ),

    // // 1. Sunny Pastel: warm, friendly, encourages action and reduces anxiety.
    // ColorSchemeData(
    //   name: 'Sunny Pastel',
    //   primary: const Color(0xFFFFB86B), // soft orange
    //   secondary: const Color(0xFFFFD6A5),
    //   surface: const Color(0xFFFFFFFF),
    //   background: const Color(0xFFFFF7ED),
    //   textPrimary: const Color(0xFF5B3A29),
    //   textSecondary: const Color(0xFF6B6B6B),
    //   gradient: const LinearGradient(
    //     colors: [Color(0xFFFFB86B), Color(0xFFFFD6A5)],
    //   ),
    //   primaryDark: const Color(0xFFFF8A50),
    //   secondaryDark: const Color(0xFFFFB86B),
    //   surfaceDark: const Color(0xFF252525),
    //   backgroundDark: const Color(0xFF0F1720),
    //   textPrimaryDark: Colors.white,
    //   textSecondaryDark: const Color(0xFFFFD6A5),
    //   nounsSurface: const Color(0xFF141414),
    //   accentTeal: const Color(0xFF06B6D4), // calm action color
    // ),

    // // 2. Mint Focus: cool greens to support concentration and reduce eye strain.
    // ColorSchemeData(
    //   name: 'Mint Focus',
    //   primary: const Color(0xFF34D399), // mint
    //   secondary: const Color(0xFFA7F3D0),
    //   surface: const Color(0xFFF6FFFB),
    //   background: const Color(0xFFF0FFF6),
    //   textPrimary: const Color(0xFF064E3B),
    //   textSecondary: const Color(0xFF065F46),
    //   gradient: const LinearGradient(
    //     colors: [Color(0xFF34D399), Color(0xFFA7F3D0)],
    //   ),
    //   primaryDark: const Color(0xFF10B981),
    //   secondaryDark: const Color(0xFF34D399),
    //   surfaceDark: const Color(0xFF0E1F1A),
    //   backgroundDark: const Color(0xFF04140E),
    //   textPrimaryDark: Colors.white,
    //   textSecondaryDark: const Color(0xFFA7F3D0),
    //   nounsSurface: const Color(0xFF071611),
    //   accentTeal: const Color(0xFF06B6D4),
    // ),

    // // 3. Sky Coral: friendly blues + coral accent for approachability and clarity.
    // ColorSchemeData(
    //   name: 'Sky & Coral',
    //   primary: const Color(0xFF60A5FA), // sky blue
    //   secondary: const Color(0xFFFDA4AF), // soft coral/pink
    //   surface: const Color(0xFFF8FAFF),
    //   background: const Color(0xFFF7FBFF),
    //   textPrimary: const Color(0xFF0F172A),
    //   textSecondary: const Color(0xFF334155),
    //   gradient: const LinearGradient(
    //     colors: [Color(0xFF60A5FA), Color(0xFFFDA4AF)],
    //   ),
    //   primaryDark: const Color(0xFF3B82F6),
    //   secondaryDark: const Color(0xFFF973A6),
    //   surfaceDark: const Color(0xFF0B1220),
    //   backgroundDark: const Color(0xFF071029),
    //   textPrimaryDark: Colors.white,
    //   textSecondaryDark: const Color(0xFF93C5FD),
    //   nounsSurface: const Color(0xFF071227),
    //   accentTeal: const Color(0xFF06B6D4),
    // ),

    // // 4. Lavender Calm: soft purples to lower stress and encourage longer sessions.
    // ColorSchemeData(
    //   name: 'Lavender Calm',
    //   primary: const Color(0xFFC7B3FF),
    //   secondary: const Color(0xFFE9D5FF),
    //   surface: const Color(0xFFFBF8FF),
    //   background: const Color(0xFFFCFBFF),
    //   textPrimary: const Color(0xFF2A2340),
    //   textSecondary: const Color(0xFF5B4B7A),
    //   gradient: const LinearGradient(
    //     colors: [Color(0xFFC7B3FF), Color(0xFFE9D5FF)],
    //   ),
    //   primaryDark: const Color(0xFF8B5CF6),
    //   secondaryDark: const Color(0xFF7C3AED),
    //   surfaceDark: const Color(0xFF14121B),
    //   backgroundDark: const Color(0xFF09060D),
    //   textPrimaryDark: Colors.white,
    //   textSecondaryDark: const Color(0xFFDCCBFF),
    //   nounsSurface: const Color(0xFF0F0C13),
    //   accentTeal: const Color(0xFF7C3AED),
    // ),

    // // 5. Playful Citrus: upbeat, high-contrast accents for motivation and gamification.
    // ColorSchemeData(
    //   name: 'Playful Citrus',
    //   primary: const Color(0xFFFDE68A), // soft lemon
    //   secondary: const Color(0xFFFECACA),
    //   surface: const Color(0xFFFFFDF0),
    //   background: const Color(0xFFFFFBEB),
    //   textPrimary: const Color(0xFF92400E),
    //   textSecondary: const Color(0xFF6B4A14),
    //   gradient: const LinearGradient(
    //     colors: [Color(0xFFFDE68A), Color(0xFFFECACA)],
    //   ),
    //   primaryDark: const Color(0xFFF59E0B),
    //   secondaryDark: const Color(0xFFFB7185),
    //   surfaceDark: const Color(0xFF231908),
    //   backgroundDark: const Color(0xFF0B0704),
    //   textPrimaryDark: Colors.white,
    //   textSecondaryDark: const Color(0xFFFFE8A8),
    //   nounsSurface: const Color(0xFF1A120D),
    //   accentTeal: const Color(0xFFF97316),
    // ),
  ];

  ColorSchemeData get currentScheme => colorSchemes[selectedSchemeIndex.value];

  // Unified app theme that switches between light & dark using isDarkMode.
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
            )
          : ColorScheme.light(
              primary: currentScheme.accentTeal,
              secondary: currentScheme.accentTeal,
              surface: currentScheme.surface,
              background: currentScheme.background,
            ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? currentScheme.backgroundDark
            : currentScheme.background,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : currentScheme.textPrimary,
      ),
      iconTheme: IconThemeData(
        color: isDark ? Colors.white : currentScheme.textPrimary,
      ),
      dividerColor: (isDark ? Colors.white54 : Colors.black12),
      cardTheme: CardThemeData(
        color: (isDark ? Colors.white.withOpacity(0.03) : Colors.white),
        surfaceTintColor: Colors.transparent,
        shadowColor: (isDark ? Colors.black : Colors.black12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: (isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: currentScheme.accentTeal,
          foregroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: currentScheme.accentTeal),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.03)
            : currentScheme.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : Colors.black.withOpacity(0.06),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: currentScheme.accentTeal),
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : currentScheme.textPrimary,
        ),
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : currentScheme.textSecondary,
        ),
      ),
      textTheme: GoogleFonts.patrickHandTextTheme(text).apply(
        bodyColor: isDark ? Colors.white : currentScheme.textPrimary,
        displayColor: isDark ? Colors.white : currentScheme.textPrimary,
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
