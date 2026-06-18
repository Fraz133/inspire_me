import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color? bgStart;
  final Color? bgEnd;
  final Color? accent1;
  final Color? accent2;
  final Color? accentAlphaLow;
  final Color? accent2AlphaLow;
  final Color? cardBg;
  final Color? cardBorder;
  final Color? text;
  final Color? subtext;
  final Color? quoteMarkColor;
  final Color? speakIconActiveColor;
  final Color? emptyStateIconColor;
  final Color? emptyStateCircleBg;
  final Color? glassTextFill;
  final Color? glassTextBorder;
  final List<Color>? accentGradient;

  const AppThemeColors({
    required this.bgStart,
    required this.bgEnd,
    required this.accent1,
    required this.accent2,
    required this.accentAlphaLow,
    required this.accent2AlphaLow,
    required this.cardBg,
    required this.cardBorder,
    required this.text,
    required this.subtext,
    required this.quoteMarkColor,
    required this.speakIconActiveColor,
    required this.emptyStateIconColor,
    required this.emptyStateCircleBg,
    required this.glassTextFill,
    required this.glassTextBorder,
    required this.accentGradient,
  });

  @override
  AppThemeColors copyWith({
    Color? bgStart,
    Color? bgEnd,
    Color? accent1,
    Color? accent2,
    Color? accentAlphaLow,
    Color? accent2AlphaLow,
    Color? cardBg,
    Color? cardBorder,
    Color? text,
    Color? subtext,
    Color? quoteMarkColor,
    Color? speakIconActiveColor,
    Color? emptyStateIconColor,
    Color? emptyStateCircleBg,
    Color? glassTextFill,
    Color? glassTextBorder,
    List<Color>? accentGradient,
  }) {
    return AppThemeColors(
      bgStart: bgStart ?? this.bgStart,
      bgEnd: bgEnd ?? this.bgEnd,
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      accentAlphaLow: accentAlphaLow ?? this.accentAlphaLow,
      accent2AlphaLow: accent2AlphaLow ?? this.accent2AlphaLow,
      cardBg: cardBg ?? this.cardBg,
      cardBorder: cardBorder ?? this.cardBorder,
      text: text ?? this.text,
      subtext: subtext ?? this.subtext,
      quoteMarkColor: quoteMarkColor ?? this.quoteMarkColor,
      speakIconActiveColor: speakIconActiveColor ?? this.speakIconActiveColor,
      emptyStateIconColor: emptyStateIconColor ?? this.emptyStateIconColor,
      emptyStateCircleBg: emptyStateCircleBg ?? this.emptyStateCircleBg,
      glassTextFill: glassTextFill ?? this.glassTextFill,
      glassTextBorder: glassTextBorder ?? this.glassTextBorder,
      accentGradient: accentGradient ?? this.accentGradient,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      bgStart: Color.lerp(bgStart, other.bgStart, t),
      bgEnd: Color.lerp(bgEnd, other.bgEnd, t),
      accent1: Color.lerp(accent1, other.accent1, t),
      accent2: Color.lerp(accent2, other.accent2, t),
      accentAlphaLow: Color.lerp(accentAlphaLow, other.accentAlphaLow, t),
      accent2AlphaLow: Color.lerp(accent2AlphaLow, other.accent2AlphaLow, t),
      cardBg: Color.lerp(cardBg, other.cardBg, t),
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t),
      text: Color.lerp(text, other.text, t),
      subtext: Color.lerp(subtext, other.subtext, t),
      quoteMarkColor: Color.lerp(quoteMarkColor, other.quoteMarkColor, t),
      speakIconActiveColor: Color.lerp(speakIconActiveColor, other.speakIconActiveColor, t),
      emptyStateIconColor: Color.lerp(emptyStateIconColor, other.emptyStateIconColor, t),
      emptyStateCircleBg: Color.lerp(emptyStateCircleBg, other.emptyStateCircleBg, t),
      glassTextFill: Color.lerp(glassTextFill, other.glassTextFill, t),
      glassTextBorder: Color.lerp(glassTextBorder, other.glassTextBorder, t),
      accentGradient: [
        Color.lerp(accentGradient![0], other.accentGradient![0], t)!,
        Color.lerp(accentGradient![1], other.accentGradient![1], t)!,
      ],
    );
  }
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.lightAccent,
      scaffoldBackgroundColor: AppColors.lightBg1,
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightAccent,
        secondary: AppColors.lightAccent2,
        surface: AppColors.lightCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightText,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.lightText,
        ),
        iconTheme: const IconThemeData(color: AppColors.lightText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide:
              const BorderSide(color: AppColors.lightAccent, width: 2),
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.lightSubtext,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 4,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      extensions: [
        AppThemeColors(
          bgStart: AppColors.lightBg1,
          bgEnd: AppColors.lightBg2,
          accent1: AppColors.lightAccent,
          accent2: AppColors.lightAccent2,
          accentAlphaLow: AppColors.lightAccent.withValues(alpha: 0.12),
          accent2AlphaLow: AppColors.lightAccent2.withValues(alpha: 0.12),
          cardBg: Colors.white.withValues(alpha: 0.55),
          cardBorder: Colors.black.withValues(alpha: 0.08),
          text: AppColors.lightText,
          subtext: AppColors.lightSubtext,
          quoteMarkColor: AppColors.lightAccent.withValues(alpha: 0.35),
          speakIconActiveColor: AppColors.lightAccent,
          emptyStateIconColor: AppColors.lightAccent.withValues(alpha: 0.5),
          emptyStateCircleBg: Colors.black.withValues(alpha: 0.04),
          glassTextFill: Colors.black.withValues(alpha: 0.03),
          glassTextBorder: Colors.black.withValues(alpha: 0.08),
          accentGradient: const [AppColors.lightAccent, AppColors.lightAccent2],
        ),
      ],
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.darkAccent,
      scaffoldBackgroundColor: AppColors.darkBg1,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkAccent,
        secondary: AppColors.darkAccent2,
        surface: AppColors.darkCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkText,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkText,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkText),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide:
              const BorderSide(color: AppColors.darkAccent, width: 2),
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.darkSubtext,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      extensions: [
        AppThemeColors(
          bgStart: AppColors.darkBg1,
          bgEnd: AppColors.darkBg2,
          accent1: AppColors.darkAccent,
          accent2: AppColors.darkAccent2,
          accentAlphaLow: AppColors.darkAccent.withValues(alpha: 0.12),
          accent2AlphaLow: AppColors.darkAccent2.withValues(alpha: 0.12),
          cardBg: const Color(0xFF212121).withValues(alpha: 0.35),
          cardBorder: Colors.white.withValues(alpha: 0.08),
          text: AppColors.darkText,
          subtext: AppColors.darkSubtext,
          quoteMarkColor: AppColors.darkAccent2.withValues(alpha: 0.35),
          speakIconActiveColor: AppColors.darkAccent2,
          emptyStateIconColor: AppColors.darkAccent2.withValues(alpha: 0.5),
          emptyStateCircleBg: Colors.white.withValues(alpha: 0.04),
          glassTextFill: Colors.white.withValues(alpha: 0.03),
          glassTextBorder: Colors.white.withValues(alpha: 0.08),
          accentGradient: const [AppColors.darkAccent, AppColors.darkAccent2],
        ),
      ],
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final color = brightness == Brightness.light
        ? AppColors.lightText
        : AppColors.darkText;
    final subColor = brightness == Brightness.light
        ? AppColors.lightSubtext
        : AppColors.darkSubtext;

    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.3,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: color,
        height: 1.3,
      ),
      headlineLarge: GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
      ),
      headlineMedium: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: subColor,
        height: 1.5,
      ),
      labelLarge: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
