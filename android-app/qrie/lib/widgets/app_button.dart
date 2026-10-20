import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant {
  primary,
  secondary,
  outline,
  danger,
  gold,
  ghost,
}

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool isTrailingIcon;
  final double height;
  final double? width;
  final bool isFullWidth;
  final bool isLoading;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.isTrailingIcon = false,
    this.height = 48.0,
    this.width,
    this.isFullWidth = false,
    this.isLoading = false,
    this.borderRadius = 14.0,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.reverse();
    }
  }

  void _onTapCancel() {
    if (widget.onPressed != null && !widget.isLoading) {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    Color backgroundColor;
    Color textColor;
    Border? border;

    switch (widget.variant) {
      case AppButtonVariant.primary:
        backgroundColor = isEnabled ? primaryColor : AppColors.surfaceSubtle;
        textColor = isEnabled ? Colors.white : AppColors.textDisabled;
        border = null;
        break;

      case AppButtonVariant.secondary:
        backgroundColor = isEnabled ? AppColors.schoolMint : AppColors.surfaceSubtle;
        textColor = isEnabled ? primaryColor : AppColors.textDisabled;
        border = Border.all(
          color: isEnabled ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
          width: 1.0,
        );
        break;

      case AppButtonVariant.outline:
        backgroundColor = Colors.white;
        textColor = isEnabled ? primaryColor : AppColors.textDisabled;
        border = Border.all(
          color: isEnabled ? AppColors.borderMedium : AppColors.borderLight,
          width: 1.5,
        );
        break;

      case AppButtonVariant.danger:
        backgroundColor = isEnabled ? AppColors.error : AppColors.surfaceSubtle;
        textColor = isEnabled ? Colors.white : AppColors.textDisabled;
        border = null;
        break;

      case AppButtonVariant.gold:
        backgroundColor = isEnabled ? AppColors.schoolGold : AppColors.surfaceSubtle;
        textColor = isEnabled ? AppColors.textPrimary : AppColors.textDisabled;
        border = null;
        break;

      case AppButtonVariant.ghost:
        backgroundColor = Colors.transparent;
        textColor = isEnabled ? primaryColor : AppColors.textDisabled;
        border = null;
        break;
    }

    Widget content;
    if (widget.isLoading) {
      content = SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    } else {
      final textWidget = Text(
        widget.text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.buttonLabel(color: textColor),
      );

      if (widget.icon != null) {
        final iconWidget = Icon(widget.icon, size: 18, color: textColor);
        content = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.isTrailingIcon
              ? [textWidget, const SizedBox(width: 8), iconWidget]
              : [iconWidget, const SizedBox(width: 8), textWidget],
        );
      } else {
        content = textWidget;
      }
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () {
          if (isEnabled) {
            HapticFeedback.lightImpact();
            widget.onPressed?.call();
          }
        },
        child: Container(
          height: widget.height,
          width: widget.isFullWidth ? double.infinity : widget.width,
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: border,
            boxShadow: (widget.variant == AppButtonVariant.primary && isEnabled)
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: content,
        ),
      ),
    );
  }
}
