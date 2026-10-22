import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../data/mock_data.dart';
import '../../state/student_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import 'subject_detail_screen.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final profile = state.profile;
    final subjects = MockData.subjects;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              DesignTokens.horizontalPadding,
              16.0,
              DesignTokens.horizontalPadding,
              96.0, // Space for floating bottom nav
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Banner
                _buildHeaderBanner(profile.grade, profile.board),

                const SizedBox(height: 20),

                // Section Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Syllabus & Subjects',
                        style: AppTypography.sectionHeader(color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${subjects.length} Subjects',
                      style: AppTypography.caption(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subject Cards List
                ...subjects.map((sub) => _buildSubjectCard(context, sub, state)),
              ],
            ),
          ),
          const FloatingAITutorWidget(
            bottomOffset: 90,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(String grade, String board) {
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
              Icons.auto_stories_rounded,
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
                  'LEARNING LIBRARY',
                  style: TextStyle(
                    fontFamily: AppTypography.primaryFont,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accentCobalt,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Explore Your Curriculum',
                  style: AppTypography.subheading(color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  'NCERT structured chapters, video lectures & notes for $grade $board.',
                  style: AppTypography.bodySmall(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject, StudentState state) {
    final completedIds = state.profile.completedLessonIds;
    final relevantChapters = MockData.chapters.where((c) => c.subjectId == subject.id).toList();

    int totalLessons = 0;
    int completedLessons = 0;
    for (final ch in relevantChapters) {
      totalLessons += ch.lessons.length;
      for (final l in ch.lessons) {
        if (completedIds.contains(l.id)) completedLessons++;
      }
    }

    final double effectiveProgress = totalLessons > 0
        ? (completedLessons / totalLessons).clamp(0.0, 1.0)
        : subject.progress;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
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
            state.setSubject(subject.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SubjectDetailScreen(subject: subject),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: subject.primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        subject.icon,
                        color: subject.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  subject.name,
                                  style: AppTypography.subheading(color: AppColors.textPrimary)
                                      .copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppColors.bgSurfaceSoft,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'OPEN',
                                      style: AppTypography.caption(color: AppColors.textPrimary)
                                          .copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 10,
                                      color: AppColors.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            subject.tagLine,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: effectiveProgress,
                    minHeight: 5,
                    backgroundColor: AppColors.bgSurfaceMuted,
                    valueColor: AlwaysStoppedAnimation<Color>(subject.primaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${relevantChapters.isNotEmpty ? relevantChapters.length : subject.chaptersCount} Chapters • $completedLessons Lessons Done',
                        style: AppTypography.caption(color: AppColors.textMuted),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${(effectiveProgress * 100).toInt()}% Completed',
                        style: TextStyle(
                          fontFamily: AppTypography.primaryFont,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: subject.primaryColor,
                        ),
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
}
