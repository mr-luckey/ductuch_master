import 'package:flutter/material.dart';

class LevelInfo {
  final ID;
  final String title;
  final String description;
  final int progress;
  final List<ModuleInfo> modules;

  LevelInfo({
    required this.ID,
    required this.title,
    required this.description,
    required this.progress,
    required this.modules,
  });
}

class ModuleInfo {
  final ID;
  final String title;
  final int lessonCount;
  final int completedLessons;
  final IconData icon;
  final bool isLocked;

  ModuleInfo({
    required this.ID,
    required this.title,
    required this.lessonCount,
    required this.completedLessons,
    required this.icon,
    required this.isLocked,
  });
}

class SubModuleInfo {
  final ID;
  final String title;
  final int lessonCount;
  final int completedLessons;
  final IconData icon;
  final bool isLocked;

  SubModuleInfo({
    required this.ID,
    required this.title,
    required this.lessonCount,
    required this.completedLessons,
    required this.icon,
    required this.isLocked,
  });
}
