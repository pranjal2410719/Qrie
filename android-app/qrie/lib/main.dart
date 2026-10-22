import 'package:flutter/material.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'features/auth/presentation/student_splash_screen.dart';
import 'features/auth/presentation/welcome_screen.dart';
import 'features/school_branding/data/school_branding_repository.dart';
import 'features/school_branding/presentation/school_theme_provider.dart';
import 'features/school_branding/presentation/widgets/student_welcome_header.dart';
import 'screens/home_screen.dart';
import 'screens/learn/learn_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/calendar/calendar_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'state/student_state.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'widgets/app_button.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/floating_ai_tutor_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QrieApp(skipSplash: false, showOnboarding: true));
}

class QrieApp extends StatefulWidget {
  final bool skipSplash;
  final bool showOnboarding;
  final AuthController? authController;

  const QrieApp({
    super.key,
    this.skipSplash = true,
    this.showOnboarding = false,
    this.authController,
  });

  @override
  State<QrieApp> createState() => _QrieAppState();
}

class _QrieAppState extends State<QrieApp> {
  final StudentState _studentState = StudentState();
  final SecureStorageService _secureStorage = SecureStorageService();
  late final ApiClient _apiClient;
  late final AuthController _authController;
  late final SchoolBrandingRepository _brandingRepo;
  final SchoolThemeProvider _themeProvider = SchoolThemeProvider();

  bool _splashComplete = false;
  bool _onboardingComplete = false;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(storage: _secureStorage);
    _authController = widget.authController ??
        AuthController(
          apiClient: _apiClient,
          secureStorage: _secureStorage,
        );
    _brandingRepo = SchoolBrandingRepository(apiClient: _apiClient);

    _loadInitialBranding();

    if (widget.skipSplash) {
      _splashComplete = true;
      _onboardingComplete = true;
      if (!widget.showOnboarding) {
        // Default to authenticated guest/demo session for direct test harnesses
        if (!_authController.isAuthenticated) {
          _authController.continueAsGuest();
        }
      }
    } else {
      _splashComplete = false;
      _onboardingComplete = false;
    }
  }

  Future<void> _loadInitialBranding() async {
    final cached = await _brandingRepo.getCachedBranding();
    _themeProvider.updateBranding(cached);
  }

  @override
  void dispose() {
    _studentState.dispose();
    _themeProvider.dispose();
    if (widget.authController == null) {
      _authController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_themeProvider, _authController]),
      builder: (context, _) {
        return StudentStateScope(
          notifier: _studentState,
          child: MaterialApp(
            title: 'Qrie',
            debugShowCheckedModeBanner: false,
            theme: _themeProvider.themeData,
            home: !_splashComplete
                ? SplashScreen(
                    authController: _authController,
                    onInitialized: () {
                      setState(() => _splashComplete = true);
                    },
                  )
                : (!_onboardingComplete
                    ? StudentOnboardingScreen(
                        authController: _authController,
                        branding: _themeProvider.branding,
                        onInitialized: () {
                          setState(() => _onboardingComplete = true);
                        },
                      )
                    : (_authController.isAuthenticated
                        ? MainScaffold(
                            themeProvider: _themeProvider,
                            authController: _authController,
                            onSignOut: () async {
                              _studentState.resetSession();
                              await _authController.signOut();
                            },
                          )
                        : WelcomeScreen(
                            authController: _authController,
                            themeProvider: _themeProvider,
                            onLoginSuccess: () {
                              setState(() {});
                            },
                          ))),
          ),
        );
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  final SchoolThemeProvider themeProvider;
  final AuthController authController;
  final VoidCallback? onSignOut;

  const MainScaffold({
    super.key,
    required this.themeProvider,
    required this.authController,
    this.onSignOut,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  List<Widget> _buildPages() {
    return [
      const HomeScreen(),
      const LearnScreen(),
      const LibraryScreen(),
      ProfileScreen(
        onBack: () => setState(() => _currentIndex = 0),
        onSignOut: widget.onSignOut,
      ),
    ];
  }

  void _showGradeSwitcherDialog(BuildContext context, StudentState state) {
    final grades = ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'];
    final boards = ['CBSE', 'ICSE', 'State Board'];

    String tempGrade = state.profile.grade;
    String tempBoard = state.profile.board;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E5E5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Select Your Grade & Board',
                        style: AppTypography.headingSmall(),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Personalize your NCERT syllabus and practice content.',
                        style: AppTypography.bodySmall(),
                      ),
                      const SizedBox(height: 20),
                      Text('GRADE / CLASS', style: AppTypography.caption(color: AppColors.charcoal)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: grades.map((g) {
                          final isSel = (g == tempGrade);
                          return GestureDetector(
                            onTap: () => setModalState(() => tempGrade = g),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFFE8F5EE) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? widget.themeProvider.branding.primaryColor : const Color(0xFFE5E5E5),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                g,
                                style: AppTypography.pillLabel(
                                  color: isSel ? AppColors.charcoal : AppColors.pencilGray,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      Text('EDUCATIONAL BOARD', style: AppTypography.caption(color: AppColors.charcoal)),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: boards.map((b) {
                          final isSel = (b == tempBoard);
                          return GestureDetector(
                            onTap: () => setModalState(() => tempBoard = b),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSel ? const Color(0xFFE8F5EE) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSel ? widget.themeProvider.branding.primaryColor : const Color(0xFFE5E5E5),
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                b,
                                style: AppTypography.pillLabel(
                                  color: isSel ? AppColors.charcoal : AppColors.pencilGray,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'APPLY SYLLABUS',
                        isFullWidth: true,
                        variant: AppButtonVariant.primary,
                        onPressed: () {
                          state.updateGradeAndBoard(tempGrade, tempBoard);
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final branding = widget.themeProvider.branding;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: _currentIndex == 3
          ? null
          : StudentWelcomeHeader(
              branding: branding,
              studentName: profile.name,
              gradeAndBoard: '${profile.grade} ${profile.board}',
              streakDays: profile.streakDays,
              gems: profile.gems,
              unreadNotificationsCount: state.unreadNotificationCount,
              onGradeTap: () => _showGradeSwitcherDialog(context, state),
              onProfileTap: () {
                setState(() => _currentIndex = 3);
              },
              onCalendarTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CalendarScreen(),
                  ),
                );
              },
              onNotificationTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _buildPages(),
          ),
          const FloatingAITutorWidget(
            bottomOffset: 92,
            rightOffset: 16,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
