import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const QuickActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  State<QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<QuickActionCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: ThemeService.defaultAnimationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: ThemeService.springCurve,
      ),
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final scheme = themeService.currentScheme;
    final isDark = themeService.isDarkMode.value;
    final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
    final secondaryTextColor = isDark ? scheme.textSecondaryDark : scheme.textSecondary;
    final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
    final borderColor = primaryColor.withOpacity(0.2);
    
    return Obx(() {
      return ScaleTransition(
        scale: _scaleAnimation,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: ThemeService.defaultAnimationDuration,
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context), vertical: ResponsiveHelper.getSpacing(context) * 0.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
                gradient: themeService.getCardGradient(isDark),
                border: Border.all(
                  color: _isHovered
                      ? primaryColor.withOpacity(0.5)
                      : borderColor,
                  width: _isHovered ? 2 : 1.5,
                ),
                boxShadow: _isHovered
                    ? [
                        ...ThemeService.getCardShadow(isDark),
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : ThemeService.getCardShadow(isDark),
              ),
              transform: Matrix4.identity()
                ..scale(_isHovered ? 1.02 : 1.0),
              child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context) * 0.8),
                child: Row(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 400),
                      curve: ThemeService.bounceCurve,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Transform.rotate(
                            angle: _isHovered ? 0.1 : 0.0,
                            child: Container(
                              padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) * 0.75),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.backgroundColor.withOpacity(0.3),
                                    widget.iconColor.withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.6),
                                border: Border.all(
                                  color: widget.iconColor.withOpacity(0.4),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.iconColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: widget.iconColor,
                                size: ResponsiveHelper.getIconSize(context),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: ResponsiveHelper.getSpacing(context)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: themeService.getTitleMediumStyle(
                              color: textColor,
                            ).copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.25),
                          Text(
                            widget.description,
                            style: themeService.getBodySmallStyle(
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
