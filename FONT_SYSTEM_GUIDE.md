# Centralized Font System Guide

## Overview
All fonts in the app are now managed through the `ThemeService`. This ensures consistency and makes it easy to change fonts globally.

## Accessing Fonts

### Method 1: Using ThemeService directly (Recommended for new code)

```dart
import 'package:get/get.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final textColor = /* your color */;

    return Text(
      'My Headline',
      style: themeService.getHeadlineMediumStyle(color: textColor),
    );
  }
}
```

### Method 2: For simple cases - Just the font family

```dart
final themeService = Get.find<ThemeService>();

Text(
  'Hello',
  style: TextStyle(
    fontSize: 16,
    fontFamily: themeService.fontFamily,
    color: Colors.black,
  ),
)
```

## Available Style Methods

### Headline Styles
- `getHeadlineStyle(color)` - 32pt, bold
- `getHeadlineLargeStyle(color)` - 28pt, bold
- `getHeadlineMediumStyle(color)` - 24pt, bold
- `getHeadlineSmallStyle(color)` - 20pt, w600

### Title Styles
- `getTitleStyle(color)` - 22pt, w600
- `getTitleLargeStyle(color)` - 22pt, w600
- `getTitleMediumStyle(color)` - 18pt, w600
- `getTitleSmallStyle(color)` - 16pt, w500

### Body Styles
- `getBodyStyle(color)` - 16pt, normal
- `getBodyLargeStyle(color)` - 16pt, normal
- `getBodyMediumStyle(color)` - 14pt, normal
- `getBodySmallStyle(color)` - 12pt, normal

### Label Styles
- `getLabelStyle(color)` - 12pt, w500
- `getLabelLargeStyle(color)` - 14pt, w600
- `getLabelMediumStyle(color)` - 12pt, w600
- `getLabelSmallStyle(color)` - 11pt, w500

### Custom Style
```dart
themeService.getStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.black,
  height: 1.5,
  letterSpacing: 0.5,
)
```

## Migration Path

### Before (Old Way):
```dart
Text(
  'Title',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: GoogleFonts.patrickHand().fontFamily,
  ),
)
```

### After (New Way):
```dart
Text(
  'Title',
  style: themeService.getTitleMediumStyle(color: textColor),
)
```

## Changing Fonts Globally

To change the font for the entire app, simply modify the `FontScheme` in `theme_service.dart`:

```dart
// In ThemeService class
late FontScheme fontScheme = FontScheme(
  primaryFont: 'Roboto', // Change to different font
  // ... other customizations
);
```

## Font Families Used
- **Primary Font**: Patrick Hand (Google Fonts)
- All text in the app uses this centralized system

## Benefits
✅ Consistency across the entire app
✅ Easy global font changes
✅ Type-safe style application
✅ Reactive to theme changes
✅ Single source of truth for typography
