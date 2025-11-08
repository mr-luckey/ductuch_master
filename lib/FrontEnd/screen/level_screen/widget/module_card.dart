import 'package:ductuch_master/Utilities/Models/model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../models/level_model.dart';

class ModuleCard extends StatelessWidget {
  final ModuleInfo moduleInfo;
  final VoidCallback? onTap;

  const ModuleCard({super.key, required this.moduleInfo, this.onTap});

  @override
  Widget build(BuildContext context) {
    final progress = moduleInfo.completedLessons / moduleInfo.lessonCount;
    final isCompleted = moduleInfo.completedLessons == moduleInfo.lessonCount;

    return MouseRegion(
      cursor: moduleInfo.isLocked
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: moduleInfo.isLocked ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..translate(0.0, moduleInfo.isLocked ? 0.0 : -2.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: moduleInfo.isLocked
                    ? Colors.white.withOpacity(0.05)
                    : Colors.white.withOpacity(0.1),
              ),
              color: moduleInfo.isLocked
                  ? Colors.white.withOpacity(0.01)
                  : Colors.white.withOpacity(0.02),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getIconColor(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIcon(),
                          color: _getIconColor(context).computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          size: 24,
                        ),
                      ),
                      // Status indicator
                      if (isCompleted)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.green, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check, size: 16, color: Colors.green),
                              const SizedBox(width: 4),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily:
                                      GoogleFonts.patrickHand().fontFamily,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (moduleInfo.isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lock, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                'Locked',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  fontFamily:
                                      GoogleFonts.patrickHand().fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    moduleInfo.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Progress Text
                  Text(
                    '${moduleInfo.completedLessons}/${moduleInfo.lessonCount} topics completed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.6),
                      fontFamily: GoogleFonts.patrickHand().fontFamily,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress Bar
                  if (!moduleInfo.isLocked)
                    Column(
                      children: [
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: progress,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: isCompleted
                                    ? Colors.green
                                    : const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${(progress * 100).round()}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.6),
                              fontFamily: GoogleFonts.patrickHand().fontFamily,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    if (moduleInfo.isLocked) {
      return Theme.of(context).colorScheme.onSurface.withOpacity(0.2);
    } else if (moduleInfo.completedLessons == moduleInfo.lessonCount) {
      return Colors.green.withOpacity(0.2);
    } else {
      return Theme.of(context).colorScheme.primary.withOpacity(0.2);
    }
  }

  IconData _getIcon() {
    if (moduleInfo.isLocked) {
      return Icons.lock;
    } else if (moduleInfo.completedLessons == moduleInfo.lessonCount) {
      return Icons.check;
    } else {
      return moduleInfo.icon;
    }
  }
}
