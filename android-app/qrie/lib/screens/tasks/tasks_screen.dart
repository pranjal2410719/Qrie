import 'package:flutter/material.dart';
import '../../models/homework.dart';
import '../../models/calendar_event.dart';
import '../../data/calendar_repository.dart';
import '../../data/mock_data.dart';
import '../../state/student_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import '../homework_detail_screen.dart';
import '../classroom/classroom_screen.dart';
import '../quiz_solver_screen.dart';

enum TaskCategoryFilter {
  all,
  scheduled,
  active,
  overdue,
}

class TasksScreen extends StatefulWidget {
  final TaskCategoryFilter initialCategory;

  const TasksScreen({
    super.key,
    this.initialCategory = TaskCategoryFilter.all,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late TaskCategoryFilter _selectedCategory;
  List<AcademicCalendarEvent> _calendarEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final events = await AcademicCalendarRepository.instance.getAllUpcomingEvents();
      if (mounted) {
        setState(() {
          _calendarEvents = events;
        });
      }
    } catch (_) {
      // Graceful fallback to empty events list
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final now = DateTime.now();

    // 1. Gather all homework tasks and evaluate status consistently
    final allHomework = state.homeworkAssignments;

    // 2. Filter items according to the selected category
    final List<Widget> items = [];

    // Study Goals (Daily goal and exam readiness)
    final dailyGoal = state.profile.dailyGoalTarget;
    final dailyCurrent = state.profile.dailyGoalCurrent;
    final isGoalCompleted = dailyCurrent >= dailyGoal && dailyGoal > 0;

    if (_selectedCategory == TaskCategoryFilter.all ||
        (_selectedCategory == TaskCategoryFilter.active && !isGoalCompleted)) {
      items.add(
        _buildStudyGoalCard(
          context: context,
          title: 'Daily Study Goal: Complete 3 Lessons',
          subtitle: 'Earn bonus XP and maintain your 6-day learning streak.',
          current: dailyCurrent,
          target: dailyGoal,
          isCompleted: isGoalCompleted,
          onTap: () {
            // Jump to first lesson of active chapter
            final activeChapter = MockData.chapters.first;
            final lesson = activeChapter.lessons.first;
            final subject = MockData.subjects.firstWhere((s) => s.id == activeChapter.subjectId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClassroomScreen(
                  subject: subject,
                  chapter: activeChapter,
                  lesson: lesson,
                ),
              ),
            );
          },
        ),
      );
    }

    // Homework items
    for (final hw in allHomework) {
      final status = state.getEffectiveStatus(hw);
      final isOverdue = status == HomeworkStatus.overdue ||
          (hw.dueDate.isBefore(now) && status != HomeworkStatus.completed);
      final isScheduled = !isOverdue && status != HomeworkStatus.completed && hw.dueDate.isAfter(now);
      final isActive = status == HomeworkStatus.inProgress ||
          status == HomeworkStatus.readyForVerification ||
          status == HomeworkStatus.submittedAwaitingReview;

      bool matches = false;
      switch (_selectedCategory) {
        case TaskCategoryFilter.all:
          matches = true;
          break;
        case TaskCategoryFilter.scheduled:
          matches = isScheduled;
          break;
        case TaskCategoryFilter.active:
          matches = isActive || (status == HomeworkStatus.assigned && !isOverdue);
          break;
        case TaskCategoryFilter.overdue:
          matches = isOverdue;
          break;
      }

      if (matches) {
        items.add(
          _buildHomeworkItemCard(
            context: context,
            hw: hw,
            status: status,
            isOverdue: isOverdue,
          ),
        );
      }
    }

    // Calendar events (Scheduled / Live classes / Sessions)
    if (_selectedCategory == TaskCategoryFilter.all ||
        _selectedCategory == TaskCategoryFilter.scheduled) {
      for (final ev in _calendarEvents) {
        items.add(_buildCalendarEventItemCard(context, ev));
      }
    }

    // Exam Readiness Milestone
    if (_selectedCategory == TaskCategoryFilter.all ||
        _selectedCategory == TaskCategoryFilter.active) {
      items.add(
        _buildMilestoneCard(
          context: context,
          title: 'Term 1 Exam Readiness: Science Diagnostic',
          tag: '⏳ High Priority',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QuizSolverScreen(subjectId: 'science'),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tasks & Study Goals',
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            Text(
              '${items.length} items in ${_categoryLabel(_selectedCategory)}',
              style: AppTypography.caption(color: AppColors.textSecondary),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Category Filter Tab Bar
              _buildCategoryTabBar(),

              // Items List
              Expanded(
                child: items.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (_, index) => items[index],
                      ),
              ),
            ],
          ),
          const FloatingAITutorWidget(
            bottomOffset: 24,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  String _categoryLabel(TaskCategoryFilter cat) {
    switch (cat) {
      case TaskCategoryFilter.all:
        return 'All';
      case TaskCategoryFilter.scheduled:
        return 'Scheduled';
      case TaskCategoryFilter.active:
        return 'Active';
      case TaskCategoryFilter.overdue:
        return 'Overdue';
    }
  }

  Widget _buildCategoryTabBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _buildFilterChip(TaskCategoryFilter.all, 'All'),
          const SizedBox(width: 8),
          _buildFilterChip(TaskCategoryFilter.scheduled, 'Scheduled'),
          const SizedBox(width: 8),
          _buildFilterChip(TaskCategoryFilter.active, 'Active'),
          const SizedBox(width: 8),
          _buildFilterChip(TaskCategoryFilter.overdue, 'Overdue'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(TaskCategoryFilter cat, String label) {
    final isSelected = _selectedCategory == cat;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCategory = cat),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.bgSurfaceOnyx : AppColors.bgSurfaceSoft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.bgSurfaceOnyx : AppColors.borderLight,
            ),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStudyGoalCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required int current,
    required int target,
    required bool isCompleted,
    required VoidCallback onTap,
  }) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentCobalt.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'STUDY GOAL',
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentCobalt,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$current / $target Done',
                      style: AppTypography.caption(color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: AppTypography.subheading(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.caption(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.bgSurfaceMuted,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentCobalt),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeworkItemCard({
    required BuildContext context,
    required HomeworkAssignment hw,
    required HomeworkStatus status,
    required bool isOverdue,
  }) {
    final statusColor = isOverdue
        ? AppColors.accentRose
        : (status == HomeworkStatus.completed ? AppColors.accentMint : AppColors.accentAmber);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(
          color: isOverdue ? AppColors.accentRose.withValues(alpha: 0.4) : AppColors.borderLight,
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeworkDetailScreen(assignment: hw),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isOverdue ? 'OVERDUE' : status.label.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hw.subjectName,
                        style: AppTypography.caption(color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      hw.formattedDueText,
                      style: AppTypography.caption(
                        color: isOverdue ? AppColors.accentRose : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  hw.title,
                  style: AppTypography.subheading(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 3),
                Text(
                  hw.description,
                  style: AppTypography.caption(color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarEventItemCard(BuildContext context, AcademicCalendarEvent ev) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(color: Color(0x06000000), blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: ev.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(ev.icon, color: ev.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: ev.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          ev.typeLabel.toUpperCase(),
                          style: TextStyle(
                            fontFamily: AppTypography.primaryFont,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: ev.color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          ev.subjectName,
                          style: AppTypography.caption(color: AppColors.textMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ev.title,
                    style: AppTypography.subheading(color: AppColors.textPrimary)
                        .copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ev.dateTime.hour}:${ev.dateTime.minute.toString().padLeft(2, '0')} • ${ev.roomOrLink ?? "Online Class"}',
                    style: AppTypography.caption(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneCard({
    required BuildContext context,
    required String title,
    required String tag,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceOnyx,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        boxShadow: const [
          BoxShadow(color: Color(0x1F000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt_rounded, color: AppColors.accentAmber, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tag,
                        style: AppTypography.caption(color: AppColors.accentAmber)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: AppTypography.subheading(color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.white60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                size: 52, color: AppColors.accentMint),
            const SizedBox(height: 16),
            Text(
              'No items in this category',
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'You have no ${_categoryLabel(_selectedCategory).toLowerCase()} tasks or goals right now.',
              style: AppTypography.caption(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
