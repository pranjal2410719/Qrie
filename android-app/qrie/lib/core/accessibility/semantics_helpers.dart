import 'package:flutter/material.dart';

/// Accessibility Helpers for WCAG 2.1 AA Compliance
class AccessibilityHelper {
  AccessibilityHelper._();

  /// Minimum touch target size for interactive controls (48 x 48 dp)
  static const double minTouchTargetSize = 48.0;

  /// Wraps any widget to guarantee at least 48x48 dp tappable area
  static Widget touchTargetWrapper({
    required Widget child,
    double minWidth = minTouchTargetSize,
    double minHeight = minTouchTargetSize,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minWidth,
        minHeight: minHeight,
      ),
      child: Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: child,
      ),
    );
  }

  /// Screen reader semantic wrapper
  static Widget screenReaderLabel({
    required Widget child,
    required String label,
    String? hint,
    bool isButton = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      child: child,
    );
  }
}
