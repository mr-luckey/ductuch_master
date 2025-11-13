import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/backend/models/level_model.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
    final padding = ResponsiveHelper.getPadding(context);
    final titleSize = ResponsiveHelper.getHeadlineSize(context);
    final spacing = ResponsiveHelper.getSpacing(context);

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildContentSection(
                    context,
                    themeService,
                    scheme,
                    textColor,
                    primaryColor,
                    secondaryColor,
                    padding,
                    titleSize,
                    spacing,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContentSection(
    BuildContext context,
    ThemeService themeService,
    ColorSchemeData scheme,
    Color textColor,
    Color primaryColor,
    Color secondaryColor,
    double padding,
    double titleSize,
    double spacing,
  ) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Animated Title with gradient
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: ThemeService.slowAnimationDuration,
            curve: ThemeService.springCurve,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: Opacity(
                  opacity: value.clamp(0.0, 1.0),
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [primaryColor, secondaryColor],
                    ).createShader(bounds),
                    child: Text(
                      'Your Learning Path',
                      style: themeService.getStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: spacing),
          _buildLevelsGrid(context),
        ],
      ),
    );
  }

  Widget _buildLevelsGrid(BuildContext context) {
    final levels = LevelModel.mockLevels;
    final spacing = ResponsiveHelper.getSpacing(context);
    final aspectRatio = ResponsiveHelper.getCardAspectRatio(context);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.isDesktop(context) ? 2 : 1,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: aspectRatio,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(
            milliseconds: 300 + (index * 100),
          ),
          curve: ThemeService.springCurve,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: GestureDetector(
                  onTap: levels[index].ontap,
                  child: LevelCard(level: levels[index]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
