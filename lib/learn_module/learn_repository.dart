import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:ductuch_master/Utilities/Models/model.dart';

class LearnRepository {
  static Map<String, LevelInfo> _levelInfo = {};
  static Map<String, List<String>> _moduleTopics = {};
  static Map<String, List<Map<String, dynamic>>> _topicPhrases = {};
  static bool _initialized = false;

  static Map<String, LevelInfo> get levelInfo {
    return _levelInfo;
  }

  static Map<String, List<String>> get moduleTopics {
    return _moduleTopics;
  }
  static List<Map<String, dynamic>>? getPhrasesRaw(String topicId) {
    return _topicPhrases[topicId];
  }

  static Future<void> init() async {
    if (_initialized) return;
    final List<String> levels = ['A1', 'A2', 'B1', 'B2'];
    for (final levelId in levels) {
      final jsonStr =
          await rootBundle.loadString('assets/learn_module/$levelId.json');
      final Map<String, dynamic> data = json.decode(jsonStr);
      _ingestLevelJson(data);
    }
    _initialized = true;
  }

  static void _ingestLevelJson(Map<String, dynamic> jsonMap) {
    final String id = jsonMap['id'];
    final String title = jsonMap['title'];
    final String description = jsonMap['description'];
    final int progress = jsonMap['progress'] ?? 0;
    final List<dynamic> modules = jsonMap['modules'] ?? [];
    final List<ModuleInfo> moduleInfos = [];

    for (final m in modules) {
      final String moduleId = m['id'];
      final String moduleTitle = m['title'];
      final String iconName = m['icon'] ?? '';
      final List<dynamic> topics = (m['topics'] ?? []) as List<dynamic>;
      _moduleTopics[moduleId] = topics.map((e) => e.toString()).toList();
      moduleInfos.add(
        ModuleInfo(
          ID: moduleId,
          title: moduleTitle,
          lessonCount: topics.length,
          completedLessons: 0,
          icon: _iconFromName(iconName),
          isLocked: false,
        ),
      );
    }

    _levelInfo[id.toLowerCase()] = LevelInfo(
      ID: id,
      title: title,
      description: description,
      progress: progress,
      modules: moduleInfos,
    );

    // Optional phrases content under "content"
    final Map<String, dynamic>? content =
        (jsonMap['content'] as Map?)?.cast<String, dynamic>();
    if (content != null) {
      content.forEach((topicId, value) {
        final List<dynamic> rawList = (value as List<dynamic>);
        _topicPhrases[topicId] = rawList
            .map((e) => (e as Map).map((k, v) => MapEntry(k.toString(), v)))
            .cast<Map<String, dynamic>>()
            .toList();
      });
    }
  }

  static IconData _iconFromName(String name) {
    switch (name) {
      case 'waving_hand':
        return Icons.waving_hand;
      case 'person':
        return Icons.person;
      case 'home':
        return Icons.home;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'schedule':
        return Icons.schedule;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'favorite':
        return Icons.favorite;
      case 'flight':
        return Icons.flight;
      case 'business_center':
        return Icons.business_center;
      case 'newspaper':
        return Icons.newspaper;
      case 'theater_comedy':
        return Icons.theater_comedy;
      case 'psychology':
        return Icons.psychology;
      case 'precision_manufacturing':
        return Icons.precision_manufacturing;
      case 'science':
        return Icons.science;
      case 'chat_bubble_outline':
        return Icons.chat_bubble_outline;
      case 'edit_note':
        return Icons.edit_note;
      default:
        return Icons.menu_book;
    }
  }
}

