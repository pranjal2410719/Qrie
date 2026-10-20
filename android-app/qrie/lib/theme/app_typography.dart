import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Qrie Design System — Typography Tokens
/// Uses Nunito for friendly, rounded headings and clean legibility.
class AppTypography {
  AppTypography._();

  // Screen & Feature Titles
  static TextStyle display({Color color = AppColors.schoolPrimary}) =>
      GoogleFonts.nunito(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.25,
        letterSpacing: -0.5,
        color: color,
      );

  static TextStyle headingLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.3,
        letterSpacing: -0.3,
        color: color,
      );

  static TextStyle headingSmall({Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunito(
        fontSize: 19,
        fontWeight: FontWeight.w800,
        height: 1.35,
        letterSpacing: -0.2,
        color: color,
      );

  static TextStyle subheading({Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        height: 1.4,
        color: color,
      );

  // Body Content (Highly legible for textbook reading & problem solving)
  static TextStyle bodyLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      );

  static TextStyle bodyMedium({Color color = AppColors.textSecondary}) =>
      GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color,
      );

  static TextStyle bodySmall({Color color = AppColors.textMuted}) =>
      GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );

  // Interactive Labels & Buttons
  static TextStyle buttonLabel({Color color = AppColors.surface}) =>
      GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: color,
      );

  static TextStyle navLabel({Color color = AppColors.textMuted}) =>
      GoogleFonts.nunito(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: color,
      );

  static TextStyle pillLabel({Color color = AppColors.textPrimary}) =>
      GoogleFonts.nunito(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle caption({Color color = AppColors.textMuted}) =>
      GoogleFonts.nunito(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: color,
      );
}
