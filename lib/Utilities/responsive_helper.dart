import 'package:flutter/material.dart';

/// Responsive helper utility for consistent sizing across different screen sizes
class ResponsiveHelper {
  /// Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Get screen size information
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  /// Check if device is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context).width < mobileBreakpoint;
  }

  /// Check if device is tablet
  static bool isTablet(BuildContext context) {
    final width = getScreenSize(context).width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if device is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context).width >= desktopBreakpoint;
  }

  /// Get responsive padding
  static double getPadding(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get responsive horizontal padding
  static double getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) return 40.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get responsive vertical padding
  static double getVerticalPadding(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 20.0;
  }

  /// Get responsive spacing
  static double getSpacing(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 24.0;
    return 16.0;
  }

  /// Get responsive font size multiplier
  static double getFontMultiplier(BuildContext context) {
    if (isDesktop(context)) return 1.2;
    if (isTablet(context)) return 1.1;
    return 1.0;
  }

  /// Get responsive headline font size
  static double getHeadlineSize(BuildContext context) {
    if (isDesktop(context)) return 40.0;
    if (isTablet(context)) return 32.0;
    return 28.0;
  }

  /// Get responsive title font size
  static double getTitleSize(BuildContext context) {
    if (isDesktop(context)) return 28.0;
    if (isTablet(context)) return 24.0;
    return 20.0;
  }

  /// Get responsive subtitle font size
  static double getSubtitleSize(BuildContext context) {
    if (isDesktop(context)) return 20.0;
    if (isTablet(context)) return 18.0;
    return 16.0;
  }

  /// Get responsive body font size
  static double getBodySize(BuildContext context) {
    if (isDesktop(context)) return 18.0;
    if (isTablet(context)) return 16.0;
    return 14.0;
  }

  /// Get responsive small font size
  static double getSmallSize(BuildContext context) {
    if (isDesktop(context)) return 14.0;
    if (isTablet(context)) return 12.0;
    return 11.0;
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context) {
    if (isDesktop(context)) return 32.0;
    if (isTablet(context)) return 28.0;
    return 24.0;
  }

  /// Get responsive small icon size
  static double getSmallIconSize(BuildContext context) {
    if (isDesktop(context)) return 20.0;
    if (isTablet(context)) return 18.0;
    return 16.0;
  }

  /// Get responsive card padding
  static double getCardPadding(BuildContext context) {
    if (isDesktop(context)) return 28.0;
    if (isTablet(context)) return 24.0;
    return 20.0;
  }

  /// Get responsive border radius
  static double getBorderRadius(BuildContext context) {
    if (isDesktop(context)) return 28.0;
    if (isTablet(context)) return 24.0;
    return 20.0;
  }

  /// Get responsive button height
  static double getButtonHeight(BuildContext context) {
    if (isDesktop(context)) return 56.0;
    if (isTablet(context)) return 52.0;
    return 48.0;
  }

  /// Get responsive button padding
  static EdgeInsets getButtonPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0);
    }
    if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 28.0, vertical: 14.0);
    }
    return const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0);
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }

  /// Get responsive card height
  static double getCardHeight(BuildContext context, {double baseHeight = 180.0}) {
    if (isDesktop(context)) return baseHeight * 1.2;
    if (isTablet(context)) return baseHeight * 1.1;
    return baseHeight;
  }

  /// Get responsive width percentage
  static double getWidthPercentage(BuildContext context, double percentage) {
    return getScreenSize(context).width * (percentage / 100);
  }

  /// Get responsive height percentage
  static double getHeightPercentage(BuildContext context, double percentage) {
    return getScreenSize(context).height * (percentage / 100);
  }

  /// Get max content width (for centering content on large screens)
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200.0;
    if (isTablet(context)) return 800.0;
    return double.infinity;
  }

  /// Get responsive aspect ratio for cards
  static double getCardAspectRatio(BuildContext context) {
    if (isDesktop(context)) return 1.5;
    if (isTablet(context)) return 1.4;
    return 1.3;
  }

  /// Get responsive progress bar height
  static double getProgressBarHeight(BuildContext context) {
    if (isDesktop(context)) return 10.0;
    if (isTablet(context)) return 9.0;
    return 8.0;
  }
}

