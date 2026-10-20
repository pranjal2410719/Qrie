import 'package:flutter/material.dart';
import '../../school_branding/models/school_branding_config.dart';
import '../../school_branding/presentation/widgets/school_logo.dart';
import '../application/auth_controller.dart';

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
    this.splashDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<StudentSplashScreen> createState() => _StudentSplashScreenState();
}

class _StudentSplashScreenState extends State<StudentSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
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
    final branding = widget.branding;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 3),

                    // Official School Emblem / Logo
                    SchoolLogo(
                      logoUrl: branding.logoUrl,
                      size: 96,
                      borderColor: branding.primaryColor.withValues(alpha: 0.3),
                    ),

                    const SizedBox(height: 24),

                    // School Name
                    Text(
                      branding.schoolName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: branding.primaryColor,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // School Motto
                    Text(
                      branding.motto.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Real Unsplash Educational Photo / Illustration
                    Container(
                      width: 200,
                      height: 130,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            offset: Offset(0, 6),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          branding.heroImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: branding.secondaryColor,
                            child: Icon(
                              Icons.menu_book_rounded,
                              size: 48,
                              color: branding.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Student Welcome Prompt
                    Text(
                      'Ready to learn today?',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4B4B4B),
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Smooth subtle loading indicator
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(branding.primaryColor),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Powered by Qrie indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.school_outlined, size: 14, color: Color(0xFFAFAFAF)),
                        const SizedBox(width: 6),
                        Text(
                          'Powered by Qrie Academic Platform',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFAFAFAF),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
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
