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
    testWidgets('SplashScreen renders pure white screen with centered Qrielogo.svg and loading indicator', (WidgetTester tester) async {
      bool initialized = false;
      final authController = AuthController(
        apiClient: ApiClient(),
        secureStorage: SecureStorageService(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(
            authController: authController,
            minDuration: const Duration(milliseconds: 50),
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

      // Fast-forward animation & timer
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(initialized, isTrue);
    });

    testWidgets('StudentOnboardingScreen renders school branding without Powered by Qrie AI footer', (WidgetTester tester) async {
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
            splashDuration: const Duration(milliseconds: 50),
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

      // Fast-forward animation and initialization timer
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));

      expect(initialized, isTrue);
    });
  });
}
