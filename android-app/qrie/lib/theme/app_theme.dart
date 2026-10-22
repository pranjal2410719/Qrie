import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'design_tokens.dart';

/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
/// Global ThemeData configuration
class AppTheme {
  AppTheme._();

  static const PageTransitionsTheme _pageTransitions = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: _SlideUpFadeTransitionBuilder(),
      TargetPlatform.iOS: _SlideUpFadeTransitionBuilder(),
      TargetPlatform.linux: _SlideUpFadeTransitionBuilder(),
    },
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      splashFactory: InkRipple.splashFactory,
      brightness: Brightness.light,
      fontFamily: AppTypography.primaryFont,
      primaryColor: AppColors.accentCobalt,
      scaffoldBackgroundColor: AppColors.bgCanvas,
      canvasColor: AppColors.bgCanvas,
      cardColor: AppColors.bgSurfaceSoft,
      dividerColor: AppColors.bgSurfaceMuted,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accentCobalt,
        secondary: AppColors.accentPeriwinkle,
        surface: AppColors.bgSurfaceSoft,
        error: AppColors.accentCoral,
        onPrimary: AppColors.textOnOnyx,
        onSecondary: AppColors.textPrimary,
        onSurface: AppColors.textPrimary,
      ),
      pageTransitionsTheme: _pageTransitions,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bgCanvas,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.bgSurfaceSoft,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgSurfaceSoft,
        selectedColor: AppColors.bgSurfaceOnyx,
        disabledColor: AppColors.bgSurfaceMuted,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9999),
        ),
        labelStyle: AppTypography.pillLabel(color: AppColors.textPrimary),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.bgCanvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgSurfaceSoft,
        hintStyle: AppTypography.body(color: AppColors.textMuted),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.accentCobalt, width: 1.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgSurfaceOnyx,
        contentTextStyle: AppTypography.bodySmall(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bgCanvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }
}

class _SlideUpFadeTransitionBuilder extends PageTransitionsBuilder {
  const _SlideUpFadeTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    ));

    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(position: slideAnimation, child: child),
    );
  }
}
