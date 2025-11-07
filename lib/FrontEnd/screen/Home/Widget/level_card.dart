import 'package:ductuch_master/Constants/FontStyle.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:flutter/material.dart';
// import '../models/level_model.dart';

class LevelCard extends StatelessWidget {
  final LevelModel level;

  const LevelCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: level.isLocked ? 1 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              level.primaryColor.withOpacity(0.2),
              level.primaryColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Level badge and title
                  _buildHeader(context),
                  const Spacer(),
                  // Progress and module info
                  _buildFooter(),
                ],
              ),
            ),
            // if (level.isLocked) _buildLockedOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: level.primaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              level.level,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(level.title, style: CustomStylee().MainStyle),
              const SizedBox(height: 4),
              Text(
                '${level.moduleCount} modules · ${level.lessonCount} lessons',
                style: CustomStylee().Subheadstyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        if (!level.isLocked) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: CustomStylee().Subheadstyle),
              Text(
                '${level.progress}%',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: level.progress / 100,
            backgroundColor: Colors.grey.shade300,
            color: level.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        if (level.progress == 100) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.emoji_events, color: level.primaryColor, size: 16),
              const SizedBox(width: 4),
              Text(
                'Completed!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: level.primaryColor,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildLockedOverlay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: Icon(Icons.lock, color: Colors.white, size: 32)),
    );
  }
}
