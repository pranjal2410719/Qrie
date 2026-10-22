import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_chip.dart';
import '../widgets/homework_study_materials_sheet.dart';
import 'homework_detail_screen.dart';
import 'homework_mini_test_screen.dart';
import 'teacher_homework_dashboard_screen.dart';

/// Dedicated Student Homework Screen
///
/// Features:
/// - Vertically browsable, paginated card feed with lazy loading support.
/// - 6 explicit states (Assigned, In Progress, Ready for Verification, Completed, Overdue, Awaiting Review).
/// - Restrained green theme for completed assignments.
/// - Filter chips: All, Due Soon, In Progress, Ready for Verification, Completed, Overdue.
/// - Direct CTA on cards: "Open", "Continue", "Take Mini-Test", "View Feedback".
/// - Study materials quick action bottom sheet launcher.
/// - Teacher portal switch for educators.
class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  String _selectedFilter = 'All';
  final ScrollController _scrollController = ScrollController();

  final List<String> _filters = [
    'All',
    'Due Soon',
    'In Progress',
    'Ready to Verify',
    'Completed',
    'Overdue',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<HomeworkAssignment> _filterAssignments(
    List<HomeworkAssignment> assignments,
    StudentState state,
  ) {
    if (_selectedFilter == 'All') return assignments;

    return assignments.where((hw) {
      final status = state.getEffectiveStatus(hw);

      switch (_selectedFilter) {
        case 'Due Soon':
          final hoursLeft = hw.dueDate.difference(DateTime.now()).inHours;
          return hoursLeft > 0 &&
              hoursLeft <= 72 &&
              status != HomeworkStatus.completed &&
              status != HomeworkStatus.overdue;
        case 'In Progress':
          return status == HomeworkStatus.inProgress;
        case 'Ready to Verify':
          return status == HomeworkStatus.readyForVerification;
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

    // If teacher mode is toggled, display the Teacher Dashboard
    if (state.isTeacherMode) {
      return const TeacherHomeworkDashboardScreen();
    }

    final assignments = state.homeworkAssignments;
    final filtered = _filterAssignments(assignments, state);

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentCobalt.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.assignment_rounded,
                      color: AppColors.accentCobalt,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Homework & Tasks',
                          style: AppTypography.cardTitle(color: AppColors.textPrimary)
                              .copyWith(fontSize: 18),
                        ),
                        Text(
                          '${state.profile.grade} • Teacher-Assigned Syllabus',
                          style: AppTypography.caption(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Teacher Switch Mode
                  TextButton.icon(
                    icon: const Icon(Icons.school_outlined, size: 16),
                    label: const Text('Teacher', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11)),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.accentCobalt,
                      visualDensity: VisualDensity.compact,
                    ),
                    onPressed: () {
                      state.toggleTeacherMode();
                    },
                  ),
                ],
              ),
            ),

            // Horizontal Filter Chips with Blurred Ends
            Container(
              height: 42,
              margin: const EdgeInsets.only(bottom: 8),
              child: BlurredEdgeScroll(
                fadeWidth: 20,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final filter = _filters[index];
                    final isSelected = filter == _selectedFilter;

                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      labelStyle: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 12.5,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedFilter = filter);
                        }
                      },
                    );
                  },
                ),
              ),
            ),

            // Vertically Browsable Homework Feed
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 400));
                        setState(() {});
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final hw = filtered[index];
                          final progress = state.getProgressForAssignment(hw.id);
                          return _buildHomeworkCard(context, state, hw, progress);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HOMEWORK CARD =================
  Widget _buildHomeworkCard(
    BuildContext context,
    StudentState state,
    HomeworkAssignment hw,
    HomeworkStudentProgress progress,
  ) {
    final status = state.getEffectiveStatus(hw);
    final isCompleted = status == HomeworkStatus.completed;
    final isOverdue = status == HomeworkStatus.overdue;

    // Due date format
    final now = DateTime.now();
    final difference = hw.dueDate.difference(now);
    String dueText;
    if (difference.isNegative) {
      dueText = 'Overdue by ${(-difference.inDays).clamp(1, 999)}d';
    } else if (difference.inHours < 24) {
      dueText = 'Due in ${difference.inHours}h';
    } else {
      dueText = 'Due in ${difference.inDays}d (${hw.dueDate.day}/${hw.dueDate.month})';
    }

    // Border and background styling
    final cardBorder = isCompleted
        ? const Color(0xFF32C787)
        : (isOverdue ? const Color(0xFFFCA5A5) : const Color(0xFFE2E8F0));

    final cardBg = isCompleted ? const Color(0xFFF0FDF4) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cardBorder, width: isCompleted ? 1.5 : 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeworkDetailScreen(assignment: hw),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta: Subject & Status Pill
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getSubjectColor(hw.subject).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          hw.subject.toUpperCase(),
                          style: TextStyle(
                            color: _getSubjectColor(hw.subject),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.6,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusPill(status),
                  ],
                ),
                const SizedBox(height: 10),

                // Homework Title & Chapter
                Text(
                  hw.title,
                  style: AppTypography.cardTitle(
                    color: isCompleted ? const Color(0xFF065F46) : AppColors.textPrimary,
                  ).copyWith(fontSize: 16),
                ),
                const SizedBox(height: 3),
                Text(
                  '${hw.chapter} • ${hw.className}',
                  style: AppTypography.caption(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 10),

                // Description Snippet
                Text(
                  hw.instructions,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body(color: AppColors.textSecondary).copyWith(
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 14),

                // Teacher, Due Date, Est Time
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.white.withValues(alpha: 0.7) : AppColors.bgSurfaceSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hw.teacherName,
                          style: AppTypography.caption(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: isOverdue ? const Color(0xFFDC2626) : AppColors.textMuted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          dueText,
                          style: TextStyle(
                            color: isOverdue ? const Color(0xFFDC2626) : AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hw.estimatedMinutes > 0) ...[
                        const SizedBox(width: 6),
                        const Text('•', style: TextStyle(color: AppColors.textMuted)),
                        const SizedBox(width: 6),
                        Text(
                          '${hw.estimatedMinutes}m',
                          style: AppTypography.caption(color: AppColors.textMuted),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Mini-Test Progress Indicator
                if (hw.miniTest != null) ...[
                  _buildMiniTestBadge(hw.miniTest!, progress),
                  const SizedBox(height: 12),
                ],

                // Action Bar
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Study Material Quick Pill
                    OutlinedButton.icon(
                      icon: const Icon(Icons.menu_book_rounded, size: 14),
                      label: const Text('Study Material', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        HomeworkStudyMaterialsSheet.show(context, hw);
                      },
                    ),

                    // Primary CTA Button
                    _buildCardCTA(context, hw, progress),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mini-Test Progress Pill
  Widget _buildMiniTestBadge(HomeworkMiniTest miniTest, HomeworkStudentProgress progress) {
    final highest = progress.highestTestScore;
    final passed = highest != null && highest >= miniTest.passingPercentage;

    Color badgeBg;
    Color textColor;
    IconData icon;
    String label;

    if (passed) {
      badgeBg = const Color(0xFFECFDF5);
      textColor = const Color(0xFF047857);
      icon = Icons.verified_rounded;
      label = 'Verification Test Passed ($highest%)';
    } else if (highest != null) {
      badgeBg = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFB91C1C);
      icon = Icons.replay_rounded;
      label = 'Mini-Test: $highest% (Need ${miniTest.passingPercentage}%)';
    } else {
      badgeBg = AppColors.bgSurfaceSoft;
      textColor = AppColors.textSecondary;
      icon = Icons.quiz_outlined;
      label = 'Mini-Test: ${miniTest.questions.length} Questions (Pass ${miniTest.passingPercentage}%)';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700, fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Primary CTA
  Widget _buildCardCTA(
    BuildContext context,
    HomeworkAssignment hw,
    HomeworkStudentProgress progress,
  ) {
    String ctaText;
    Color ctaBg = AppColors.bgSurfaceOnyx;
    VoidCallback onTap;

    switch (progress.status) {
      case HomeworkStatus.assigned:
        ctaText = 'Start Homework';
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)),
          );
        };
        break;
      case HomeworkStatus.inProgress:
        ctaText = 'Continue';
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)),
          );
        };
        break;
      case HomeworkStatus.readyForVerification:
        ctaText = 'Take Mini-Test';
        ctaBg = AppColors.accentCobalt;
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeworkMiniTestScreen(assignment: hw)),
          );
        };
        break;
      case HomeworkStatus.completed:
        ctaText = 'Review Work';
        ctaBg = const Color(0xFF32C787);
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)),
          );
        };
        break;
      case HomeworkStatus.overdue:
        ctaText = 'Complete Now';
        ctaBg = const Color(0xFFDC2626);
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)),
          );
        };
        break;
      case HomeworkStatus.submittedAwaitingReview:
        ctaText = 'View Status';
        ctaBg = const Color(0xFF7C3AED);
        onTap = () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomeworkDetailScreen(assignment: hw)),
          );
        };
        break;
    }

    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: ctaBg,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        ctaText,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
      ),
    );
  }

  // Status Pill
  Widget _buildStatusPill(HomeworkStatus status) {
    Color bg;
    Color text;
    String label;
    IconData? icon;

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
        label = 'Ready to Verify';
        break;
      case HomeworkStatus.completed:
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF047857);
        label = 'Completed';
        icon = Icons.check_circle_rounded;
        break;
      case HomeworkStatus.overdue:
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFB91C1C);
        label = 'Overdue';
        icon = Icons.warning_amber_rounded;
        break;
      case HomeworkStatus.submittedAwaitingReview:
        bg = const Color(0xFFF3E8FF);
        text = const Color(0xFF6B21A8);
        label = 'Awaiting Review';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: text),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 10.5),
          ),
        ],
      ),
    );
  }

  Color _getSubjectColor(String subject) {
    final s = subject.toLowerCase();
    if (s.contains('math')) return AppColors.accentCobalt;
    if (s.contains('sci') || s.contains('phys') || s.contains('chem') || s.contains('bio')) {
      return const Color(0xFF059669);
    }
    if (s.contains('eng')) return AppColors.accentTangerine;
    return const Color(0xFF7C3AED);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.bgSurfaceSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_turned_in_outlined,
                size: 44,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No assignments in "$_selectedFilter"',
              style: AppTypography.cardTitle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'There are no homework tasks currently categorized under "$_selectedFilter".',
              textAlign: TextAlign.center,
              style: AppTypography.caption(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedFilter = 'All');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.accentCobalt,
                side: const BorderSide(color: AppColors.accentCobalt),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Show All Assignments', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
