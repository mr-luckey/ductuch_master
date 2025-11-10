import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/learn_module/learn_repository.dart';

class LearningPathData {
  static Map<String, LevelInfo> get levelInfo => LearnRepository.levelInfo;

  // Topics for each module (Level → Module → Topic)
  static Map<String, List<String>> get moduleTopics =>
      LearnRepository.moduleTopics;
}
