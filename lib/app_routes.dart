import 'package:ductuch_master/frontend/screens/lessons/A1/a1_lesson.dart';
import 'package:ductuch_master/frontend/screens/lessons/A2/a2_lesson.dart';
import 'package:ductuch_master/frontend/screens/lessons/B1/b1_lesson.dart';
import 'package:ductuch_master/frontend/screens/lessons/B2/b2_lesson.dart';
import 'package:ductuch_master/frontend/screens/lessons/C1/c1_lesson.dart';
import 'package:ductuch_master/frontend/screens/lessons/C2/c2_lesson.dart';
import 'package:ductuch_master/frontend/screens/home/home_screen.dart';
import 'package:ductuch_master/frontend/screens/level/level_screen.dart';
import 'package:ductuch_master/frontend/screens/main_navigation.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const mainNavigation = '/';
  static const home = '/home';
  static const second = '/second';
  static const lessonA1 = '/lesson/a1';
  static const lessonA2 = '/lesson/a2';
  static const lessonB1 = '/lesson/b1';
  static const lessonB2 = '/lesson/b2';
  static const lessonC1 = '/lesson/c1';
  static const lessonC2 = '/lesson/c2';

  static final routes = [
    GetPage(name: mainNavigation, page: () => const MainNavigation()),
    GetPage(name: home, page: () => HomePage()),
    GetPage(
      name: second,
      page: () {
        // Get the level argument from route
        final args = Get.arguments;
        String level = '';
        if (args is String) {
          level = args;
        } else if (args is Map) {
          level = args['level']?.toString() ?? '';
        }
        return LevelScreen(level: level);
      },
    ),
    // Separate routes for each level's lesson screen
    GetPage(
      name: lessonA1,
      page: () {
        final args = Get.arguments;
        String moduleId = '';
        if (args is Map) {
          moduleId = args['moduleId']?.toString() ?? '';
        } else if (args is String) {
          moduleId = args;
        }
        return A1LessonScreen(
          moduleId: moduleId.isNotEmpty ? moduleId : 'A1-M1',
        );
      },
    ),
    GetPage(
      name: lessonA2,
      page: () {
        final args = Get.arguments;
        String moduleId = '';
        if (args is Map) {
          moduleId = args['moduleId']?.toString() ?? '';
        } else if (args is String) {
          moduleId = args;
        }
        return A2LessonScreen(
          moduleId: moduleId.isNotEmpty ? moduleId : 'A2-M5',
        );
      },
    ),
    GetPage(
      name: lessonB1,
      page: () {
        final args = Get.arguments;
        String moduleId = '';
        if (args is Map) {
          moduleId = args['moduleId']?.toString() ?? '';
        } else if (args is String) {
          moduleId = args;
        }
        return B1LessonScreen(
          moduleId: moduleId.isNotEmpty ? moduleId : 'B1-M9',
        );
      },
    ),
    GetPage(
      name: lessonB2,
      page: () {
        final args = Get.arguments;
        String moduleId = '';
        if (args is Map) {
          moduleId = args['moduleId']?.toString() ?? '';
        } else if (args is String) {
          moduleId = args;
        }
        return B2LessonScreen(
          moduleId: moduleId.isNotEmpty ? moduleId : 'B2-M13',
        );
      },
    ),
    GetPage(
      name: lessonC1,
      page: () {
        // C1LessonScreen doesn't require moduleId currently
        return const C1LessonScreen();
      },
    ),
    GetPage(
      name: lessonC2,
      page: () {
        final args = Get.arguments;
        String moduleId = '';
        if (args is Map) {
          moduleId = args['moduleId']?.toString() ?? '';
        } else if (args is String) {
          moduleId = args;
        }
        return C2LessonScreen(
          moduleId: moduleId.isNotEmpty ? moduleId : 'C2-M1',
        );
      },
    ),
  ];
}
