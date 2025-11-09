import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../FrontEnd/screen/categories/category_data.dart';
import '../FrontEnd/screen/categories/category_screen.dart';
import '../FrontEnd/screen/verbs/verbs_screen.dart';
import '../FrontEnd/screen/nouns/nouns_screen.dart';
import '../FrontEnd/screen/sentences/sentences_screen.dart';
import '../FrontEnd/screen/practice/practice_screen.dart';
import '../FrontEnd/screen/exam/exam_screen.dart';

/// Data loader class to load JSON data files
class DataLoader {
  static Future<List<CategoryInfo>> loadCategories() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/Data/json/categories_data.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((item) {
        final iconName = item['icon'] as String;
        IconData icon;
        switch (iconName) {
          case 'apple':
            icon = Icons.apple;
            break;
          case 'eco':
            icon = Icons.eco;
            break;
          case 'construction':
            icon = Icons.construction;
            break;
          case 'calendar_today':
            icon = Icons.calendar_today;
            break;
          case 'wb_sunny':
            icon = Icons.wb_sunny;
            break;
          case 'calendar_month':
            icon = Icons.calendar_month;
            break;
          case 'home':
            icon = Icons.home;
            break;
          case 'category':
            icon = Icons.category;
            break;
          default:
            icon = Icons.category;
        }

        final words = (item['words'] as List).map((word) {
          return CategoryWord(
            german: word['german'] as String,
            english: word['english'] as String,
          );
        }).toList();

        return CategoryInfo(
          name: item['name'] as String,
          icon: icon,
          words: words,
        );
      }).toList();
    } catch (e) {
      print('Error loading categories: $e');
      return [];
    }
  }

  static Future<List<VerbData>> loadVerbs() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/Data/json/verbs_data.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((item) {
        return VerbData(
          infinitive: item['infinitive'] as String,
          english: item['english'] as String,
          conjugation: item['conjugation'] as String,
          examples: (item['examples'] as List).map((e) => e as String).toList(),
        );
      }).toList();
    } catch (e) {
      print('Error loading verbs: $e');
      return [];
    }
  }

  static Future<List<NounData>> loadNouns() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/Data/json/nouns_data.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((item) {
        return NounData(
          singular: item['singular'] as String,
          plural: item['plural'] as String,
          english: item['english'] as String,
          meaning: item['meaning'] as String?,
        );
      }).toList();
    } catch (e) {
      print('Error loading nouns: $e');
      return [];
    }
  }

  static Future<List<SentenceData>> loadSentences() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/Data/json/sentences_data.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((item) {
        return SentenceData(
          german: item['german'] as String,
          english: item['english'] as String,
          meaning: item['meaning'] as String?,
        );
      }).toList();
    } catch (e) {
      print('Error loading sentences: $e');
      return [];
    }
  }

  static Future<List<PracticeItem>> loadPracticeItems() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/Data/json/practice_data.json',
      );
      final List<dynamic> jsonData = json.decode(jsonString);

      return jsonData.map((item) {
        return PracticeItem(
          german: item['german'] as String,
          english: item['english'] as String,
          meaning: item['meaning'] as String?,
          type: item['type'] as String,
          examples: item['examples'] != null
              ? (item['examples'] as List).map((e) => e as String).toList()
              : null,
        );
      }).toList();
    } catch (e) {
      print('Error loading practice items: $e');
      return [];
    }
  }

  static Future<Map<String, List<ExamQuestion>>> loadExamQuestions() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'lib/Data/json/exam_questions_data.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final Map<String, List<ExamQuestion>> questions = {};

      jsonData.forEach((level, levelQuestions) {
        questions[level] = (levelQuestions as List).map((item) {
          return ExamQuestion(
            question: item['question'] as String,
            options: (item['options'] as List).map((o) => o as String).toList(),
            correctAnswerIndex: item['correctAnswerIndex'] as int,
            explanation: item['explanation'] as String?,
          );
        }).toList();
      });

      return questions;
    } catch (e) {
      print('Error loading exam questions: $e');
      return {};
    }
  }
}
