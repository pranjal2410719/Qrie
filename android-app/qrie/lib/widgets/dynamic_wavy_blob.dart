import 'package:flutter/material.dart';

/// A circular AI tutor avatar with a clean, simple, and visible circular border.
///
/// Features:
/// - Crisp circular core with white backdrop and the official Qrie Q logo.
/// - Simple, high-contrast, solid circular border (no wavy distortion or fuzzy outer aura).
/// - Dynamic status-aware coloration:
///   - Context active: Vibrant Emerald (#10B981)
///   - Test Guardrails mode: Warm Amber (#F59E0B)
///   - Default idle: Brand Sky/Cobalt (#0284C7)
/// - Clean drop shadow for clear visibility on all background surfaces.
/// - Active beacon dot indicator for context-aware states.
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
    // Determine status-aware border and accent color
    final Color accentColor = isTestMode
        ? const Color(0xFFF59E0B) // Amber for Guardrails
        : (hasActiveContext
            ? const Color(0xFF10B981) // Emerald for active context
            : const Color(0xFF0284C7)); // Brand Sky/Cobalt

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // High-visibility solid circular container with crisp, visible border
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: accentColor,
                  width: 2.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.16),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipOval(
                child: centerChild ??
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/Q_logo.png',
                        width: size - 10,
                        height: size - 10,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.auto_awesome,
                          color: accentColor,
                          size: size * 0.45,
                        ),
                      ),
                    ),
              ),
            ),

            // Status beacon indicator dot (online / context active)
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
                            .withValues(alpha: 0.6),
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
