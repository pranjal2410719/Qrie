import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A horizontal scrollable wrapper that adds a subtle frosted blur and gradient fade
/// at both the left and right ends of the scroll group.
class BlurredEdgeScroll extends StatelessWidget {
  final Widget child;
  final double fadeWidth;
  final Color? edgeColor;
  final double blurSigma;

  const BlurredEdgeScroll({
    super.key,
    required this.child,
    this.fadeWidth = 22.0,
    this.edgeColor,
    this.blurSigma = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ShaderMask(
              shaderCallback: (Rect bounds) {
                if (bounds.width <= 0) {
                  return const LinearGradient(
                          colors: [Colors.black, Colors.black])
                      .createShader(bounds);
                }
                final double startRatio =
                    (fadeWidth / bounds.width).clamp(0.01, 0.20);
                final double endRatio =
                    (1.0 - (fadeWidth / bounds.width)).clamp(0.80, 0.99);

                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, startRatio, endRatio, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: child,
            ),
            // Left subtle frosted blur edge
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: fadeWidth,
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            (edgeColor ?? Colors.white).withValues(alpha: 0.70),
                            (edgeColor ?? Colors.white).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Right subtle frosted blur edge
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: fadeWidth,
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            (edgeColor ?? Colors.white).withValues(alpha: 0.70),
                            (edgeColor ?? Colors.white).withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Modern pill-shaped chip designed for the "Pastel Bento & Onyx" system.
class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;
  final Color? inactiveColor;
  final Widget? trailing;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.activeColor,
    this.inactiveColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final activeBg = activeColor ?? AppColors.bgSurfaceOnyx;
    final inactiveBg = inactiveColor ?? AppColors.bgSurfaceSoft;

    return ChoiceChip(
      avatar: icon != null
          ? Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            )
          : null,
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: activeBg,
      backgroundColor: inactiveBg,
      side: BorderSide(
        color: isSelected ? activeBg : const Color(0xFFE2E8F0),
        width: isSelected ? 1.5 : 1.0,
      ),
      elevation: isSelected ? 2 : 0,
      pressElevation: 1,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9999),
      ),
      labelStyle: TextStyle(
        fontFamily: AppTypography.primaryFont,
        color: isSelected ? Colors.white : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        fontSize: 12.5,
      ),
    );
  }
}
