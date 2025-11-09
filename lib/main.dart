import 'package:ductuch_master/FrontEnd/screen/controller/lesson_controller.dart';
import 'package:ductuch_master/app_routes.dart';
import 'package:ductuch_master/Utilities/Services/tts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final LessonController lessonController = Get.put(LessonController());
  final TtsService ttsService = Get.put(TtsService());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DeutschMaster',
      theme: ThemeData(
        fontFamily: GoogleFonts.patrickHand().fontFamily,
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Colors.white70,
          surface: Color(0xFF0B0F14),
          background: Color(0xFF0B0F14),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0F14),
          elevation: 0,
          foregroundColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.mainNavigation,
      getPages: AppRoutes.routes,
    );
  }
}
