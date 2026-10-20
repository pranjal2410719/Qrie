import 'package:flutter/material.dart';

/// Qrie Design System — Color Tokens
/// Minimalist, accessible, school-aligned palette with DPS Forest Green primary.
class AppColors {
  AppColors._();

  // School Primary & Brand Accents (Delhi Public School Society)
  static const Color schoolPrimary = Color(0xFF0F5132); // DPS Forest Green
  static const Color schoolPrimaryLight = Color(0xFF198754);
  static const Color schoolMint = Color(0xFFE8F5EE); // Mint Wash
  static const Color schoolGold = Color(0xFFD4AF37); // Official Emblem Gold
  static const Color schoolGoldLight = Color(0xFFFFF9E6);

  // Modern Minimal Neutrals (Slate scale)
  static const Color background = Color(0xFFF8FAFC); // Clean Canvas
  static const Color surface = Color(0xFFFFFFFF); // Card & Modal Surface
  static const Color surfaceSubtle = Color(0xFFF1F5F9);
  static const Color borderLight = Color(0xFFE2E8F0); // 1px clean separator
  static const Color borderMedium = Color(0xFFCBD5E1);

  // Typography Neutrals
  static const Color textPrimary = Color(0xFF0F172A); // High-contrast Slate 900
  static const Color textSecondary = Color(0xFF475569); // Slate 600
  static const Color textMuted = Color(0xFF64748B); // Slate 500
  static const Color textDisabled = Color(0xFF94A3B8); // Slate 400

  // Educational Feedback & State Colors (Restrained, accessible)
  static const Color success = Color(0xFF059669); // Forest Emerald
  static const Color successSurface = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFD97706); // Amber
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color error = Color(0xFFDC2626); // Crimson
  static const Color errorSurface = Color(0xFFFEF2F2);
  static const Color errorBorder = Color(0xFFFECACA);

  static const Color info = Color(0xFF0284C7); // Academic Sky Blue
  static const Color infoSurface = Color(0xFFF0F9FF);
  static const Color infoBorder = Color(0xFFBAE6FD);

  // Backward compatibility aliases
  static const Color eagerGreen = schoolPrimary;
  static const Color eagerGreenDark = Color(0xFF0B3D25);
  static const Color storybookGreen = schoolMint;
  static const Color freshLeaf = Color(0xFFA5ED6E);
  static const Color sparkBlue = info;
  static const Color sparkBlueDark = Color(0xFF0369A1);
  static const Color nightInk = textPrimary;
  static const Color paperWhite = surface;
  static const Color charcoal = textPrimary;
  static const Color pencilGray = textSecondary;
  static const Color fadedGray = textDisabled;
  static const Color cloudGray = background;
  static const Color lineGray = borderLight;
  static const Color fireOrange = warning;
  static const Color fireOrangeDark = Color(0xFFB45309);
  static const Color rubyRed = error;
  static const Color rubyRedLight = errorSurface;
  static const Color goldYellow = schoolGold;
  static const Color royalPurple = Color(0xFF7C3AED);
}
