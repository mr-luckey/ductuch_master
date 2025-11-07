import 'package:flutter/material.dart';

enum StreakSize { small, large }

class StreakCounter extends StatelessWidget {
  final int days;
  final StreakSize size;

  const StreakCounter({super.key, required this.days, required this.size});

  @override
  Widget build(BuildContext context) {
    final iconSize = size == StreakSize.large ? 32.0 : 24.0;
    final textStyle = size == StreakSize.large
        ? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
        : const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: const Color(0xFFEF4444),
            size: iconSize,
          ),
          const SizedBox(width: 4),
          Text(
            '$days',
            style: textStyle.copyWith(color: const Color(0xFFEF4444)),
          ),
        ],
      ),
    );
  }
}
