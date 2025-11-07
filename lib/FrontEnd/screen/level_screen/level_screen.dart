import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:ductuch_master/FrontEnd/screen/level_screen/widget/module_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
// import 'package:go_router/go_router.dart';
// import '../widgets/module_card.dart';
// import '../models/level_model.dart';

class LevelScreen extends StatelessWidget {
  final String level;

  const LevelScreen({super.key, this.level = ''});

  @override
  Widget build(BuildContext context) {
    final levelInfo = {
      'a1': LevelInfo(
        title: 'A1 - Beginner',
        description: '',
        ID: 'A1',

        progress: 75,
        modules: [
          ModuleInfo(
            ID: 'A1-L1',
            title: 'Basics & Greetings',
            lessonCount: 5,
            completedLessons:
                3, //I need to update this veriable when we press enter on the screen
            //add an ID on ead module
            //Pass that ID to the nxt screen to load the data according to that ID
            icon: Icons.book,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A1-L2',

            title: 'Numbers & Time',
            lessonCount: 5,
            completedLessons: 4,
            icon: Icons.calendar_today,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A1-L3',

            title: 'Family & People',
            lessonCount: 5,
            completedLessons: 3,
            icon: Icons.people,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A1-L4',

            title: 'Food & Dining',
            lessonCount: 5,
            completedLessons: 2,
            icon: Icons.restaurant,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A1-L5',

            title: 'Daily Routine',
            lessonCount: 5,
            completedLessons: 1,
            icon: Icons.home,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A1-L6',
            title: 'City & Directions',
            lessonCount: 5,
            completedLessons: 0,
            icon: Icons.location_on,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A1-L7',
            title: 'Animals & Nature',
            lessonCount: 5,
            completedLessons: 0,
            icon: Icons.nature,
            isLocked: true,
          ),
          ModuleInfo(
            ID: 'A1-L8',
            title: 'A1 Final Review',
            lessonCount: 5,
            completedLessons: 0,
            icon: Icons.emoji_events,
            isLocked: true,
          ),
        ],
      ),
      'a2': LevelInfo(
        ID: 'A2',
        title: 'A2 - Elementary',
        description: '',
        progress: 30,
        modules: [
          ModuleInfo(
            ID: 'A2-L1',
            title: 'Travel & Transportation',
            lessonCount: 5,
            completedLessons: 4,
            icon: Icons.location_on,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A2-L2',
            title: 'Shopping & Services',
            lessonCount: 5,
            completedLessons: 2,
            icon: Icons.shopping_cart,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A2-L3',
            title: 'Health & Body',
            lessonCount: 5,
            completedLessons: 0,
            icon: Icons.health_and_safety,
            isLocked: false,
          ),
          ModuleInfo(
            ID: 'A2-L4',
            title: 'Hobbies & Leisure',
            lessonCount: 5,
            completedLessons: 0,
            icon: Icons.sports_esports,
            isLocked: true,
          ),
        ],
      ),
    };

    final currentLevel = levelInfo[level] ?? levelInfo['a1']!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final module = currentLevel.modules[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ModuleCard(
                      moduleInfo: module,
                      onTap: () {
                        Get.toNamed(
                          '/lesson',
                          arguments: {'moduleId': module.ID},
                        );
                        // Navigate to module details or lessons
                        // Example: Get.to(ModuleDetailScreen(moduleId: module.ID));
                      },
                    ),
                  );
                }, childCount: currentLevel.modules.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
