import 'package:flutter/material.dart';

/// Design Tokens for the Pastel Bento & Onyx design system.
/// All values are defined as `const` to be used throughout the app.
class DesignTokens {
  // ==== Colors ==== //
  static const Color bgCanvas = Color(0xFFFFFFFF); // #FFFFFF
  static const Color bgSurfaceSoft = Color(0xFFF4F5F7); // #F4F5F7
  static const Color bgSurfaceMuted = Color(0xFFE8EAEE); // #E8EAEE
  static const Color bgSurfaceOnyx = Color(0xFF0D0D11); // #0D0D11
  static const Color bgOnboardingLilac = Color(0xFFDF96F7); // #DF96F7
  static const Color bgShowcaseBackdrop = Color(0xFFFDDDFE); // #FDDDFE

  // Accent / Semantic colors
  static const Color accentPeriwinkle = Color(0xFFB5C3F8); // #B5C3F8
  static const Color accentCobalt = Color(0xFF6982F3); // #6982F3
  static const Color accentMustard = Color(0xFFF3C750); // #F3C750
  static const Color accentOrchid = Color(0xFFE298F8); // #E298F8
  static const Color accentAmber = Color(0xFFF28D35); // #F28D35
  static const Color accentCoral = Color(0xFFEB5A28); // #EB5A28
  static const Color accentRose = Color(0xFFE83879); // #E83879
  static const Color accentMint = Color(0xFF32C787); // #32C787
  static const Color accentMintSoft = Color(0xFFA9F0B8); // #A9F0B8

  // Text colors
  static const Color textPrimary = Color(0xFF111216); // #111216
  static const Color textSecondary = Color(0xFF717582); // #717582
  static const Color textMuted = Color(0xFFA0A5B5); // #A0A5B5
  static const Color textOnOnyx = Color(0xFFFFFFFF); // #FFFFFF
  static const Color textOnOnyxMuted = Color(0xFF9CA3AF); // #9CA3AF

  // ==== Radii ==== //
  static const double radiusScreen = 40.0;
  static const double radiusCardLg = 28.0;
  static const double radiusCardMd = 22.0;
  static const double radiusPill = 9999.0;

  // ==== Shadows ==== //
  static const List<BoxShadow> shadowSoft = [
    BoxShadow(
      color: Color.fromRGBO(17, 18, 22, 0.06),
      offset: Offset(0, 12),
      blurRadius: 32,
      spreadRadius: -8,
    ),
  ];

  // ==== Spacing ==== //
  static const double horizontalPadding = 20.0;
  static const double verticalSectionGap = 22.0;
  static const double bentoGridGap = 12.0;
  static const double cardPaddingCompact = 16.0;
  static const double cardPaddingLarge = 20.0;
}
