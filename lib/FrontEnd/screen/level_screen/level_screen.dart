import 'package:ductuch_master/backend/data/learning_path_data.dart';
import 'package:ductuch_master/backend/services/theme_service.dart';
import 'package:ductuch_master/FrontEnd/screen/level_screen/widget/module_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ductuch_master/controllers/lesson_controller.dart';
import 'package:ductuch_master/FrontEnd/screen/exam/exam_screen.dart';

class LevelScreen extends StatelessWidget {
  final String level;

  const LevelScreen({super.key, this.level = ''});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    final lessonController = Get.find<LessonController>();
    // Get level from constructor or route arguments
    String currentLevelKey = level;
    if (currentLevelKey.isEmpty) {
      final args = Get.arguments;
      if (args is String) {
        currentLevelKey = args;
      } else if (args is Map) {
        currentLevelKey = args['level']?.toString() ?? '';
      }
    }

    // Normalize to lowercase for lookup
    currentLevelKey = currentLevelKey.toLowerCase();

    // Get the level info, default to 'a1' if not found
    final currentLevel =
        LearningPathData.levelInfo[currentLevelKey] ??
        LearningPathData.levelInfo['a1']!;

    print(
      'LevelScreen: Displaying level "$currentLevelKey" with ${currentLevel.modules.length} modules',
    );

    final levelCodeUpper = currentLevelKey.toUpperCase();
    final progressPercent = lessonController.levelProgressPercent(
      levelCodeUpper,
    );
    final allDone = progressPercent >= 100;

    return Obx(() {
      final scheme = themeService.currentScheme;
      final isDark = themeService.isDarkMode.value;
      final textColor = isDark ? scheme.textPrimaryDark : scheme.textPrimary;
      final primaryColor = isDark ? scheme.primaryDark : scheme.primary;
      final surfaceColor = isDark ? scheme.surfaceDark : scheme.surface;
      final backgroundColor = isDark
          ? scheme.backgroundDark
          : scheme.background;

      return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button and title row
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: textColor.withOpacity(0.1),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.chevron_left,
                                color: textColor,
                                size: 22,
                              ),
                              padding: const EdgeInsets.all(6),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentLevel.title,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontFamily: Theme.of(
                                      context,
                                    ).textTheme.headlineMedium?.fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                          color: surfaceColor.withOpacity(0.08),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: (progressPercent / 100)
                                              .clamp(0.0, 1.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: primaryColor.withOpacity(
                                                0.7,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$progressPercent%',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textColor.withOpacity(0.8),
                                        fontFamily: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                                if (currentLevel.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    currentLevel.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textColor.withOpacity(0.8),
                                      fontFamily: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.fontFamily,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Modules list or empty state
              if (currentLevel.modules.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.construction,
                          size: 64,
                          color: textColor.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.fontFamily,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This level is under development',
                          style: TextStyle(
                            fontSize: 14,
                            color: textColor.withOpacity(0.8),
                            fontFamily: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
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
                            print('Tapping module: ${module.ID}');

                            // Determine the route based on the module's level prefix
                            String route = '/lesson/a1'; // default fallback

                            // Extract level from module ID (e.g., "A1-M1" -> "A1")
                            final moduleLevel = module.ID
                                .split('-')
                                .first
                                .toUpperCase();

                            switch (moduleLevel) {
                              case 'A1':
                                route = '/lesson/a1';
                                break;
                              case 'A2':
                                route = '/lesson/a2';
                                break;
                              case 'B1':
                                route = '/lesson/b1';
                                break;
                              case 'B2':
                                route = '/lesson/b2';
                                break;
                              case 'C1':
                                route = '/lesson/c1';
                                break;
                              case 'C2':
                                route = '/lesson/c2';
                                break;
                              default:
                                print(
                                  'Warning: Unknown module level "$moduleLevel", defaulting to A1',
                                );
                                route = '/lesson/a1';
                            }

                            print(
                              'Navigating to route: $route with moduleId: ${module.ID}',
                            );

                            Get.toNamed(
                              route,
                              arguments: {'moduleId': module.ID},
                            );
                          },
                        ),
                      );
                    }, childCount: currentLevel.modules.length),
                  ),
                ),
              if (allDone)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: textColor.withOpacity(0.1)),
                        color: primaryColor.withOpacity(0.12),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => const ExamScreen(),
                              arguments: {'level': levelCodeUpper},
                            );
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.assignment_turned_in,
                                  color: primaryColor,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Take Exam for $levelCodeUpper',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                      fontFamily: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.fontFamily,
                                    ),
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: primaryColor),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      );
    });
  }
}
