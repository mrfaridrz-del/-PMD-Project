import 'package:flutter/material.dart';

class AppColors {

  // BACKGROUND

  static Color background(bool isDark) =>

      isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF6F7FB);

  // CARD

  static Color card(bool isDark) =>

      isDark
          ? const Color(0xFF1E293B)
          : Colors.white;

  // TEXT

  static Color text(bool isDark) =>

      isDark
          ? Colors.white
          : Colors.black;

  // SUB TEXT

  static Color subText(bool isDark) =>

      isDark
          ? Colors.white70
          : Colors.grey.shade600;

  // SUB TEXT

  static Color subtitle(bool isDark) =>

    isDark
        ? Colors.white70
        : Colors.grey.shade600;

  // PRIMARY

  static const Color primary =
      Color(0xFF6366F1);
}