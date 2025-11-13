import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/backend/models/level_model.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelsOverviewScreen extends StatefulWidget {
  const LevelsOverviewScreen({super.key});

  @override
  State<LevelsOverviewScreen> createState() => _LevelsOverviewScreenState();
}

class _LevelsOverviewScreenState extends State<LevelsOverviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ThemeService.slowAnimationDuration,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final background = isDark ? scheme.backgroundDark : scheme.background;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final secondaryText = isDark
          ? scheme.textSecondaryDark
          : scheme.textSecondary;
      final accent = scheme.accentTeal;

      return Scaffold(
        backgroundColor: background,

        // appBar: AppBar(
        //   backgroundColor: background,
        //   elevation: 0,
        //   title: Text(
        //     'Levels',
        //     style: themeService
        //         .getTitleLargeStyle(color: textColor)
        //         .copyWith(fontWeight: FontWeight.bold),
        //   ),
        // ),
        body: SafeArea(
          child: FadeTransition(
            opacity: CurvedAnimation(parent: _controller, curve: Curves.easeIn),
            child: ListView.separated(
              padding: ResponsiveHelper.getButtonPadding(context),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeaderCard(
                    themeService: themeService,
                    textColor: textColor,
                    secondaryText: secondaryText,
                    accent: accent,
                    isDark: isDark,
                  );
                }
                final level = LevelModel.mockLevels[index - 1];
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 350 + (index * 60)),
                  curve: ThemeService.springCurve,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(24 * (1 - value), 0),
                      child: Opacity(
                        opacity: value.clamp(0.0, 1.0),
                        child: child,
                      ),
                    );
                  },
                  child: LevelCard(level: level),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: ResponsiveHelper.getSpacing(context) * 1.125),
              itemCount: LevelModel.mockLevels.length + 1,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildHeaderCard({
    required ThemeService themeService,
    required Color textColor,
    required Color secondaryText,
    required Color accent,
    required bool isDark,
  }) {
    final scheme = themeService.currentScheme;
    final primary = isDark ? scheme.primaryDark : scheme.primary;

    return Container(
      padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 1.2),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.14), accent.withOpacity(0.12)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: primary.withOpacity(0.25), width: 1.5),
        boxShadow: ThemeService.getCardShadow(isDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                height: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.9),
                  gradient: LinearGradient(
                    colors: [
                      accent.withOpacity(0.3),
                      primary.withOpacity(0.25),
                    ],
                  ),
                  border: Border.all(color: accent.withOpacity(0.45), width: 2),
                ),
                child: Icon(Icons.map_outlined, color: accent, size: ResponsiveHelper.getIconSize(context)),
              ),
              SizedBox(width: ResponsiveHelper.getSpacing(context)),
              Expanded(
                child: Text(
                  'Choose your next milestone',
                  style: themeService
                      .getTitleMediumStyle(color: textColor)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.875),
          Text(
            'Browse all CEFR-aligned levels, track what you\'ve completed, and dive deeper into the skills you need most.',
            style: themeService.getBodyMediumStyle(
              color: secondaryText.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}
