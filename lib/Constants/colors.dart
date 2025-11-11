// DEPRECATED: This file is deprecated. All colors and styling should now use ThemeService.
// See lib/backend/services/theme_service.dart for the new centralized theme system.
// This file is kept for backward compatibility but should not be used in new code.

import 'package:flutter/material.dart';

class AppColors {
  // DEPRECATED: Use ThemeService instead
  @Deprecated('Use ThemeService.getSuccessColor() instead')
  static const Color success = Color(0xFF4CAF50);
  
  @Deprecated('Use ThemeService.getErrorColor() instead')
  static const Color error = Color(0xFFF44336);
  
  @Deprecated('Use ThemeService.getWarningColor() instead')
  static const Color warning = Color(0xFFFFC107);
  
  @Deprecated('Use ThemeService.getInfoColor() instead')
  static const Color info = Color(0xFF03A9F4);
}
