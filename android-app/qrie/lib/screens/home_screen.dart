import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/chapter.dart';
import '../models/lesson.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/app_chip.dart';
import '../widgets/app_progress_bar.dart';
import 'lesson_screen.dart';
import 'quiz_solver_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final selectedSubId = state.selectedSubjectId;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    // Filter chapters by selected subject
    final relevantChapters = MockData.chapters.where((c) => c.subjectId == selectedSubId).toList();
    final activeChapter = relevantChapters.isNotEmpty ? relevantChapters.first : MockData.chapters.first;

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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Daily Goal Card (Minimalist & Encouraging)
            AppCard(
              padding: const EdgeInsets.all(16.0),
              hasShadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.schoolMint,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.flag_rounded,
                          size: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAILY LEARNING FOCUS',
                              style: AppTypography.caption(color: AppColors.textMuted),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.dailyGoalCurrent} of ${profile.dailyGoalTarget} lessons completed',
                              style: AppTypography.subheading(color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: dailyFraction >= 1.0 ? AppColors.successSurface : AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: dailyFraction >= 1.0 ? AppColors.successBorder : AppColors.borderLight,
                          ),
                        ),
                        child: Text(
                          '${(dailyFraction * 100).toInt()}%',
                          style: AppTypography.caption(
                            color: dailyFraction >= 1.0 ? AppColors.success : AppColors.textSecondary,
                          ).copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppProgressBar(
                    value: dailyFraction,
                    height: 8,
                    fillColor: primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 2. Subject Filter Selector Chips
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: MockData.subjects.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final sub = MockData.subjects[index];
                  final isSelected = (sub.id == selectedSubId);

                  return AppChip(
                    label: sub.name,
                    icon: sub.icon,
                    isSelected: isSelected,
                    activeColor: primaryColor,
                    onTap: () => state.setSubject(sub.id),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 3. Hero "Continue Learning" Card (Single Primary Action)
            AppCard(
              padding: const EdgeInsets.all(20),
              backgroundColor: AppColors.surface,
              borderColor: primaryColor.withValues(alpha: 0.35),
              hasShadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.schoolMint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'CONTINUE LEARNING',
                          style: AppTypography.caption(color: primaryColor).copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 4),
                          Text(
                            '${nextLesson.durationMinutes} mins',
                            style: AppTypography.caption(color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.bolt_rounded, size: 15, color: AppColors.schoolGold),
                          const SizedBox(width: 2),
                          Text(
                            '+${nextLesson.xpReward} XP',
                            style: AppTypography.caption(color: AppColors.textPrimary).copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nextLesson.title,
                    style: AppTypography.headingSmall(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nextLesson.subtitle,
                    style: AppTypography.bodyMedium(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    text: 'RESUME LESSON',
                    isFullWidth: true,
                    icon: Icons.play_arrow_rounded,
                    variant: AppButtonVariant.primary,
                    onPressed: () {
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
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 4. Chapter Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activeChapter.title.toUpperCase(),
                          style: AppTypography.caption(color: primaryColor).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          activeChapter.subtitle,
                          style: AppTypography.subheading(color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSubtle,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Text(
                      '${activeChapter.lessons.length} Topics',
                      style: AppTypography.caption(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 5. Minimalist Chapter Learning Path
            _buildLearningPath(context, activeChapter, profile.completedLessonIds, primaryColor),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPath(
    BuildContext context,
    Chapter chapter,
    Set<String> completedIds,
    Color primaryColor,
  ) {
    final lessons = chapter.lessons;

    return Center(
      child: Column(
        children: List.generate(lessons.length, (index) {
          final lesson = lessons[index];
          final isCompleted = completedIds.contains(lesson.id);
          final isCurrent = !isCompleted && (index == 0 || completedIds.contains(lessons[index - 1].id));
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
                primaryColor: primaryColor,
              ),
              if (!isLast)
                Container(
                  width: 3,
                  height: 32,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? primaryColor : AppColors.borderLight,
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
    required Color primaryColor,
  }) {
    Color nodeBg;
    Color borderColor;
    Color iconColor;
    IconData icon;

    if (isCompleted) {
      nodeBg = primaryColor;
      borderColor = primaryColor;
      iconColor = Colors.white;
      icon = Icons.check_rounded;
    } else if (isCurrent) {
      nodeBg = AppColors.schoolMint;
      borderColor = primaryColor;
      iconColor = primaryColor;
      icon = Icons.play_arrow_rounded;
    } else {
      nodeBg = AppColors.surface;
      borderColor = AppColors.borderLight;
      iconColor = AppColors.textDisabled;
      icon = Icons.lock_outline_rounded;
    }

    final double nodeSize = isBoss ? 64.0 : 56.0;

    return Semantics(
      button: true,
      label: '${lesson.title}, ${isCompleted ? "Completed" : isCurrent ? "Current topic" : "Locked"}',
      child: InkWell(
        onTap: () {
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
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  color: nodeBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: isCurrent ? 2.5 : 1.5,
                  ),
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(icon, color: iconColor, size: isBoss ? 28 : 24),
                ),
              ),
              const SizedBox(width: 14),
              SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCurrent)
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.schoolMint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'START HERE',
                          style: AppTypography.caption(color: primaryColor).copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    Text(
                      lesson.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.subheading(
                        color: isLocked ? AppColors.textMuted : AppColors.textPrimary,
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
