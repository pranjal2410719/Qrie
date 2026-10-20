import 'package:flutter/material.dart';
import 'app_progress_bar.dart';

/// Backward compatibility adapter delegating to modern [AppProgressBar].
class DuolingoProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  const DuolingoProgressBar({
    super.key,
    required this.value,
    this.height = 10.0,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppProgressBar(
      value: value,
      height: height,
      fillColor: color,
      backgroundColor: backgroundColor,
    );
  }
}
