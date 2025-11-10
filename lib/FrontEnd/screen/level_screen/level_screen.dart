import 'package:ductuch_master/Data/learning_path_data.dart';
import 'package:ductuch_master/FrontEnd/screen/level_screen/widget/module_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class LevelScreen extends StatelessWidget {
  final String level;

  const LevelScreen({super.key, this.level = ''});

  @override
  Widget build(BuildContext context) {
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

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.chevron_left,
                                color: textTheme.titleLarge?.color ?? Colors.white,
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
                                    color: textTheme.titleLarge?.color ?? Colors.white,
                                    fontFamily:
                                        GoogleFonts.patrickHand().fontFamily,
                                  ),
                                ),
                                if (currentLevel.description.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    currentLevel.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: textTheme.bodyMedium?.color?.withOpacity(0.8),
                                      fontFamily:
                                          GoogleFonts.patrickHand().fontFamily,
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
                          color: textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Coming Soon',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textTheme.titleLarge?.color ?? Colors.white,
                            fontFamily: GoogleFonts.patrickHand().fontFamily,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This level is under development',
                          style: TextStyle(
                            fontSize: 14,
                            color: textTheme.bodyMedium?.color?.withOpacity(0.8),
                            fontFamily: GoogleFonts.patrickHand().fontFamily,
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
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      );
  }
}
