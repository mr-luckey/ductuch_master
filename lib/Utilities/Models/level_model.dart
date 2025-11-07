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
      moduleCount: 8,
      lessonCount: 40,
      progress: 75,
      isLocked: false,
      ontap: () {
        Get.toNamed('/second', arguments: 'A1');
      },
      primaryColor: const Color(0xFF3B82F6),
    ),
    LevelModel(
      level: 'A2',
      title: 'Elementary',
      moduleCount: 8,
      lessonCount: 40,
      progress: 30,
      isLocked: false,
      ontap: () {
        Get.toNamed('/second', arguments: 'A2');
      },
      primaryColor: const Color(0xFFF59E0B),
    ),
    LevelModel(
      level: 'B1',
      title: 'Intermediate',
      moduleCount: 8,
      lessonCount: 40,
      progress: 0,
      isLocked: true,
      ontap: () {
        Get.toNamed('/second', arguments: 'B1');
      },
      primaryColor: const Color(0xFF10B981),
    ),
    LevelModel(
      level: 'B2',
      title: 'Upper Intermediate',
      moduleCount: 8,
      lessonCount: 40,
      progress: 0,
      ontap: () {
        Get.toNamed('/second', arguments: 'B2');
      },
      isLocked: true,
      primaryColor: const Color(0xFF8B5CF6),
    ),
    LevelModel(
      level: 'C1',
      title: 'Advanced',
      moduleCount: 8,
      lessonCount: 40,
      progress: 0,
      ontap: () {
        Get.toNamed('/second', arguments: 'C1');
      },
      isLocked: true,
      primaryColor: const Color(0xFFEC4899),
    ),
    LevelModel(
      level: 'C2',
      title: 'Mastery',
      moduleCount: 8,
      lessonCount: 40,
      ontap: () {
        Get.toNamed('/second', arguments: 'C2');
      },
      progress: 0,
      isLocked: true,
      primaryColor: const Color(0xFFEF4444),
    ),
  ];
}
