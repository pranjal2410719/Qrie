import 'package:flutter/material.dart';
import '../../models/subject.dart';
import '../../models/chapter.dart';
import '../../models/lesson.dart';
import '../../models/study_material.dart';
import '../../state/student_state.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/design_tokens.dart';
import '../../widgets/floating_ai_tutor_widget.dart';
import 'pdf_viewer_screen.dart';
import 'image_viewer_screen.dart';

class ClassroomScreen extends StatefulWidget {
  final Subject subject;
  final Chapter chapter;
  final Lesson lesson;

  const ClassroomScreen({
    super.key,
    required this.subject,
    required this.chapter,
    required this.lesson,
  });

  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();
}

class _ClassroomScreenState extends State<ClassroomScreen> {
  bool _isPlaying = false;
  double _playbackProgress = 0.35;
  bool _hasVideoError = false;
  bool _isNavigatingToMaterial = false;

  @override
  void initState() {
    super.initState();
    // Record this lecture access in StudentState after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = StudentStateScope.of(context);
        // Check if there was prior progress for this lesson
        final existingRecent = state.recentLecture;
        if (existingRecent != null && existingRecent.lessonId == widget.lesson.id) {
          setState(() {
            _playbackProgress = existingRecent.playbackProgress;
          });
        }
        state.recordLectureActivity(
          lesson: widget.lesson,
          chapter: widget.chapter,
          subject: widget.subject,
          progress: _playbackProgress,
          isCompleted: state.profile.completedLessonIds.contains(widget.lesson.id),
        );
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        // Increment progress smoothly as student watches
        _playbackProgress = (_playbackProgress + 0.15).clamp(0.0, 1.0);
      }
    });

    final state = StudentStateScope.of(context);
    final isDone = _playbackProgress >= 0.95;
    if (isDone && !state.profile.completedLessonIds.contains(widget.lesson.id)) {
      state.completeLesson(widget.lesson.id, widget.lesson.xpReward);
    }
    state.updateLectureProgress(
      lessonId: widget.lesson.id,
      progress: _playbackProgress,
      isCompleted: isDone,
    );
  }

  void _onSeek(double value) {
    setState(() {
      _playbackProgress = value;
    });
    final state = StudentStateScope.of(context);
    state.updateLectureProgress(
      lessonId: widget.lesson.id,
      progress: _playbackProgress,
      isCompleted: _playbackProgress >= 0.95,
    );
  }

  void _openStudyMaterial(TopicStudyMaterial material) async {
    if (_isNavigatingToMaterial) return;
    _isNavigatingToMaterial = true;

    try {
      if (material.type == StudyMaterialType.image) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImageViewerScreen(
              material: material,
              topicTitle: widget.lesson.title,
            ),
          ),
        );
      } else {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PdfViewerScreen(
              material: material,
              topicTitle: widget.lesson.title,
            ),
          ),
        );
      }
    } finally {
      _isNavigatingToMaterial = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final isCompleted = state.profile.completedLessonIds.contains(widget.lesson.id);
    final isBookmarked = state.profile.bookmarkedLessonIds.contains(widget.lesson.id);
    final materials = widget.lesson.studyMaterials;

    final elapsedSeconds = (_playbackProgress * widget.lesson.durationMinutes * 60).toInt();
    final totalSeconds = widget.lesson.durationMinutes * 60;
    final elapsedFormatted =
        '${(elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}';
    final totalFormatted =
        '${(totalSeconds ~/ 60).toString().padLeft(2, '0')}:${(totalSeconds % 60).toString().padLeft(2, '0')}';

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
              widget.lesson.title,
              style: AppTypography.subheading(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${widget.subject.name} • ${widget.chapter.title}',
              style: AppTypography.caption(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Save for Revision',
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: isBookmarked ? AppColors.schoolGold : AppColors.textSecondary,
            ),
            onPressed: () {
              state.toggleBookmark(widget.lesson.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isBookmarked ? 'Removed from revision bookmarks' : 'Saved to revision bookmarks',
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.borderLight),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 96),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 7.2 Video Lecture Player Section ─────────────────────────
                _buildVideoSection(
                  elapsedFormatted: elapsedFormatted,
                  totalFormatted: totalFormatted,
                  isCompleted: isCompleted,
                ),

                // ── Lecture Information & Metadata ────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.bgSurfaceSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    size: 14, color: AppColors.textSecondary),
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
                              color: AppColors.accentMustard.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded,
                                    size: 14, color: AppColors.accentAmber),
                                const SizedBox(width: 3),
                                Text(
                                  '+${widget.lesson.xpReward} XP',
                                  style: AppTypography.caption(color: AppColors.accentAmber)
                                      .copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentMint.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      size: 14, color: AppColors.accentMint),
                                  const SizedBox(width: 4),
                                  Text(
                                    'COMPLETED',
                                    style: AppTypography.caption(color: AppColors.accentMint)
                                        .copyWith(fontWeight: FontWeight.w800),
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
                        style: AppTypography.bodyMedium(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 24, color: AppColors.borderLight),

                // ── 7.3 Study-Material List Section ──────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Topic Study Resources',
                          style: AppTypography.sectionHeader(color: AppColors.textPrimary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.bgSurfaceSoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${materials.length} Materials',
                          style: AppTypography.caption(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                if (materials.isEmpty)
                  _buildEmptyMaterialsState()
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: materials.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = materials[index];
                      return _buildStudyMaterialCard(item);
                    },
                  ),

                const SizedBox(height: 24),

                // ── Core Principles / Concept Summary ────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome_rounded,
                                color: AppColors.accentCobalt, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'CORE CONCEPTS & KEY POINTS',
                                style: AppTypography.caption(color: AppColors.accentCobalt)
                                    .copyWith(fontWeight: FontWeight.w800),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.lesson.summaryText,
                          style: AppTypography.bodySmall(color: AppColors.textPrimary),
                        ),
                        if (widget.lesson.keyPoints.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          ...widget.lesson.keyPoints.map(
                            (pt) => Padding(
                              padding: const EdgeInsets.only(bottom: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style: TextStyle(
                                          color: AppColors.accentCobalt,
                                          fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      pt,
                                      style: AppTypography.bodySmall(
                                          color: AppColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Section 8: Floating Qrie AI Assistant ──────────────────────────
          const FloatingAITutorWidget(
            bottomOffset: 24,
            rightOffset: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection({
    required String elapsedFormatted,
    required String totalFormatted,
    required bool isCompleted,
  }) {
    if (_hasVideoError) {
      return Container(
        height: 220,
        color: const Color(0xFF0F172A),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.video_camera_back_outlined,
                  color: AppColors.accentRose, size: 48),
              const SizedBox(height: 10),
              Text(
                'Video lecture unavailable',
                style: AppTypography.subheading(color: Colors.white),
              ),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgSurfaceOnyx,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => setState(() => _hasVideoError = false),
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Retry Playback'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 220,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A), // Slate 900
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background graphic
          Center(
            child: Icon(
              widget.subject.icon,
              size: 84,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),

          // Central Play / Pause Button
          GestureDetector(
            onTap: _togglePlayPause,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: widget.subject.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),

          // Top Header badges
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
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'QRIE LIVE CLASSROOM',
                        style: AppTypography.caption(color: Colors.white)
                            .copyWith(fontWeight: FontWeight.w800),
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
                    color: widget.subject.primaryColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '1080p HD',
                    style: AppTypography.caption(color: Colors.white)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // Bottom Controls & Scrubber Bar
          Positioned(
            bottom: 8,
            left: 14,
            right: 14,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      elapsedFormatted,
                      style: AppTypography.caption(color: Colors.white)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      totalFormatted,
                      style: AppTypography.caption(color: Colors.white70),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                    trackHeight: 3.5,
                    activeTrackColor: widget.subject.primaryColor,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: _playbackProgress,
                    onChanged: _onSeek,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyMaterialCard(TopicStudyMaterial item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
          onTap: () => _openStudyMaterial(item),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: item.color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: item.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.typeLabel.toUpperCase(),
                              style: TextStyle(
                                fontFamily: AppTypography.primaryFont,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: item.color,
                              ),
                            ),
                          ),
                          Text(
                            item.fileSize,
                            style: AppTypography.caption(color: AppColors.textMuted),
                          ),
                          if (item.pageCount != null)
                            Text(
                              '• ${item.pageCount} pages',
                              style: AppTypography.caption(color: AppColors.textMuted),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: AppTypography.subheading(color: AppColors.textPrimary)
                            .copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: AppTypography.caption(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.bgSurfaceSoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.borderLight),
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
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 11, color: AppColors.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyMaterialsState() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(DesignTokens.radiusCardMd),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.folder_open_rounded,
                size: 40, color: AppColors.textMuted),
            const SizedBox(height: 10),
            Text(
              'No study materials attached yet',
              style: AppTypography.subheading(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'Your teacher will post chapter notes and diagrams here.',
              style: AppTypography.caption(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
