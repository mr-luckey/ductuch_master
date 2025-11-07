import 'package:ductuch_master/FrontEnd/screen/controller/lesson_controller.dart';
import 'package:ductuch_master/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final LessonController lessonController = Get.put(LessonController());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DeutschMaster',
      theme: ThemeData(
        fontFamily: GoogleFonts.patrickHand().fontFamily,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F14),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF10B981),
          brightness: Brightness.dark,
          primary: const Color(0xFF10B981),
          secondary: const Color(0xFF38BDF8),
          surface: const Color(0xFF111722),
          background: const Color(0xFF0B0F14),
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
        ),
      ),

      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
