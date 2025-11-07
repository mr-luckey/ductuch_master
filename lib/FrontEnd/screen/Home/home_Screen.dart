import 'package:ductuch_master/Constants/FontStyle.dart';
import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/FrontEnd/screen/Home/Widget/quick_action_card.dart';
import 'package:ductuch_master/FrontEnd/screen/Home/Widget/stats_card.dart';
import 'package:ductuch_master/FrontEnd/screen/Home/Widget/welcome_card.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        child: Column(children: [_buildContentSection(context)]),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          Text('Your Learning Path', style: CustomStylee().Mainheadingstyle),
          const SizedBox(height: 16),
          _buildLevelsGrid(),
        ],
      ),
    );
  }

  Widget _buildLevelsGrid() {
    final levels = LevelModel.mockLevels;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: levels[index].ontap,
          child: LevelCard(level: levels[index]),
        );
      },
    );
  }
}
