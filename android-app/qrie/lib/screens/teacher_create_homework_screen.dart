import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/homework.dart';
import '../state/student_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_button.dart';

/// Teacher Homework Creation Screen
///
/// Allows teachers to:
/// - Select Class/Section, Subject, and Chapter
/// - Define Title, Instructions, Due Date, and Estimated Completion Time
/// - Add structured content blocks (Headings, Equations, Diagrams, PDF attachments)
/// - Attach study materials
/// - Configure Topic Verification Mini-Test with passing score & attempt rules
class TeacherCreateHomeworkScreen extends StatefulWidget {
  const TeacherCreateHomeworkScreen({super.key});

  @override
  State<TeacherCreateHomeworkScreen> createState() => _TeacherCreateHomeworkScreenState();
}

class _TeacherCreateHomeworkScreenState extends State<TeacherCreateHomeworkScreen> {
  final _formKey = GlobalKey<FormState>();

  String _selectedClass = 'Class 9-A';
  String _selectedSubject = 'Mathematics';
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController(text: 'Linear Equations');
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _estMinutesController = TextEditingController(text: '35');

  DateTime _dueDate = DateTime.now().add(const Duration(days: 3, hours: 4));
  bool _includeMiniTest = true;
  int _passingThreshold = 70;
  int _maxAttempts = 3;
  bool _requiresTeacherReview = true;

  @override
  void dispose() {
    _titleController.dispose();
    _chapterController.dispose();
    _instructionsController.dispose();
    _estMinutesController.dispose();
    super.dispose();
  }

