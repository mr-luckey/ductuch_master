import 'package:ductuch_master/FrontEnd/screen/exam/exam_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/practice/practice_screen.dart';
import 'package:ductuch_master/FrontEnd/screen/categories/categories_list_screen.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/navigation_helper.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: ThemeService.slowAnimationDuration,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final isSmallScreen = ResponsiveHelper.isMobile(context);

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;

      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;

      return Scaffold(
        backgroundColor: backgroundColor,

        // appBar: AppBar(
        //   backgroundColor: backgroundColor,
        //   elevation: 0,
        //   title: Hero(
        //     tag: 'more_title',
        //     child: Material(
        //       color: Colors.transparent,
        //       child: Text(
        //         'More',
        //         style: themeService.getTitleLargeStyle(color: textColor)
        //             .copyWith(
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //   ),
        //   actions: [const TtsSpeedDropdown()],
        // ),
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > 500
                        ? 500
                        : constraints.maxWidth,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth > 500 ? 20 : 16,
                    vertical: constraints.maxWidth > 500 ? 30 : 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.25),
                      // Animated header
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: ThemeService.defaultAnimationDuration,
                        curve: ThemeService.springCurve,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [textColor, primaryColor],
                                    ).createShader(bounds),
                                    child: Text(
                                      'More Options',
                                      style: themeService
                                          .getHeadlineSmallStyle(
                                            color: Colors.white,
                                          )
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                  SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.75),
                                  Text(
                                    'Explore additional learning features',
                                    style: themeService.getBodyMediumStyle(
                                      color: textColor.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.5),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildOptionCard(
                              context,
                              'Exam',
                              'Test your knowledge with timed exams',
                              Icons.quiz,
                              () => NavigationHelper.pushWithBottomNav(
                                context,
                                const ExamScreen(),
                              ),
                              isSmallScreen,
                              scheme,
                              isDark,
                              0,
                              themeService,
                            ),
                            SizedBox(height: ResponsiveHelper.getSpacing(context)),
                            _buildOptionCard(
                              context,
                              'Practice',
                              'Practice without time limits',
                              Icons.park_rounded,
                              () => NavigationHelper.pushWithBottomNav(
                                context,
                                const PracticeScreen(),
                              ),
                              isSmallScreen,
                              scheme,
                              isDark,
                              1,
                              themeService,
                            ),
                            SizedBox(height: ResponsiveHelper.getSpacing(context)),
                            _buildOptionCard(
                              context,
                              'Categories',
                              'Learn words by category',
                              Icons.category,
                              () => NavigationHelper.pushWithBottomNav(
                                context,
                                const CategoriesListScreen(),
                              ),
                              isSmallScreen,
                              scheme,
                              isDark,
                              2,
                              themeService,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    bool isSmallScreen,
    scheme,
    bool isDark,
    int index,
    ThemeService themeService,
  ) {
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
    final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: ThemeService.springCurve,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - value), 0),
          child: Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                gradient: LinearGradient(
                  colors: [
                    surfaceColor.withOpacity(0.05),
                    surfaceColor.withOpacity(0.02),
                  ],
                ),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                  splashColor: primaryColor.withOpacity(0.2),
                  highlightColor: primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                    child: Row(
                      children: [
                        // Animated Icon Container
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: ThemeService.defaultAnimationDuration,
                          curve: ThemeService.bounceCurve,
                          builder: (context, iconValue, child) {
                            return Transform.scale(
                              scale: iconValue,
                              child: Container(
                                width: isSmallScreen ? 56 : 64,
                                height: isSmallScreen ? 56 : 64,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      primaryColor.withOpacity(0.3),
                                      secondaryColor.withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                                  border: Border.all(
                                    color: primaryColor.withOpacity(0.4),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryColor.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  icon,
                                  color: primaryColor,
                                  size: isSmallScreen ? 28 : 32,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: ResponsiveHelper.getSpacing(context) * 1.25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: themeService
                                    .getTitleMediumStyle(color: textColor)
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.25),
                              Text(
                                subtitle,
                                style: themeService.getBodySmallStyle(
                                  color: textColor.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor.withOpacity(0.7),
                          size: isSmallScreen ? 18 : 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
