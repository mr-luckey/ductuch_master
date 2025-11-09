import 'package:ductuch_master/FrontEnd/screen/nouns/nouns_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/verbs/verbs_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/sentences/sentences_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/learn/learn_screen.dart';
import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final ThemeService themeService = Get.find<ThemeService>();

  final List<Widget> _screens = [
    const NounsScreen(),
    const VerbsScreen(),
    const SentencesScreen(),
    const LearnScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final selectedColor = isDark ? scheme.primaryDark : scheme.primary;
      final unselectedColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;

      return Scaffold(
        backgroundColor: backgroundColor,
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark
                ? scheme.surfaceDark.withOpacity(0.8)
                : scheme.surface.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.book_outlined,
                    activeIcon: Icons.book,
                    label: 'Nouns',
                    index: 0,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    icon: Icons.auto_awesome_outlined,
                    activeIcon: Icons.auto_awesome,
                    label: 'Verbs',
                    index: 1,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    icon: Icons.chat_bubble_outline,
                    activeIcon: Icons.chat_bubble,
                    label: 'Sentences',
                    index: 2,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                  _buildNavItem(
                    icon: Icons.school_outlined,
                    activeIcon: Icons.school,
                    label: 'Learn',
                    index: 3,
                    selectedColor: selectedColor,
                    unselectedColor: unselectedColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color selectedColor,
    required Color unselectedColor,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? selectedColor : unselectedColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? selectedColor : unselectedColor,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
