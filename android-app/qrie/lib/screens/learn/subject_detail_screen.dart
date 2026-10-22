import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../models/chapter.dart';
import '../../data/mock_data.dart';
import '../../state/student_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import 'chapter_topics_screen.dart';

class SubjectDetailScreen extends StatelessWidget {
  final Subject subject;

  const SubjectDetailScreen({
    super.key,
    required this.subject,
  });

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final completedIds = state.profile.completedLessonIds;

    // Filter chapters belonging strictly to this subject
    final chapters = MockData.chapters
        .where((c) => c.subjectId == subject.id)
        .toList();

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
              subject.name,
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            Text(
              '${chapters.length} Chapters Available',
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Subject Overview Header Banner
                _buildSubjectHeaderCard(context, chapters, completedIds),

                const SizedBox(height: 20),

                Text(
                  'Chapters & Syllabus',
                  style: AppTypography.sectionHeader(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                if (chapters.isEmpty)
                  _buildEmptyChaptersCard()
                else
                  ...chapters.map((ch) {
                    final totalLessons = ch.lessons.length;
                    final completedCount = ch.lessons
                        .where((l) => completedIds.contains(l.id))
                        .length;
                    final progress = totalLessons > 0
                        ? (completedCount / totalLessons).clamp(0.0, 1.0)
                        : 0.0;
                    final isAllCompleted = completedCount == totalLessons && totalLessons > 0;

                    return _buildChapterCard(
                      context: context,
                      chapter: ch,
                      completedCount: completedCount,
                      totalCount: totalLessons,
                      progress: progress,
                      isCompleted: isAllCompleted,
                    );
                  }),
              ],
            ),
          ),
          const FloatingAITutorWidget(
            bottomOffset: 24,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectHeaderCard(
    BuildContext context,
    List<Chapter> chapters,
    Set<String> completedIds,
  ) {
    int totalLessons = 0;
    int completedLessons = 0;
    for (final c in chapters) {
      totalLessons += c.lessons.length;
      for (final l in c.lessons) {
        if (completedIds.contains(l.id)) completedLessons++;
      }
    }
    final overallProgress = totalLessons > 0
        ? (completedLessons / totalLessons).clamp(0.0, 1.0)
        : subject.progress;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceOnyx,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: subject.primaryColor.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(subject.icon, color: subject.primaryColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NCERT CURRICULUM',
                      style: TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: subject.primaryColor,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subject.name,
                      style: AppTypography.headingSmall(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${(overallProgress * 100).toInt()}% Done',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subject.tagLine,
            style: AppTypography.bodySmall(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: overallProgress,
              minHeight: 6,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(subject.primaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$completedLessons of $totalLessons topics mastered',
                  style: AppTypography.caption(color: Colors.white60),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Class 8 CBSE',
                style: AppTypography.caption(color: Colors.white60),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard({
    required BuildContext context,
    required Chapter chapter,
    required int completedCount,
    required int totalCount,
    required double progress,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(
          color: isCompleted ? AppColors.accentMint.withValues(alpha: 0.4) : AppColors.borderLight,
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
                builder: (_) => ChapterTopicsScreen(
                  subject: subject,
                  chapter: chapter,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.accentMint.withValues(alpha: 0.15)
                            : subject.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check_circle_rounded : chapter.icon,
                        color: isCompleted ? AppColors.accentMint : subject.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.title,
                            style: AppTypography.subheading(color: AppColors.textPrimary)
                                .copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            chapter.subtitle,
                            style: AppTypography.caption(color: AppColors.textSecondary),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 4,
                    backgroundColor: AppColors.bgSurfaceMuted,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? AppColors.accentMint : subject.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '$completedCount / $totalCount Topics Completed',
                        style: AppTypography.caption(color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isCompleted ? AppColors.accentMint : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChaptersCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.menu_book_rounded, size: 40, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(
              'No chapters added for this subject yet',
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 6),
            Text(
              'Curriculum updates from your school will appear here.',
              style: AppTypography.caption(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
