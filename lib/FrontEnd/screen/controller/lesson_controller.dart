// controllers/lesson_controller.dart
import 'package:get/get.dart';

class LessonController extends GetxController {
  var completedLessons = <String>[].obs;

  void markLessonCompleted(String lessonId) {
    if (!completedLessons.contains(lessonId)) {
      completedLessons.add(lessonId);
    }
  }

  bool isLessonCompleted(String lessonId) {
    return completedLessons.contains(lessonId);
  }
}
