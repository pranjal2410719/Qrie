import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.eagerGreen,
      scaffoldBackgroundColor: AppColors.paperWhite,
      canvasColor: AppColors.paperWhite,
      cardColor: AppColors.paperWhite,
      dividerColor: AppColors.lineGray,
      colorScheme: const ColorScheme.light(
        primary: AppColors.eagerGreen,
        secondary: AppColors.sparkBlue,
        surface: AppColors.paperWhite,
        error: AppColors.rubyRed,
        onPrimary: AppColors.paperWhite,
        onSecondary: AppColors.paperWhite,
        onSurface: AppColors.charcoal,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paperWhite,
        foregroundColor: AppColors.charcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.paperWhite,
        selectedColor: AppColors.storybookGreen,
        disabledColor: AppColors.cloudGray,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.lineGray, width: 2),
        ),
        labelStyle: AppTypography.pillLabel(color: AppColors.charcoal),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.paperWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.lineGray, width: 2),
        ),
      ),
    );
  }
}
