import 'package:flutter/material.dart';
import '../../school_branding/models/school_branding_config.dart';
import '../../school_branding/presentation/widgets/school_logo.dart';
import '../application/auth_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/design_tokens.dart';

/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
/// Student Onboarding Split-Screen Layout:
/// - Top 58%: Pure white background (#FFFFFF) with school branding,
///   editorial headline, and a Skip pill button (#F4F5F7).
/// - Bottom 42%: Pastel lilac surface (#DF96F7) with floating vector sparkles
///   and a 64x64 solid Onyx (#0D0D11) circular orbital CTA button with outer arc.
///
/// NOTE: Clean, institutional onboarding without third-party or powered-by clutter.
class StudentOnboardingScreen extends StatefulWidget {
  final AuthController authController;
  final SchoolBrandingConfig branding;
  final VoidCallback onInitialized;
  final Duration splashDuration;

  const StudentOnboardingScreen({
    super.key,
    required this.authController,
    required this.branding,
    required this.onInitialized,
    this.splashDuration = const Duration(milliseconds: 2400),
  });

  @override
  State<StudentOnboardingScreen> createState() =>
      _StudentOnboardingScreenState();
}

/// Backwards compatibility alias for existing test runners
typedef StudentSplashScreen = StudentOnboardingScreen;

class _StudentOnboardingScreenState extends State<StudentOnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      await widget.authController.initializeSession();
    } catch (_) {}
    if (widget.splashDuration > Duration.zero) {
      await Future.delayed(widget.splashDuration);
    }
    _proceed();
  }

  void _proceed() {
    if (_navigated || !mounted) return;
    _navigated = true;
    widget.onInitialized();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branding = widget.branding;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Column(
            children: [
              // ── Top 58%: White editorial canvas ──────────────────────────
              Expanded(
                flex: 58,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with school crest, school name, and Skip pill
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SchoolLogo(
                                    logoUrl: branding.logoUrl,
                                    size: 42,
                                    borderColor: AppColors.bgSurfaceMuted,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          branding.schoolName,
                                          style: AppTypography.subheading(
                                                  color: AppColors.textPrimary)
                                              .copyWith(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          branding.motto.isNotEmpty
                                              ? branding.motto
                                              : 'Academic Portal',
                                          style: AppTypography.caption(
                                                  color: AppColors.textSecondary)
                                              .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: _proceed,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.bgSurfaceSoft,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Text(
                                  'Skip',
                                  style: AppTypography.caption(
                                      color: AppColors.textSecondary),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // School pill tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accentCobalt.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            branding.schoolName.toUpperCase(),
                            style: AppTypography.caption(
                                    color: AppColors.accentCobalt)
                                .copyWith(
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.6),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Display headline
                        RichText(
                          text: TextSpan(
                            style: AppTypography.display(
                                    color: AppColors.textPrimary)
                                .copyWith(fontSize: 27, height: 1.25),
                            children: const [
                              TextSpan(text: 'Your Brain Called.\n'),
                              TextSpan(
                                text: 'It Wants More.',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          'Empowering active recall, interactive lessons, and NCERT mastery.',
                          style: AppTypography.body(
                              color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Bottom 42%: Pastel lilac with orbital CTA ─────────────────
              Expanded(
                flex: 42,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.bgOnboardingLilac,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(DesignTokens.radiusCardLg),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Floating star / sparkle garnishes
                      Positioned(
                        top: 24,
                        left: 36,
                        child: _Sparkle(
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.85)),
                      ),
                      Positioned(
                        top: 48,
                        right: 48,
                        child: _Sparkle(
                            size: 14,
                            color:
                                AppColors.accentCobalt.withValues(alpha: 0.6)),
                      ),
                      Positioned(
                        bottom: 32,
                        left: 54,
                        child: _Sparkle(
                            size: 12,
                            color:
                                AppColors.accentMustard.withValues(alpha: 0.7)),
                      ),
                      Positioned(
                        bottom: 60,
                        right: 36,
                        child: _Sparkle(
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.8)),
                      ),

                      // Orbital CTA
                      SafeArea(
                        top: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _OrbitalCtaButton(onTap: _proceed),
                              const SizedBox(height: 16),
                              Text(
                                'Tap to begin learning',
                                style: AppTypography.caption(
                                        color: AppColors.bgSurfaceOnyx)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Primary Orbital CTA: 64x64 Onyx button with 78px 240-degree orbital arc
// ─────────────────────────────────────────────────────────────────────────────
class _OrbitalCtaButton extends StatelessWidget {
  final VoidCallback onTap;

  const _OrbitalCtaButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 86,
        height: 86,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 240-degree orbital track arc around button
            CustomPaint(
              size: const Size(78, 78),
              painter: _OrbitalArcPainter(
                trackColor: AppColors.bgSurfaceOnyx.withValues(alpha: 0.15),
                arcColor: AppColors.bgSurfaceOnyx,
                sweepAngleDegrees: 240,
                strokeWidth: 2.2,
              ),
            ),

            // Inner 64x64 solid Onyx button
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.bgSurfaceOnyx,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.bgSurfaceOnyx.withValues(alpha: 0.35),
                    offset: const Offset(0, 8),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 240-degree orbital arc painter
// ─────────────────────────────────────────────────────────────────────────────
class _OrbitalArcPainter extends CustomPainter {
  final Color trackColor;
  final Color arcColor;
  final double sweepAngleDegrees;
  final double strokeWidth;

  _OrbitalArcPainter({
    required this.trackColor,
    required this.arcColor,
    required this.sweepAngleDegrees,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Full subtle track circle
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Dynamic 240-degree progress arc
    final arcPaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + 0.6
      ..strokeCap = StrokeCap.round;

    const startAngle = -1.5708; // -90 degrees in radians (top of circle)
    final sweepAngle = (sweepAngleDegrees * 3.1415926535) / 180;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Four-pointed vector sparkle
// ─────────────────────────────────────────────────────────────────────────────
class _Sparkle extends StatelessWidget {
  final double size;
  final Color color;

  const _Sparkle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _SparklePainter(color: color),
    );
  }
}

class _SparklePainter extends CustomPainter {
  final Color color;

  _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    final path = Path()
      ..moveTo(cx, 0)
      ..quadraticBezierTo(cx, cy, w, cy)
      ..quadraticBezierTo(cx, cy, cx, h)
      ..quadraticBezierTo(cx, cy, 0, cy)
      ..quadraticBezierTo(cx, cy, cx, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
