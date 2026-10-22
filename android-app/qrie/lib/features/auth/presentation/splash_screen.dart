import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../application/auth_controller.dart';

/// True App Splash & Loading Screen
///
/// Features:
/// - Pure white background (#FFFFFF) to seamlessly blend with the vector SVG logo.
/// - Centered official Qrie AI logo rendered from 'assets/Qrielogo.svg'.
/// - Smooth subtle fade-in and scale animation.
/// - Background initialization of authentication session, tokens, and storage.
/// - Minimalist progress indicator to communicate loading state.
/// - Invokes [onInitialized] when loading completes.
class SplashScreen extends StatefulWidget {
  final AuthController authController;
  final VoidCallback onInitialized;
  final Duration minDuration;

  const SplashScreen({
    super.key,
    required this.authController,
    required this.onInitialized,
    this.minDuration = const Duration(milliseconds: 1400),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final stopwatch = Stopwatch()..start();

    try {
      await widget.authController.initializeSession();
    } catch (_) {}

    stopwatch.stop();
    final elapsed = stopwatch.elapsed;
    if (elapsed < widget.minDuration && widget.minDuration > Duration.zero) {
      await Future.delayed(widget.minDuration - elapsed);
    }

    if (mounted && !_initialized) {
      _initialized = true;
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  // Centered official Qrielogo.svg with white backdrop
                  SvgPicture.asset(
                    'assets/Qrielogo.svg',
                    width: 240,
                    height: 200,
                    fit: BoxFit.contain,
                    placeholderBuilder: (context) => const SizedBox(
                      width: 240,
                      height: 200,
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Subtle loading indicator
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0284C7), // Qrie Sky/Cobalt
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
