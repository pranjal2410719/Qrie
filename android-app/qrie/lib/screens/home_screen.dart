import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../models/chapter.dart';
import '../models/lesson.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/app_chip.dart';
import '../widgets/bento_components.dart';
import '../widgets/recent_lecture_card.dart';
import 'quiz_solver_screen.dart';
import 'learn/learn_screen.dart';
import 'classroom/classroom_screen.dart';
import 'tasks/tasks_screen.dart';

/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
/// Full Home Screen Implementation with Modular Bento Architecture
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final selectedSubId = state.selectedSubjectId;

    // Filter chapters by selected subject
    final relevantChapters =
        MockData.chapters.where((c) => c.subjectId == selectedSubId).toList();
    final activeChapter = relevantChapters.isNotEmpty
        ? relevantChapters.first
        : MockData.chapters.first;

    // Find next uncompleted lesson
    Lesson? nextLesson;
    for (final ch in relevantChapters) {
      for (final les in ch.lessons) {
        if (!profile.completedLessonIds.contains(les.id)) {
          nextLesson = les;
          break;
        }
      }
      if (nextLesson != null) break;
    }
    nextLesson ??= activeChapter.lessons.first;

    final dailyFraction = (profile.dailyGoalTarget > 0)
        ? (profile.dailyGoalCurrent / profile.dailyGoalTarget).clamp(0.0, 1.0)
        : 0.0;

    // Real dynamic counts for BentoTodoGrid
    final now = DateTime.now();
    int scheduledCount = 0;
    int activeCount = 0;
    int overdueCount = 0;

    for (final hw in state.homeworkAssignments) {
      final status = state.getEffectiveStatus(hw);
      final isOverdue = status == HomeworkStatus.overdue ||
          (hw.dueDate.isBefore(now) && status != HomeworkStatus.completed);
      if (isOverdue) {
        overdueCount++;
      } else if (status != HomeworkStatus.completed) {
        activeCount++;
        if (hw.dueDate.isAfter(now)) {
          scheduledCount++;
        }
      }
    }
    if (profile.dailyGoalCurrent < profile.dailyGoalTarget) {
      activeCount++;
    }
    final allCount = scheduledCount + activeCount + overdueCount;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          DesignTokens.horizontalPadding,
          16.0,
          DesignTokens.horizontalPadding,
          96.0, // Detached floating bottom nav spacing
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Dynamic Recent Lecture Card (Section 4) ───────────────────
            RecentLectureCard(
              recentLecture: state.recentLecture,
              onBrowseSubjects: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LearnScreen()),
                );
              },
            ),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 2. 2x2 Dynamic To-Do Bento Grid (Section 5) ──────────────────
            Text(
              'Tasks & Study Goals',
              style: AppTypography.sectionHeader(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            BentoTodoGrid(
              allCount: allCount,
              scheduledCount: scheduledCount,
              activeCount: activeCount,
              overdueCount: overdueCount,
              onTileTap: (category) {
                TaskCategoryFilter filter;
                switch (category.toLowerCase()) {
                  case 'scheduled':
                    filter = TaskCategoryFilter.scheduled;
                    break;
                  case 'active':
                    filter = TaskCategoryFilter.active;
                    break;
                  case 'overdue':
                    filter = TaskCategoryFilter.overdue;
                    break;
                  case 'all':
                  default:
                    filter = TaskCategoryFilter.all;
                    break;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TasksScreen(initialCategory: filter),
                  ),
                );
              },
            ),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 4. Subject Selector Filter Chips ─────────────────────────────
            _buildSubjectChips(state, selectedSubId),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 5. "My Activity" Donut Chart Card (Component 5.4) ─────────────
            MyActivityDonutCard(
              totalTime: '${(profile.streakDays * 2.8).toStringAsFixed(1)}h',
              completionPercent: '${(dailyFraction * 100).toInt()}%',
              onMenuTap: () {},
            ),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 6. Onyx Milestone Tracker Card (Component 5.7) ───────────────
            BentoMilestoneTrackerCard(
              title: 'Term 1 Exam Readiness',
              durationTag: '⏳ 8h Left',
              priority: 'High',
              attachmentsCount: 4,
              assigneeName: profile.name.isNotEmpty ? profile.name : 'Student',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizSolverScreen(
                      subjectId: selectedSubId,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            // ── 7. Chapter Learning Path Header (Section 2.1 Offers & Power-ups removed) ─
            _buildChapterHeader(context, activeChapter),

            const SizedBox(height: 18),

            // ── 9. Learning Path Nodes ───────────────────────────────────────
            _buildLearningPath(
                context, activeChapter, profile.completedLessonIds),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  // ── Subject Chips ─────────────────────────────────────────────────────────
  Widget _buildSubjectChips(StudentState state, String selectedSubId) {
    return SizedBox(
      height: 42,
      child: BlurredEdgeScroll(
        fadeWidth: 20,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: MockData.subjects.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final sub = MockData.subjects[index];
            final isSelected = sub.id == selectedSubId;

            return ChoiceChip(
              avatar: Icon(
                sub.icon,
                size: 15,
                color: isSelected ? Colors.white : sub.primaryColor,
              ),
              label: Text(sub.name),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  HapticFeedback.selectionClick();
                  state.setSubject(sub.id);
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
                fontSize: 12.5,
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Chapter Header ─────────────────────────────────────────────────────────
  Widget _buildChapterHeader(BuildContext context, Chapter activeChapter) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeChapter.title.toUpperCase(),
                style: AppTypography.caption(color: AppColors.accentCobalt)
                    .copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.6),
              ),
              const SizedBox(height: 3),
              Text(
                activeChapter.subtitle,
                style: AppTypography.sectionHeader(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.bgSurfaceSoft,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Text(
            '${activeChapter.lessons.length} Topics',
            style: AppTypography.caption(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  // ── Learning Path ──────────────────────────────────────────────────────────
  Widget _buildLearningPath(
    BuildContext context,
    Chapter chapter,
    Set<String> completedIds,
  ) {
    final lessons = chapter.lessons;

    return Center(
      child: Column(
        children: List.generate(lessons.length, (index) {
          final lesson = lessons[index];
          final isCompleted = completedIds.contains(lesson.id);
          final isCurrent = !isCompleted &&
              (index == 0 || completedIds.contains(lessons[index - 1].id));
          final isLocked = !isCompleted && !isCurrent;
          final isLast = index == lessons.length - 1;

          return Column(
            children: [
              _buildPathNode(
                context: context,
                chapter: chapter,
                lesson: lesson,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLocked: isLocked,
                isBoss: isLast,
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 32,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.accentMint
                        : AppColors.bgSurfaceMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPathNode({
    required BuildContext context,
    required Chapter chapter,
    required Lesson lesson,
    required bool isCompleted,
    required bool isCurrent,
    required bool isLocked,
    required bool isBoss,
  }) {
    Color nodeBg;
    Color iconColor;
    IconData icon;

    if (isCompleted) {
      nodeBg = AppColors.accentMint;
      iconColor = Colors.white;
      icon = Icons.check_rounded;
    } else if (isCurrent) {
      nodeBg = AppColors.bgSurfaceOnyx;
      iconColor = Colors.white;
      icon = Icons.play_arrow_rounded;
    } else {
      nodeBg = AppColors.bgSurfaceMuted;
      iconColor = AppColors.textMuted;
      icon = Icons.lock_outline_rounded;
    }

    final double nodeSize = isBoss ? 64.0 : 56.0;

    return Semantics(
      button: true,
      label:
          '${lesson.title}, ${isCompleted ? "Completed" : isCurrent ? "Current topic" : "Locked"}',
      child: InkWell(
        onTap: () {
          if (isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Complete previous lessons to unlock this topic!'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          if (lesson.type == LessonType.quiz) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizSolverScreen(subjectId: chapter.subjectId),
              ),
            );
          } else {
            final subject = MockData.subjects.firstWhere(
              (s) => s.id == chapter.subjectId,
              orElse: () => MockData.subjects.first,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ClassroomScreen(
                  subject: subject,
                  chapter: chapter,
                  lesson: lesson,
                ),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: Row(
            children: [
              Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  color: nodeBg,
                  shape: BoxShape.circle,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: AppColors.bgSurfaceOnyx.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(icon, color: iconColor, size: isBoss ? 28 : 24),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(bottom: 3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentCobalt.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text(
                          'START HERE',
                          style: AppTypography.caption(
                                  color: AppColors.accentCobalt)
                              .copyWith(
                                  fontSize: 10, fontWeight: FontWeight.w800),
                        ),
                      ),
                    Text(
                      lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.subheading(
                        color: isLocked
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ).copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${lesson.durationMinutes} mins • +${lesson.xpReward} XP',
                      style: AppTypography.caption(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
