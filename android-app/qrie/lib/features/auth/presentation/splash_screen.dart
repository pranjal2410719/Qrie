import 'package:flutter/material.dart';
import '../../../widgets/mascot_avatar.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_typography.dart';
import '../application/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  final AuthController authController;
  final VoidCallback onInitialized;

  const SplashScreen({
    super.key,
    required this.authController,
    required this.onInitialized,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _init();
  }

  Future<void> _init() async {
    await widget.authController.initializeSession();
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      widget.onInitialized();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: const MascotAvatar(
                size: 96,
                expression: MascotExpression.happy,
                showBadge: false,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'qrie',
              style: AppTypography.display(color: AppColors.eagerGreen),
            ),
            const SizedBox(height: 6),
            Text(
              'Curiosity-driven learning',
              style: AppTypography.bodyMedium(color: AppColors.pencilGray),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.eagerGreen),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
