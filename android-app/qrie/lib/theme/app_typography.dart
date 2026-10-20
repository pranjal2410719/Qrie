import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Duolingo Design Tokens — Typography
/// Uses Nunito (rounded display like Feather) and Nunito Sans for clean legibility.
class AppTypography {
  AppTypography._();

  // Display Headlines (Feather / Nunito ExtraBold)
  static TextStyle display({Color color = AppColors.eagerGreen}) =>
      GoogleFonts.nunito(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        height: 1.2,
        letterSpacing: -0.96,
        color: color,
      );

  static TextStyle headingLarge({Color color = AppColors.eagerGreen}) =>
      GoogleFonts.nunito(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        height: 1.2,
        letterSpacing: -0.8,
        color: color,
      );

  static TextStyle headingSmall({Color color = AppColors.charcoal}) =>
      GoogleFonts.nunito(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        height: 1.25,
        color: color,
      );

  static TextStyle subheading({Color color = AppColors.charcoal}) =>
      GoogleFonts.nunito(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        height: 1.35,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.pencilGray}) =>
      GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  static TextStyle bodySmall({Color color = AppColors.pencilGray}) =>
      GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  // Sticker & Button labels (Uppercase with tracking)
  static TextStyle buttonLabel({Color color = AppColors.paperWhite}) =>
      GoogleFonts.nunito(
        fontSize: 15,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
        color: color,
      );

  static TextStyle navLabel({Color color = AppColors.pencilGray}) =>
      GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
        color: color,
      );

  static TextStyle pillLabel({Color color = AppColors.charcoal}) =>
      GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle caption({Color color = AppColors.pencilGray}) =>
      GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: color,
      );
}
