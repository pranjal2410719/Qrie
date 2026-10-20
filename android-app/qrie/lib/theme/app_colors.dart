import 'package:flutter/material.dart';

/// Qrie Design System — Unified Color Tokens
///
/// Single source of truth for every color reference in the app.
/// All legacy aliases from the old system are preserved here so
/// no existing widget needs to change its import.
class AppColors {
  AppColors._();

  // ─────────────────────────────────────────────
  // SURFACES  (Pastel Bento & Onyx language)
  // ─────────────────────────────────────────────
  static const Color bgCanvas          = Color(0xFFFFFFFF);
  static const Color bgSurfaceSoft     = Color(0xFFF4F5F7);
  static const Color bgSurfaceMuted    = Color(0xFFE8EAEE);
  static const Color bgSurfaceOnyx     = Color(0xFF0D0D11);
  static const Color bgOnboardingLilac = Color(0xFFDF96F7);
  static const Color bgShowcaseBackdrop= Color(0xFFFDDDFE);

  // ─────────────────────────────────────────────
  // ACCENTS
  // ─────────────────────────────────────────────
  static const Color accentPeriwinkle  = Color(0xFFB5C3F8);
  static const Color accentCobalt      = Color(0xFF6982F3);
  static const Color accentMustard     = Color(0xFFF3C750);
  static const Color accentOrchid      = Color(0xFFE298F8);
  static const Color accentAmber       = Color(0xFFF28D35);
  static const Color accentCoral       = Color(0xFFEB5A28);
  static const Color accentRose        = Color(0xFFE83879);
  static const Color accentMint        = Color(0xFF32C787);
  static const Color accentMintSoft    = Color(0xFFA9F0B8);
  static const Color accentTangerine   = Color(0xFFF28D35);
  static const Color accentPeach       = Color(0xFFFED7AA);
  static const Color accentLilac       = Color(0xFFDF96F7);

  // ─────────────────────────────────────────────
  // TEXT
  // ─────────────────────────────────────────────
  static const Color textPrimary       = Color(0xFF111216);
  static const Color textSecondary     = Color(0xFF717582);
  static const Color textMuted         = Color(0xFFA0A5B5);
  static const Color textDisabled      = Color(0xFFCBCDD6);
  static const Color textOnOnyx        = Color(0xFFFFFFFF);
  static const Color textOnOnyxMuted   = Color(0xFF9CA3AF);

  // ─────────────────────────────────────────────
  // SEMANTIC — SUCCESS
  // ─────────────────────────────────────────────
  static const Color success           = Color(0xFF16A34A); // green-600
  static const Color successSurface    = Color(0xFFF0FDF4); // green-50
  static const Color successBorder     = Color(0xFFBBF7D0); // green-200

  // ─────────────────────────────────────────────
  // SEMANTIC — ERROR
  // ─────────────────────────────────────────────
  static const Color error             = Color(0xFFDC2626); // red-600
  static const Color errorSurface      = Color(0xFFFEF2F2); // red-50
  static const Color errorBorder       = Color(0xFFFECACA); // red-200

  // ─────────────────────────────────────────────
  // SEMANTIC — WARNING
  // ─────────────────────────────────────────────
  static const Color warning           = Color(0xFFD97706); // amber-600
  static const Color warningSurface    = Color(0xFFFFFBEB); // amber-50
  static const Color warningBorder     = Color(0xFFFDE68A); // amber-200

  // ─────────────────────────────────────────────
  // SEMANTIC — INFO
  // ─────────────────────────────────────────────
  static const Color info              = Color(0xFF2563EB); // blue-600
  static const Color infoSurface       = Color(0xFFEFF6FF); // blue-50
  static const Color infoBorder        = Color(0xFFBFDBFE); // blue-200

  // ─────────────────────────────────────────────
  // BORDERS / DIVIDERS
  // ─────────────────────────────────────────────
  static const Color borderLight       = Color(0xFFEEEFF2);
  static const Color borderMedium      = Color(0xFFD8DBE2);
  static const Color borderStrong      = Color(0xFFB0B5C3);

  // ─────────────────────────────────────────────
  // SURFACE UTILITIES
  // ─────────────────────────────────────────────
  static const Color surfaceSubtle     = Color(0xFFF4F5F7);

  // ─────────────────────────────────────────────
  // SCHOOL-BRANDED TOKENS  (dynamic; used as defaults)
  // ─────────────────────────────────────────────

  /// Default school green — overridden at runtime via SchoolThemeProvider
  static const Color schoolPrimary     = Color(0xFF16A34A);

  /// Soft mint tint for icon containers, highlighted rows, etc.
  static const Color schoolMint        = Color(0xFFECFDF5); // emerald-50

  /// Warm gold for XP, streaks, rewards
  static const Color schoolGold        = Color(0xFFF59E0B); // amber-500
  static const Color schoolGoldLight   = Color(0xFFFEF3C7); // amber-100

  // ─────────────────────────────────────────────
  // LEGACY ALIASES — keep old widget references working
  // ─────────────────────────────────────────────

  /// Previously used in TopNavigationBar and AppTheme
  static const Color eagerGreen        = Color(0xFF16A34A);
  static const Color paperWhite        = Color(0xFFFFFFFF);
  static const Color charcoal          = Color(0xFF111216);
  static const Color lineGray          = Color(0xFFEEEFF2);
  static const Color fadedGray         = Color(0xFFE8EAEE);
  static const Color cloudGray         = Color(0xFFF4F5F7);
  static const Color pencilGray        = Color(0xFFA0A5B5);
  static const Color sparkBlue         = Color(0xFF6982F3);
  static const Color fireOrange        = Color(0xFFF28D35);
  static const Color storybookGreen    = Color(0xFFECFDF5);
  static const Color rubyRed           = Color(0xFFDC2626);

  /// Generic surface (white card background)
  static const Color surface           = Color(0xFFFFFFFF);

  /// Generic page/scaffold background (near-white)
  static const Color background        = Color(0xFFFAFAFB);

  /// Legacy primary fallback
  static const Color primary           = eagerGreen;

  // ─────────────────────────────────────────────
  // DARK / SHADE VARIANTS  (used by mascot + subjects)
  // ─────────────────────────────────────────────

  /// Darker cobalt blue — shadow tint on sparkBlue subject card
  static const Color sparkBlueDark     = Color(0xFF4A64E8);

  /// Darker green — shadow tint on eagerGreen subject card
  static const Color eagerGreenDark    = Color(0xFF0F7A33);

  /// Darker amber-orange — shadow tint on fireOrange elements
  static const Color fireOrangeDark    = Color(0xFFBF6010);

  /// Rich purple — Chemistry subject + Doubt Buster badge
  static const Color royalPurple       = Color(0xFF8B3CF7);

  /// Gold-yellow — mascot tassel, Speed Demon badge
  static const Color goldYellow        = Color(0xFFF59E0B);

  /// Near-black ink — mascot pupils, graduation cap
  static const Color nightInk          = Color(0xFF1A1A2E);
}
