import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/mock_data.dart';
import '../models/homework.dart';
import '../models/lesson.dart';
import '../screens/lesson_screen.dart';
import '../screens/quiz_solver_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Contextual Study Materials Bottom Sheet
///
/// Features:
/// - Categorizes linked study resources (Masterclass, Recorded Lectures, Notes, Practice, Tests).
/// - Handles all enum types so no resource disappears.
/// - Central resource launcher routing to LessonScreen, QuizSolverScreen, or Document Reader.
/// - Adaptive card sizing for narrow mobile screens.
/// - Helpful empty state when no matching resources are found.
class HomeworkStudyMaterialsSheet extends StatelessWidget {
  final HomeworkAssignment assignment;

  const HomeworkStudyMaterialsSheet({
    super.key,
    required this.assignment,
  });

  static void show(BuildContext context, HomeworkAssignment assignment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => HomeworkStudyMaterialsSheet(assignment: assignment),
    );
  }

  void _handleOpenResource(BuildContext context, HomeworkResource resource) {
    HapticFeedback.selectionClick();
    Navigator.pop(context); // Close bottom sheet

    switch (resource.type) {
      case HomeworkResourceType.masterclass:
      case HomeworkResourceType.recordedLecture:
      case HomeworkResourceType.classLecture:
        // Find matching or sample chapter lesson
        final chapter = MockData.chapters.firstWhere(
          (c) => c.subjectId == assignment.subjectId,
          orElse: () => MockData.chapters.first,
        );
        final lesson = chapter.lessons.firstWhere(
          (l) => l.type == LessonType.video || l.type == LessonType.interactive,
          orElse: () => chapter.lessons.first,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LessonScreen(lesson: lesson, chapter: chapter),
          ),
        );
        break;

      case HomeworkResourceType.practiceSet:
      case HomeworkResourceType.practiceQuestions:
      case HomeworkResourceType.chapterTest:
      case HomeworkResourceType.revisionTest:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizSolverScreen(subjectId: assignment.subjectId),
          ),
        );
        break;

      case HomeworkResourceType.studyNotes:
        _showNotesViewer(context, resource);
        break;
    }
  }

  void _showNotesViewer(BuildContext context, HomeworkResource resource) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.bgCanvas,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: AppColors.bgSurfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.menu_book_rounded, color: Color(0xFF10B981), size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.title,
                            style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${assignment.subject} • High-Yield Revision Document',
                            style: AppTypography.caption(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('KEY FORMULA SHEET', style: AppTypography.caption(color: AppColors.accentCobalt).copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: const Text(
                              '1. V = I · R  (Ohm\'s Law)\n2. Series: R_eq = R₁ + R₂ + ... + Rₙ\n3. Parallel: 1/R_eq = 1/R₁ + 1/R₂ + ...\n4. Joule\'s Heating: H = I² · R · t\n5. Electrical Power: P = V · I = I²R = V²/R',
                              style: TextStyle(fontFamily: 'monospace', fontSize: 13, height: 1.5, color: Color(0xFF0F172A)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('CORE DEFINITIONS & LAWS', style: AppTypography.caption(color: const Color(0xFF10B981)).copyWith(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          Text(
                            '• Resistance is the opposition offered to current flow by a conductor. SI unit: Ohm (Ω).\n• 1 Ohm is defined as the resistance of a conductor such that 1 Volt causes a current of 1 Ampere.\n• Factors affecting resistance: R = ρ · (l / A), where ρ is electrical resistivity.',
                            style: AppTypography.body(color: AppColors.textPrimary).copyWith(height: 1.45, fontSize: 13),
                          ),
                        ],
                      ),
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

  @override
  Widget build(BuildContext context) {
    final resources = assignment.linkedResources;

    final masterclasses = resources
        .where((r) => r.type == HomeworkResourceType.masterclass)
        .toList();
    final lectures = resources
        .where((r) =>
            r.type == HomeworkResourceType.recordedLecture ||
            r.type == HomeworkResourceType.classLecture)
        .toList();
    final notes = resources
        .where((r) => r.type == HomeworkResourceType.studyNotes)
        .toList();
    final practiceSets = resources
        .where((r) =>
            r.type == HomeworkResourceType.practiceSet ||
            r.type == HomeworkResourceType.practiceQuestions)
        .toList();
    final chapterTests = resources
        .where((r) =>
            r.type == HomeworkResourceType.chapterTest ||
            r.type == HomeworkResourceType.revisionTest)
        .toList();

    final hasAnyResource = resources.isNotEmpty;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: AppColors.bgSurfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentCobalt.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: AppColors.accentCobalt,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Study Materials & Resources',
                          style: AppTypography.cardTitle(color: AppColors.textPrimary),
                        ),
                        Text(
                          '${assignment.subject} • ${assignment.chapter}',
                          style: AppTypography.caption(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0x0F000000)),

            // Content or Empty State
            Expanded(
              child: !hasAnyResource
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_outlined, size: 48, color: AppColors.textMuted),
                            const SizedBox(height: 14),
                            Text(
                              'No Linked Materials',
                              style: AppTypography.cardTitle(color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Your teacher has not attached extra study links for this assignment.',
                              textAlign: TextAlign.center,
                              style: AppTypography.caption(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      children: [
                        if (masterclasses.isNotEmpty) ...[
                          _buildSectionHeader('MASTERCLASS', Icons.play_lesson_rounded, const Color(0xFFF59E0B)),
                          ...masterclasses.map((r) => _buildResourceCard(context, r)),
                          const SizedBox(height: 20),
                        ],
                        if (lectures.isNotEmpty) ...[
                          _buildSectionHeader('RECORDED LECTURES', Icons.video_library_rounded, AppColors.accentCobalt),
                          ...lectures.map((r) => _buildResourceCard(context, r)),
                          const SizedBox(height: 20),
                        ],
                        if (notes.isNotEmpty) ...[
                          _buildSectionHeader('STUDY NOTES & FORMULAS', Icons.menu_book_rounded, const Color(0xFF10B981)),
                          ...notes.map((r) => _buildResourceCard(context, r)),
                          const SizedBox(height: 20),
                        ],
                        if (practiceSets.isNotEmpty) ...[
                          _buildSectionHeader('PRACTICE QUESTIONS', Icons.tune_rounded, AppColors.accentTangerine),
                          ...practiceSets.map((r) => _buildResourceCard(context, r)),
                          const SizedBox(height: 20),
                        ],
                        if (chapterTests.isNotEmpty) ...[
                          _buildSectionHeader('TOPIC REVISION TESTS', Icons.verified_rounded, const Color(0xFF7C3AED)),
                          ...chapterTests.map((r) => _buildResourceCard(context, r)),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(BuildContext context, HomeworkResource resource) {
    IconData icon;
    Color iconColor;
    Color bgPill;
    String actionLabel;

    switch (resource.type) {
      case HomeworkResourceType.masterclass:
        icon = Icons.ondemand_video_rounded;
        iconColor = const Color(0xFFF59E0B);
        bgPill = const Color(0xFFFEF3C7);
        actionLabel = 'Watch';
        break;
      case HomeworkResourceType.recordedLecture:
      case HomeworkResourceType.classLecture:
        icon = Icons.play_circle_outline_rounded;
        iconColor = AppColors.accentCobalt;
        bgPill = const Color(0xFFEFF6FF);
        actionLabel = 'Lecture';
        break;
      case HomeworkResourceType.studyNotes:
        icon = Icons.description_outlined;
        iconColor = const Color(0xFF10B981);
        bgPill = AppColors.accentMint.withValues(alpha: 0.3);
        actionLabel = 'Read';
        break;
      case HomeworkResourceType.practiceSet:
      case HomeworkResourceType.practiceQuestions:
        icon = Icons.tune_rounded;
        iconColor = AppColors.accentTangerine;
        bgPill = AppColors.accentPeach;
        actionLabel = 'Practice';
        break;
      case HomeworkResourceType.chapterTest:
      case HomeworkResourceType.revisionTest:
        icon = Icons.verified_rounded;
        iconColor = const Color(0xFF7C3AED);
        bgPill = const Color(0xFFEDE9FE);
        actionLabel = 'Test';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.bgSurfaceSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.bgSurfaceMuted),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgPill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resource.title,
                  style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 13.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (resource.durationMinutes != null) ...[
                      const Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.durationMinutes}m',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (resource.pageCount != null) ...[
                      const Icon(Icons.pages_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.pageCount}p',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (resource.questionCount != null) ...[
                      const Icon(Icons.help_outline_rounded, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.questionCount} Qs',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _handleOpenResource(context, resource),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgSurfaceOnyx,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
