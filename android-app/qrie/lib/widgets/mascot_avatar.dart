import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum MascotExpression {
  happy,
  excited,
  thinking,
  celebration,
  studying,
}

class MascotAvatar extends StatelessWidget {
  final double size;
  final MascotExpression expression;
  final bool showBadge;

  const MascotAvatar({
    super.key,
    this.size = 64.0,
    this.expression = MascotExpression.happy,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Mascot Body Canvas
          CustomPaint(
            size: Size(size, size),
            painter: _MascotPainter(expression: expression),
          ),
          if (showBadge)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.sparkBlue,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.paperWhite, width: 2),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  size: size * 0.22,
                  color: AppColors.paperWhite,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MascotPainter extends CustomPainter {
  final MascotExpression expression;

  _MascotPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer Body Shadow / Outline
    final outlinePaint = Paint()
      ..color = const Color(0xFF388E00)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.04;

    // Body Fill (Eager Green)
    final bodyPaint = Paint()
      ..color = AppColors.eagerGreen
      ..style = PaintingStyle.fill;

    // Draw chubby rounded mascot head/body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.12, w * 0.8, h * 0.78),
      Radius.circular(w * 0.36),
    );
    canvas.drawRRect(bodyRect, bodyPaint);
    canvas.drawRRect(bodyRect, outlinePaint);

    // Cute ears / tufts
    final tuftPathLeft = Path()
      ..moveTo(w * 0.2, h * 0.15)
      ..lineTo(w * 0.12, h * 0.04)
      ..lineTo(w * 0.32, h * 0.12)
      ..close();
    final tuftPathRight = Path()
      ..moveTo(w * 0.8, h * 0.15)
      ..lineTo(w * 0.88, h * 0.04)
      ..lineTo(w * 0.68, h * 0.12)
      ..close();
    canvas.drawPath(tuftPathLeft, bodyPaint);
    canvas.drawPath(tuftPathRight, bodyPaint);
    canvas.drawPath(tuftPathLeft, outlinePaint);
    canvas.drawPath(tuftPathRight, outlinePaint);

    // Tummy patch (Storybook Green soft wash)
    final tummyPaint = Paint()
      ..color = AppColors.storybookGreen
      ..style = PaintingStyle.fill;
    final tummyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.24, h * 0.46, w * 0.52, h * 0.42),
      Radius.circular(w * 0.26),
    );
    canvas.drawRRect(tummyRect, tummyPaint);

    // Eyes
    final eyeBgPaint = Paint()..color = AppColors.paperWhite;
    final pupilPaint = Paint()..color = AppColors.nightInk;
    final sparklePaint = Paint()..color = AppColors.paperWhite;

    final leftEyeCenter = Offset(w * 0.34, h * 0.38);
    final rightEyeCenter = Offset(w * 0.66, h * 0.38);
    final eyeRadius = w * 0.14;
    final pupilRadius = w * 0.07;

    // Left Eye
    canvas.drawCircle(leftEyeCenter, eyeRadius, eyeBgPaint);
    canvas.drawCircle(leftEyeCenter, eyeRadius, outlinePaint);
    // Right Eye
    canvas.drawCircle(rightEyeCenter, eyeRadius, eyeBgPaint);
    canvas.drawCircle(rightEyeCenter, eyeRadius, outlinePaint);

    if (expression == MascotExpression.excited || expression == MascotExpression.celebration) {
      // Happy star / arc eyes
      final starEyePaint = Paint()
        ..color = AppColors.nightInk
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = w * 0.05;

      canvas.drawArc(
        Rect.fromCircle(center: leftEyeCenter, radius: eyeRadius * 0.6),
        3.14 * 1.1,
        3.14 * 0.8,
        false,
        starEyePaint,
      );
      canvas.drawArc(
        Rect.fromCircle(center: rightEyeCenter, radius: eyeRadius * 0.6),
        3.14 * 1.1,
        3.14 * 0.8,
        false,
        starEyePaint,
      );
    } else {
      // Standard curious / friendly eyes
      canvas.drawCircle(leftEyeCenter.translate(w * 0.01, 0), pupilRadius, pupilPaint);
      canvas.drawCircle(rightEyeCenter.translate(w * 0.01, 0), pupilRadius, pupilPaint);
      // Catchlights
      canvas.drawCircle(leftEyeCenter.translate(w * 0.03, -h * 0.02), w * 0.025, sparklePaint);
      canvas.drawCircle(rightEyeCenter.translate(w * 0.03, -h * 0.02), w * 0.025, sparklePaint);
    }

    // Beak (Fire Orange)
    final beakPaint = Paint()..color = AppColors.fireOrange;
    final beakBorderPaint = Paint()
      ..color = AppColors.fireOrangeDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025;

    final beakPath = Path()
      ..moveTo(w * 0.44, h * 0.42)
      ..lineTo(w * 0.56, h * 0.42)
      ..lineTo(w * 0.5, h * 0.54)
      ..close();
    canvas.drawPath(beakPath, beakPaint);
    canvas.drawPath(beakPath, beakBorderPaint);

    // Graduation Cap / Student accessory for celebration/studying
    if (expression == MascotExpression.celebration || expression == MascotExpression.studying) {
      final capPaint = Paint()..color = AppColors.nightInk;
      final capPath = Path()
        ..moveTo(w * 0.5, h * 0.02)
        ..lineTo(w * 0.78, h * 0.1)
        ..lineTo(w * 0.5, h * 0.18)
        ..lineTo(w * 0.22, h * 0.1)
        ..close();
      canvas.drawPath(capPath, capPaint);

      // Gold tassel
      final tasselPaint = Paint()
        ..color = AppColors.goldYellow
        ..strokeWidth = w * 0.03
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(w * 0.5, h * 0.1), Offset(w * 0.76, h * 0.22), tasselPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MascotPainter oldDelegate) =>
      oldDelegate.expression != expression;
}
