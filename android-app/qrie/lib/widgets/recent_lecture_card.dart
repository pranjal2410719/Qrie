import 'package:flutter/material.dart';
import '../models/recent_lecture.dart';
import '../data/mock_data.dart';
import '../screens/classroom/classroom_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/design_tokens.dart';

class RecentLectureCard extends StatelessWidget {
  final RecentLectureRecord? recentLecture;
  final VoidCallback? onBrowseSubjects;

  const RecentLectureCard({
    super.key,
    required this.recentLecture,
    this.onBrowseSubjects,
  });

  void _resumeLecture(BuildContext context, RecentLectureRecord recent) {
    // Resolve subject, chapter, and lesson objects
    final subject = MockData.subjects.firstWhere(
      (s) => s.id == recent.subjectId,
      orElse: () => MockData.subjects.first,
    );

    final chapter = MockData.chapters.firstWhere(
      (c) => c.id == recent.chapterId,
      orElse: () => MockData.chapters.firstWhere(
        (c) => c.subjectId == subject.id,
        orElse: () => MockData.chapters.first,
      ),
    );

    final lesson = chapter.lessons.firstWhere(
      (l) => l.id == recent.lessonId,
      orElse: () => chapter.lessons.first,
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

  @override
  Widget build(BuildContext context) {
    if (recentLecture == null) {
      return _buildFirstTimeState(context);
    }

    final recent = recentLecture!;
    final progress = recent.playbackProgress.clamp(0.0, 1.0);
    final percent = (progress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: DesignTokens.shadowSoft,
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subject Avatar / Thumbnail
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.bgSurfaceOnyx,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1F000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title and context
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.accentCobalt.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            recent.subjectName.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppTypography.primaryFont,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentCobalt,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        Text(
                          '• ${recent.formattedLastAccessed}',
                          style: AppTypography.caption(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      recent.topicTitle,
                      style: AppTypography.subheading(color: AppColors.textPrimary)
                          .copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      recent.chapterTitle,
                      style: AppTypography.caption(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Progress bar & percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recent.isCompleted
                      ? 'Lecture Completed'
                      : '$percent% completed (${recent.durationMinutes}m total)',
                  style: AppTypography.caption(
                    color: recent.isCompleted ? AppColors.accentMint : AppColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (recent.isCompleted) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentMint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'COMPLETED',
                    style: TextStyle(
                      fontFamily: AppTypography.primaryFont,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentMint,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: AppColors.bgSurfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(
                recent.isCompleted ? AppColors.accentMint : AppColors.accentCobalt,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bgSurfaceOnyx,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: () => _resumeLecture(context, recent),
              icon: Icon(
                recent.isCompleted ? Icons.replay_rounded : Icons.play_arrow_rounded,
                size: 20,
              ),
              label: Text(
                recent.isCompleted ? 'Review Lecture' : 'Continue learning',
                style: const TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFirstTimeState(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardLg),
        boxShadow: DesignTokens.shadowSoft,
        border: Border.all(color: AppColors.borderLight, width: 1.0),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accentMint.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: AppColors.accentMint,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'START YOUR FIRST LECTURE',
                      style: TextStyle(
                        fontFamily: AppTypography.primaryFont,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentMint,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'No recent lectures yet',
                      style: AppTypography.subheading(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Explore your syllabus to begin watching NCERT video lessons and reading chapter study materials.',
            style: AppTypography.bodySmall(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bgSurfaceOnyx,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              onPressed: onBrowseSubjects ??
                  () {
                    // Open default first chapter lesson
                    final chapter = MockData.chapters.first;
                    final lesson = chapter.lessons.first;
                    final subject = MockData.subjects.firstWhere((s) => s.id == chapter.subjectId);
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
              icon: const Icon(Icons.explore_rounded, size: 18),
              label: const Text(
                'Browse Subjects & Start Learning',
                style: TextStyle(
                  fontFamily: AppTypography.primaryFont,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
