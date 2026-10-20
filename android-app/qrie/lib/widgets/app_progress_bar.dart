import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? fillColor;
  final Color? backgroundColor;
  final double borderRadius;

  const AppProgressBar({
    super.key,
    required this.value,
    this.height = 8.0,
    this.fillColor,
    this.backgroundColor,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final activeColor = fillColor ?? Theme.of(context).colorScheme.primary;
    final trackColor = backgroundColor ?? AppColors.surfaceSubtle;

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clamped,
        child: Container(
          decoration: BoxDecoration(
            color: activeColor,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
