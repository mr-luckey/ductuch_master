import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubmoduleCard extends StatefulWidget {
  final ModuleInfo moduleInfo;
  final VoidCallback? onTap;

  const SubmoduleCard({super.key, required this.moduleInfo, this.onTap});

  @override
  State<SubmoduleCard> createState() => _SubmoduleCardState();
}

class _SubmoduleCardState extends State<SubmoduleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: ThemeService.defaultCurve,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final secondaryColor = isDark ? scheme.secondaryDark : scheme.secondary;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;

      return MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _isHovered = true);
          _animationController.forward();
        },
        onExit: (_) {
          setState(() => _isHovered = false);
          _animationController.reverse();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                gradient: themeService.getCardGradient(isDark),
                boxShadow: ThemeService.getCardShadow(isDark),
                border: Border.all(
                  color: primaryColor.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onTap,
                  borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context)),
                  splashColor: primaryColor.withOpacity(0.2),
                  highlightColor: primaryColor.withOpacity(0.1),
                  child: Padding(
                    padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Animated Icon Container
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
                          duration: ThemeService.defaultAnimationDuration,
                          curve: ThemeService.springCurve,
                          builder: (context, value, child) {
                            return Transform.rotate(
                              angle: value * 0.1,
                              child: Transform.scale(
                                scale: 1.0 + (value * 0.1),
                                child: Container(
                                  width: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                                  height: ResponsiveHelper.isDesktop(context) ? 64 : ResponsiveHelper.isTablet(context) ? 60 : 56,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        primaryColor.withOpacity(0.2),
                                        secondaryColor.withOpacity(0.15),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: Offset(0, 4 * value),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.moduleInfo.icon,
                                    color: primaryColor,
                                    size: ResponsiveHelper.isDesktop(context) ? 32 : ResponsiveHelper.isTablet(context) ? 30 : 28,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context)),
                        // Title with Hero animation
                        Hero(
                          tag: 'submodule_${widget.moduleInfo.ID}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.moduleInfo.title,
                              style: themeService
                                  .getTitleMediumStyle(color: textColor)
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: ResponsiveHelper.getTitleSize(context),
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.5),
                        // Subtle accent line
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: _isHovered ? 1.0 : 0.0),
                          duration: ThemeService.defaultAnimationDuration,
                          builder: (context, value, child) {
                            return Container(
                              height: ResponsiveHelper.getProgressBarHeight(context) * 0.3,
                              width: (ResponsiveHelper.getSpacing(context) * 2.5) * value,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, secondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
