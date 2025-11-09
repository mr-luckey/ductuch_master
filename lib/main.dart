import 'package:ductuch_master/FrontEnd/screen/controller/lesson_controller.dart';
import 'package:ductuch_master/app_routes.dart';
import 'package:ductuch_master/Utilities/Services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final LessonController lessonController = Get.put(LessonController());
  final ThemeService themeService = Get.put(ThemeService());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = themeService.isDarkMode.value;
      final scheme = themeService.currentScheme;

      return GetMaterialApp(
        title: 'DeutschMaster',
        theme: ThemeData(
          fontFamily: GoogleFonts.patrickHand().fontFamily,
          brightness: Brightness.light,
          primaryColor: scheme.primary,
          scaffoldBackgroundColor: scheme.background,
          colorScheme: ColorScheme.light(
            primary: scheme.primary,
            secondary: scheme.secondary,
            surface: scheme.surface,
            background: scheme.background,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: scheme.textPrimary,
          ),
        ),
        darkTheme: ThemeData(
          fontFamily: GoogleFonts.patrickHand().fontFamily,
          brightness: Brightness.dark,
          primaryColor: scheme.primaryDark,
          scaffoldBackgroundColor: scheme.backgroundDark,
          colorScheme: ColorScheme.dark(
            primary: scheme.primaryDark,
            secondary: scheme.secondaryDark,
            surface: scheme.surfaceDark,
            background: scheme.backgroundDark,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
        ),
        themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.mainNavigation,
        getPages: AppRoutes.routes,
      );
    });
  }
}
