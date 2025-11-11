# Font System Migration TODO

## Completed
- ✅ Created `FontScheme` class in theme_service.dart
- ✅ Added `FontScheme` properties to `ThemeService`
- ✅ Added helper methods to `ThemeService` for easy font access
- ✅ Created FONT_SYSTEM_GUIDE.md documentation

## Screens to Migrate (Priority Order)

### High Priority - Most Common Screens
- [ ] lib/FrontEnd/screen/C1/C1_lesson.dart
  - Replace all `GoogleFonts.patrickHand().fontFamily` with `themeService.fontFamily`
  - Replace heading styles with `getTitleMediumStyle()` or `getHeadlineMediumStyle()`
  - Replace body text with `getBodyMediumStyle()` or `getBodySmallStyle()`

- [ ] lib/FrontEnd/screen/C2/C2_lesson.dart
  - Same pattern as C1_lesson.dart

- [ ] lib/FrontEnd/screen/A1/A1_lesson.dart
  - Same pattern as C1_lesson.dart

- [ ] lib/FrontEnd/screen/level_screen/widget/module_card.dart
  - Replace all `GoogleFonts.patrickHand().fontFamily` occurrences
  - Update title, progress text, percentage text to use theme fonts

### Medium Priority - Feature Screens
- [ ] lib/FrontEnd/screen/sentences/sentences_screen.dart
  - Mix of `GoogleFonts.patrickHand()` and `Theme.of(context).textTheme`
  - Standardize to use `themeService` methods

- [ ] lib/FrontEnd/screen/categories/category_screen.dart
  - Already partially using `Theme.of(context).textTheme`
  - Replace with `themeService` methods

- [ ] lib/FrontEnd/screen/practice/practice_screen.dart
  - Already partially using `Theme.of(context).textTheme`
  - Replace with `themeService` methods

### Lower Priority - Navigation & Home
- [ ] lib/FrontEnd/screen/main_navigation.dart
  - Replace all `GoogleFonts.patrickHand().fontFamily` with `themeService.fontFamily`

- [ ] lib/FrontEnd/screen/Home/home_Screen.dart
  - Replace `GoogleFonts.patrickHand()` style with `themeService.getTitleStyle()`

- [ ] lib/FrontEnd/screen/Home/Widget/welcome_card.dart
  - Replace `Theme.of(context).textTheme` with `themeService` methods

- [ ] lib/FrontEnd/screen/Home/Widget/level_card.dart
  - If exists, migrate to new system

- [ ] lib/FrontEnd/screen/A1/A1_lesson.dart
  - Already listed in High Priority

- [ ] lib/FrontEnd/screen/A1/widget/submodule_card.dart
  - Check and migrate if needed

### Other Screens
- [ ] lib/FrontEnd/screen/categories/categories_list_screen.dart
  - Replace Theme.of() calls with themeService methods

- [ ] lib/FrontEnd/screen/Home/Widget/progress_circle.dart
  - Check and migrate if needed

- [ ] lib/FrontEnd/screen/Home/Widget/streak_counter.dart
  - Check and migrate if needed

- [ ] lib/Utilities/Widgets/tts_speed_dropdown.dart
  - Check and migrate if needed

## Migration Pattern Example

### Before:
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

### After (Option 1 - Using pre-built styles):
```dart
Text(
  'Title',
  style: themeService.getTitleMediumStyle(color: textColor),
)
```

### After (Option 2 - Using fontFamily only):
```dart
Text(
  'Title',
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textColor,
    fontFamily: themeService.fontFamily,
  ),
)
```

## Notes
- After each screen is migrated, verify no compile errors
- Test that fonts render correctly on different devices
- The FontScheme can be extended with more style variations as needed
- Consider migrating in batches to minimize disruption
