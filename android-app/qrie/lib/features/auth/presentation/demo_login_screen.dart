import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/config/app_config.dart';
import '../../../core/config/demo_config.dart';
import '../../../state/student_state.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../theme/design_tokens.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../school_branding/presentation/school_theme_provider.dart';
import '../application/auth_controller.dart';
import 'login_screen.dart';

/// Screen Three — Demo Login
///
/// Features:
/// - Clean form layout inside rounded card surface using Qrie design tokens.
/// - Prefilled development / demo credentials (`student.demo@qrie.local` / `QrieDemo123!`).
/// - Password visibility toggle and editable input fields.
/// - Back navigation to Welcome screen.
/// - Isolated demo authentication mechanism guarding production auth.
/// - Fallback route to school-code authentication.
class DemoLoginScreen extends StatefulWidget {
  final AuthController authController;
  final SchoolThemeProvider themeProvider;
  final VoidCallback onLoginSuccess;

  const DemoLoginScreen({
    super.key,
    required this.authController,
    required this.themeProvider,
    required this.onLoginSuccess,
  });

  @override
  State<DemoLoginScreen> createState() => _DemoLoginScreenState();
}

class _DemoLoginScreenState extends State<DemoLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final isDemo = AppConfig.current.enableDemoAuth;
    _emailController = TextEditingController(
      text: isDemo ? DemoConfig.demoEmail : '',
    );
    _passwordController = TextEditingController(
      text: isDemo ? DemoConfig.demoPassword : '',
    );

    _emailFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_isLoading) return;

    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Verify demo credentials via AuthController
    final success = await widget.authController.signInWithDemo(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      // Initialize demo student state
      try {
        final studentState = StudentStateScope.of(context);
        studentState.initializeForDemo();
      } catch (_) {}

      setState(() => _isLoading = false);
      widget.onLoginSuccess();
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = widget.authController.errorMessage ??
            'Sign in failed. Check credentials or enable demo mode.';
      });
    }
  }

  void _showForgotPasswordDialog() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: Row(
          children: [
            const Icon(Icons.help_outline_rounded, color: AppColors.accentCobalt),
            const SizedBox(width: 8),
            Text('Reset Password', style: AppTypography.headingSmall()),
          ],
        ),
        content: Text(
          'Student accounts are provisioned and managed by your educational institution. Please contact your class teacher or school administrator for password assistance.',
          style: AppTypography.body(color: AppColors.textSecondary).copyWith(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Understood',
              style: AppTypography.buttonLabel(color: AppColors.accentCobalt),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterInfo() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'New student registrations are processed through your school administrator.',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _switchToSchoolCodeLogin() {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          authController: widget.authController,
          branding: widget.themeProvider.branding,
          onLoginSuccess: widget.onLoginSuccess,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDemo = AppConfig.current.enableDemoAuth;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                  maxWidth: 520,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ── Top Navigation Row ──────────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                            color: AppColors.textPrimary,
                            tooltip: 'Back to Welcome',
                            onPressed: () => Navigator.pop(context),
                          ),
                          GestureDetector(
                            onTap: _showRegisterInfo,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                              child: Text(
                                'Need an Account?',
                                style: AppTypography.caption(color: AppColors.accentCobalt)
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── Heading and Subtitle ────────────────────────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Sign In',
                                style: AppTypography.display(color: AppColors.textPrimary)
                                    .copyWith(fontSize: 28, fontWeight: FontWeight.w800),
                              ),
                              const Spacer(),
                              if (isDemo)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEFF6FF),
                                    borderRadius: BorderRadius.circular(9999),
                                    border: Border.all(color: const Color(0xFFBFDBFE)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.accentCobalt),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Demo Mode',
                                        style: AppTypography.caption(color: AppColors.accentCobalt)
                                            .copyWith(fontWeight: FontWeight.w800, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isDemo
                                ? 'Prefilled development credentials loaded. Tap Sign In to enter the student dashboard.'
                                : 'Enter your student credentials to continue to your dashboard.',
                            style: AppTypography.body(color: AppColors.textSecondary)
                                .copyWith(fontSize: 13.5, height: 1.4),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // ── Rounded Form Card Surface ───────────────────────────────
                      AppCard(
                        padding: const EdgeInsets.all(20.0),
                        borderRadius: DesignTokens.radiusCardMd,
                        backgroundColor: const Color(0xFFF8FAFC),
                        borderColor: const Color(0xFFE2E8F0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email field label
                            Text(
                              'STUDENT EMAIL',
                              style: AppTypography.caption(color: AppColors.textSecondary)
                                  .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _emailController,
                              focusNode: _emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              style: AppTypography.body(color: AppColors.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Enter student email',
                                hintStyle: AppTypography.body(color: AppColors.textMuted),
                                prefixIcon: const Icon(Icons.mail_outline_rounded,
                                    color: AppColors.accentCobalt, size: 20),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: AppColors.accentCobalt, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter student email';
                                }
                                if (!val.contains('@')) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Password field label + Forgot Password action
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'PASSWORD',
                                  style: AppTypography.caption(color: AppColors.textSecondary)
                                      .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                                ),
                                GestureDetector(
                                  onTap: _showForgotPasswordDialog,
                                  child: Text(
                                    'Forgot Password?',
                                    style: AppTypography.caption(color: AppColors.accentCobalt)
                                        .copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: _passwordController,
                              focusNode: _passwordFocus,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _handleLogin(),
                              style: AppTypography.body(color: AppColors.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w600),
                              decoration: InputDecoration(
                                hintText: 'Enter student password',
                                hintStyle: AppTypography.body(color: AppColors.textMuted),
                                prefixIcon: const Icon(Icons.lock_outline_rounded,
                                    color: AppColors.accentCobalt, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: AppColors.textMuted,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() => _obscurePassword = !_obscurePassword);
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: AppColors.accentCobalt, width: 2),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter password';
                                }
                                if (val.trim().length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            if (_errorMessage != null) ...[
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.errorSurface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.errorBorder),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        color: AppColors.error, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: AppTypography.caption(color: AppColors.error)
                                            .copyWith(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Actions & Alternative School Login ──────────────────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppButton(
                            text: _isLoading ? 'SIGNING IN...' : 'SIGN IN TO QRIE',
                            isFullWidth: true,
                            variant: AppButtonVariant.primary,
                            onPressed: _isLoading ? () {} : _handleLogin,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Text(
                                  'OR',
                                  style: AppTypography.caption(color: AppColors.textMuted)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                              const Expanded(child: Divider(color: Color(0xFFE2E8F0))),
                            ],
                          ),
                          const SizedBox(height: 14),
                          AppButton(
                            text: 'USE SCHOOL CODE & PIN',
                            isFullWidth: true,
                            variant: AppButtonVariant.secondary,
                            onPressed: _switchToSchoolCodeLogin,
                          ),
                          const SizedBox(height: 16),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
