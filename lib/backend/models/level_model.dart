import 'dart:ui';

import 'package:get/route_manager.dart';

class LevelModel {
  final String level;
  final String title;
  final int moduleCount;
  final int lessonCount;
  final int progress;
  final bool isLocked;
  final Color primaryColor;
  final Function()? ontap;

  const LevelModel({
    required this.level,
    required this.title,
    required this.moduleCount,
    required this.lessonCount,
    required this.progress,
    required this.isLocked,
    required this.primaryColor,
    this.ontap,
  });

  static List<LevelModel> get mockLevels => [
    LevelModel(
      level: 'A1',
      title: 'Beginner',
      moduleCount: 4,
      lessonCount: 15, // 3+4+4+4 topics
      progress: 0,
      isLocked: false,
      ontap: () {
        Get.toNamed('/second', arguments: 'a1');
      },
      primaryColor: const Color(0xFF3B82F6),
    ),
    LevelModel(
      level: 'A2',
      title: 'Elementary',
      moduleCount: 4,
      lessonCount: 16, // 4 topics each
      progress: 0,
      isLocked: false,
      ontap: () {
        Get.toNamed('/second', arguments: 'a2');
      },
      primaryColor: const Color(0xFFF59E0B),
    ),
    LevelModel(
      level: 'B1',
      title: 'Intermediate',
      moduleCount: 4,
      lessonCount: 16, // 4 topics each
      progress: 0,
      isLocked: false,
      ontap: () {
        Get.toNamed('/second', arguments: 'b1');
      },
      primaryColor: const Color(0xFF10B981),
    ),
    LevelModel(
      level: 'B2',
      title: 'Upper Intermediate',
      moduleCount: 4,
      lessonCount: 16, // 4 topics each
      progress: 0,
      ontap: () {
        Get.toNamed('/second', arguments: 'b2');
      },
      isLocked: false,
      primaryColor: const Color(0xFF8B5CF6),
    ),
    LevelModel(
      level: 'C1',
      title: 'Advanced',
      moduleCount: 0, // Empty for now
      lessonCount: 0,
      progress: 0,
      ontap: () {
        Get.toNamed('/second', arguments: 'c1');
      },
      isLocked: false,
      primaryColor: const Color(0xFFEC4899),
    ),
    LevelModel(
      level: 'C2',
      title: 'Mastery',
      moduleCount: 0, // Empty for now
      lessonCount: 0,
      ontap: () {
        Get.toNamed('/second', arguments: 'c2');
      },
      progress: 0,
      isLocked: false,
      primaryColor: const Color(0xFFEF4444),
    ),
  ];
}


