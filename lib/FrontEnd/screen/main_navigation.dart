import 'package:ductuch_master/FrontEnd/screen/nouns/nouns_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/verbs/verbs_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/sentences/sentences_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/more/more_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/Levels/levels_overview_screen.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/frontend/screens/learn/learn_screen.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:get/get.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with SingleTickerProviderStateMixin {
  late PersistentTabController _controller;
  final ThemeService themeService = Get.find<ThemeService>();
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navBarHeight = ResponsiveHelper.isDesktop(context)
        ? 90.0
        : ResponsiveHelper.isTablet(context)
            ? 80.0
            : 70.0;
    final iconSize = ResponsiveHelper.getIconSize(context);
    final fontSize = ResponsiveHelper.getSmallSize(context);
    final borderRadius = ResponsiveHelper.getBorderRadius(context);

    return Obx(() {
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;

      final selectedColor = isDark ? scheme.primaryDark : scheme.primary;
      final unselectedColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final navBarColor = isDark ? scheme.surfaceDark : scheme.surface;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

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
          primaryColor: primaryColor,
        ),
        backgroundColor: navBarColor,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border.all(color: primaryColor.withOpacity(0.2), width: 1.5),
        ),
        navBarStyle: NavBarStyle.style9,
        navBarHeight: navBarHeight,
      );
    });
  }

  List<Widget> _buildScreens() {
    return [
      const LearnScreen(),
      const LevelsOverviewScreen(),
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
    required Color primaryColor,
  }) {
    return [
      PersistentBottomNavBarItem(
        icon: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _controller.index == 0 ? _pulseAnimation.value : 1.0,
              child: Icon(Icons.school_outlined, size: iconSize),
            );
          },
        ),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Learn',
        textStyle: themeService.getStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.layers_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Levels',
        textStyle: themeService.getStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.book_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Nouns',
        textStyle: themeService.getStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.auto_awesome_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Verbs',
        textStyle: themeService.getStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.chat_bubble_outline, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Sentences',
        textStyle: themeService.getStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.more_horiz, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'More',
        textStyle: themeService.getStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
  }
}
