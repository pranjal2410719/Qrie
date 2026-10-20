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
  final _schoolCodeController = TextEditingController(text: 'DPS-RKP-042');
  final _studentIdController = TextEditingController(text: 'DPS-2026-8A-14');
  final _passwordController = TextEditingController(text: 'dps@student');

  bool _obscurePassword = true;

  @override
  void dispose() {
    _schoolCodeController.dispose();
    _studentIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await widget.authController.signInWithSchoolCode(
      schoolCode: _schoolCodeController.text.trim(),
      studentRollOrEmail: _studentIdController.text.trim(),
      pinOrPassword: _passwordController.text.trim(),
    );

    if (success && mounted) {
      widget.onLoginSuccess();
    }
  }

  void _handleDemoSignIn() {
    _schoolCodeController.text = 'DPS-RKP-042';
    _studentIdController.text = 'DPS-2026-8A-14';
    _passwordController.text = 'dps@student';
    widget.authController.continueAsGuest();
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.authController;
    final branding = widget.branding ?? SchoolBrandingConfig.dpsDefault();

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
                    // School emblem & welcome header
                    Center(
                      child: SchoolLogo(
                        logoUrl: branding.logoUrl,
                        size: 72,
                        borderColor: branding.primaryColor.withValues(alpha: 0.25),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      branding.schoolName,
                      textAlign: TextAlign.center,
                      style: AppTypography.headingSmall(color: branding.primaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Student Learning Portal',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(),
                    ),
                    const SizedBox(height: 24),

                    if (controller.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.errorSurface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.errorBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.error, size: 20),
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

                    AppCard(
                      padding: const EdgeInsets.all(20.0),
                      hasShadow: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // School Code field
                          Text('SCHOOL CODE', style: AppTypography.caption(color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _schoolCodeController,
                            textCapitalization: TextCapitalization.characters,
                            style: AppTypography.bodyLarge(),
                            decoration: InputDecoration(
                              hintText: 'e.g. DPS-RKP-042',
                              prefixIcon: const Icon(Icons.school_outlined, size: 20, color: AppColors.textMuted),
                              filled: true,
                              fillColor: AppColors.background,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                borderSide: BorderSide(color: branding.primaryColor, width: 1.8),
                              ),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Enter school code' : null,
                          ),
                          const SizedBox(height: 16),

                          // Student ID field
                          Text('STUDENT ADMISSION / ROLL NO', style: AppTypography.caption(color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _studentIdController,
                            style: AppTypography.bodyLarge(),
                            decoration: InputDecoration(
                              hintText: 'e.g. DPS-2026-8A-14',
                              prefixIcon: const Icon(Icons.badge_outlined, size: 20, color: AppColors.textMuted),
                              filled: true,
                              fillColor: AppColors.background,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                borderSide: BorderSide(color: branding.primaryColor, width: 1.8),
                              ),
                            ),
                            validator: (val) => val == null || val.trim().isEmpty ? 'Enter student ID' : null,
                          ),
                          const SizedBox(height: 16),

                          // Password field
                          Text('PASSWORD / ACCESS PIN', style: AppTypography.caption(color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: AppTypography.bodyLarge(),
                            decoration: InputDecoration(
                              hintText: 'Enter student password',
                              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20, color: AppColors.textMuted),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  size: 20,
                                  color: AppColors.textMuted,
                                ),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                borderSide: BorderSide(color: branding.primaryColor, width: 1.8),
                              ),
                            ),
                            validator: (val) => val == null || val.isEmpty ? 'Enter password' : null,
                          ),
                          const SizedBox(height: 22),

                          // Sign In Button
                          AppButton(
                            text: 'SIGN IN TO PORTAL',
                            isFullWidth: true,
                            isLoading: controller.status == AuthStatus.authenticating,
                            variant: AppButtonVariant.primary,
                            onPressed: _handleSignIn,
                          ),
                          const SizedBox(height: 12),

                          // Demo Student Login Button
                          AppButton(
                            text: 'EXPLORE DEMO ACCOUNT',
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
                          const Icon(Icons.shield_outlined, size: 15, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Text(
                            'Student privacy protected • Encrypted & Ad-Free',
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
