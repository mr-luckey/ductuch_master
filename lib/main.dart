import 'package:ductuch_master/Constants/colors.dart';
import 'package:ductuch_master/FrontEnd/screen/controller/lesson_controller.dart';
import 'package:ductuch_master/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6), // Primary blue
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFF6B7280),
          background: const Color(0xFFF8FAFC),
        ),
        useMaterial3: true,
      ),

      debugShowCheckedModeBanner: false,

      initialRoute: AppRoutes.home,
      getPages: AppRoutes.routes,
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Lingua - Listen & Learn',
//       theme: ThemeData(fontFamily: 'Inter', useMaterial3: true),
//       home: const PhraseScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
