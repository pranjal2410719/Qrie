import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../models/chapter.dart';
import '../../models/lesson.dart';
import '../../state/student_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import '../classroom/classroom_screen.dart';

class ChapterTopicsScreen extends StatelessWidget {
  final Subject subject;
  final Chapter chapter;

  const ChapterTopicsScreen({
    super.key,
    required this.subject,
    required this.chapter,
  });

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final completedIds = state.profile.completedLessonIds;
    final lessons = chapter.lessons;

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
              chapter.title,
              style: AppTypography.subheading(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${subject.name} • ${lessons.length} Topics',
              style: AppTypography.caption(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: DesignTokens.horizontalPadding,
              vertical: 16.0,
            ),
            itemCount: lessons.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              final isCompleted = completedIds.contains(lesson.id);

              return _buildTopicRow(
                context: context,
                lesson: lesson,
                topicIndex: index + 1,
                isCompleted: isCompleted,
              );
            },
          ),
          const FloatingAITutorWidget(
            bottomOffset: 24,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildTopicRow({
    required BuildContext context,
    required Lesson lesson,
    required int topicIndex,
    required bool isCompleted,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(
          color: isCompleted ? AppColors.accentMint.withValues(alpha: 0.35) : AppColors.borderLight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
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
                builder: (_) => ClassroomScreen(
                  subject: subject,
                  chapter: chapter,
                  lesson: lesson,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                // Step / Index circle or checkmark
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.accentMint
                        : subject.primaryColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                        : Text(
                            '$topicIndex',
                            style: TextStyle(
                              fontFamily: AppTypography.primaryFont,
                              fontWeight: FontWeight.w700,
                              color: subject.primaryColor,
                              fontSize: 14,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title and badges
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          if (lesson.studyMaterials.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accentCobalt.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${lesson.studyMaterials.length} RESOURCES',
                                style: TextStyle(
                                  fontFamily: AppTypography.primaryFont,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.accentCobalt,
                                ),
                              ),
                            ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.bgSurfaceSoft,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${lesson.durationMinutes}m • +${lesson.xpReward} XP',
                              style: AppTypography.caption(color: AppColors.textSecondary)
                                  .copyWith(fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lesson.title,
                        style: AppTypography.subheading(color: AppColors.textPrimary)
                            .copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        lesson.subtitle,
                        style: AppTypography.caption(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Play / Open button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: subject.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: subject.primaryColor.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
