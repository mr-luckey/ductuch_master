import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/app_routes.dart';
import 'package:ductuch_master/backend/services/tts_service.dart';
import 'package:ductuch_master/backend/repository/learn_repository.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LearnRepository.init();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final LessonController lessonController = Get.put(LessonController());
  final TtsService ttsService = Get.put(TtsService());
  final ThemeService themeService = Get.put(ThemeService());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DeutschMaster',
      theme: themeService.appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.mainNavigation,
      getPages: AppRoutes.routes,
    );
  }
}
