import 'package:flutter/material.dart';
import '../../../widgets/duolingo_button.dart';
import '../../../widgets/mascot_avatar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../application/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  final AuthController authController;
  final VoidCallback onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.authController,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _schoolCodeController = TextEditingController(text: 'DELHI-042');
  final _studentIdController = TextEditingController(text: 'STD-104');
  final _passwordController = TextEditingController(text: 'qrie2026');

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
      schoolCode: _schoolCodeController.text,
      studentRollOrEmail: _studentIdController.text,
      pinOrPassword: _passwordController.text,
    );

    if (success && mounted) {
      widget.onLoginSuccess();
    }
  }

  void _handleGuestExplore() {
    widget.authController.continueAsGuest();
    widget.onLoginSuccess();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.authController;

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: MascotAvatar(
                        size: 80,
                        expression: MascotExpression.happy,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Welcome to Qrie',
                      textAlign: TextAlign.center,
                      style: AppTypography.headingSmall(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Enter your school details or explore as guest',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall(),
                    ),
                    const SizedBox(height: 28),

                    if (controller.errorMessage != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECEB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFF4B4B), width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline_rounded, color: Color(0xFFFF4B4B), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                controller.errorMessage!,
                                style: AppTypography.caption(color: const Color(0xFFD32F2F)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],

                    // School Code field
                    Text('SCHOOL CODE', style: AppTypography.caption(color: AppColors.charcoal)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _schoolCodeController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'e.g. DELHI-042',
                        prefixIcon: const Icon(Icons.school_outlined, color: AppColors.pencilGray),
                        filled: true,
                        fillColor: AppColors.cloudGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.lineGray, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.lineGray, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.eagerGreen, width: 2),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter school code' : null,
                    ),
                    const SizedBox(height: 16),

                    // Student ID / Roll No field
                    Text('STUDENT ID / ROLL NO', style: AppTypography.caption(color: AppColors.charcoal)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _studentIdController,
                      decoration: InputDecoration(
                        hintText: 'e.g. STD-104 or Roll No',
                        prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.pencilGray),
                        filled: true,
                        fillColor: AppColors.cloudGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.lineGray, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.lineGray, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.eagerGreen, width: 2),
                        ),
                      ),
                      validator: (val) => val == null || val.trim().isEmpty ? 'Please enter student ID' : null,
                    ),
                    const SizedBox(height: 16),

                    // Password / PIN field
                    Text('PASSWORD / PIN', style: AppTypography.caption(color: AppColors.charcoal)),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.pencilGray),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                            color: AppColors.pencilGray,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        filled: true,
                        fillColor: AppColors.cloudGray,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.lineGray, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.lineGray, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: AppColors.eagerGreen, width: 2),
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter password' : null,
                    ),
                    const SizedBox(height: 24),

                    // Sign In Button
                    DuolingoButton(
                      text: controller.status == AuthStatus.authenticating ? 'SIGNING IN...' : 'SIGN IN',
                      fullWidth: true,
                      style: DuolingoButtonStyle.primaryGreen,
                      onPressed: controller.status == AuthStatus.authenticating ? null : _handleSignIn,
                    ),
                    const SizedBox(height: 14),

                    // Guest explore button
                    DuolingoButton(
                      text: 'CONTINUE AS GUEST',
                      fullWidth: true,
                      style: DuolingoButtonStyle.outlineGray,
                      onPressed: _handleGuestExplore,
                    ),
                    const SizedBox(height: 28),

                    // Privacy badge
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shield_outlined, size: 16, color: AppColors.pencilGray),
                          const SizedBox(width: 6),
                          Text(
                            'Student privacy protected • Ad-free & encrypted',
                            style: AppTypography.caption(color: AppColors.pencilGray).copyWith(fontSize: 11),
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
