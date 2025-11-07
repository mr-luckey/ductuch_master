import 'package:ductuch_master/FrontEnd/screen/A1/A1_lesson.dart';
import 'package:ductuch_master/FrontEnd/screen/Home/home_Screen.dart';
import 'package:ductuch_master/FrontEnd/screen/level_screen/level_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const home = '/';
  static const second = '/second';

  static final routes = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: second, page: () => LevelScreen()),
    GetPage(
      name: '/lesson',
      page: () => A1LessonScreen(moduleId: Get.arguments['moduleId'] ?? ''),
    ),
    // GetPage(name: second, page: () => const SecondScreen()),
  ];
}
