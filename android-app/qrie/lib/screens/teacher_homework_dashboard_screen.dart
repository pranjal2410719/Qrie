import 'package:flutter/material.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';
import 'teacher_create_homework_screen.dart';

/// Teacher Homework Monitoring & Submission Dashboard
///
/// Features:
/// - Class submission metrics: Total students, In Progress, Submitted, Completed, Overdue
/// - Assignment roster inspection: Student status, written work attachments, mini-test scores
/// - Teacher grading modal: Sign off on homework, input grade marks, provide feedback
/// - Action button to create & publish new homework assignments
class TeacherHomeworkDashboardScreen extends StatefulWidget {
  const TeacherHomeworkDashboardScreen({super.key});

  @override
  State<TeacherHomeworkDashboardScreen> createState() => _TeacherHomeworkDashboardScreenState();
}

class _TeacherHomeworkDashboardScreenState extends State<TeacherHomeworkDashboardScreen> {
  String _selectedClass = 'Class 9-A';
  String? _expandedAssignmentId;

  void _showGradeDialog(
    BuildContext context,
    StudentState state,
    HomeworkAssignment assignment,
    String studentName,
  ) {
    final feedbackController = TextEditingController(text: 'Excellent step-by-step working! Solutions are neat and verified.');
    final scoreController = TextEditingController(text: '95');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCanvas,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
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
                    'Grade Student Submission',
                    style: AppTypography.cardTitle(color: AppColors.textPrimary),
                  ),
                  Text(
                    'Reviewing work of $studentName for "${assignment.title}"',
                    style: AppTypography.caption(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // Submitted Attachment Preview
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgSurfaceSoft,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.bgSurfaceMuted),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.attachment_rounded, color: AppColors.accentCobalt, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Notebook_Solution_Ex3.2.jpg (2.4 MB)',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Verified',
                          style: TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w700, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Score input
                  Row(
                    children: [
                      const Text(
                        'Grade Score (out of 100):',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(width: 14),
                      SizedBox(
                        width: 70,
                        child: TextField(
                          controller: scoreController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Feedback input
                  const Text(
                    'Teacher Feedback & Remarks:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.bgSurfaceSoft,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.bgSurfaceMuted),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 20),

                  AppButton(
                    text: 'APPROVE & MARK COMPLETED',
                    isFullWidth: true,
                    variant: AppButtonVariant.primary,
                    onPressed: () {
                      state.updateAssignmentStatusByTeacher(
                        assignmentId: assignment.id,
                        status: HomeworkStatus.completed,
                        feedback: feedbackController.text.trim(),
                        gradePoints: int.tryParse(scoreController.text) ?? 95,
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Graded and approved submission for $studentName!'),
                          backgroundColor: const Color(0xFF059669),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);
    final assignments = state.homeworkAssignments;

    return Scaffold(
      backgroundColor: AppColors.bgCanvas,
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentCobalt.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.school_rounded, color: AppColors.accentCobalt, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Teacher Dashboard', style: AppTypography.cardTitle(color: AppColors.textPrimary)),
                        Text('Monitor class submissions & grade work', style: AppTypography.caption(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  // Student View Toggle
                  TextButton.icon(
                    icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                    label: const Text('Student View', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                    onPressed: () {
                      state.toggleTeacherMode();
                    },
                  ),
                ],
              ),
            ),

            // Class Selector Pills
            Container(
              height: 40,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: ['Class 9-A', 'Class 9-B', 'Class 10-A'].map((cls) {
                  final isSel = cls == _selectedClass;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cls),
                      selected: isSel,
                      selectedColor: AppColors.bgSurfaceOnyx,
                      backgroundColor: AppColors.bgSurfaceSoft,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                      onSelected: (val) => setState(() => _selectedClass = cls),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Metrics Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildMetricTile('34', 'Assigned', AppColors.accentCobalt),
                  const SizedBox(width: 8),
                  _buildMetricTile('24', 'In Progress', AppColors.accentTangerine),
                  const SizedBox(width: 8),
                  _buildMetricTile('6', 'Awaiting', const Color(0xFF8B5CF6)),
                  const SizedBox(width: 8),
                  _buildMetricTile('4', 'Overdue', const Color(0xFFEF4444)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Assignments List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final hw = assignments[index];
                  final isExpanded = _expandedAssignmentId == hw.id;
                  final progress = state.getProgressForAssignment(hw.id);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            hw.title,
                            style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 14),
                          ),
                          subtitle: Text(
                            '${hw.subject} • ${hw.className} • Due in ${hw.dueDate.difference(DateTime.now()).inDays} days',
                            style: AppTypography.caption(color: AppColors.textSecondary),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _expandedAssignmentId = isExpanded ? null : hw.id;
                              });
                            },
                          ),
                        ),

                        // Expanded Roster View
                        if (isExpanded) ...[
                          const Divider(height: 1, color: Color(0x0F000000)),
                          Container(
                            padding: const EdgeInsets.all(14),
                            color: AppColors.bgSurfaceSoft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'STUDENT SUBMISSIONS',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textSecondary,
                                        letterSpacing: 0.6,
                                      ),
                                    ),
                                    Text(
                                      'Status: ${_formatStatus(progress.status)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: progress.status == HomeworkStatus.completed
                                            ? const Color(0xFF059669)
                                            : AppColors.accentCobalt,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Student Roster Tile
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE2E8F0)),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.accentCobalt.withValues(alpha: 0.15),
                                        child: Text(
                                          state.profile.name[0],
                                          style: const TextStyle(
                                            color: AppColors.accentCobalt,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.profile.name,
                                              style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 13),
                                            ),
                                            Text(
                                              'Mini-Test: ${progress.highestTestScore != null ? "${progress.highestTestScore}%" : "Not Taken"} • Work: ${progress.writtenWorkSubmitted ? "Submitted" : "Pending"}',
                                              style: AppTypography.caption(color: AppColors.textSecondary).copyWith(fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => _showGradeDialog(context, state, hw, state.profile.name),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.bgSurfaceOnyx,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        child: Text(
                                          progress.status == HomeworkStatus.completed ? 'Regrade' : 'Grade',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.bgSurfaceOnyx,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'CREATE ASSIGNMENT',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TeacherCreateHomeworkScreen(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricTile(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTypography.caption(color: AppColors.textSecondary).copyWith(fontSize: 10, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatus(HomeworkStatus status) {
    switch (status) {
      case HomeworkStatus.assigned:
        return 'Assigned';
      case HomeworkStatus.inProgress:
        return 'In Progress';
      case HomeworkStatus.readyForVerification:
        return 'Ready For Verification';
      case HomeworkStatus.completed:
        return 'Completed';
      case HomeworkStatus.overdue:
        return 'Overdue';
      case HomeworkStatus.submittedAwaitingReview:
        return 'Awaiting Review';
    }
  }
}
