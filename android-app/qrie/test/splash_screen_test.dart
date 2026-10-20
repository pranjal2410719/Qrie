import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qrie/core/network/api_client.dart';
import 'package:qrie/core/storage/secure_storage.dart';
import 'package:qrie/features/auth/application/auth_controller.dart';
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

  testWidgets('StudentSplashScreen renders school logo, name, motto, and calls onInitialized', (WidgetTester tester) async {
    bool initialized = false;
    final branding = SchoolBrandingConfig.dpsDefault();
    final authController = AuthController(
      apiClient: ApiClient(),
      secureStorage: SecureStorageService(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: StudentSplashScreen(
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
    expect(find.text('Delhi Public School, R.K. Puram'), findsOneWidget);
    expect(find.text('SERVICE BEFORE SELF'), findsOneWidget);
    expect(find.text('Ready to learn today?'), findsOneWidget);
    expect(find.text('Powered by Qrie Academic Platform'), findsOneWidget);

    // Fast-forward animation and initialization timer
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));

    expect(initialized, isTrue);
  });
}
