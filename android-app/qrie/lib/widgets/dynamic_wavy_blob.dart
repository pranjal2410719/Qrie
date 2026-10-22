import 'package:flutter/material.dart';

/// A circular AI tutor avatar with a clean, simple, and visible circular border.
///
/// Features:
/// - Crisp circular core with white backdrop and the official Qrie Q logo.
/// - Simple, high-contrast, visible dual-ring circular border (no wavy distortion).
/// - Dynamic status-aware coloration:
///   - Context active: Vibrant Emerald (#10B981)
///   - Test Guardrails mode: Warm Amber (#F59E0B)
///   - Default idle: Brand Sky/Cobalt (#0284C7)
/// - Floating ambient shadow for elevation and distinct visibility on all backgrounds.
/// - Active beacon dot for context-aware states.
class DynamicWavyBlob extends StatelessWidget {
  final double size;
  final bool hasActiveContext;
  final bool isTestMode;
  final VoidCallback? onTap;
  final Widget? centerChild;

  const DynamicWavyBlob({
    super.key,
    this.size = 54.0,
    this.hasActiveContext = false,
    this.isTestMode = false,
    this.onTap,
    this.centerChild,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine status-aware accent and ring colors
    final Color accentColor = isTestMode
        ? const Color(0xFFF59E0B) // Amber for Guardrails
        : (hasActiveContext
            ? const Color(0xFF10B981) // Emerald for active context
            : const Color(0xFF0284C7)); // Brand Sky/Cobalt

    final Color ringColor = isTestMode
        ? const Color(0xFFFDE68A) // Soft amber halo
        : (hasActiveContext
            ? const Color(0xFFA7F3D0) // Soft emerald halo
            : const Color(0xFFBAE6FD)); // Soft sky halo

    final outerRingSize = size + 8.0;
    final coreSize = size;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: outerRingSize,
        height: outerRingSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // 1. Simple, clean, and visible outer accent halo / ring
            Container(
              width: outerRingSize,
              height: outerRingSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ringColor.withValues(alpha: 0.35),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
            ),

            // 2. High-visibility solid core container with primary circular border
            Container(
              width: coreSize,
              height: coreSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: accentColor,
                  width: 2.5,
                ),
                boxShadow: [
                  // Ambient drop shadow for high contrast & visibility on all backgrounds
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.16),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                  // Soft outer accent glow
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.22),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipOval(
                child: centerChild != null
                    ? centerChild!
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset(
                          'assets/Q_logo.png',
                          width: coreSize - 8,
                          height: coreSize - 8,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.auto_awesome,
                            color: Color(0xFF0284C7),
                            size: 26,
                          ),
                        ),
                      ),
              ),
            ),

            // 3. Status beacon indicator dot (online/context active)
            if (hasActiveContext || isTestMode)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isTestMode
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isTestMode
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF10B981))
                            .withValues(alpha: 0.7),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
