import 'package:flutter/material.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/auth/presentation/student_splash_screen.dart';
import 'features/school_branding/data/school_branding_repository.dart';
import 'features/school_branding/presentation/school_theme_provider.dart';
import 'features/school_branding/presentation/widgets/student_welcome_header.dart';
import 'screens/doubt_chat_screen.dart';
import 'screens/home_screen.dart';
import 'screens/library_screen.dart';
import 'screens/practice_screen.dart';
import 'screens/profile_screen.dart';
import 'state/student_state.dart';
import 'theme/app_colors.dart';
import 'theme/app_typography.dart';
import 'widgets/bottom_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QrieApp());
}

class QrieApp extends StatefulWidget {
  final bool skipSplash;

  const QrieApp({super.key, this.skipSplash = false});

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

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient(storage: _secureStorage);
    _authController = AuthController(
      apiClient: _apiClient,
      secureStorage: _secureStorage,
    );
    _brandingRepo = SchoolBrandingRepository(apiClient: _apiClient);

    _loadInitialBranding();

    if (widget.skipSplash) {
      _initialized = true;
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
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeProvider,
      builder: (context, _) {
        return StudentStateScope(
          notifier: _studentState,
          child: MaterialApp(
            title: 'Qrie Student App',
            debugShowCheckedModeBanner: false,
            theme: _themeProvider.themeData,
            home: !_initialized
                ? StudentSplashScreen(
                    authController: _authController,
                    branding: _themeProvider.branding,
                    onInitialized: () {
                      setState(() => _initialized = true);
                    },
                  )
                : MainScaffold(
                    themeProvider: _themeProvider,
                    authController: _authController,
                  ),
          ),
        );
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  final SchoolThemeProvider themeProvider;
  final AuthController authController;

  const MainScaffold({
    super.key,
    required this.themeProvider,
    required this.authController,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    PracticeScreen(),
    DoubtChatScreen(),
    LibraryScreen(),
    ProfileScreen(),
  ];

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
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: widget.themeProvider.branding.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () {
                            state.updateGradeAndBoard(tempGrade, tempBoard);
                            Navigator.pop(ctx);
                          },
                          child: Text('APPLY SYLLABUS', style: AppTypography.buttonLabel()),
                        ),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: StudentWelcomeHeader(
          branding: branding,
          studentName: profile.name,
          gradeAndBoard: '${profile.grade} ${profile.board}',
          streakDays: profile.streakDays,
          gems: profile.gems,
          onGradeTap: () => _showGradeSwitcherDialog(context, state),
          onProfileTap: () {
            setState(() => _currentIndex = 4);
          },
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
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
