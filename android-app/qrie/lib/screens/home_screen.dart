import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/chapter.dart';
import '../models/lesson.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/duolingo_progress_bar.dart';
import '../widgets/mascot_avatar.dart';
import 'lesson_screen.dart';
import 'quiz_solver_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final selectedSubId = state.selectedSubjectId;

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

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // 1. Daily Goal Banner with Mascot
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.paperWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.lineGray, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    offset: Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const MascotAvatar(
                    size: 52,
                    expression: MascotExpression.happy,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'DAILY LEARNING GOAL',
                                style: AppTypography.caption(color: AppColors.pencilGray),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${profile.dailyGoalCurrent}/${profile.dailyGoalTarget} DONE',
                              style: AppTypography.buttonLabel(color: AppColors.eagerGreenDark).copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        DuolingoProgressBar(
                          value: profile.dailyGoalCurrent / profile.dailyGoalTarget,
                          height: 12,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          profile.dailyGoalCurrent >= profile.dailyGoalTarget
                              ? 'Goal achieved for today! Keep up the momentum!'
                              : '1 more lesson to maintain your ${profile.streakDays}-day streak!',
                          style: AppTypography.caption(color: AppColors.charcoal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Subject Filter Selector Chips (Duolingo Sticker Style)
          SizedBox(
            height: 46,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: MockData.subjects.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final sub = MockData.subjects[index];
                final isSelected = (sub.id == selectedSubId);

                return GestureDetector(
                  onTap: () => state.setSubject(sub.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.storybookGreen : AppColors.paperWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.eagerGreen : AppColors.lineGray,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? const [
                              BoxShadow(
                                color: AppColors.eagerGreenDark,
                                offset: Offset(0, 2),
                                blurRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      children: [
                        Text(sub.emoji, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(
                          sub.name.toUpperCase(),
                          style: AppTypography.navLabel(
                            color: isSelected ? AppColors.charcoal : AppColors.pencilGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 18),

          // 3. Hero "Continue Learning" Card (BYJU'S style active lesson card)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.paperWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.eagerGreen, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.eagerGreenDark,
                    offset: Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.storybookGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NEXT UP • ${nextLesson.durationMinutes} MINS',
                          style: AppTypography.caption(color: AppColors.eagerGreenDark),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.cloudGray,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.bolt_rounded, size: 14, color: AppColors.goldYellow),
                            const SizedBox(width: 2),
                            Text(
                              '+${nextLesson.xpReward} XP',
                              style: AppTypography.caption(color: AppColors.charcoal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nextLesson.title,
                    style: AppTypography.headingSmall(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    nextLesson.subtitle,
                    style: AppTypography.bodySmall(),
                  ),
                  const SizedBox(height: 16),
                  DuolingoButton(
                    text: 'RESUME LESSON',
                    fullWidth: true,
                    style: DuolingoButtonStyle.primaryGreen,
                    icon: Icons.play_arrow_rounded,
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
          ),

          const SizedBox(height: 28),

          // 4. Gamified Chapter Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeChapter.title.toUpperCase(),
                        style: AppTypography.buttonLabel(color: AppColors.pencilGray).copyWith(fontSize: 12),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        activeChapter.subtitle,
                        style: AppTypography.bodySmall(color: AppColors.charcoal),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline_rounded, color: AppColors.pencilGray),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 5. Duolingo Vertical Node Learning Path
          _buildVerticalLearningTree(context, activeChapter, profile.completedLessonIds),

          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildVerticalLearningTree(
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
          final isCurrent = !isCompleted && (index == 0 || completedIds.contains(lessons[index - 1].id));
          final isLocked = !isCompleted && !isCurrent;
          final isLast = index == lessons.length - 1;

          // Subtle zig-zag curve for Duolingo path feeling
          final double horizontalOffset = (index % 3 == 1)
              ? 20.0
              : (index % 3 == 2)
                  ? -20.0
                  : 0.0;

          return Column(
            children: [
              Transform.translate(
                offset: Offset(horizontalOffset, 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
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
                    if (isCurrent)
                      Positioned(
                        top: -10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.paperWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.eagerGreen, width: 2),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.eagerGreenDark,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            'START! ⭐',
                            style: AppTypography.buttonLabel(color: AppColors.eagerGreenDark).copyWith(fontSize: 10),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 8,
                  height: 36,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.eagerGreen : AppColors.lineGray,
                    borderRadius: BorderRadius.circular(4),
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
    Color nodeColor;
    Color shadowColor;
    IconData icon;
    Color iconColor;

    if (isBoss) {
      nodeColor = isCompleted ? AppColors.goldYellow : AppColors.cloudGray;
      shadowColor = isCompleted ? const Color(0xFFC78900) : AppColors.fadedGray;
      icon = Icons.emoji_events_rounded;
      iconColor = isCompleted ? AppColors.paperWhite : AppColors.fadedGray;
    } else if (isCompleted) {
      nodeColor = AppColors.eagerGreen;
      shadowColor = AppColors.eagerGreenDark;
      icon = Icons.check_rounded;
      iconColor = AppColors.paperWhite;
    } else if (isCurrent) {
      nodeColor = AppColors.sparkBlue;
      shadowColor = AppColors.sparkBlueDark;
      icon = Icons.play_arrow_rounded;
      iconColor = AppColors.paperWhite;
    } else {
      nodeColor = AppColors.cloudGray;
      shadowColor = AppColors.lineGray;
      icon = Icons.lock_rounded;
      iconColor = AppColors.fadedGray;
    }

    final double size = isBoss ? 76.0 : 66.0;

    return GestureDetector(
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
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: nodeColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? AppColors.paperWhite : shadowColor,
                width: isCurrent ? 3.5 : 2.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: const Offset(0, 5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: iconColor, size: isBoss ? 38 : 32),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 110,
            child: Text(
              lesson.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.caption(
                color: isCurrent ? AppColors.charcoal : AppColors.pencilGray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
