import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../features/school_branding/models/school_branding_config.dart';
import '../models/student_profile.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_card.dart';
import 'doubt_chat_screen.dart';

/// Redesigned Student Profile Screen
///
/// Follows the reference layout's vertical composition:
/// 1. Top prominent header/background area with subtle styling.
/// 2. Upper-left Back button and upper-right Settings action.
/// 3. Large rounded profile card overlapping the lower edge of the header.
/// 4. Centered circular profile image overlapping the header/card boundary.
/// 5. Student identity (Name, Class, School, Learning Profile label).
/// 6. Quick actions row (Edit, Syllabus, Doubts, Settings).
/// 7. Three-item statistics row (Day Streak, Lessons Done, Total XP).
/// 8. Secondary information section (Academic Badges, Weekly Activity, School Credentials).
/// 9. Reserved bottom space for the floating bottom navigation bar.
class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSignOut;

  const ProfileScreen({
    super.key,
    this.onBack,
    this.onSignOut,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _chartCtrl;
  late List<Animation<double>> _barAnimations;
  Timer? _startTimer;

  static const double _headerHeight = 175.0;
  static const double _cardOverlap = 26.0;
  static const double _avatarSize = 92.0;

  @override
  void initState() {
    super.initState();

    _chartCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _barAnimations = List.generate(7, (i) {
      final start = (i * 0.08).clamp(0.0, 1.0);
      final end = (start + 0.45).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _chartCtrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    final isTesting = Platform.environment.containsKey('FLUTTER_TEST') ||
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTesting) {
      _startTimer = Timer(const Duration(milliseconds: 280), () {
        if (mounted) _chartCtrl.forward();
      });
    } else {
      _chartCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    _chartCtrl.dispose();
    super.dispose();
  }

  void _handleBack(BuildContext context) {
    HapticFeedback.lightImpact();
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      widget.onBack?.call();
    }
  }

  void _showEditProfileSheet(BuildContext context, StudentState state) {
    HapticFeedback.mediumImpact();
    final nameController = TextEditingController(text: state.profile.name);
    int selectedDailyGoal = state.profile.dailyGoalTarget;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Edit Student Profile',
                      style: AppTypography.headingSmall(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Update your profile information and daily learning goals.',
                      style: AppTypography.bodySmall(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'STUDENT FULL NAME',
                      style: AppTypography.caption(color: AppColors.textPrimary)
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.bgSurfaceSoft,
                        hintText: 'Enter student full name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.accentCobalt, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DAILY STUDY TARGET',
                          style: AppTypography.caption(color: AppColors.textPrimary)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentCobalt.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$selectedDailyGoal lessons / day',
                            style: AppTypography.caption(color: AppColors.accentCobalt)
                                .copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.accentCobalt,
                        inactiveTrackColor: const Color(0xFFE2E8F0),
                        thumbColor: AppColors.accentCobalt,
                        overlayColor: AppColors.accentCobalt.withValues(alpha: 0.2),
                      ),
                      child: Slider(
                        value: selectedDailyGoal.toDouble(),
                        min: 1,
                        max: 8,
                        divisions: 7,
                        onChanged: (val) {
                          setSheetState(() => selectedDailyGoal = val.round());
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.bgSurfaceOnyx,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          state.updateProfileName(nameController.text);
                          state.updateDailyGoalTarget(selectedDailyGoal);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Profile details updated successfully.'),
                              backgroundColor: AppColors.bgSurfaceOnyx,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          );
                        },
                        child: Text(
                          'SAVE CHANGES',
                          style: AppTypography.buttonLabel(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showSettingsSheet(BuildContext context, StudentState state) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text('Account & Preferences', style: AppTypography.headingSmall()),
                const SizedBox(height: 14),
                _buildSettingsOption(
                  icon: Icons.school_outlined,
                  title: 'Curriculum & Grade',
                  subtitle: '${state.profile.grade} • ${state.profile.board}',
                  onTap: () {
                    Navigator.pop(ctx);
                    _showGradeSwitcher(context, state);
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.sync_rounded,
                  title: 'Offline Database & Cache',
                  subtitle: 'SQLite Outbox synced • Local storage healthy',
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Offline database is synchronized and active.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notification Preferences',
                  subtitle: 'Homework due dates and live lecture reminders active',
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.info_outline_rounded,
                  title: 'About Qrie Academic Platform',
                  subtitle: 'Version 2.4.0 (Student Edition)',
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
                _buildSettingsOption(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  subtitle: 'Log out of this session and return to welcome screen',
                  onTap: () {
                    Navigator.pop(ctx);
                    _confirmSignOut(context);
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: AppColors.error),
            const SizedBox(width: 8),
            Text('Sign Out', style: AppTypography.headingSmall()),
          ],
        ),
        content: Text(
          'Are you sure you want to sign out of your Qrie student account?',
          style: AppTypography.body(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL',
                style: AppTypography.buttonLabel(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onSignOut?.call();
            },
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.accentCobalt, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.subheading(color: AppColors.textPrimary)
                        .copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTypography.caption(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  void _showGradeSwitcher(BuildContext context, StudentState state) {
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
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4.5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text('Select Your Grade & Board', style: AppTypography.headingSmall()),
                    const SizedBox(height: 4),
                    Text(
                      'Personalize your NCERT syllabus and practice content.',
                      style: AppTypography.bodySmall(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 18),
                    Text('GRADE / CLASS', style: AppTypography.caption(color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: grades.map((g) {
                        final isSel = (g == tempGrade);
                        return ChoiceChip(
                          label: Text(g),
                          selected: isSel,
                          onSelected: (selected) {
                            if (selected) setModalState(() => tempGrade = g);
                          },
                          selectedColor: AppColors.accentCobalt.withValues(alpha: 0.15),
                          backgroundColor: AppColors.bgSurfaceSoft,
                          labelStyle: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            color: isSel ? AppColors.accentCobalt : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSel ? AppColors.accentCobalt : const Color(0xFFE2E8F0),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text('CURRICULUM BOARD', style: AppTypography.caption(color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: boards.map((b) {
                        final isSel = (b == tempBoard);
                        return ChoiceChip(
                          label: Text(b),
                          selected: isSel,
                          onSelected: (selected) {
                            if (selected) setModalState(() => tempBoard = b);
                          },
                          selectedColor: AppColors.accentCobalt.withValues(alpha: 0.15),
                          backgroundColor: AppColors.bgSurfaceSoft,
                          labelStyle: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            color: isSel ? AppColors.accentCobalt : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: isSel ? AppColors.accentCobalt : const Color(0xFFE2E8F0),
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
                          backgroundColor: AppColors.bgSurfaceOnyx,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          state.updateGradeAndBoard(tempGrade, tempBoard);
                          Navigator.pop(ctx);
                        },
                        child: Text(
                          'APPLY SYLLABUS',
                          style: AppTypography.buttonLabel(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
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
    final dpsBranding = SchoolBrandingConfig.dpsDefault();

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // ── Section 1 & 2: Header + Overlapping Avatar + Main Profile Card ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Top Header/Background Area
                _buildHeaderBackground(context),

                // 2. Large Main Profile Card (starts overlapping lower edge of header)
                Padding(
                  padding: const EdgeInsets.only(
                    top: _headerHeight - _cardOverlap,
                    left: DesignTokens.horizontalPadding,
                    right: DesignTokens.horizontalPadding,
                  ),
                  child: _buildMainProfileCard(profile, state),
                ),

                // 3. Centered Circular Profile Avatar (overlapping header & card)
                Positioned(
                  top: (_headerHeight - _cardOverlap) - (_avatarSize / 2),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _buildOverlappingAvatar(context, profile, dpsBranding, state),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Section 3: Secondary Information Section ────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.horizontalPadding,
              ),
              child: _buildSecondarySection(profile, state),
            ),

            // Bottom padding for floating navigation bar clearance
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  // ── Header Area ─────────────────────────────────────────────────────────────
  Widget _buildHeaderBackground(BuildContext context) {
    return Container(
      height: _headerHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E293B), // Slate 800
            Color(0xFF1E3A8A), // Deep Blue 900
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button (Upper-Left)
              _buildHeaderGlassButton(
                icon: Icons.arrow_back_ios_new_rounded,
                tooltip: 'Back',
                onTap: () => _handleBack(context),
              ),

              // Header Center Label
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Student Profile',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subheading(color: Colors.white)
                        .copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.3),
                  ),
                ),
              ),

              // Settings Action (Upper-Right)
              _buildHeaderGlassButton(
                icon: Icons.settings_outlined,
                tooltip: 'Settings',
                onTap: () => _showSettingsSheet(context, StudentStateScope.of(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderGlassButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.22),
              width: 1.2,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  // ── Overlapping Circular Profile Avatar ──────────────────────────────────────
  Widget _buildOverlappingAvatar(
    BuildContext context,
    StudentProfile profile,
    SchoolBrandingConfig dpsBranding,
    StudentState state,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Circular Avatar Container with Crisp Multi-layer Border & Elevation
        Container(
          width: _avatarSize,
          height: _avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 4.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              profile.profileImageUrl,
              width: _avatarSize,
              height: _avatarSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Initial fallback
                final initials = profile.name.isNotEmpty
                    ? profile.name
                        .trim()
                        .split(' ')
                        .map((e) => e.isNotEmpty ? e[0] : '')
                        .take(2)
                        .join()
                        .toUpperCase()
                    : 'ST';

                return Container(
                  width: _avatarSize,
                  height: _avatarSize,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Accessible Edit/Camera Badge
        Positioned(
          bottom: 2,
          right: 2,
          child: GestureDetector(
            onTap: () => _showEditProfileSheet(context, state),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accentCobalt,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentCobalt.withValues(alpha: 0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Main Student Profile Card ───────────────────────────────────────────────
  Widget _buildMainProfileCard(StudentProfile profile, StudentState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Student Name & Verification Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  profile.name,
                  style: AppTypography.headingSmall().copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.verified_rounded,
                color: AppColors.accentCobalt,
                size: 20,
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 2. Class & Curriculum Pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF), // Blue 50
              borderRadius: BorderRadius.circular(9999),
              border: Border.all(color: const Color(0xFFBFDBFE)),
            ),
            child: Text(
              '${profile.grade} • ${profile.board} Curriculum',
              style: const TextStyle(
                fontFamily: AppTypography.primaryFont,
                color: Color(0xFF1D4ED8),
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 8),

          // 3. School Name & Student Identifier
          Text(
            'Delhi Public School, R.K. Puram • ID: ${profile.id.toUpperCase()}',
            style: AppTypography.caption(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          // 4. Learning Profile Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome_rounded, size: 13, color: AppColors.accentAmber),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Curious Explorer • Scholar Level 4',
                  style: AppTypography.caption(color: AppColors.textMuted)
                      .copyWith(fontWeight: FontWeight.w600, fontSize: 11.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 5. Quick-Action Row (Compact, independent tappable targets)
          _buildQuickActionRow(state),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 18),

          // 6. Three-Item Statistics Row
          _buildThreeStatisticsRow(profile),
        ],
      ),
    );
  }

  // ── Quick-Action Row ────────────────────────────────────────────────────────
  Widget _buildQuickActionRow(StudentState state) {
    return Row(
      children: [
        Expanded(
          child: _buildActionItem(
            icon: Icons.edit_outlined,
            label: 'Edit',
            onTap: () => _showEditProfileSheet(context, state),
          ),
        ),
        Expanded(
          child: _buildActionItem(
            icon: Icons.tune_rounded,
            label: 'Syllabus',
            onTap: () => _showGradeSwitcher(context, state),
          ),
        ),
        Expanded(
          child: _buildActionItem(
            icon: Icons.psychology_outlined,
            label: 'Doubts',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DoubtChatScreen()),
              );
            },
          ),
        ),
        Expanded(
          child: _buildActionItem(
            icon: Icons.shield_outlined,
            label: 'Settings',
            onTap: () => _showSettingsSheet(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Icon(icon, color: AppColors.accentCobalt, size: 20),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: AppTypography.primaryFont,
                color: AppColors.textPrimary,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Three-Item Statistics Row ───────────────────────────────────────────────
  Widget _buildThreeStatisticsRow(StudentProfile profile) {
    return Row(
      children: [
        // Metric 1: Day Streak
        Expanded(
          child: _buildStatisticColumn(
            value: '${profile.streakDays}',
            unit: 'Days',
            label: 'DAY STREAK',
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.accentAmber,
            bgColor: const Color(0xFFFEF3C7),
          ),
        ),

        Container(
          width: 1,
          height: 38,
          color: const Color(0xFFE2E8F0),
        ),

        // Metric 2: Lessons Completed
        Expanded(
          child: _buildStatisticColumn(
            value: '${profile.completedLessonIds.length}',
            unit: 'Done',
            label: 'LESSONS',
            icon: Icons.task_alt_rounded,
            iconColor: const Color(0xFF10B981),
            bgColor: const Color(0xFFD1FAE5),
          ),
        ),

        Container(
          width: 1,
          height: 38,
          color: const Color(0xFFE2E8F0),
        ),

        // Metric 3: Total XP
        Expanded(
          child: _buildStatisticColumn(
            value: '${profile.totalXp}',
            unit: 'XP',
            label: 'TOTAL XP',
            icon: Icons.bolt_rounded,
            iconColor: AppColors.accentCobalt,
            bgColor: const Color(0xFFDBEAFE),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticColumn({
    required String value,
    required String unit,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 14),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTypography.primaryFont,
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.4,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  // ── Secondary Information Section (Two-Card Structure) ──────────────────────
  Widget _buildSecondarySection(StudentProfile profile, StudentState state) {
    return Column(
      children: [
        // Card 1: Academic Badges & Achievements
        _buildBadgesCard(),

        const SizedBox(height: 16),

        // Card 2: Weekly Study Activity & Daily Goal
        _buildWeeklyActivityCard(profile),

        const SizedBox(height: 16),

        // Card 3: School Organization Credentials
        _buildCredentialsCard(),
      ],
    );
  }

  // ── Academic Badges Card ────────────────────────────────────────────────────
  Widget _buildBadgesCard() {
    final unlockedCount = MockData.badges.where((b) => b['unlocked'] == true).length;
    final totalCount = MockData.badges.length;

    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: AppColors.accentCobalt.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.emoji_events_rounded,
                    color: AppColors.accentCobalt, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Badges',
                  style: AppTypography.subheading(color: AppColors.textPrimary)
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Text(
                  '$unlockedCount of $totalCount Unlocked',
                  style: const TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    color: Color(0xFF1D4ED8),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Horizontal Badges Carousel
          SizedBox(
            height: 114,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MockData.badges.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final badge = MockData.badges[index];
                final isUnlocked = badge['unlocked'] as bool;

                return Container(
                  width: 108,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? const Color(0xFFF8FAFC)
                        : const Color(0xFFF1F5F9).withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isUnlocked
                          ? const Color(0xFFE2E8F0)
                          : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? const Color(0xFFD1FAE5)
                              : const Color(0xFFE2E8F0),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isUnlocked
                              ? (badge['icon'] as IconData)
                              : Icons.lock_outline_rounded,
                          color: isUnlocked
                              ? const Color(0xFF059669)
                              : AppColors.textMuted,
                          size: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        badge['name'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          color: isUnlocked ? AppColors.textPrimary : AppColors.textMuted,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isUnlocked ? 'Unlocked' : 'In Progress',
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          color: isUnlocked ? const Color(0xFF059669) : AppColors.textMuted,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Weekly Activity & Daily Goal Card ───────────────────────────────────────
  Widget _buildWeeklyActivityCard(StudentProfile profile) {
    final goalPercent = (profile.dailyGoalCurrent / profile.dailyGoalTarget).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.all(18),
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: AppColors.accentCobalt, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Study Activity',
                  style: AppTypography.subheading(color: AppColors.textPrimary)
                      .copyWith(fontSize: 15, fontWeight: FontWeight.w800),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '14.6h this week',
                style: AppTypography.caption(color: AppColors.accentCobalt)
                    .copyWith(fontWeight: FontWeight.w800),
                maxLines: 1,
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Daily Target Progress Indicator
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Daily Goal',
                        style: AppTypography.caption(color: AppColors.textPrimary)
                            .copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${profile.dailyGoalCurrent}/${profile.dailyGoalTarget} Lessons',
                      style: AppTypography.caption(color: AppColors.accentCobalt)
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: goalPercent,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE2E8F0),
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentCobalt),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Animated Bar Chart
          AnimatedBuilder(
            animation: _chartCtrl,
            builder: (_, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(7, (index) {
                  final hours = MockData.weeklyStudyHours[index];
                  final day = MockData.weekDays[index];
                  const maxHeight = 68.0;
                  final heightFactor = (hours / 4.0).clamp(0.18, 1.0);
                  final targetH = maxHeight * heightFactor;
                  final animatedH = targetH * _barAnimations[index].value;
                  final isToday = (index == 5);

                  return Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Opacity(
                          opacity: _barAnimations[index].value,
                          child: Text(
                            '${hours}h',
                            style: AppTypography.caption(color: AppColors.textMuted)
                                .copyWith(fontSize: 10),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 16,
                          height: animatedH,
                          decoration: BoxDecoration(
                            color: isToday
                                ? AppColors.accentCobalt
                                : const Color(0xFFBFDBFE),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          day,
                          style: AppTypography.caption(
                            color: isToday ? AppColors.textPrimary : AppColors.textMuted,
                          ).copyWith(
                            fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── School Organization Credentials Card ────────────────────────────────────
  Widget _buildCredentialsCard() {
    return AppCard(
      padding: const EdgeInsets.all(18),
      backgroundColor: const Color(0xFFF8FAFC),
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_user_rounded,
                  color: AppColors.accentCobalt, size: 19),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'SCHOOL CREDENTIALS & ENROLMENT',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption(color: AppColors.accentCobalt)
                      .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCredentialRow('Institution', 'Delhi Public School, R.K. Puram'),
          _buildCredentialRow('School Code', 'DPS-RKP-042'),
          _buildCredentialRow('Official Motto', 'Service Before Self'),
          _buildCredentialRow('Affiliation', 'CBSE Board Affiliation #2730017'),
          _buildCredentialRow('Offline Mode', 'SQLite Outbox Active & Sync Ready'),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.errorBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: const Text(
              'LOG OUT OF QRIE',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTypography.caption(color: AppColors.textMuted),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.bodySmall(color: AppColors.textPrimary)
                  .copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
