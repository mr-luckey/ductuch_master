import 'package:ductuch_master/Constants/FontStyle.dart';
import 'package:ductuch_master/Utilities/Models/level_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../models/level_model.dart';

class LevelCard extends StatelessWidget {
  final LevelModel level;

  const LevelCard({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        color: Colors.white.withOpacity(0.02),
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
            color: const Color(0xFF10B981).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              level.level,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: GoogleFonts.patrickHand().fontFamily,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                level.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${level.moduleCount} modules · ${level.lessonCount} lessons',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
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
              Text(
                'Progress',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.6),
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
              Text(
                '${level.progress}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: Colors.white.withOpacity(0.05),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: level.progress / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: const Color(0xFF10B981),
                ),
              ),
            ),
          ),
        ],
        if (level.progress == 100) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Color(0xFF10B981),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Completed!',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF10B981),
                  fontFamily: GoogleFonts.patrickHand().fontFamily,
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
