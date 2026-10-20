import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Qrie Design System — Typography Tokens (Pastel Bento & Onyx)
/// Uses Poppins via google_fonts for clean, modern legibility.
class AppTypography {
  AppTypography._();

  static const String primaryFont = 'Poppins';

  // ── Core scale ──────────────────────────────────────────────────────

  /// Display / Onboarding — 28px, -0.02em
  static TextStyle display({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w400,
        height: 34 / 28,
        letterSpacing: -0.02,
        color: color,
      );

  /// Headline — 20px Bold
  static TextStyle headline({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 26 / 20,
        color: color,
      );

  /// Metric Hero — 26px Bold
  static TextStyle metricHero({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 32 / 26,
        letterSpacing: -0.03,
        color: color,
      );

  /// Section Header H2 — 18px Bold
  static TextStyle sectionHeader({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 24 / 18,
        letterSpacing: -0.01,
        color: color,
      );

  /// Card Title H3 — 16px SemiBold
  static TextStyle cardTitle({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 22 / 16,
        color: color,
      );

  /// Body — 13px Medium
  static TextStyle body({Color color = AppColors.textSecondary}) =>
      GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 18 / 13,
        color: color,
      );

  /// Caption / Pill — 11px SemiBold
  static TextStyle caption({Color color = AppColors.textMuted}) =>
      GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 14 / 11,
        letterSpacing: 0.01,
        color: color,
      );

  // ── Legacy method aliases — keep all existing screens working ────────

  /// Alias → display (28px)
  static TextStyle headingSmall({Color color = AppColors.textPrimary}) =>
      display(color: color);

  /// Alias → metricHero (26px Bold)
  static TextStyle headingMedium({Color color = AppColors.textPrimary}) =>
      metricHero(color: color);

  /// Alias → sectionHeader (18px Bold)
  static TextStyle headingExtraSmall({Color color = AppColors.textPrimary}) =>
      sectionHeader(color: color);

  /// 24px ExtraBold — kept for any screen that calls headingLarge
  static TextStyle headingLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.3,
        letterSpacing: -0.3,
        color: color,
      );

  /// 16px SemiBold — section sub-titles, card headings
  static TextStyle subheading({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: color,
      );

  /// 16px Medium — large body copy
  static TextStyle bodyLarge({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.5,
        color: color,
      );

  /// 14px Medium — standard body
  static TextStyle bodyMedium({Color color = AppColors.textSecondary}) =>
      GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.45,
        color: color,
      );

  /// 13px Medium — small body / helper
  static TextStyle bodySmall({Color color = AppColors.textMuted}) =>
      GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: color,
      );

  /// 14px Bold — CTA labels
  static TextStyle buttonLabel({Color color = AppColors.textOnOnyx}) =>
      GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: color,
      );

  /// 11px Bold — bottom nav labels
  static TextStyle navLabel({Color color = AppColors.textMuted}) =>
      GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
        color: color,
      );

  /// 13px Bold — pill / chip labels
  static TextStyle pillLabel({Color color = AppColors.textPrimary}) =>
      GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: color,
      );
}
