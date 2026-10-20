import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DuolingoProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color fillColor;
  final Color highlightColor;
  final Color trackColor;

  const DuolingoProgressBar({
    super.key,
    required this.value,
    this.height = 14.0,
    this.fillColor = AppColors.eagerGreen,
    this.highlightColor = AppColors.freshLeaf,
    this.trackColor = AppColors.cloudGray,
  });

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: AppColors.lineGray, width: 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final barWidth = constraints.maxWidth * clamped;
          return Stack(
            children: [
              if (clamped > 0)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: barWidth,
                  height: height,
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(height / 2),
                  ),
                ),
              // Top glossy shine highlight
              if (clamped > 0.05)
                Positioned(
                  top: 2,
                  left: 4,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: (barWidth - 8).clamp(0, double.infinity),
                    height: (height / 3.5),
                    decoration: BoxDecoration(
                      color: highlightColor.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(height / 4),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
