import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final padding = isTablet ? 24.0 : 16.0;
    final spacing = isTablet ? 32.0 : 24.0;

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Learn')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 800 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Learning Path',
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose a level to start learning',
                  style: textTheme.bodyLarge?.copyWith(
                    color: textTheme.bodyLarge?.color?.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: spacing),
                _buildLevelsList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelsList(BuildContext context) {
    final levels = LevelModel.mockLevels;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return LevelCard(level: levels[index]);
      },
      separatorBuilder: (context, _) => SizedBox(height: 16),
    );
  }
}
