import 'package:flutter/material.dart';
import '../../school_branding/models/school_branding_config.dart';
import '../../school_branding/presentation/widgets/school_logo.dart';
import '../application/auth_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/design_tokens.dart';

/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
/// 5.8 Onboarding Split-Screen Layout
/// - Top 58%: Pure white background (#FFFFFF) with school branding,
///   editorial headline, and a Skip pill button (#F4F5F7).
/// - Bottom 42%: Pastel lilac surface (#DF96F7) with floating vector sparkles
///   and a 64x64 solid Onyx (#0D0D11) circular orbital CTA button with outer arc.
class StudentSplashScreen extends StatefulWidget {
  final AuthController authController;
  final SchoolBrandingConfig branding;
  final VoidCallback onInitialized;
  final Duration splashDuration;

  const StudentSplashScreen({
    super.key,
    required this.authController,
    required this.branding,
    required this.onInitialized,
    this.splashDuration = const Duration(milliseconds: 2400),
  });

  @override
  State<StudentSplashScreen> createState() => _StudentSplashScreenState();
}

class _StudentSplashScreenState extends State<StudentSplashScreen>
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
                        // Header row with logo and Skip pill
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SchoolLogo(
                              logoUrl: branding.logoUrl,
                              size: 44,
                              borderColor: AppColors.bgSurfaceMuted,
                            ),
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
                              horizontal: 10, vertical: 4),
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
                            size: 18, color: Colors.white.withValues(alpha: 0.85)),
                      ),
                      Positioned(
                        top: 48,
                        right: 48,
                        child: _Sparkle(
                            size: 14,
                            color: AppColors.accentCobalt.withValues(alpha: 0.6)),
                      ),
                      Positioned(
                        bottom: 32,
                        left: 54,
                        child: _Sparkle(
                            size: 12,
                            color: AppColors.accentMustard.withValues(alpha: 0.7)),
                      ),
                      Positioned(
                        bottom: 60,
                        right: 36,
                        child: _Sparkle(
                            size: 16, color: Colors.white.withValues(alpha: 0.8)),
                      ),

                      // Orbital CTA and footer
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
                              const SizedBox(height: 6),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt_rounded,
                                      size: 13,
                                      color: AppColors.bgSurfaceOnyx
                                          .withValues(alpha: 0.6)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Powered by Qrie Academic Platform',
                                    style: AppTypography.caption(
                                            color: AppColors.bgSurfaceOnyx
                                                .withValues(alpha: 0.6))
                                        .copyWith(fontSize: 10),
                                  ),
                                ],
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
        width: 82,
        height: 82,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Partial orbital stroke arc (1.5px solid #111216, ~240 degrees)
            CustomPaint(
              size: const Size(78, 78),
              painter: _OrbitalArcPainter(),
            ),
            // Solid 64x64 Onyx button
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.bgSurfaceOnyx,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x330D0D11),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbitalArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.bgSurfaceOnyx
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    // Spanning ~240 degrees (4.18 radians) around the left side
    canvas.drawArc(rect, 2.3, 4.18, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// 4-point sparkle vector garnish
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

  const _SparklePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;

    path.moveTo(cx, 0);
    path.quadraticBezierTo(cx, cy, w, cy);
    path.quadraticBezierTo(cx, cy, cx, h);
    path.quadraticBezierTo(cx, cy, 0, cy);
    path.quadraticBezierTo(cx, cy, cx, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
