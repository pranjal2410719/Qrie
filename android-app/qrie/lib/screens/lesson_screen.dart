import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/chapter.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/duolingo_button.dart';
import '../widgets/mascot_avatar.dart';
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
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final isCompleted = state.profile.completedLessonIds.contains(widget.lesson.id);
    final isBookmarked = state.profile.bookmarkedLessonIds.contains(widget.lesson.id);

    return Scaffold(
      backgroundColor: AppColors.paperWhite,
      appBar: AppBar(
        title: Text(
          widget.chapter.title,
          style: AppTypography.navLabel(color: AppColors.charcoal),
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.charcoal),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.sparkBlue : AppColors.pencilGray,
            ),
            onPressed: () {
              state.toggleBookmark(widget.lesson.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Removed from bookmarks' : 'Added to Revision Bookmarks',
                    style: AppTypography.buttonLabel(color: AppColors.paperWhite),
                  ),
                  backgroundColor: AppColors.charcoal,
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(2),
          child: Divider(height: 2, thickness: 2, color: AppColors.lineGray),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lesson Title & Badges
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.storybookGreen,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.eagerGreen, width: 1.5),
                    ),
                    child: Text(
                      '${widget.lesson.durationMinutes} MINS',
                      style: AppTypography.caption(color: AppColors.eagerGreenDark),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.cloudGray,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.lineGray, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⚡ ', style: TextStyle(fontSize: 12)),
                        Text(
                          '+${widget.lesson.xpReward} XP',
                          style: AppTypography.caption(color: AppColors.charcoal),
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.storybookGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.eagerGreen, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'COMPLETED',
                            style: AppTypography.caption(color: AppColors.eagerGreenDark),
                          ),
                        ],
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                widget.lesson.title,
                style: AppTypography.headingSmall(),
              ),

              const SizedBox(height: 4),

              Text(
                widget.lesson.subtitle,
                style: AppTypography.bodySmall(color: AppColors.pencilGray),
              ),

              const SizedBox(height: 18),

              // Mock Video Lesson Player (BYJU'S Visual Concept Player)
              Container(
                height: 210,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.nightInk,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background Illustration Mock
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF0D1B2A),
                                AppColors.nightInk,
                                const Color(0xFF1B263B),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.biotech_rounded,
                              size: 80,
                              color: AppColors.freshLeaf.withValues(alpha: 0.18),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Center Play/Pause 3D Sticker Button
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
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.eagerGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.paperWhite, width: 3),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.eagerGreenDark,
                              offset: Offset(0, 4),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: AppColors.paperWhite,
                          size: 36,
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'BYJU\'S Concept Visual',
                              style: AppTypography.caption(color: AppColors.paperWhite),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.rubyRed,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'HD 1080P',
                              style: AppTypography.caption(color: AppColors.paperWhite),
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
                                style: AppTypography.caption(color: AppColors.paperWhite),
                              ),
                              Text(
                                '${widget.lesson.durationMinutes}:00m',
                                style: AppTypography.caption(color: AppColors.fadedGray),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _playbackProgress,
                              minHeight: 6,
                              backgroundColor: Colors.white24,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.eagerGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Summary Box (Storybook Format)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cloudGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.lineGray, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.auto_stories_rounded, color: AppColors.charcoal, size: 20),
                        const SizedBox(width: 8),
                        Text('CONCEPT SUMMARY', style: AppTypography.buttonLabel(color: AppColors.charcoal)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.lesson.summaryText,
                      style: AppTypography.bodyMedium(color: AppColors.pencilGray),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Key Takeaways List
              Text('Key Takeaways', style: AppTypography.subheading()),
              const SizedBox(height: 12),
              ...widget.lesson.keyPoints.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.storybookGreen,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.eagerGreen, width: 1.5),
                        ),
                        child: const Icon(Icons.check, size: 14, color: AppColors.eagerGreenDark),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: AppTypography.bodySmall(color: AppColors.charcoal),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              // Qrie Mascot Fun Fact Callout
              if (widget.lesson.funFact.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.storybookGreen.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.freshLeaf, width: 2),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MascotAvatar(
                        size: 48,
                        expression: MascotExpression.excited,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DID YOU KNOW?',
                              style: AppTypography.buttonLabel(color: AppColors.eagerGreenDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lesson.funFact,
                              style: AppTypography.bodySmall(color: AppColors.charcoal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 28),

              // Action Buttons
              DuolingoButton(
                text: isCompleted ? 'LESSON COMPLETED ✓' : 'COMPLETE LESSON (+${widget.lesson.xpReward} XP)',
                fullWidth: true,
                style: isCompleted ? DuolingoButtonStyle.outlineGray : DuolingoButtonStyle.primaryGreen,
                icon: isCompleted ? Icons.check_circle : Icons.verified_rounded,
                onPressed: () {
                  if (!isCompleted) {
                    state.completeLesson(widget.lesson.id, widget.lesson.xpReward);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Lesson complete! Earned +${widget.lesson.xpReward} XP!',
                          style: AppTypography.buttonLabel(color: AppColors.paperWhite),
                        ),
                        backgroundColor: AppColors.eagerGreen,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 12),

              DuolingoButton(
                text: 'TAKE CHAPTER QUIZ',
                fullWidth: true,
                style: DuolingoButtonStyle.secondaryBlue,
                icon: Icons.quiz_rounded,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizSolverScreen(subjectId: widget.chapter.subjectId),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
