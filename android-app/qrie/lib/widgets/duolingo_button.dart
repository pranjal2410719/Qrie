import 'package:flutter/material.dart';
import 'app_button.dart';

enum DuolingoButtonStyle {
  primaryGreen,
  secondaryBlue,
  outlineGray,
  dangerRed,
  highlightGold,
}

/// Backward compatibility adapter delegating to modern [AppButton].
class DuolingoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final DuolingoButtonStyle style;
  final IconData? icon;
  final double height;
  final double? width;
  final bool fullWidth;
  final bool isUppercase;
  final double borderRadius;

  const DuolingoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = DuolingoButtonStyle.primaryGreen,
    this.icon,
    this.height = 48.0,
    this.width,
    this.fullWidth = false,
    this.isUppercase = true,
    this.borderRadius = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    AppButtonVariant variant;
    switch (style) {
      case DuolingoButtonStyle.primaryGreen:
        variant = AppButtonVariant.primary;
        break;
      case DuolingoButtonStyle.secondaryBlue:
        variant = AppButtonVariant.secondary;
        break;
      case DuolingoButtonStyle.outlineGray:
        variant = AppButtonVariant.outline;
        break;
      case DuolingoButtonStyle.dangerRed:
        variant = AppButtonVariant.danger;
        break;
      case DuolingoButtonStyle.highlightGold:
        variant = AppButtonVariant.gold;
        break;
    }

    return AppButton(
      text: isUppercase ? text.toUpperCase() : text,
      onPressed: onPressed,
      variant: variant,
      icon: icon,
      height: height,
      width: width,
      isFullWidth: fullWidth,
      borderRadius: borderRadius,
    );
  }
}
