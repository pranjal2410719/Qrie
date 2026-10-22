import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/core/network/api_client.dart';
import 'package:qrie/core/storage/secure_storage.dart';
import 'package:qrie/features/auth/application/auth_controller.dart';
import 'package:qrie/features/auth/presentation/splash_screen.dart';
import 'package:qrie/features/auth/presentation/student_splash_screen.dart';
import 'package:qrie/features/school_branding/models/school_branding_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        return null; // Return null (no stored tokens)
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
  });

  group('Splash Screen & Onboarding Screen Tests', () {
    testWidgets('SplashScreen takes at least 3 seconds by default and renders white screen with Qrielogo.svg', (WidgetTester tester) async {
      bool initialized = false;
      final authController = AuthController(
        apiClient: ApiClient(),
        secureStorage: SecureStorageService(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(
            authController: authController,
            // Uses default minDuration = 3 seconds
            onInitialized: () {
              initialized = true;
            },
          ),
        ),
      );

      // Verify pure white background scaffold
      final scaffoldFinder = find.byType(Scaffold);
      expect(scaffoldFinder, findsOneWidget);
      final scaffold = tester.widget<Scaffold>(scaffoldFinder);
      expect(scaffold.backgroundColor, equals(Colors.white));

      // Verify centered SVG logo
      expect(find.byType(SvgPicture), findsOneWidget);

      // Verify loading progress indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Fast-forward 2.5 seconds: should NOT have completed yet (< 3 seconds)
      await tester.pump(const Duration(milliseconds: 2500));
      expect(initialized, isFalse);

      // Fast-forward remaining 600ms (total > 3 seconds): now completes
      await tester.pump(const Duration(milliseconds: 600));
      expect(initialized, isTrue);
    });

    testWidgets('StudentOnboardingScreen renders school branding, does NOT advance automatically, and proceeds on tap', (WidgetTester tester) async {
      bool initialized = false;
      final branding = SchoolBrandingConfig.dpsDefault();
      final authController = AuthController(
        apiClient: ApiClient(),
        secureStorage: SecureStorageService(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StudentOnboardingScreen(
            authController: authController,
            branding: branding,
            onInitialized: () {
              initialized = true;
            },
          ),
        ),
      );

      // Verify school branding elements appear immediately
      expect(find.text(branding.schoolName.toUpperCase()), findsOneWidget);
      expect(find.text(branding.motto), findsOneWidget);
      expect(find.text('Tap to begin learning'), findsOneWidget);

      // Verify Powered by Qrie AI text is strictly removed
      expect(find.text('Powered by Qrie AI'), findsNothing);

      // Advance time by 10 seconds: screen MUST NOT advance automatically
      await tester.pump(const Duration(seconds: 10));
      expect(initialized, isFalse);

      // Screen advances ONLY when user taps forward button or label
      await tester.tap(find.text('Tap to begin learning'));
      await tester.pump();
      expect(initialized, isTrue);
    });

    testWidgets('StudentOnboardingScreen advances when tapping Skip button', (WidgetTester tester) async {
      bool initialized = false;
      final branding = SchoolBrandingConfig.dpsDefault();
      final authController = AuthController(
        apiClient: ApiClient(),
        secureStorage: SecureStorageService(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StudentOnboardingScreen(
            authController: authController,
            branding: branding,
            onInitialized: () {
              initialized = true;
            },
          ),
        ),
      );

      // Does not advance on its own
      await tester.pump(const Duration(seconds: 5));
      expect(initialized, isFalse);

      // Advances on tapping Skip
      await tester.tap(find.text('Skip'));
      await tester.pump();
      expect(initialized, isTrue);
    });
  });
}
