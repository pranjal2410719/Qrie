import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum DuolingoButtonStyle {
  primaryGreen,
  secondaryBlue,
  outlineGray,
  dangerRed,
  highlightGold,
}

class DuolingoButton extends StatefulWidget {
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
    this.height = 50.0,
    this.width,
    this.fullWidth = false,
    this.isUppercase = true,
    this.borderRadius = 12.0,
  });

  @override
  State<DuolingoButton> createState() => _DuolingoButtonState();
}

class _DuolingoButtonState extends State<DuolingoButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;

    Color fillColor;
    Color bottomShadowColor;
    Color textColor;
    Border? border;

    switch (widget.style) {
      case DuolingoButtonStyle.primaryGreen:
        fillColor = isEnabled ? AppColors.eagerGreen : AppColors.cloudGray;
        bottomShadowColor = isEnabled ? AppColors.eagerGreenDark : AppColors.fadedGray;
        textColor = isEnabled ? AppColors.paperWhite : AppColors.fadedGray;
        border = null;
        break;

      case DuolingoButtonStyle.secondaryBlue:
        fillColor = isEnabled ? AppColors.sparkBlue : AppColors.cloudGray;
        bottomShadowColor = isEnabled ? AppColors.sparkBlueDark : AppColors.fadedGray;
        textColor = isEnabled ? AppColors.paperWhite : AppColors.fadedGray;
        border = null;
        break;

      case DuolingoButtonStyle.outlineGray:
        fillColor = AppColors.paperWhite;
        bottomShadowColor = AppColors.fadedGray;
        textColor = isEnabled ? AppColors.sparkBlue : AppColors.fadedGray;
        border = Border.all(
          color: isEnabled ? AppColors.lineGray : AppColors.fadedGray,
          width: 2.0,
        );
        break;

      case DuolingoButtonStyle.dangerRed:
        fillColor = isEnabled ? AppColors.rubyRed : AppColors.cloudGray;
        bottomShadowColor = isEnabled ? const Color(0xFFD62D2D) : AppColors.fadedGray;
        textColor = AppColors.paperWhite;
        border = null;
        break;

      case DuolingoButtonStyle.highlightGold:
        fillColor = isEnabled ? AppColors.goldYellow : AppColors.cloudGray;
        bottomShadowColor = isEnabled ? const Color(0xFFD49E00) : AppColors.fadedGray;
        textColor = AppColors.charcoal;
        border = null;
        break;
    }

    final double shadowDepth = isEnabled ? 4.0 : 2.0;
    final double topMargin = _isPressed ? shadowDepth : 0.0;
    final double bottomMargin = _isPressed ? 0.0 : shadowDepth;

    final double horizontalPadding = widget.height < 45 ? 12.0 : 16.0;

    Widget content = Container(
      height: widget.height,
      width: widget.fullWidth ? double.infinity : widget.width,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: border,
        boxShadow: (isEnabled && !_isPressed)
            ? [
                BoxShadow(
                  color: bottomShadowColor,
                  offset: Offset(0, shadowDepth),
                  blurRadius: 0,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            Icon(widget.icon, color: textColor, size: 20),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              widget.isUppercase ? widget.text.toUpperCase() : widget.text,
              style: AppTypography.buttonLabel(color: textColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );

    return GestureDetector(
      onTapDown: isEnabled
          ? (_) {
              setState(() => _isPressed = true);
              HapticFeedback.lightImpact();
            }
          : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
        child: content,
      ),
    );
  }
}
