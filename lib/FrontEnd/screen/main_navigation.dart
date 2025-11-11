import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/frontend/screens/learn/learn_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/nouns/nouns_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/verbs/verbs_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/sentences/sentences_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/more/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:get/get.dart';
// import 'package:ductuch_master/services/theme_service.dart'; // Import the theme service

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late PersistentTabController _controller;
  final ThemeService themeService =
      Get.find<ThemeService>(); // Get theme service

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final navBarHeight = isTablet ? 80.0 : 70.0;
    final iconSize = isTablet ? 28.0 : 24.0;
    final fontSize = isTablet ? 13.0 : 11.0;

    return Obx(() {
      // Use Obx to react to theme changes
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;

      // Get colors based on current theme mode
      final selectedColor = isDark ? scheme.primaryDark : scheme.primary;
      final unselectedColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final navBarColor = isDark ? scheme.surfaceDark : scheme.surface;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _buildNavBarItems(
          selectedColor: selectedColor,
          unselectedColor: unselectedColor,
          textColor: textColor,
          iconSize: iconSize,
          fontSize: fontSize,
        ),
        backgroundColor: navBarColor,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTablet ? 20 : 16),
            topRight: Radius.circular(isTablet ? 20 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: textColor.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border.all(
            color: isDark
                ? scheme.backgroundDark.withOpacity(0.1)
                : scheme.background.withOpacity(0.1),
            width: 1,
          ),
        ),
        navBarStyle: NavBarStyle.style9,
        navBarHeight: navBarHeight,
      );
    });
  }

  List<Widget> _buildScreens() {
    return [
      const LearnScreen(),
      const NounsScreen(),
      const VerbsScreen(),
      const SentencesScreen(),
      const MoreScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _buildNavBarItems({
    required Color selectedColor,
    required Color unselectedColor,
    required Color textColor,
    required double iconSize,
    required double fontSize,
  }) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.school_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Learn',
        textStyle: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.patrickHand().fontFamily,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.book_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Nouns',
        textStyle: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.patrickHand().fontFamily,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.auto_awesome_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Verbs',
        textStyle: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.patrickHand().fontFamily,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.chat_bubble_outline, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Sentences',
        textStyle: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.patrickHand().fontFamily,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.more_horiz, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'More',
        textStyle: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontFamily: GoogleFonts.patrickHand().fontFamily,
        ),
      ),
    ];
  }
}
