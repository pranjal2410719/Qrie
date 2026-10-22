import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_chip.dart';
import 'homework_detail_screen.dart';
import 'homework_mini_test_screen.dart';
import 'quiz_solver_screen.dart';
import 'teacher_homework_dashboard_screen.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  String _hwFilter = 'All';

  final List<String> _hwFilters = [
    'All',
    'Due Soon',
    'In Progress',
    'Completed',
    'Overdue',
  ];

  List<HomeworkAssignment> _filterAssignments(
    List<HomeworkAssignment> assignments,
    StudentState state,
  ) {
    if (_hwFilter == 'All') return assignments;
    return assignments.where((hw) {
      final status = state.getEffectiveStatus(hw);
      switch (_hwFilter) {
        case 'Due Soon':
          final h = hw.dueDate.difference(DateTime.now()).inHours;
          return h > 0 &&
              h <= 72 &&
              status != HomeworkStatus.completed &&
              status != HomeworkStatus.overdue;
        case 'In Progress':
          return status == HomeworkStatus.inProgress;
        case 'Completed':
          return status == HomeworkStatus.completed;
        case 'Overdue':
          return status == HomeworkStatus.overdue;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);

    // Teacher mode — hand off to teacher dashboard
    if (state.isTeacherMode) {
      return const TeacherHomeworkDashboardScreen();
    }

    final filtered = _filterAssignments(state.homeworkAssignments, state);

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.horizontalPadding, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Practice Zone Header — Onyx card ────────────────────
            _buildPracticeHeader(),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── Daily Speed Challenge ────────────────────────────────
            _buildSpeedChallengeCard(context),

            const SizedBox(height: 28),

            // ── Subject Practice Sets ────────────────────────────────
            Text(
              'Subject Practice Sets',
              style: AppTypography.sectionHeader(),
            ),
            const SizedBox(height: 14),

            ...MockData.subjects.map((sub) =>
                _buildSubjectPracticeCard(context, sub)),

            const SizedBox(height: 16),

            // ── Exam Diagnostic Card ─────────────────────────────────
            _buildDiagnosticCard(context),

            const SizedBox(height: 32),

            // ── Homework & Tasks ─────────────────────────────────────
            _buildHomeworkSectionHeader(context, state),

            const SizedBox(height: 12),

            // Homework filter chips
            _buildHomeworkFilterChips(),

            const SizedBox(height: 14),

            // Assignment cards
            if (filtered.isEmpty)
              _buildHomeworkEmptyState()
            else
              ...filtered.map((hw) => _buildHomeworkCard(context, hw, state)),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Practice Zone Header (Onyx surface) ─────────────────────────────
  Widget _buildPracticeHeader() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceOnyx,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: DesignTokens.shadowSoft,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.accentCobalt.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: AppColors.accentPeriwinkle,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PRACTICE & MASTERY',
                  style: AppTypography.caption(
                          color: AppColors.textOnOnyxMuted)
                      .copyWith(
                          fontWeight: FontWeight.w800, letterSpacing: 0.6),
                ),
                const SizedBox(height: 3),
                Text(
                  'Strengthen Your Concepts',
                  style:
                      AppTypography.subheading(color: AppColors.textOnOnyx),
                ),
                const SizedBox(height: 2),
                Text(
                  'Adaptive question sets aligned with school syllabus.',
                  style:
                      AppTypography.bodySmall(color: AppColors.textOnOnyxMuted),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accentMint.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.accentMint,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ── Daily Speed Challenge ────────────────────────────────────────────
  Widget _buildSpeedChallengeCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      backgroundColor: AppColors.bgCanvas,
      borderColor: AppColors.accentMustard.withValues(alpha: 0.50),
      hasShadow: true,
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Timer badge — periwinkle
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accentPeriwinkle.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_outlined,
                          size: 13, color: AppColors.accentCobalt),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'SPEED SPRINT • 60s',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption(
                                  color: AppColors.accentCobalt)
                              .copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // XP reward
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accentMustard.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded,
                        size: 14, color: AppColors.accentMustard),
                    const SizedBox(width: 2),
                    Text(
                      '+50 XP',
                      style: AppTypography.caption(color: AppColors.textPrimary)
                          .copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Daily 5-Question Brain Booster',
            style: AppTypography.headingExtraSmall(),
          ),
          const SizedBox(height: 6),
          Text(
            'Rapid-fire questions from Science and Linear Equations to boost mental recall.',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuizSolverScreen()),
              );
            },
            child: Container(
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accentCobalt,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt_rounded,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'START SPEED SPRINT',
                      style: AppTypography.buttonLabel(
                          color: AppColors.textOnOnyx),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Subject Practice Card ────────────────────────────────────────────
  Widget _buildSubjectPracticeCard(BuildContext context, dynamic sub) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        padding: const EdgeInsets.all(DesignTokens.cardPaddingCompact),
        borderRadius: DesignTokens.radiusCardMd,
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: (sub.primaryColor as Color).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Icon(sub.icon as IconData,
                    size: 22, color: sub.primaryColor as Color),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.name as String,
                    style:
                        AppTypography.subheading(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${sub.chaptersCount} Practice Sets Available',
                    style: AppTypography.caption(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            // Cobalt PRACTICE pill
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        QuizSolverScreen(subjectId: sub.id as String),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentCobalt,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  'PRACTICE',
                  style:
                      AppTypography.caption(color: AppColors.textOnOnyx)
                          .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Exam Diagnostic Card ─────────────────────────────────────────────
  Widget _buildDiagnosticCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(DesignTokens.cardPaddingLarge),
      backgroundColor: AppColors.bgSurfaceMuted,
      borderRadius: DesignTokens.radiusCardMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_outlined,
                  color: AppColors.accentCobalt, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'EXAM READINESS DIAGNOSTIC',
                  style: AppTypography.caption(color: AppColors.textPrimary)
                      .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehensive 20-minute diagnostic test tailored to CBSE / ICSE Term standards. Pinpoints concept gaps automatically.',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'TAKE DIAGNOSTIC TEST',
            isFullWidth: true,
            variant: AppButtonVariant.outline,
            icon: Icons.assignment_turned_in_outlined,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const QuizSolverScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // ── Homework Section Header ──────────────────────────────────────────
  Widget _buildHomeworkSectionHeader(BuildContext context, StudentState state) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.accentCobalt.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.assignment_rounded,
            color: AppColors.accentCobalt,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Homework & Tasks',
                style: AppTypography.sectionHeader(color: AppColors.textPrimary),
              ),
              Text(
                '${state.profile.grade} • Teacher-Assigned',
                style: AppTypography.caption(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        // Teacher mode toggle
        TextButton.icon(
          icon: const Icon(Icons.school_outlined, size: 15),
          label: const Text(
            'Teacher',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          ),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentCobalt,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppColors.accentCobalt, width: 1),
            ),
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            state.toggleTeacherMode();
          },
        ),
      ],
    );
  }

  // ── Homework Filter Chips ────────────────────────────────────────────
  Widget _buildHomeworkFilterChips() {
    return SizedBox(
      height: 40,
      child: BlurredEdgeScroll(
        fadeWidth: 18,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _hwFilters.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final filter = _hwFilters[i];
            final isSelected = filter == _hwFilter;
            return ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  HapticFeedback.selectionClick();
                  setState(() => _hwFilter = filter);
                }
              },
              selectedColor: AppColors.bgSurfaceOnyx,
              backgroundColor: AppColors.bgSurfaceSoft,
              side: BorderSide(
                color: isSelected
                    ? AppColors.bgSurfaceOnyx
                    : const Color(0xFFE2E8F0),
                width: isSelected ? 1.5 : 1.0,
              ),
              elevation: isSelected ? 2 : 0,
              pressElevation: 1,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              labelStyle: TextStyle(
                fontFamily: AppTypography.primaryFont,
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Homework Assignment Card ─────────────────────────────────────────
  Widget _buildHomeworkCard(
    BuildContext context,
    HomeworkAssignment hw,
    StudentState state,
  ) {
    final status = state.getEffectiveStatus(hw);
    final daysLeft = hw.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = status == HomeworkStatus.overdue;
    final isCompleted = status == HomeworkStatus.completed;
    final subjectColor = _getSubjectColor(hw.subject);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        padding: const EdgeInsets.all(14),
        borderRadius: DesignTokens.radiusCardMd,
        hasShadow: false,
        borderColor: isOverdue
            ? const Color(0xFFFFCDD2)
            : isCompleted
                ? const Color(0xFFBBF7D0)
                : AppColors.borderLight,
        backgroundColor: isCompleted
            ? const Color(0xFFF0FDF4)
            : isOverdue
                ? const Color(0xFFFFF5F5)
                : AppColors.bgCanvas,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject colour strip
            Container(
              width: 4,
              height: 52,
              decoration: BoxDecoration(
                color: subjectColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hw.title,
                          style: AppTypography.subheading(
                            color: AppColors.textPrimary,
                          ).copyWith(fontSize: 13.5),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildStatusPill(status),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    hw.subject,
                    style: AppTypography.caption(color: subjectColor)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isOverdue
                                  ? Icons.warning_amber_rounded
                                  : Icons.schedule_rounded,
                              size: 13,
                              color: isOverdue
                                  ? const Color(0xFFDC2626)
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                isOverdue
                                    ? 'Overdue'
                                    : isCompleted
                                        ? 'Completed'
                                        : daysLeft == 0
                                            ? 'Due Today'
                                            : 'Due in $daysLeft day${daysLeft == 1 ? '' : 's'}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.caption(
                                  color: isOverdue
                                      ? const Color(0xFFDC2626)
                                      : AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildCTAButton(context, hw, status, state),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCTAButton(
    BuildContext context,
    HomeworkAssignment hw,
    HomeworkStatus status,
    StudentState state,
  ) {
    String ctaText;
    Color ctaBg;
    VoidCallback onTap;

    switch (status) {
      case HomeworkStatus.assigned:
        ctaText = 'Open';
        ctaBg = AppColors.accentCobalt;
        onTap = () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)));
        break;
      case HomeworkStatus.inProgress:
        ctaText = 'Continue';
        ctaBg = const Color(0xFF2563EB);
        onTap = () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)));
        break;
      case HomeworkStatus.readyForVerification:
        ctaText = 'Mini-Test';
        ctaBg = const Color(0xFFD97706);
        onTap = () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeworkMiniTestScreen(assignment: hw)));
        break;
      case HomeworkStatus.completed:
        ctaText = 'Review';
        ctaBg = const Color(0xFF059669);
        onTap = () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)));
        break;
      case HomeworkStatus.overdue:
        ctaText = 'Submit';
        ctaBg = const Color(0xFFDC2626);
        onTap = () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)));
        break;
      case HomeworkStatus.submittedAwaitingReview:
        ctaText = 'View';
        ctaBg = const Color(0xFF7C3AED);
        onTap = () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)));
        break;
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: ctaBg,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      ),
      child: Text(
        ctaText,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  Widget _buildStatusPill(HomeworkStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case HomeworkStatus.assigned:
        bg = AppColors.bgSurfaceSoft;
        text = AppColors.textSecondary;
        label = 'Assigned';
        break;
      case HomeworkStatus.inProgress:
        bg = const Color(0xFFEFF6FF);
        text = AppColors.accentCobalt;
        label = 'In Progress';
        break;
      case HomeworkStatus.readyForVerification:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFB45309);
        label = 'To Verify';
        break;
      case HomeworkStatus.completed:
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF047857);
        label = 'Done';
        break;
      case HomeworkStatus.overdue:
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFB91C1C);
        label = 'Overdue';
        break;
      case HomeworkStatus.submittedAwaitingReview:
        bg = const Color(0xFFF3E8FF);
        text = const Color(0xFF6B21A8);
        label = 'Reviewing';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildHomeworkEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.bgSurfaceSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              size: 32,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'No assignments here',
            style: AppTypography.subheading(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            'All caught up in this category!',
            style: AppTypography.caption(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    final s = subject.toLowerCase();
    if (s.contains('math')) {
      return AppColors.accentCobalt;
    }
    if (s.contains('sci') ||
        s.contains('phys') ||
        s.contains('chem') ||
        s.contains('bio')) {
      return const Color(0xFF059669);
    }
    if (s.contains('eng')) {
      return AppColors.accentTangerine;
    }
    return const Color(0xFF7C3AED);
  }
}
