import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ductuch_master/backend/data/learning_path_data.dart';

class LessonController extends GetxController {
  /// Topic IDs that are fully completed (e.g., 'A1-M1-T1')
  final RxList<String> completedLessons = <String>[].obs;

  /// Map of topicId -> set of listened phrase indices within that topic
  final RxMap<String, Set<int>> _listenedByTopic = <String, Set<int>>{}.obs;

  /// Levels that have been passed via exam (e.g., 'A1', 'A2')
  final RxSet<String> _passedLevels = <String>{}.obs;

  /// Progress indices for verbs, nouns, sentences
  final RxInt verbsIndex = 0.obs;
  final RxInt nounsIndex = 0.obs;
  final RxInt sentencesIndex = 0.obs;
  final RxInt practiceIndex = 0.obs;

  static const String _prefsKeyCompletedLessons = 'completed_lessons';
  static const String _prefsKeyListenedByTopic = 'listened_by_topic';
  static const String _prefsKeyPassedLevels = 'passed_levels';
  static const String _prefsKeyVerbsIndex = 'verbs_index';
  static const String _prefsKeyNounsIndex = 'nouns_index';
  static const String _prefsKeySentencesIndex = 'sentences_index';
  static const String _prefsKeyPracticeIndex = 'practice_index';

  @override
  void onInit() {
    super.onInit();
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load completed lessons
      final completedList = prefs.getStringList(_prefsKeyCompletedLessons) ?? [];
      completedLessons.value = completedList;
      
      // Load listened by topic
      final listenedJson = prefs.getString(_prefsKeyListenedByTopic);
      if (listenedJson != null) {
        final Map<String, dynamic> decoded = json.decode(listenedJson);
        _listenedByTopic.value = decoded.map(
          (key, value) => MapEntry(key, (value as List).cast<int>().toSet()),
        );
      }
      
      // Load passed levels
      final passedList = prefs.getStringList(_prefsKeyPassedLevels) ?? [];
      _passedLevels.clear();
      _passedLevels.addAll(passedList);
      
      // Load progress indices
      verbsIndex.value = prefs.getInt(_prefsKeyVerbsIndex) ?? 0;
      nounsIndex.value = prefs.getInt(_prefsKeyNounsIndex) ?? 0;
      sentencesIndex.value = prefs.getInt(_prefsKeySentencesIndex) ?? 0;
      practiceIndex.value = prefs.getInt(_prefsKeyPracticeIndex) ?? 0;
    } catch (e) {
      print('Error loading state: $e');
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save completed lessons
      await prefs.setStringList(_prefsKeyCompletedLessons, completedLessons.toList());
      
      // Save listened by topic
      final listenedMap = _listenedByTopic.map(
        (key, value) => MapEntry(key, value.toList()),
      );
      await prefs.setString(_prefsKeyListenedByTopic, json.encode(listenedMap));
      
      // Save passed levels
      await prefs.setStringList(_prefsKeyPassedLevels, _passedLevels.toList());
      
      // Save progress indices
      await prefs.setInt(_prefsKeyVerbsIndex, verbsIndex.value);
      await prefs.setInt(_prefsKeyNounsIndex, nounsIndex.value);
      await prefs.setInt(_prefsKeySentencesIndex, sentencesIndex.value);
      await prefs.setInt(_prefsKeyPracticeIndex, practiceIndex.value);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  void markLessonCompleted(String lessonId) {
    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
      _saveState();
    }
  }

  bool isLessonCompleted(String lessonId) {
    return completedLessons.contains(lessonId);
  }

  /// Mark a phrase within a topic as listened.
  /// If all phrases for the topic are listened, mark the lesson completed.
  void markPhraseListened({
    required String topicId,
    required int phraseIndex,
    required int totalPhrases,
  }) {
    final set = _listenedByTopic[topicId] ?? <int>{};
    set.add(phraseIndex);
    _listenedByTopic[topicId] = set;
    _saveState();

    if (set.length >= totalPhrases) {
      markLessonCompleted(topicId);
    }
  }

  /// Whether a specific phrase in a topic has been listened.
  bool isPhraseListened(String topicId, int phraseIndex) {
    final set = _listenedByTopic[topicId];
    if (set == null) return false;
    return set.contains(phraseIndex);
  }

  /// Number of listened phrases for a topic.
  int listenedCountForTopic(String topicId) {
    return _listenedByTopic[topicId]?.length ?? 0;
  }

  /// Compute total topics for a given level (A1, A2, ...), based on LearningPathData
  int totalTopicsForLevel(String level) {
    final levelUpper = level.toUpperCase();
    int total = 0;
    LearningPathData.moduleTopics.forEach((moduleId, topics) {
      if (moduleId.toUpperCase().startsWith(levelUpper)) {
        total += topics.length;
      }
    });
    return total;
  }

  /// Compute completed topics for a given level.
  int completedTopicsForLevel(String level) {
    final levelUpper = level.toUpperCase();
    return completedLessons.where((topicId) => topicId.toUpperCase().startsWith(levelUpper)).length;
  }

  /// Progress percentage for a level (0-100).
  int levelProgressPercent(String level) {
    final total = totalTopicsForLevel(level);
    if (total == 0) return 0;
    final done = completedTopicsForLevel(level);
    return ((done / total) * 100).floor();
  }

  /// Mark level as passed (after exam result)
  void markLevelPassed(String level) {
    _passedLevels.add(level.toUpperCase());
    _saveState();
  }

  /// Update verbs progress index
  void updateVerbsIndex(int index) {
    verbsIndex.value = index;
    _saveState();
  }

  /// Update nouns progress index
  void updateNounsIndex(int index) {
    nounsIndex.value = index;
    _saveState();
  }

  /// Update sentences progress index
  void updateSentencesIndex(int index) {
    sentencesIndex.value = index;
    _saveState();
  }

  /// Update practice progress index
  void updatePracticeIndex(int index) {
    practiceIndex.value = index;
    _saveState();
  }

  bool isLevelPassed(String level) {
    return _passedLevels.contains(level.toUpperCase());
  }
}


