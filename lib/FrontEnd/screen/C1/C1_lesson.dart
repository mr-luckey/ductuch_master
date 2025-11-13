import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class C1LessonScreen extends StatefulWidget {
  const C1LessonScreen({super.key});

  @override
  State<C1LessonScreen> createState() => _C1LessonScreenState();
}

class _C1LessonScreenState extends State<C1LessonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
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
    _rotationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final themeService = Get.find<ThemeService>();
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Rotating icon
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: ThemeService.defaultAnimationDuration,
                    curve: ThemeService.bounceCurve,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: RotationTransition(
                          turns: _rotationController,
                          child: Container(
                            width: ResponsiveHelper.isDesktop(context) ? 140 : ResponsiveHelper.isTablet(context) ? 130 : 120,
                            height: ResponsiveHelper.isDesktop(context) ? 140 : ResponsiveHelper.isTablet(context) ? 130 : 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor.withOpacity(0.3),
                                  secondaryColor.withOpacity(0.2),
                                ],
                              ),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.4),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.construction,
                              size: ResponsiveHelper.isDesktop(context) ? 70 : ResponsiveHelper.isTablet(context) ? 65 : 60,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context) * 2),
                  // Title with gradient
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 600),
                    curve: ThemeService.springCurve,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [textColor, primaryColor],
                            ).createShader(bounds),
                            child: Text(
                              'Coming Soon',
                              style: themeService
                                  .getHeadlineMediumStyle(color: Colors.white)
                                  .copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context)),
                  // Subtitle
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 800),
                    curve: ThemeService.springCurve,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: Text(
                          'This level is under development',
                          style: themeService.getBodyLargeStyle(
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
