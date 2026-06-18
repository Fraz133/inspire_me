import 'package:flutter/material.dart';

class AppColors {
  // Light theme
  static const lightBg1 = Color(0xFFF8F6F0);
  static const lightBg2 = Color(0xFFEDE8E0);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF2D2D2D);
  static const lightSubtext = Color(0xFF6B6B6B);
  static const lightAccent = Color(0xFFE8A838);
  static const lightAccent2 = Color(0xFFD4782F);

  // Dark theme
  static const darkBg1 = Color(0xFF0A0E21);
  static const darkBg2 = Color(0xFF141A33);
  static const darkCard = Color(0xFF1C2340);
  static const darkText = Color(0xFFF0F0F0);
  static const darkSubtext = Color(0xFF8E8E9A);
  static const darkAccent = Color(0xFF6C63FF);
  static const darkAccent2 = Color(0xFF00D2FF);

  // Common
  static const heartRed = Color(0xFFFF4757);
  static const success = Color(0xFF2ED573);
  static const error = Color(0xFFFF6B6B);
  static const googleRed = Color(0xFFDB4437);

  // Gradient pairs
  static const lightGradient = [Color(0xFFF093FB), Color(0xFFF5576C)];
  static const darkGradient = [Color(0xFF6C63FF), Color(0xFF00D2FF)];
  static const buttonGradient = [Color(0xFFE8A838), Color(0xFFD4782F)];
  static const darkButtonGradient = [Color(0xFF6C63FF), Color(0xFF9D50BB)];
}

class AppSizes {
  static const double paddingSm = 8.0;
  static const double paddingMd = 16.0;
  static const double paddingLg = 24.0;
  static const double paddingXl = 32.0;
  static const double radiusSm = 12.0;
  static const double radiusMd = 20.0;
  static const double radiusLg = 28.0;
  static const double iconSm = 20.0;
  static const double iconMd = 28.0;
  static const double iconLg = 36.0;
}

class AppDurations {
  static const quote = Duration(milliseconds: 600);
  static const button = Duration(milliseconds: 200);
  static const theme = Duration(milliseconds: 500);
  static const splash = Duration(seconds: 3);
  static const stagger = Duration(milliseconds: 100);
}
