import 'package:ductuch_master/FrontEnd/screen/Home/Widget/level_card.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F14),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [_buildContentSection(context)]),
        ),
      ),
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Your Learning Path',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontFamily: GoogleFonts.patrickHand().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
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
