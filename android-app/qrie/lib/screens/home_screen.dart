import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/chapter.dart';
import '../models/lesson.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';
import '../widgets/bento_components.dart';
import 'lesson_screen.dart';
import 'quiz_solver_screen.dart';

/// EdTech Mobile UI Design System ("Pastel Bento & Onyx")
/// Full Home Screen Implementation with Modular Bento Architecture
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedOfferIndex = 1;

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

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
            horizontal: DesignTokens.horizontalPadding, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Horizontal Calendar Strip (Component 5.2) ─────────────────
            const BentoCalendarStrip(),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 2. Featured Lesson Card ("Map the Path" Component 5.3) ───────
            FeaturedLessonCard(
              title: nextLesson.title,
              subtitle: '${activeChapter.title} • ${nextLesson.durationMinutes} mins',
              progress: dailyFraction,
              timeLabel: '${(dailyFraction * 100).toInt()}% • +${nextLesson.xpReward} XP',
              rating: 5.0,
              onResume: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      lesson: nextLesson!,
                      chapter: activeChapter,
                    ),
                  ),
                );
              },
              onCopyLink: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LessonScreen(
                      lesson: nextLesson!,
                      chapter: activeChapter,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 3. 2x2 To-Do Bento Grid (Component 5.6) ──────────────────────
            Text(
              'Tasks & Study Goals',
              style: AppTypography.sectionHeader(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            BentoTodoGrid(
              allCount: activeChapter.lessons.length * 3,
              scheduledCount: 13,
              activeCount: profile.streakDays,
              overdueCount: 2,
              onTileTap: (category) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Filtered tasks: $category',
                      style: AppTypography.bodySmall(color: Colors.white),
                    ),
                    backgroundColor: AppColors.bgSurfaceOnyx,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
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

            const SizedBox(height: DesignTokens.verticalSectionGap),

            // ── 7. 3-Column Gamified Offer Tiles ("Hot Offers" Component 5.5) ─
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Hot Offers & Power-Ups',
                    style:
                        AppTypography.sectionHeader(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentRose.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(
                    'PROMO',
                    style: AppTypography.caption(color: AppColors.accentRose)
                        .copyWith(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            BentoHotOffersGrid(
              activeIndex: _selectedOfferIndex,
              onTileTap: (index) {
                setState(() => _selectedOfferIndex = index);
              },
            ),

            const SizedBox(height: 28),

            // ── 8. Chapter Learning Path Header ──────────────────────────────
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
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: MockData.subjects.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sub = MockData.subjects[index];
          final isSelected = sub.id == selectedSubId;

          return GestureDetector(
            onTap: () => state.setSubject(sub.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.bgSurfaceOnyx
                    : AppColors.bgSurfaceSoft,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.bgSurfaceOnyx.withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    sub.icon,
                    size: 14,
                    color: isSelected
                        ? AppColors.textOnOnyx
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sub.name,
                    style: AppTypography.pillLabel(
                      color: isSelected
                          ? AppColors.textOnOnyx
                          : AppColors.textPrimary,
                    ).copyWith(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonScreen(lesson: lesson, chapter: chapter),
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
