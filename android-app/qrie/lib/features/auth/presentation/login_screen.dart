import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../school_branding/models/school_branding_config.dart';
import '../../school_branding/presentation/widgets/school_logo.dart';
import '../application/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  final VoidCallback onLoginSuccess;
  final SchoolBrandingConfig? branding;

  const LoginScreen({
    super.key,
    required this.authController,
    required this.onLoginSuccess,
    this.branding,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolCodeController =
      TextEditingController(text: 'DPS-RKP-042');
  final _studentIdController =
      TextEditingController(text: 'DPS-2026-8A-14');
  final _passwordController =
      TextEditingController(text: 'dps@student');

  // Focus nodes to drive animated focus states
  final _schoolCodeFocus = FocusNode();
  final _studentIdFocus  = FocusNode();
  final _passwordFocus   = FocusNode();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _schoolCodeFocus.addListener(_onFocusChange);
    _studentIdFocus.addListener(_onFocusChange);
    _passwordFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _schoolCodeController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    _schoolCodeFocus.dispose();
    _studentIdFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    final success = await widget.authController.signInWithSchoolCode(
      schoolCode: _schoolCodeController.text.trim(),
      studentRollOrEmail: _studentIdController.text.trim(),
      pinOrPassword: _passwordController.text.trim(),
    );
    if (success && mounted) widget.onLoginSuccess();
  }

  void _handleDemoSignIn() {
    _schoolCodeController.text = 'DPS-RKP-042';
    _studentIdController.text  = 'DPS-2026-8A-14';
    _passwordController.text   = 'dps@student';
    widget.authController.continueAsGuest();
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.authController;
    final branding = widget.branding ?? SchoolBrandingConfig.dpsDefault();
    final accent = branding.primaryColor;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── School logo & welcome header ──────────────────
                    Center(
                      child: SchoolLogo(
                        logoUrl: branding.logoUrl,
                        size: 72,
                        borderColor: accent.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      branding.schoolName,
                      textAlign: TextAlign.center,
                      style: AppTypography.headingSmall(color: accent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Student Learning Portal',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 28),

                    // ── Error banner ──────────────────────────────────
                    if (controller.errorMessage != null) ...[
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.errorBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: AppColors.error, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage!,
                                style: AppTypography.caption(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Login form card ───────────────────────────────
                    AppCard(
                      padding: const EdgeInsets.all(20.0),
                      hasShadow: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // School Code
                          _AnimatedFieldLabel(
                            label: 'School Code',
                            isFocused: _schoolCodeFocus.hasFocus,
                            accentColor: accent,
                          ),
                          const SizedBox(height: 6),
                          _AnimatedTextField(
                            controller: _schoolCodeController,
                            focusNode: _schoolCodeFocus,
                            accentColor: accent,
                            hintText: 'e.g. DPS-RKP-042',
                            prefixIcon: Icons.school_outlined,
                            textCapitalization: TextCapitalization.characters,
                            validator: (val) =>
                                (val == null || val.trim().isEmpty)
                                    ? 'Please enter your school code'
                                    : null,
                          ),
                          const SizedBox(height: 18),

                          // Student ID
                          _AnimatedFieldLabel(
                            label: 'Student Admission / Roll No.',
                            isFocused: _studentIdFocus.hasFocus,
                            accentColor: accent,
                          ),
                          const SizedBox(height: 6),
                          _AnimatedTextField(
                            controller: _studentIdController,
                            focusNode: _studentIdFocus,
                            accentColor: accent,
                            hintText: 'e.g. DPS-2026-8A-14',
                            prefixIcon: Icons.badge_outlined,
                            validator: (val) =>
                                (val == null || val.trim().isEmpty)
                                    ? 'Please enter your student ID'
                                    : null,
                          ),
                          const SizedBox(height: 18),

                          // Password
                          _AnimatedFieldLabel(
                            label: 'Password / Access PIN',
                            isFocused: _passwordFocus.hasFocus,
                            accentColor: accent,
                          ),
                          const SizedBox(height: 6),
                          _AnimatedTextField(
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            accentColor: accent,
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
                                color: _passwordFocus.hasFocus
                                    ? accent
                                    : AppColors.textMuted,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                            validator: (val) =>
                                (val == null || val.isEmpty)
                                    ? 'Please enter your password'
                                    : null,
                          ),
                          const SizedBox(height: 24),

                          // Sign In Button
                          AppButton(
                            text: 'Sign in to Portal',
                            isFullWidth: true,
                            isLoading: controller.status == AuthStatus.authenticating,
                            variant: AppButtonVariant.primary,
                            onPressed: _handleSignIn,
                          ),
                          const SizedBox(height: 12),

                          // Demo Account Button
                          AppButton(
                            text: 'Explore Demo Account',
                            isFullWidth: true,
                            variant: AppButtonVariant.secondary,
                            icon: Icons.play_circle_outline_rounded,
                            onPressed: _handleDemoSignIn,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Privacy badge
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shield_outlined,
                              size: 15, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            'Student privacy protected · Encrypted & Ad-Free',
                            style: AppTypography.caption(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Animated field label: colour + weight transitions on focus
// ─────────────────────────────────────────────────────────────────────────
class _AnimatedFieldLabel extends StatelessWidget {
  final String label;
  final bool isFocused;
  final Color accentColor;

  const _AnimatedFieldLabel({
    required this.label,
    required this.isFocused,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      style: AppTypography.caption(
        color: isFocused ? accentColor : AppColors.textSecondary,
      ).copyWith(
        fontWeight: isFocused ? FontWeight.w700 : FontWeight.w600,
      ),
      child: Text(label),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────
// Animated text field: smooth glow + border transition on focus
// ─────────────────────────────────────────────────────────────────────────
class _AnimatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color accentColor;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;

  const _AnimatedTextField({
    required this.controller,
    required this.focusNode,
    required this.accentColor,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isFocused = focusNode.hasFocus;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        // Soft glow ring that fades in on focus
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.14),
                  blurRadius: 12,
                  spreadRadius: -2,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        textCapitalization: textCapitalization,
        style: AppTypography.bodyLarge(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Icon(
              prefixIcon,
              key: ValueKey(isFocused),
              size: 20,
              color: isFocused ? accentColor : AppColors.textMuted,
            ),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.background,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: accentColor, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.error, width: 1.8),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
