import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrie/core/config/app_config.dart';
import 'package:qrie/core/config/demo_config.dart';
import 'package:qrie/core/network/api_client.dart';
import 'package:qrie/core/storage/secure_storage.dart';
import 'package:qrie/features/auth/application/auth_controller.dart';
import 'package:qrie/features/auth/presentation/demo_login_screen.dart';
import 'package:qrie/features/auth/presentation/welcome_screen.dart';
import 'package:qrie/features/school_branding/presentation/school_theme_provider.dart';
import 'package:qrie/main.dart';
import 'package:qrie/state/student_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SecureStorageService secureStorage;
  late ApiClient apiClient;
  late AuthController authController;
  late SchoolThemeProvider themeProvider;
  late StudentState studentState;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    // Mock secure storage in-memory channels
    final storageMap = <String, String>{};
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'write') {
          final key = methodCall.arguments['key'] as String;
          final value = methodCall.arguments['value'] as String;
          storageMap[key] = value;
          return null;
        } else if (methodCall.method == 'read') {
          final key = methodCall.arguments['key'] as String;
          return storageMap[key];
        } else if (methodCall.method == 'deleteAll') {
          storageMap.clear();
          return null;
        }
        return null;
      },
    );

    secureStorage = SecureStorageService();
    apiClient = ApiClient(storage: secureStorage);
    authController = AuthController(
      apiClient: apiClient,
      secureStorage: secureStorage,
    );
    themeProvider = SchoolThemeProvider();
    studentState = StudentState();

    // Ensure development mode with demo auth enabled by default
    AppConfig.initialize(AppConfig.development(enableDemoAuth: true));
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
      null,
    );
    authController.dispose();
    themeProvider.dispose();
    studentState.dispose();
  });

  Widget createTestableWelcomeScreen({VoidCallback? onLoginSuccess}) {
    return StudentStateScope(
      notifier: studentState,
      child: MaterialApp(
        theme: themeProvider.themeData,
        home: WelcomeScreen(
          authController: authController,
          themeProvider: themeProvider,
          onLoginSuccess: onLoginSuccess ?? () {},
        ),
      ),
    );
  }

  Widget createTestableDemoLoginScreen({VoidCallback? onLoginSuccess}) {
    return StudentStateScope(
      notifier: studentState,
      child: MaterialApp(
        theme: themeProvider.themeData,
        home: DemoLoginScreen(
          authController: authController,
          themeProvider: themeProvider,
          onLoginSuccess: onLoginSuccess ?? () {},
        ),
      ),
    );
  }

  group('Onboarding & Welcome Screen Tests', () {
    testWidgets('Screen One: Welcome screen renders brand, headline, and both primary CTAs', (tester) async {
      await tester.pumpWidget(createTestableWelcomeScreen());
      await tester.pumpAndSettle();

      // Verify branding and heading
      expect(find.text('Qrie'), findsOneWidget);
      expect(find.textContaining('Your Brain Called'), findsOneWidget);
      expect(find.textContaining('active recall'), findsOneWidget);

      // Verify two prominent actions
      expect(find.text('SIGN IN'), findsOneWidget);
      expect(find.text('GET STARTED / REGISTER'), findsOneWidget);

      // Verify feature pills
      expect(find.text('Active Recall'), findsOneWidget);
      expect(find.text('NCERT Aligned'), findsOneWidget);
      expect(find.text('AI Tutor'), findsOneWidget);
      expect(find.text('DEMO READY'), findsOneWidget);
    });

    testWidgets('Tapping Sign In opens Demo Login screen smoothly with back navigation support', (tester) async {
      await tester.pumpWidget(createTestableWelcomeScreen());
      await tester.pumpAndSettle();

      // Tap Sign In
      await tester.tap(find.text('SIGN IN'));
      await tester.pumpAndSettle();

      // Verify Demo Login screen opened
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(DemoLoginScreen), findsOneWidget);

      // Test back navigation
      await tester.tap(find.byTooltip('Back to Welcome'));
      await tester.pumpAndSettle();

      // Verify back on Welcome screen
      expect(find.byType(WelcomeScreen), findsOneWidget);
      expect(find.text('GET STARTED / REGISTER'), findsOneWidget);
    });

    testWidgets('Tapping Get Started opens student onboarding guidance sheet', (tester) async {
      await tester.pumpWidget(createTestableWelcomeScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('GET STARTED / REGISTER'));
      await tester.pumpAndSettle();

      expect(find.text('Student Onboarding'), findsOneWidget);
      expect(find.textContaining('Qrie accounts are provisioned in collaboration with your school'), findsOneWidget);
      expect(find.text('CONTINUE TO DEMO LOGIN'), findsOneWidget);
    });
  });

  group('Prefilled Demo Login Screen Tests', () {
    testWidgets('Fields are prefilled with demo credentials and password obscured by default', (tester) async {
      await tester.pumpWidget(createTestableDemoLoginScreen());
      await tester.pumpAndSettle();

      // Verify prefilled values
      expect(find.text(DemoConfig.demoEmail), findsOneWidget);
      expect(find.text(DemoConfig.demoPassword), findsOneWidget);

      // Password field should be obscured
      final editableTextWidgets = tester.widgetList<EditableText>(find.byType(EditableText));
      final passwordEditable = editableTextWidgets.firstWhere((w) => w.obscureText);
      expect(passwordEditable.obscureText, isTrue);

      // Tap visibility toggle to reveal password
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();

      final updatedPasswordEditable = tester.widgetList<EditableText>(find.byType(EditableText)).firstWhere((w) => w.controller.text == DemoConfig.demoPassword);
      expect(updatedPasswordEditable.obscureText, isFalse);
    });

    testWidgets('Fields remain editable and validate input format', (tester) async {
      await tester.pumpWidget(createTestableDemoLoginScreen());
      await tester.pumpAndSettle();

      // Clear email and test required validation
      await tester.enterText(find.byWidgetPredicate((w) => w is TextField && w.controller?.text == DemoConfig.demoEmail), '');
      await tester.pump();

      await tester.tap(find.text('SIGN IN TO QRIE'));
      await tester.pump();

      expect(find.text('Please enter student email'), findsOneWidget);

      // Test invalid email
      await tester.enterText(find.byWidgetPredicate((w) => w is TextField && w.controller?.text == ''), 'invalid-email');
      await tester.pump();

      await tester.tap(find.text('SIGN IN TO QRIE'));
      await tester.pump();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });

    testWidgets('Forgot password action provides school administrator guidance dialog', (tester) async {
      await tester.pumpWidget(createTestableDemoLoginScreen());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      expect(find.text('Reset Password'), findsOneWidget);
      expect(find.textContaining('provisioned and managed by your educational institution'), findsOneWidget);

      await tester.tap(find.text('Understood'));
      await tester.pumpAndSettle();
      expect(find.text('Reset Password'), findsNothing);
    });
  });

  group('Demo Authentication & Production Protection Tests', () {
    testWidgets('Successful demo login triggers callback and creates distinguishable demo session', (tester) async {
      bool loginSuccessCalled = false;

      await tester.pumpWidget(createTestableDemoLoginScreen(
        onLoginSuccess: () => loginSuccessCalled = true,
      ));
      await tester.pumpAndSettle();

      // Tap Sign In with prefilled demo credentials
      await tester.tap(find.text('SIGN IN TO QRIE'));
      await tester.pump(); // Start loading
      expect(find.text('SIGNING IN...'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(loginSuccessCalled, isTrue);
      expect(authController.isAuthenticated, isTrue);
      expect(authController.isDemoSession, isTrue);
      expect(authController.currentUser?.id, DemoConfig.demoStudentId);
      expect(authController.currentUser?.isDemo, isTrue);
    });

    testWidgets('Demo authentication is strictly rejected when demo mode is disabled', (tester) async {
      // Disable demo auth explicitly (simulating production environment)
      AppConfig.initialize(AppConfig.production(enableDemoAuth: false));

      await tester.pumpWidget(createTestableDemoLoginScreen());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, DemoConfig.demoEmail);
      await tester.enterText(find.byType(TextField).last, DemoConfig.demoPassword);
      await tester.pump();

      await tester.tap(find.text('SIGN IN TO QRIE'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Demo authentication is disabled'), findsOneWidget);
      expect(authController.isAuthenticated, isFalse);
      expect(authController.isDemoSession, isFalse);
    });

    test('Sign out clears demo session completely', () async {
      // Sign in first
      await authController.signInWithDemo(
        email: DemoConfig.demoEmail,
        password: DemoConfig.demoPassword,
      );
      expect(authController.isAuthenticated, isTrue);
      expect(authController.isDemoSession, isTrue);

      // Sign out
      await authController.signOut();
      expect(authController.isAuthenticated, isFalse);
      expect(authController.isDemoSession, isFalse);
      expect(authController.currentUser, isNull);
    });

    testWidgets('Full flow: App loads Onboarding, signs in with demo, and enters Dashboard', (tester) async {
      await tester.pumpWidget(QrieApp(
        skipSplash: true,
        showOnboarding: true,
        authController: authController,
      ));
      await tester.pumpAndSettle();

      // Should display WelcomeScreen
      expect(find.byType(WelcomeScreen), findsOneWidget);

      // Tap Sign In
      await tester.tap(find.text('SIGN IN'));
      await tester.pumpAndSettle();

      // Should display DemoLoginScreen
      expect(find.byType(DemoLoginScreen), findsOneWidget);

      // Tap Sign In to Qrie
      await tester.tap(find.text('SIGN IN TO QRIE'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 1000));

      // App should navigate directly into student Dashboard (MainScaffold)
      expect(find.byType(MainScaffold), findsOneWidget);
      expect(find.textContaining('Hi,'), findsOneWidget);
    });
  });
}
