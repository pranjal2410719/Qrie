import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/config/app_config.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/design_tokens.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../school_branding/presentation/school_theme_provider.dart';
import '../application/auth_controller.dart';
import 'demo_login_screen.dart';

/// Screen One & Screen Two: Welcome / Onboarding Introduction
///
/// Features:
/// - Polished onboarding introduction following Qrie's Pastel Bento & Onyx design tokens.
/// - Prominent central rounded panel with Qrie AI branding and value pillars.
/// - Two prominent actions: "Sign In" and "Get Started".
/// - Debounced transitions to prevent duplicate navigation.
/// - Responsive and narrow-screen safe.
class WelcomeScreen extends StatefulWidget {
  final AuthController authController;
  final SchoolThemeProvider themeProvider;
  final VoidCallback onLoginSuccess;

  const WelcomeScreen({
    super.key,
    required this.authController,
    required this.themeProvider,
    required this.onLoginSuccess,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isNavigating = false;

  void _navigateToLogin() {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    HapticFeedback.lightImpact();

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, animation, secondaryAnimation) => DemoLoginScreen(
          authController: widget.authController,
          themeProvider: widget.themeProvider,
          onLoginSuccess: () {
            if (Navigator.canPop(ctx)) {
              Navigator.pop(ctx);
            }
            widget.onLoginSuccess();
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    ).then((_) {
      if (mounted) setState(() => _isNavigating = false);
    });
  }

  void _showGetStartedInfo() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.accentCobalt.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.school_rounded, color: AppColors.accentCobalt, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Student Onboarding',
                              style: AppTypography.headingSmall(color: AppColors.textPrimary)),
                          Text('School-Partnered Education',
                              style: AppTypography.caption(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Qrie accounts are provisioned in collaboration with your school. Your school administrator provides your student roll code and access PIN.',
                  style: AppTypography.body(color: AppColors.textSecondary).copyWith(height: 1.45),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: Color(0xFF1D4ED8), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Developing or evaluating? Use the prefilled Demo Login to explore all student features instantly.',
                          style: AppTypography.caption(color: const Color(0xFF1E40AF))
                              .copyWith(fontWeight: FontWeight.w600, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AppButton(
                  text: 'CONTINUE TO DEMO LOGIN',
                  isFullWidth: true,
                  variant: AppButtonVariant.primary,
                  onPressed: () {
                    Navigator.pop(ctx);
                    _navigateToLogin();
                  },
                ),
                const SizedBox(height: 10),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'Dismiss',
                      style: AppTypography.caption(color: AppColors.textMuted)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDemoEnabled = AppConfig.current.enableDemoAuth;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 32,
                  maxWidth: 520,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Top Header Brand Row ────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF6FF),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFDBEAFE)),
                              ),
                              child: SvgPicture.asset(
                                'assets/Qrielogo.svg',
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Qrie',
                              style: AppTypography.headingMedium(color: AppColors.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                            ),
                          ],
                        ),
                        if (isDemoEnabled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accentCobalt.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(9999),
                              border: Border.all(color: AppColors.accentCobalt.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.accentCobalt,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'DEMO READY',
                                  style: AppTypography.caption(color: AppColors.accentCobalt)
                                      .copyWith(fontWeight: FontWeight.w800, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Central Rounded Hero Card ──────────────────────────────
                    AppCard(
                      padding: const EdgeInsets.all(24.0),
                      borderRadius: DesignTokens.radiusCardLg,
                      backgroundColor: const Color(0xFFF8FAFC),
                      borderColor: const Color(0xFFE2E8F0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Vector mascot / brand showcase
                          Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0F000000),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/Qlogo.svg',
                                width: 54,
                                height: 54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Welcome headline
                          Text(
                            'Your Brain Called.\nIt Wants More.',
                            textAlign: TextAlign.center,
                            style: AppTypography.display(color: AppColors.textPrimary).copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              letterSpacing: -0.4,
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Short description
                          Text(
                            'Empowering active recall, interactive lessons, and NCERT mastery with your 24/7 AI tutor.',
                            textAlign: TextAlign.center,
                            style: AppTypography.body(color: AppColors.textSecondary)
                                .copyWith(fontSize: 13.5, height: 1.45),
                          ),

                          const SizedBox(height: 22),

                          // 3 Feature highlight pills
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildPill(Icons.bolt_rounded, 'Active Recall', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                              _buildPill(Icons.menu_book_rounded, 'NCERT Aligned', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                              _buildPill(Icons.psychology_rounded, 'AI Tutor', const Color(0xFFEFF6FF), AppColors.accentCobalt),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Bottom Action Buttons ──────────────────────────────────
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppButton(
                          text: 'SIGN IN',
                          isFullWidth: true,
                          variant: AppButtonVariant.primary,
                          onPressed: _navigateToLogin,
                        ),
                        const SizedBox(height: 12),
                        AppButton(
                          text: 'GET STARTED / REGISTER',
                          isFullWidth: true,
                          variant: AppButtonVariant.secondary,
                          onPressed: _showGetStartedInfo,
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Powered by Qrie AI',
                                style: AppTypography.caption(color: AppColors.textMuted)
                                    .copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                              ),
                              const SizedBox(width: 5),
                              SvgPicture.asset(
                                'assets/Qrielogo.svg',
                                width: 14,
                                height: 14,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPill(IconData icon, String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textCol),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTypography.primaryFont,
              color: textCol,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
