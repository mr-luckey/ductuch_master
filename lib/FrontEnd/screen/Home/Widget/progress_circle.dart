import 'package:flutter/material.dart';

class ProgressCircle extends StatelessWidget {
  final int progress;
  final double size;

  const ProgressCircle({super.key, required this.progress, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: progress / 100,
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF3B82F6)),
          ),
        ),
        Text(
          '$progress%',
          style: TextStyle(
            fontSize: size * 0.2,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
