import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'progress_circle.dart';
import 'streak_counter.dart';

class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});

  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: ThemeService.springCurve,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;

    return Obx(() {
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondaryTextColor = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final borderColor = primaryColor.withOpacity(0.2);

      return FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
              gradient: themeService.getCardGradient(isDark),
              border: Border.all(color: borderColor, width: 1.5),
              boxShadow: ThemeService.getCardShadow(isDark),
            ),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
              child: Column(
                children: [
                  // Welcome Message and Button
                  _buildWelcomeSection(
                    context,
                    themeService,
                    scheme,
                    isDark,
                    textColor,
                    secondaryTextColor,
                    primaryColor,
                  ),
                  SizedBox(height: ResponsiveHelper.getSpacing(context)),
                  // Progress and Streak
                  _buildProgressSection(
                    context,
                    themeService,
                    scheme,
                    isDark,
                    secondaryTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildWelcomeSection(
    BuildContext context,
    ThemeService themeService,
    dynamic scheme,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
    Color primaryColor,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 400),
                curve: ThemeService.springCurve,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [textColor, primaryColor],
                        ).createShader(bounds),
                        child: Text(
                          'Welcome back! 👋',
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
              const SizedBox(height: 8),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 500),
                curve: ThemeService.springCurve,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Text(
                      'Keep your streak going and continue your German journey',
                      style: themeService.getBodyMediumStyle(
                        color: secondaryTextColor,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600),
                curve: ThemeService.bounceCurve,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to levels
                        },
                        child: Container(
                          padding: ResponsiveHelper.getButtonPadding(context),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, scheme.accentTeal],
                            ),
                            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.6),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_arrow, size: ResponsiveHelper.getSmallIconSize(context), color: Colors.white),
                              SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.5),
                              Text(
                                'Continue Learning',
                                style: themeService.getBodyMediumStyle(
                                  color: Colors.white,
                                ).copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    ThemeService themeService,
    dynamic scheme,
    bool isDark,
    Color secondaryTextColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 700),
          curve: ThemeService.springCurve,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  children: [
                    Text(
                      'Daily Goal',
                      style: themeService.getBodySmallStyle(
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                    ProgressCircle(progress: 60, size: ResponsiveHelper.isDesktop(context) ? 100 : ResponsiveHelper.isTablet(context) ? 90 : 80),
                  ],
                ),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 800),
          curve: ThemeService.springCurve,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  children: [
                    Text(
                      'Streak',
                      style: themeService.getBodySmallStyle(
                        color: secondaryTextColor,
                      ),
                    ),
                    SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                    StreakCounter(days: 12, size: StreakSize.large),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
