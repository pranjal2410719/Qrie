import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import '../widgets/floating_ai_tutor_widget.dart';
import '../widgets/homework_study_materials_sheet.dart';
import 'homework_mini_test_screen.dart';

/// Teacher-Assigned Homework Detail Screen
///
/// Features:
/// - Section A: Assignment Overview, Due Date & Completed Mastery Banner
/// - Section B: Formatted Content Blocks (Formulas, Graphic Diagrams, Attachments)
/// - Section C: Learning Objectives Checklist
/// - Section D: 5-Step Restricted Completion Checklist
/// - Section E: Interactive Submission Sheet with Camera/Gallery/PDF selector
/// - Section F: Floating Study Materials Pill & Context-Aware Floating AI Tutor
class HomeworkDetailScreen extends StatefulWidget {
  final HomeworkAssignment assignment;

  const HomeworkDetailScreen({
    super.key,
    required this.assignment,
  });

  @override
  State<HomeworkDetailScreen> createState() => _HomeworkDetailScreenState();
}

class _HomeworkDetailScreenState extends State<HomeworkDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StudentStateScope.of(context).setTutorContext(
          assignment: widget.assignment,
          isTestMode: false,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showSubmissionModal(BuildContext context, StudentState state) {
    final textController = TextEditingController();
    String? attachedFileName;
    String? attachedFileSize;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCanvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 16),
                      Text(
                        'Submit Written Homework',
                        style: AppTypography.cardTitle(color: AppColors.textPrimary),
                      ),
                      Text(
                        'Attach notebook photos or PDF solutions for teacher review.',
                        style: AppTypography.caption(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),

                      // Interactive File Picker Trigger / Preview
                      if (attachedFileName == null) ...[
                        Row(
                          children: [
                            Expanded(
                              child: _buildUploadOption(
                                icon: Icons.camera_alt_rounded,
                                label: 'Camera',
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setModalState(() {
                                    attachedFileName = 'Notebook_Photo_${DateTime.now().millisecondsSinceEpoch % 10000}.jpg';
                                    attachedFileSize = '2.8 MB';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildUploadOption(
                                icon: Icons.photo_library_rounded,
                                label: 'Gallery',
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setModalState(() {
                                    attachedFileName = 'Scan_Solution_${widget.assignment.subject}_p1.jpg';
                                    attachedFileSize = '3.2 MB';
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildUploadOption(
                                icon: Icons.picture_as_pdf_rounded,
                                label: 'PDF Doc',
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setModalState(() {
                                    attachedFileName = '${widget.assignment.chapter}_Assignment.pdf';
                                    attachedFileSize = '1.4 MB';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFF32C787), width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF32C787),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      attachedFileName!,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Ready to submit • $attachedFileSize',
                                      style: AppTypography.caption(color: const Color(0xFF047857)),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close_rounded, color: Colors.red),
                                onPressed: () {
                                  setModalState(() {
                                    attachedFileName = null;
                                    attachedFileSize = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),

                      // Notes Input
                      TextField(
                        controller: textController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Add notes for your teacher (optional)...',
                          hintStyle: AppTypography.caption(color: AppColors.textMuted),
                          filled: true,
                          fillColor: AppColors.bgSurfaceSoft,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: AppColors.bgSurfaceMuted),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                      const SizedBox(height: 20),

                      AppButton(
                        text: 'CONFIRM & SUBMIT WRITTEN WORK',
                        isFullWidth: true,
                        variant: AppButtonVariant.primary,
                        onPressed: attachedFileName != null
                            ? () {
                                state.submitWrittenWork(
                                  widget.assignment.id,
                                  [attachedFileName!],
                                  textController.text,
                                );
                                Navigator.pop(ctx);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Written work submitted successfully! +25 XP'),
                                    backgroundColor: Color(0xFF059669),
                                  ),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgSurfaceSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.bgSurfaceMuted),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.accentCobalt, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentDialog(BuildContext context, String attachmentTitle) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                attachmentTitle,
                style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgSurfaceSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.bgSurfaceMuted),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.description_outlined, size: 36, color: AppColors.accentCobalt),
                    const SizedBox(height: 8),
                    Text(
                      'Document Reader Preview',
                      style: AppTypography.caption(color: AppColors.textSecondary),
                    ),
                    const Text('Official NCERT Syllabus Worksheet • 4 Pages', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This attachment contains the teacher-provided problem set and reference questions. Open in full view to read offline.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Viewing $attachmentTitle offline.')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.bgSurfaceOnyx,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Open in Viewer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final progress = state.getProgressForAssignment(widget.assignment.id);
    final effectiveStatus = state.getEffectiveStatus(widget.assignment);
    final isCompleted = effectiveStatus == HomeworkStatus.completed;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            state.clearTutorContext();
            Navigator.pop(context);
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.assignment.subject.toUpperCase(),
              style: AppTypography.caption(color: AppColors.accentCobalt).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              widget.assignment.title,
              style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: 'https://qrie.school/homework/${widget.assignment.id}'),
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Assignment link copied to clipboard!'),
                    backgroundColor: AppColors.bgSurfaceOnyx,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Completed Work Review Banner (if completed)
                if (isCompleted) ...[
                  _buildCompletedMasteryBanner(progress),
                  const SizedBox(height: 16),
                ],

                // SECTION A: Assignment Overview
                _buildOverviewSection(progress, effectiveStatus),
                const SizedBox(height: 20),

                // SECTION B: Rich Structured Content
                _buildStructuredContentSection(),
                const SizedBox(height: 20),

                // SECTION C: Learning Objectives
                _buildLearningObjectivesSection(),
                const SizedBox(height: 20),

                // SECTION D: 5-Step Restricted Completion Checklist
                _buildCompletionChecklistSection(state, progress),
                const SizedBox(height: 20),

                // Teacher Feedback (if any)
                if (progress.teacherFeedback != null) ...[
                  _buildTeacherFeedbackSection(progress),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),

          // SECTION E: Floating Study Materials Button
          Positioned(
            right: 16,
            top: 16,
            child: Material(
              elevation: 4,
              shadowColor: Colors.black.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              color: AppColors.bgSurfaceOnyx,
              child: InkWell(
                onTap: () {
                  HapticFeedback.selectionClick();
                  HomeworkStudyMaterialsSheet.show(context, widget.assignment);
                },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.auto_stories_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Study Materials',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Floating Qrie AI Tutor Button positioned safely
          FloatingAITutorWidget(
            bottomOffset: 92,
            rightOffset: 16,
            contextualHomework: widget.assignment,
            isTestMode: false,
          ),

          // Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomActionBar(context, state, progress, isCompleted),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedMasteryBanner(HomeworkStudentProgress progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF32C787), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF32C787),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COMPLETED WORK VERIFIED',
                  style: TextStyle(
                    color: Color(0xFF047857),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'All mandatory requirements satisfied. Verification Test score: ${progress.highestTestScore ?? 100}%.',
                  style: const TextStyle(color: Color(0xFF065F46), fontSize: 12.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SECTION A: OVERVIEW =================
  Widget _buildOverviewSection(HomeworkStudentProgress progress, HomeworkStatus status) {
    final formattedDue = '${widget.assignment.dueDate.day}/${widget.assignment.dueDate.month}/${widget.assignment.dueDate.year} at ${widget.assignment.dueDate.hour.toString().padLeft(2, '0')}:${widget.assignment.dueDate.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.assignment.title,
                      style: AppTypography.headline(color: AppColors.textPrimary).copyWith(fontSize: 19),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.assignment.chapter} • ${widget.assignment.className}',
                      style: AppTypography.caption(color: AppColors.textSecondary).copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _buildStatusPill(status),
            ],
          ),
          const SizedBox(height: 14),

          // Metadata Row: Teacher, Due Date, Est. Time
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgSurfaceSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person_pin_rounded, size: 16, color: AppColors.accentCobalt),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Assigned by ${widget.assignment.teacherName}',
                        style: AppTypography.body(color: AppColors.textPrimary).copyWith(fontSize: 12.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event_rounded, size: 16, color: AppColors.accentTangerine),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Due: $formattedDue',
                        style: AppTypography.body(color: AppColors.textPrimary).copyWith(fontSize: 12.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.timer_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.assignment.estimatedMinutes} min',
                      style: AppTypography.caption(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Teacher Instructions
          Text(
            'TEACHER\'S INSTRUCTIONS',
            style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.assignment.instructions,
            style: AppTypography.body(color: AppColors.textPrimary).copyWith(height: 1.45),
          ),
        ],
      ),
    );
  }

  // ================= SECTION B: STRUCTURED CONTENT =================
  Widget _buildStructuredContentSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, size: 18, color: AppColors.accentCobalt),
              const SizedBox(width: 8),
              Text(
                'ASSIGNMENT CONTENT',
                style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          ...widget.assignment.contentBlocks.map((block) => _buildContentBlockItem(block)),
        ],
      ),
    );
  }

  Widget _buildContentBlockItem(HomeworkContentBlock block) {
    switch (block.type) {
      case HomeworkBlockType.heading:
        return Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            block.content,
            style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 15),
          ),
        );
      case HomeworkBlockType.paragraph:
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            block.content,
            style: AppTypography.body(color: AppColors.textPrimary).copyWith(height: 1.45),
          ),
        );
      case HomeworkBlockType.equation:
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (block.caption != null)
                Text(
                  block.caption!.toUpperCase(),
                  style: AppTypography.caption(color: AppColors.accentCobalt).copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Text(
                  block.content,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
        );
      case HomeworkBlockType.diagram:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.accentMint.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.accentMint.withValues(alpha: 0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.schema_outlined, color: Color(0xFF059669), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    block.caption ?? 'Visual Concept Diagram',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF065F46),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_tree_outlined, color: AppColors.accentCobalt, size: 32),
                      const SizedBox(height: 4),
                      Text(
                        'Diagrammatic Schematic: ${block.content}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case HomeworkBlockType.attachment:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.bgSurfaceSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.bgSurfaceMuted),
          ),
          child: Row(
            children: [
              const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFEF4444), size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  block.content,
                  style: AppTypography.body(color: AppColors.textPrimary).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton(
                onPressed: () => _showAttachmentDialog(context, block.content),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgSurfaceOnyx,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('View', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      case HomeworkBlockType.questionPrompt:
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFBFDBFE)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.help_center_rounded, color: AppColors.accentCobalt, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Practice Exercise',
                    style: TextStyle(
                      color: AppColors.accentCobalt,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                block.content,
                style: AppTypography.body(color: AppColors.textPrimary).copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        );
      case HomeworkBlockType.bulletList:
      case HomeworkBlockType.qaSection:
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            block.content,
            style: AppTypography.body(color: AppColors.textPrimary).copyWith(height: 1.4),
          ),
        );
    }
  }

  // ================= SECTION C: LEARNING OBJECTIVES =================
  Widget _buildLearningObjectivesSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.flag_rounded, size: 18, color: Color(0xFF10B981)),
              const SizedBox(width: 8),
              Text(
                'LEARNING OBJECTIVES',
                style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.assignment.learningObjectives.map((obj) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 16, color: Color(0xFF10B981)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        obj,
                        style: AppTypography.body(color: AppColors.textPrimary).copyWith(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // ================= SECTION D: 5-STEP RESTRICTED CHECKLIST =================
  Widget _buildCompletionChecklistSection(StudentState state, HomeworkStudentProgress progress) {
    final steps = [
      {
        'id': 'step_1',
        'title': 'Review assignment & study materials',
        'desc': 'Examine teacher prompt and linked chapter notes',
        'action': 'Toggleable',
      },
      {
        'id': 'step_2',
        'title': 'Complete exercise problems',
        'desc': 'Solve all assigned textbook/worksheet problems',
        'action': 'Toggleable',
      },
      {
        'id': 'step_3',
        'title': 'Upload written notebook work',
        'desc': progress.writtenWorkSubmitted ? 'Work uploaded and verified' : 'Tap to upload written solutions',
        'action': 'Action: Upload',
      },
      {
        'id': 'step_4',
        'title': 'Pass Topic Verification Mini-Test',
        'desc': progress.highestTestScore != null ? 'Best score: ${progress.highestTestScore}%' : 'Score ≥ 70% to satisfy verification',
        'action': 'Action: Take Test',
      },
      {
        'id': 'step_5',
        'title': 'Teacher review & grading',
        'desc': widget.assignment.requiresTeacherReview ? 'Pending teacher approval' : 'Not required for this task',
        'action': 'Teacher Only',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist_rounded, size: 18, color: AppColors.accentCobalt),
              const SizedBox(width: 8),
              Text(
                'COMPLETION CHECKLIST',
                style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'All mandatory steps must be verified before marking completed.',
            style: AppTypography.caption(color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),

          ...steps.map((s) {
            final stepId = s['id']!;
            final isDone = progress.completedStepIds.contains(stepId);

            return InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                if (stepId == 'step_1' || stepId == 'step_2') {
                  state.toggleChecklistItem(widget.assignment.id, stepId);
                } else if (stepId == 'step_3') {
                  _showSubmissionModal(context, state);
                } else if (stepId == 'step_4') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeworkMiniTestScreen(assignment: widget.assignment),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Teacher evaluation is granted upon instructor review.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: isDone ? const Color(0xFF32C787) : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? const Color(0xFF32C787) : const Color(0xFFCBD5E1),
                          width: 1.8,
                        ),
                      ),
                      child: isDone
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  s['title']!,
                                  style: AppTypography.cardTitle(
                                    color: isDone ? const Color(0xFF065F46) : AppColors.textPrimary,
                                  ).copyWith(fontSize: 13),
                                ),
                              ),
                              if (stepId == 'step_3' && !isDone)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentCobalt.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('UPLOAD', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.accentCobalt)),
                                ),
                              if (stepId == 'step_4' && !isDone)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD97706).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('START TEST', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFFD97706))),
                                ),
                              if (stepId == 'step_5')
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgSurfaceSoft,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('TEACHER', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.textMuted)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            s['desc']!,
                            style: AppTypography.caption(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTeacherFeedbackSection(HomeworkStudentProgress progress) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E8FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD8B4FE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.rate_review_rounded, color: Color(0xFF7C3AED), size: 18),
              SizedBox(width: 8),
              Text(
                'TEACHER FEEDBACK & GRADE',
                style: TextStyle(
                  color: Color(0xFF6B21A8),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            progress.teacherFeedback!,
            style: const TextStyle(color: Color(0xFF581C87), fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(HomeworkStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case HomeworkStatus.assigned:
        bg = AppColors.bgSurfaceSoft;
        text = AppColors.textSecondary;
        label = 'Assigned';
        break;
      case HomeworkStatus.inProgress:
        bg = const Color(0xFFEFF6FF);
        text = AppColors.accentCobalt;
        label = 'In Progress';
        break;
      case HomeworkStatus.readyForVerification:
        bg = const Color(0xFFFEF3C7);
        text = const Color(0xFFB45309);
        label = 'Ready to Verify';
        break;
      case HomeworkStatus.completed:
        bg = const Color(0xFFECFDF5);
        text = const Color(0xFF047857);
        label = 'Completed';
        break;
      case HomeworkStatus.overdue:
        bg = const Color(0xFFFEF2F2);
        text = const Color(0xFFB91C1C);
        label = 'Overdue';
        break;
      case HomeworkStatus.submittedAwaitingReview:
        bg = const Color(0xFFF3E8FF);
        text = const Color(0xFF6B21A8);
        label = 'Awaiting Review';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(color: text, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }

  // ================= BOTTOM ACTION BAR =================
  Widget _buildBottomActionBar(
    BuildContext context,
    StudentState state,
    HomeworkStudentProgress progress,
    bool isCompleted,
  ) {
    final hasMiniTest = widget.assignment.miniTest != null;
    final testPassed = progress.highestTestScore != null &&
        progress.highestTestScore! >= (widget.assignment.miniTest?.passingPercentage ?? 70);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0x0F000000))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: isCompleted
            ? Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'COMPLETED • REVIEW TEST',
                      variant: AppButtonVariant.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeworkMiniTestScreen(assignment: widget.assignment),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  // Submit Written Work Button
                  Expanded(
                    child: AppButton(
                      text: progress.writtenWorkSubmitted ? 'WORK UPLOADED' : 'SUBMIT WRITTEN WORK',
                      variant: progress.writtenWorkSubmitted
                          ? AppButtonVariant.outline
                          : AppButtonVariant.secondary,
                      onPressed: () => _showSubmissionModal(context, state),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Mini-Test Button
                  if (hasMiniTest)
                    Expanded(
                      child: AppButton(
                        text: testPassed ? 'RETAKE TEST' : 'TAKE MINI-TEST',
                        variant: AppButtonVariant.primary,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeworkMiniTestScreen(assignment: widget.assignment),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
