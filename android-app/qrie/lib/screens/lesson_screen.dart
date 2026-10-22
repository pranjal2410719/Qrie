import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/chapter.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/app_card.dart';
import '../widgets/floating_ai_tutor_widget.dart';
import '../data/mock_data.dart';
import 'quiz_solver_screen.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final Chapter chapter;

  const LessonScreen({
    super.key,
    required this.lesson,
    required this.chapter,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  bool _isPlaying = false;
  double _playbackProgress = 0.35;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = StudentStateScope.of(context);
        final subject = MockData.subjects.firstWhere(
          (s) => s.id == widget.chapter.subjectId,
          orElse: () => MockData.subjects.first,
        );
        state.recordLectureActivity(
          lesson: widget.lesson,
          chapter: widget.chapter,
          subject: subject,
          progress: _playbackProgress,
          isCompleted: state.profile.completedLessonIds.contains(widget.lesson.id),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isCompleted = state.profile.completedLessonIds.contains(widget.lesson.id);
    final isBookmarked = state.profile.bookmarkedLessonIds.contains(widget.lesson.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chapter.title.toUpperCase(),
              style: AppTypography.caption(color: primaryColor).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.lesson.title,
              style: AppTypography.subheading(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Save for Revision',
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: isBookmarked ? AppColors.schoolGold : AppColors.textMuted,
            ),
            onPressed: () {
              state.toggleBookmark(widget.lesson.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Removed from revision bookmarks' : 'Saved to Revision Bookmarks',
                    style: AppTypography.bodySmall(color: Colors.white),
                  ),
                  backgroundColor: AppColors.textPrimary,
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.borderLight),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            // Metadata chips (Duration, XP, Completion Status)
            Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.schedule_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.lesson.durationMinutes} mins',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.schoolGoldLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.schoolGold.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt_rounded, size: 15, color: AppColors.schoolGold),
                      const SizedBox(width: 2),
                      Text(
                        '+${widget.lesson.xpReward} XP',
                        style: AppTypography.caption(color: AppColors.textPrimary).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.successSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.successBorder),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          'COMPLETED',
                          style: AppTypography.caption(color: AppColors.success).copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Lesson Header
            Text(
              widget.lesson.title,
              style: AppTypography.headingSmall(),
            ),
            const SizedBox(height: 4),
            Text(
              widget.lesson.subtitle,
              style: AppTypography.bodyMedium(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 18),

            // Visual Concept Player Card
            AppCard(
              padding: EdgeInsets.zero,
              backgroundColor: const Color(0xFF0F172A), // Slate 900
              borderRadius: 16,
              child: SizedBox(
                height: 190,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Educational Background Graphic
                    Center(
                      child: Icon(
                        Icons.science_rounded,
                        size: 72,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                    ),

                    // Play / Pause Control Button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                          if (_isPlaying && _playbackProgress < 1.0) {
                            _playbackProgress = (_playbackProgress + 0.2).clamp(0.0, 1.0);
                          }
                        });
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x33000000),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    // Top Player Bar
                    Positioned(
                      top: 12,
                      left: 14,
                      right: 14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'Concept Guide',
                                  style: AppTypography.caption(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'HD Visuals',
                              style: AppTypography.caption(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom Scrubber Bar
                    Positioned(
                      bottom: 12,
                      left: 14,
                      right: 14,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${(_playbackProgress * widget.lesson.durationMinutes).toStringAsFixed(1)}m',
                                style: AppTypography.caption(color: Colors.white),
                              ),
                              Text(
                                '${widget.lesson.durationMinutes}:00m',
                                style: AppTypography.caption(color: AppColors.textDisabled),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _playbackProgress,
                              minHeight: 5,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Concept Summary Card
            AppCard(
              padding: const EdgeInsets.all(18),
              backgroundColor: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded, color: primaryColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'CORE CONCEPT SUMMARY',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.caption(color: primaryColor).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.lesson.summaryText,
                    style: AppTypography.bodyLarge(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Key Takeaways Section
            Text('Key Principles', style: AppTypography.subheading()),
            const SizedBox(height: 10),
            ...widget.lesson.keyPoints.asMap().entries.map((entry) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.schoolMint,
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                      ),
                      child: Icon(Icons.check, size: 13, color: primaryColor),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTypography.bodyMedium(color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 14),

            // Academic Highlight / Study Note
            if (widget.lesson.funFact.isNotEmpty)
              AppCard(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.schoolMint,
                borderColor: primaryColor.withValues(alpha: 0.25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.school_rounded, color: primaryColor, size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXAM PREPARATION NOTE',
                            style: AppTypography.caption(color: primaryColor).copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.lesson.funFact,
                            style: AppTypography.bodySmall(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Action Buttons
            AppButton(
              text: 'Practice This Concept',
              isFullWidth: true,
              icon: Icons.quiz_rounded,
              variant: AppButtonVariant.primary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizSolverScreen(subjectId: widget.chapter.subjectId),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            AppButton(
              text: isCompleted ? 'Lesson Completed' : 'Complete Lesson (+${widget.lesson.xpReward} XP)',
              isFullWidth: true,
              icon: isCompleted ? Icons.check_circle_outline : Icons.task_alt_rounded,
              variant: isCompleted ? AppButtonVariant.outline : AppButtonVariant.secondary,
              onPressed: () {
                if (!isCompleted) {
                  state.completeLesson(widget.lesson.id, widget.lesson.xpReward);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Lesson complete! Earned +${widget.lesson.xpReward} XP',
                        style: AppTypography.bodySmall(color: Colors.white),
                      ),
                      backgroundColor: primaryColor,
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 24),
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
}
