import 'package:flutter/material.dart';
import '../models/homework.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Contextual Study Materials Bottom Sheet
///
/// Categorizes linked study resources for an assignment:
/// - Masterclass (High-yield conceptual video)
/// - Recorded Lectures (Detailed classroom sessions)
/// - Study Notes & Formula Sheets (Quick revision cards & PDFs)
/// - Practice Sets (Graded problem drill)
/// - Chapter Tests (Comprehensive mock tests)
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

  @override
  Widget build(BuildContext context) {
    final resources = assignment.linkedResources;

    final masterclasses = resources
        .where((r) => r.type == HomeworkResourceType.masterclass)
        .toList();
    final lectures = resources
        .where((r) => r.type == HomeworkResourceType.recordedLecture)
        .toList();
    final notes = resources
        .where((r) => r.type == HomeworkResourceType.studyNotes)
        .toList();
    final practiceSets = resources
        .where((r) => r.type == HomeworkResourceType.practiceSet)
        .toList();
    final chapterTests = resources
        .where((r) => r.type == HomeworkResourceType.chapterTest)
        .toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: AppColors.bgCanvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
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

          // Scrollable List of resource sections
          Expanded(
            child: ListView(
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
                  _buildSectionHeader('PRACTICE SETS', Icons.fitness_center_rounded, AppColors.accentTangerine),
                  ...practiceSets.map((r) => _buildResourceCard(context, r)),
                  const SizedBox(height: 20),
                ],
                if (chapterTests.isNotEmpty) ...[
                  _buildSectionHeader('CHAPTER TESTS', Icons.quiz_rounded, const Color(0xFF8B5CF6)),
                  ...chapterTests.map((r) => _buildResourceCard(context, r)),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ],
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
              letterSpacing: 0.8,
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
    String actionLabel = 'Open';

    switch (resource.type) {
      case HomeworkResourceType.masterclass:
        icon = Icons.play_circle_filled_rounded;
        iconColor = const Color(0xFFD97706);
        bgPill = const Color(0xFFFEF3C7);
        actionLabel = 'Watch';
        break;
      case HomeworkResourceType.recordedLecture:
      case HomeworkResourceType.classLecture:
        icon = Icons.smart_display_rounded;
        iconColor = AppColors.accentCobalt;
        bgPill = AppColors.accentPeriwinkle;
        actionLabel = 'Play';
        break;
      case HomeworkResourceType.studyNotes:
        icon = Icons.description_rounded;
        iconColor = const Color(0xFF059669);
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
        actionLabel = 'Take';
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
                  style: AppTypography.cardTitle(color: AppColors.textPrimary)
                      .copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (resource.durationMinutes != null) ...[
                      const Icon(Icons.timer_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.durationMinutes} min',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
                    ],
                    if (resource.pageCount != null) ...[
                      const Icon(Icons.pages_outlined, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${resource.pageCount} pages',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 10),
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
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${resource.title}...'),
                  backgroundColor: AppColors.bgSurfaceOnyx,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
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
