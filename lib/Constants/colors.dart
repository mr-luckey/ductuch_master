import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  Widget buttonn(
    String text,
    Function()? ontap,
    Color buttoncolor,
    final height,
    final Width,
  ) => GestureDetector(
    onTap: ontap,
    child: Container(
      height: height,
      width: Width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: buttoncolor,
      ),
      child: Center(child: Text(text)),
    ),
  );

  // TextStyle popnies = TextStyle(fontSize: 10, fontFamily: 'Popnies');
  // 🌟 Primary Colors
  static const Color primary = Color(0xFF2196F3); // Bright Sky Blue
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // 🟢 Secondary Colors
  static const Color secondary = Color(0xFF00BCD4); // Cyan Blue
  static const Color secondaryDark = Color(0xFF0097A7);
  static const Color secondaryLight = Color(0xFFB2EBF2);

  // 🟡 Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF03A9F4);

  // ⚪ Neutral Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFE0E0E0);
  static const Color disabled = Color(0xFFBDBDBD);

  // ⚫ Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  // 🌈 Gradient Colors
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF42A5F5), Color(0xFF26C6DA)],
  );
}