  void _publishAssignment(StudentState state) {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.heavyImpact();

    final assignmentId = 'hw_${DateTime.now().millisecondsSinceEpoch}';

    HomeworkMiniTest? miniTest;
    if (_includeMiniTest) {
      miniTest = HomeworkMiniTest(
        id: 'test_$assignmentId',
        title: '${_chapterController.text} Verification Mini-Test',
        description: 'Verify your understanding of ${_titleController.text.trim()}.',
        passingPercentage: _passingThreshold,
        maxAttempts: _maxAttempts,
        estimatedMinutes: 8,
        questions: [
          const HomeworkMiniQuestion(
            id: 'q1',
            subjectId: 'math',
            question: 'Solve for x: 3x - 5 = 16. What is the value of x?',
            options: ['x = 5', 'x = 7', 'x = 9', 'x = 11'],
            correctIndex: 1,
            explanation: '3x - 5 = 16 => 3x = 21 => x = 7.',
            hint: 'Add 5 to both sides, then divide by 3.',
          ),
          const HomeworkMiniQuestion(
            id: 'q2',
            subjectId: 'math',
            question: 'In a linear equation ax + b = 0, what is the degree of the variable x?',
            options: ['0', '1', '2', 'Variable'],
            correctIndex: 1,
            explanation: 'A linear equation has highest power/degree equal to 1.',
            hint: 'Look at the exponent of x.',
          ),
          const HomeworkMiniQuestion(
            id: 'q3',
            subjectId: 'math',
            question: 'If 2(y + 3) = 14, what is the value of y?',
            options: ['y = 4', 'y = 5', 'y = 3', 'y = 7'],
            correctIndex: 0,
            explanation: '2y + 6 = 14 => 2y = 8 => y = 4.',
            hint: 'Distribute 2 first or divide both sides by 2.',
          ),
        ],
      );
    }

    final newAssignment = HomeworkAssignment(
      id: assignmentId,
      title: _titleController.text.trim(),
      subject: _selectedSubject,
      chapter: _chapterController.text.trim(),
      className: _selectedClass,
      teacherName: 'Prof. Sharma (You)',
      assignedDate: DateTime.now(),
      dueDate: _dueDate,
      instructions: _instructionsController.text.trim(),
      estimatedMinutes: int.tryParse(_estMinutesController.text) ?? 30,
      contentBlocks: [
        const HomeworkContentBlock(
          type: HomeworkBlockType.heading,
          content: 'Exercise Overview',
        ),
        HomeworkContentBlock(
          type: HomeworkBlockType.paragraph,
          content: _instructionsController.text.trim(),
        ),
        const HomeworkContentBlock(
          type: HomeworkBlockType.equation,
          content: 'ax + b = c  =>  x = (c - b) / a',
          caption: 'Standard Form Formula',
        ),
      ],
      learningObjectives: [
        'Formulate and solve standard linear equations',
        'Verify solutions using back-substitution',
      ],
      linkedResources: [
        HomeworkResource(
          id: 'res_note_$assignmentId',
          title: '${_chapterController.text} Revision Notes & Formulas',
          type: HomeworkResourceType.studyNotes,
          pageCount: 4,
          urlOrPath: 'assets/notes/notes.pdf',
        ),
        HomeworkResource(
          id: 'res_prac_$assignmentId',
          title: '${_chapterController.text} Practice Problems',
          type: HomeworkResourceType.practiceSet,
          questionCount: 15,
          urlOrPath: 'assets/practice/set1.json',
        ),
      ],
      miniTest: miniTest,
      requiresTeacherReview: _requiresTeacherReview,
    );

    state.addHomeworkAssignment(newAssignment);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Homework "${newAssignment.title}" published to $_selectedClass!'),
        backgroundColor: const Color(0xFF059669),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = StudentStateScope.of(context);

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
              'TEACHER PORTAL',
              style: AppTypography.caption(color: AppColors.accentCobalt).copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
            Text(
              'Create New Assignment',
              style: AppTypography.cardTitle(color: AppColors.textPrimary).copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Class & Subject Row
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      label: 'TARGET CLASS',
                      value: _selectedClass,
                      items: ['Class 8-A', 'Class 9-A', 'Class 9-B', 'Class 10-A'],
                      onChanged: (val) => setState(() => _selectedClass = val!),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildDropdown(
                      label: 'SUBJECT',
                      value: _selectedSubject,
                      items: ['Mathematics', 'Science', 'English', 'Social Science'],
                      onChanged: (val) => setState(() => _selectedSubject = val!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Homework Title
              _buildTextField(
                label: 'HOMEWORK TITLE',
                controller: _titleController,
                hintText: 'e.g. Exercise 3.2: Linear Equations In One Variable',
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter title' : null,
              ),
              const SizedBox(height: 18),

              // Chapter & Topic
              _buildTextField(
                label: 'CHAPTER / SYLLABUS TOPIC',
                controller: _chapterController,
                hintText: 'e.g. Chapter 3: Linear Equations',
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter chapter' : null,
              ),
              const SizedBox(height: 18),

              // Instructions
              _buildTextField(
                label: 'TEACHER INSTRUCTIONS & DESCRIPTION',
                controller: _instructionsController,
                hintText: 'Provide detailed instructions, exercise questions to solve, and steps required...',
                maxLines: 4,
                validator: (val) => val == null || val.trim().isEmpty ? 'Enter instructions' : null,
              ),
              const SizedBox(height: 18),

              // Estimated Time & Due Date
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'EST. TIME (MINS)',
                      controller: _estMinutesController,
                      hintText: '35',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DUE DATE',
                          style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _dueDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 90)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dueDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  _dueDate.hour,
                                  _dueDate.minute,
                                );
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.bgSurfaceSoft,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.bgSurfaceMuted),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.accentCobalt),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                                    style: AppTypography.body(color: AppColors.textPrimary).copyWith(fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Topic Verification Mini-Test Switch & Config
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Topic Verification Mini-Test',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: _includeMiniTest,
                          activeTrackColor: AppColors.accentCobalt,
                          onChanged: (val) => setState(() => _includeMiniTest = val),
                        ),
                      ],
                    ),
                    if (_includeMiniTest) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Requires students to pass a 3-question conceptual quiz before homework completion is awarded.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdown(
                              label: 'MIN PASSING SCORE',
                              value: '$_passingThreshold%',
                              items: ['60%', '70%', '80%', '90%'],
                              onChanged: (val) => setState(() {
                                _passingThreshold = int.parse(val!.replaceAll('%', ''));
                              }),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _buildDropdown(
                              label: 'MAX ATTEMPTS',
                              value: '$_maxAttempts Attempts',
                              items: ['2 Attempts', '3 Attempts', '5 Attempts'],
                              onChanged: (val) => setState(() {
                                _maxAttempts = int.parse(val!.split(' ')[0]);
                              }),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Requires Teacher Review Switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Require Teacher Grading',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Hold assignment in "Awaiting Review" until you sign off',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _requiresTeacherReview,
                      activeTrackColor: AppColors.accentCobalt,
                      onChanged: (val) => setState(() => _requiresTeacherReview = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Publish Button
              AppButton(
                text: 'PUBLISH HOMEWORK TO CLASS',
                isFullWidth: true,
                variant: AppButtonVariant.primary,
                onPressed: () => _publishAssignment(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTypography.body(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body(color: AppColors.textMuted).copyWith(fontSize: 13),
            filled: true,
            fillColor: AppColors.bgSurfaceSoft,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.bgSurfaceMuted),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption(color: AppColors.textSecondary).copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.bgSurfaceSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.bgSurfaceMuted),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              style: AppTypography.body(color: AppColors.textPrimary).copyWith(fontSize: 13, fontWeight: FontWeight.w600),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
