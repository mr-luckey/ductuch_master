import 'package:get/get.dart';
import 'package:ductuch_master/backend/data/learning_path_data.dart';

class LessonController extends GetxController {
  /// Topic IDs that are fully completed (e.g., 'A1-M1-T1')
  final RxList<String> completedLessons = <String>[].obs;

  /// Map of topicId -> set of listened phrase indices within that topic
  final RxMap<String, Set<int>> _listenedByTopic = <String, Set<int>>{}.obs;

  /// Levels that have been passed via exam (e.g., 'A1', 'A2')
  final RxSet<String> _passedLevels = <String>{}.obs;

  void markLessonCompleted(String lessonId) {
    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
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
  }

  bool isLevelPassed(String level) {
    return _passedLevels.contains(level.toUpperCase());
  }
}


