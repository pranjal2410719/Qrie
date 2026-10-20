import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Qrie AppCard — Pastel Bento & Onyx surface container.
///
/// Default bg: [AppColors.bgSurfaceSoft], radius 22, optional soft shadow.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool hasShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 22.0,
    this.hasShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.bgSurfaceSoft;
    final border = borderColor ?? Colors.transparent;
    final br = BorderRadius.circular(borderRadius);

    final decoration = BoxDecoration(
      color: bg,
      borderRadius: br,
      border: border != Colors.transparent
          ? Border.all(color: border, width: 1.2)
          : null,
      boxShadow: hasShadow
          ? const [
              BoxShadow(
                color: Color.fromRGBO(17, 18, 22, 0.06),
                offset: Offset(0, 12),
                blurRadius: 32,
                spreadRadius: -8,
              ),
            ]
          : null,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: br,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            onTap: onTap,
            borderRadius: br,
            splashColor: AppColors.bgSurfaceMuted.withValues(alpha: 0.6),
            highlightColor: AppColors.bgSurfaceMuted.withValues(alpha: 0.4),
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
    }

    return Container(decoration: decoration, padding: padding, child: child);
  }
}
