import 'package:ductuch_master/FrontEnd/screen/learn/learn_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/nouns/nouns_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/verbs/verbs_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/sentences/sentences_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/more/more_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late PersistentTabController _controller;

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

    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = colorScheme.primary;
    final unselectedColor = Colors.white70;
    final navBarColor = colorScheme.surface.withOpacity(0.95);

    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _buildNavBarItems(
        selectedColor: selectedColor,
        unselectedColor: unselectedColor,
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
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      navBarStyle: NavBarStyle.style1,
      navBarHeight: navBarHeight,
    );
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
    required double iconSize,
    required double fontSize,
  }) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.school_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Learn',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.book_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Nouns',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.auto_awesome_outlined, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Verbs',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.chat_bubble_outline, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'Sentences',
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.more_horiz, size: iconSize),
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        title: 'More',
      ),
    ];
  }
}
