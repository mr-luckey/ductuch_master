import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/Utilities/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatsCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
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
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: ThemeService.defaultAnimationDuration,
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: ResponsiveHelper.getSpacing(context) * 0.5, vertical: ResponsiveHelper.getSpacing(context) * 0.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.8),
            gradient: themeService.getCardGradient(isDark),
            border: Border.all(
              color: _isHovered
                  ? widget.iconColor.withOpacity(0.6)
                  : borderColor,
              width: _isHovered ? 2 : 1.5,
            ),
            boxShadow: _isHovered
                ? [
                    ...ThemeService.getCardShadow(isDark),
                    BoxShadow(
                      color: widget.iconColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : ThemeService.getCardShadow(isDark),
          ),
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.05 : 1.0),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveHelper.getCardPadding(context) * 0.8),
            child: Row(
              children: [
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context) * 0.625),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.iconColor.withOpacity(0.3),
                          widget.iconColor.withOpacity(0.15),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(ResponsiveHelper.getBorderRadius(context) * 0.6),
                      border: Border.all(
                        color: widget.iconColor.withOpacity(0.5),
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
                SizedBox(width: ResponsiveHelper.getSpacing(context) * 0.75),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.label,
                        style: themeService.getBodySmallStyle(
                          color: secondaryTextColor,
                        ),
                      ),
                      SizedBox(height: ResponsiveHelper.getSpacing(context) * 0.25),
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 600),
                        curve: ThemeService.springCurve,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Opacity(
                              opacity: value.clamp(0.0, 1.0),
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: [textColor, widget.iconColor],
                                ).createShader(bounds),
                                child: Text(
                                  widget.value,
                                  style: themeService
                                      .getHeadlineSmallStyle(color: Colors.white)
                                      .copyWith(
                                    fontWeight: FontWeight.bold,
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
            ),
          ),
        ),
      );
    });
  }
}
