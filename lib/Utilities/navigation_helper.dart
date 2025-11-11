import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

/// Helper class for navigation that maintains bottom navigation bar
class NavigationHelper {
  /// Navigate to a screen while maintaining bottom navigation
  static void pushWithBottomNav(
    BuildContext context,
    Widget screen, {
    bool withNavBar = true,
    dynamic arguments,
  }) {
    if (withNavBar && context.findAncestorWidgetOfExactType<PersistentTabView>() != null) {
      // If we're in a PersistentTabView context, use pushNewScreen
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: screen,
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    } else {
      // Fallback to regular GetX navigation
      if (arguments != null) {
        Get.to(() => screen, arguments: arguments);
      } else {
        Get.to(() => screen);
      }
    }
  }

  /// Navigate and replace current screen
  static void pushReplacementWithBottomNav(
    BuildContext context,
    Widget screen, {
    bool withNavBar = true,
  }) {
    if (withNavBar && context.findAncestorWidgetOfExactType<PersistentTabView>() != null) {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: screen,
        withNavBar: true,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
      // Pop the previous screen
      Navigator.of(context).pop();
    } else {
      Get.off(() => screen);
    }
  }
}

