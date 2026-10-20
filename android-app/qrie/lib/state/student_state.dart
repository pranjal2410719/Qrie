import 'package:flutter/material.dart';
import '../models/student_profile.dart';
import '../models/doubt_message.dart';
import '../models/homework.dart';
import '../data/mock_data.dart';
import '../data/mock_homework.dart';

class StudentState extends ChangeNotifier {
  StudentProfile _profile = MockData.initialStudent;
  String _selectedSubjectId = 'science';
  final List<DoubtMessage> _doubtMessages = List.from(MockData.initialDoubtMessages);

  // Homework State
  final List<HomeworkAssignment> _homeworkAssignments = List.from(MockHomeworkData.assignments);
  final Map<String, HomeworkStudentProgress> _homeworkProgress = Map.from(MockHomeworkData.initialProgress);
  bool _isTeacherMode = false;

  // AI Tutor Active Context
  HomeworkAssignment? _activeHomeworkContext;
  String? _activeQuestionContext;
  bool _isTestGuardrailActive = false;

  StudentProfile get profile => _profile;
  String get selectedSubjectId => _selectedSubjectId;
  List<DoubtMessage> get doubtMessages => List.unmodifiable(_doubtMessages);
  List<HomeworkAssignment> get homeworkAssignments => List.unmodifiable(_homeworkAssignments);
  Map<String, HomeworkStudentProgress> get homeworkProgress => Map.unmodifiable(_homeworkProgress);
  bool get isTeacherMode => _isTeacherMode;
  HomeworkAssignment? get activeHomeworkContext => _activeHomeworkContext;
  String? get activeQuestionContext => _activeQuestionContext;
  bool get isTestGuardrailActive => _isTestGuardrailActive;

  void toggleTeacherMode() {
    _isTeacherMode = !_isTeacherMode;
    notifyListeners();
  }

  void setTutorContext({
    HomeworkAssignment? assignment,
    String? question,
    bool isTestMode = false,
  }) {
    _activeHomeworkContext = assignment;
    _activeQuestionContext = question;
    _isTestGuardrailActive = isTestMode;
    notifyListeners();
  }

  void clearTutorContext() {
    _activeHomeworkContext = null;
    _activeQuestionContext = null;
    _isTestGuardrailActive = false;
    notifyListeners();
  }

  HomeworkStudentProgress getProgressForAssignment(String assignmentId) {
    if (_homeworkProgress.containsKey(assignmentId)) {
      return _homeworkProgress[assignmentId]!;
    }
    final initial = HomeworkStudentProgress(
      assignmentId: assignmentId,
      studentId: _profile.id,
      status: HomeworkStatus.assigned,
    );
    _homeworkProgress[assignmentId] = initial;
    return initial;
  }

  void toggleChecklistItem(String assignmentId, String stepId) {
    final current = getProgressForAssignment(assignmentId);
    final updatedSteps = Set<String>.from(current.completedStepIds);

    if (updatedSteps.contains(stepId)) {
      updatedSteps.remove(stepId);
    } else {
      updatedSteps.add(stepId);
    }

    // Determine automatic status transition if not already completed/overdue
    HomeworkStatus newStatus = current.status;
    if (newStatus == HomeworkStatus.assigned && updatedSteps.isNotEmpty) {
      newStatus = HomeworkStatus.inProgress;
    } else if (newStatus == HomeworkStatus.inProgress &&
        updatedSteps.contains('step_1') &&
        updatedSteps.contains('step_2') &&
        updatedSteps.contains('step_3')) {
      newStatus = HomeworkStatus.readyForVerification;
    }

    _homeworkProgress[assignmentId] = current.copyWith(
      completedStepIds: updatedSteps,
      status: newStatus,
    );
    notifyListeners();
  }

  void submitWrittenWork(String assignmentId, List<String> attachmentPaths, String studentNotes) {
    final current = getProgressForAssignment(assignmentId);
    final updatedSteps = Set<String>.from(current.completedStepIds)..add('step_3');

    // Find assignment
    final assignment = _homeworkAssignments.firstWhere(
      (a) => a.id == assignmentId,
      orElse: () => _homeworkAssignments.first,
    );

    HomeworkStatus newStatus = HomeworkStatus.readyForVerification;
    if (assignment.miniTest == null) {
      newStatus = assignment.requiresTeacherReview
          ? HomeworkStatus.submittedAwaitingReview
          : HomeworkStatus.completed;
      if (newStatus == HomeworkStatus.completed) {
        updatedSteps.add('step_5');
      }
    }

    _homeworkProgress[assignmentId] = current.copyWith(
      completedStepIds: updatedSteps,
      writtenWorkSubmitted: true,
      writtenSubmissionDate: DateTime.now(),
      submittedAttachmentUrls: attachmentPaths,
      studentNotes: studentNotes,
      status: newStatus,
    );

    // Reward XP for completing written work
    _profile = _profile.copyWith(
      totalXp: _profile.totalXp + 25,
      gems: _profile.gems + 5,
    );

    notifyListeners();
  }

  void recordTestAttempt({
    required String assignmentId,
    required HomeworkTestAttempt attempt,
    required HomeworkMiniTest miniTest,
  }) {
    final current = getProgressForAssignment(assignmentId);
    final updatedAttempts = List<HomeworkTestAttempt>.from(current.testAttempts)..add(attempt);

    int highestScore = current.highestTestScore ?? 0;
    if (attempt.scorePercentage > highestScore) {
      highestScore = attempt.scorePercentage;
    }

    final updatedSteps = Set<String>.from(current.completedStepIds);
    HomeworkStatus newStatus = current.status;

    final assignment = _homeworkAssignments.firstWhere(
      (a) => a.id == assignmentId,
      orElse: () => _homeworkAssignments.first,
    );

    if (attempt.passed) {
      updatedSteps.add('step_4');
      if (assignment.requiresTeacherReview) {
        newStatus = HomeworkStatus.submittedAwaitingReview;
      } else {
        newStatus = HomeworkStatus.completed;
        updatedSteps.add('step_5');
      }
      // Reward completion XP & Gems
      _profile = _profile.copyWith(
        totalXp: _profile.totalXp + 50,
        gems: _profile.gems + 10,
        dailyGoalCurrent: _profile.dailyGoalCurrent < _profile.dailyGoalTarget
            ? _profile.dailyGoalCurrent + 1
            : _profile.dailyGoalCurrent,
      );
    } else {
      // If student hasn't passed, status remains inProgress or readyForVerification
      newStatus = HomeworkStatus.readyForVerification;
    }

    _homeworkProgress[assignmentId] = current.copyWith(
      testAttempts: updatedAttempts,
      highestTestScore: highestScore,
      completedStepIds: updatedSteps,
      status: newStatus,
    );

    notifyListeners();
  }

  void addHomeworkAssignment(HomeworkAssignment newAssignment) {
    _homeworkAssignments.insert(0, newAssignment);
    _homeworkProgress[newAssignment.id] = HomeworkStudentProgress(
      assignmentId: newAssignment.id,
      studentId: _profile.id,
      status: HomeworkStatus.assigned,
    );
    notifyListeners();
  }

  void updateAssignmentStatusByTeacher({
    required String assignmentId,
    required HomeworkStatus status,
    required String feedback,
    int? gradePoints,
  }) {
    final current = getProgressForAssignment(assignmentId);
    final updatedSteps = Set<String>.from(current.completedStepIds);
    if (status == HomeworkStatus.completed) {
      updatedSteps.add('step_5');
    }

    _homeworkProgress[assignmentId] = current.copyWith(
      status: status,
      teacherFeedback: feedback,
      gradePoints: gradePoints,
      completedStepIds: updatedSteps,
    );
    notifyListeners();
  }

  void setSubject(String subjectId) {
    if (_selectedSubjectId != subjectId) {
      _selectedSubjectId = subjectId;
      notifyListeners();
    }
  }

  void updateGradeAndBoard(String grade, String board) {
    _profile = _profile.copyWith(grade: grade, board: board);
    notifyListeners();
  }

  void completeLesson(String lessonId, int xpReward) {
    final updatedCompleted = Set<String>.from(_profile.completedLessonIds)..add(lessonId);
    final updatedGoal = (_profile.dailyGoalCurrent < _profile.dailyGoalTarget)
        ? _profile.dailyGoalCurrent + 1
        : _profile.dailyGoalCurrent;

    _profile = _profile.copyWith(
      completedLessonIds: updatedCompleted,
      totalXp: _profile.totalXp + xpReward,
      gems: _profile.gems + (xpReward ~/ 5),
      dailyGoalCurrent: updatedGoal,
    );
    notifyListeners();
  }

  void toggleBookmark(String lessonId) {
    final updatedBookmarks = Set<String>.from(_profile.bookmarkedLessonIds);
    if (updatedBookmarks.contains(lessonId)) {
      updatedBookmarks.remove(lessonId);
    } else {
      updatedBookmarks.add(lessonId);
    }
    _profile = _profile.copyWith(bookmarkedLessonIds: updatedBookmarks);
    notifyListeners();
  }

  void addDoubt({
    required String text,
    String? formulaOrSnippet,
    String? keyConcept,
    List<String>? followUpSuggestions,
    String? imageAttachment,
  }) {
    // 1. Add student message
    final studentMsg = DoubtMessage(
      id: 'dm_${DateTime.now().millisecondsSinceEpoch}',
      text: text,
      isStudent: true,
      timestamp: DateTime.now(),
      imageAttachment: imageAttachment,
    );
    _doubtMessages.add(studentMsg);
    notifyListeners();

    // 2. Generate intelligent tutor response
    Future.delayed(const Duration(milliseconds: 600), () {
      final tutorMsg = _generateTutorResponse(text);
      _doubtMessages.add(tutorMsg);
      // Give student 5 XP for asking a doubt
      _profile = _profile.copyWith(
        totalXp: _profile.totalXp + 10,
        gems: _profile.gems + 2,
      );
      notifyListeners();
    });
  }

  DoubtMessage _generateTutorResponse(String query) {
    final q = query.toLowerCase();
    String responseText = '';
    String? formula;
    String? concept;
    List<String>? followUps;

    if (q.contains('cell') || q.contains('membrane')) {
      responseText =
          'Great question about cell biology. The cell membrane acts as a selective gatekeeper (selectively permeable). It allows essential nutrients, water, and oxygen to diffuse in while pumping out metabolic waste products.';
      formula = 'Diffusion & Osmosis: Solvent flows from High -> Low concentration';
      concept = 'Selective Permeability & Homeostasis';
      followUps = [
        'What happens when a cell is placed in salt water?',
        'What is active transport vs passive transport?',
      ];
    } else if (q.contains('equation') || q.contains('solve') || q.contains('x')) {
      responseText =
          'Here is the systematic breakdown for solving linear equations:\n1. Move all variable terms to the Left Hand Side by changing signs.\n2. Move all numerical constants to the Right Hand Side.\n3. Simplify both sides and isolate the variable.\n4. Verify your work by substituting the value back into the original equation.';
      formula = 'ax + b = cx + d  ->  (a - c)x = d - b';
      concept = 'Algebraic Balancing & Transposition';
      followUps = [
        'Solve 4(x - 2) = 12',
        'How to solve fractions in linear equations?',
      ];
    } else if (q.contains('photosynthesis') || q.contains('plant')) {
      responseText =
          'Photosynthesis is the process green plants use to convert light energy into chemical energy. Inside the chloroplasts, green chlorophyll captures photons and combines Carbon Dioxide with Water to create Glucose and Oxygen.';
      formula = '6CO₂ + 6H₂O + Sunlight -> C₆H₁₂O₆ + 6O₂';
      concept = 'Light-dependent and Light-independent reactions';
      followUps = [
        'Why do leaves turn yellow in autumn?',
        'Do plants perform respiration at night?',
      ];
    } else {
      responseText =
          'Great scientific inquiry! In school science and math, the golden rule is connecting principles to everyday observations. Here is the key concept:\n\n1. Identify the given variables and known laws.\n2. Write down the core relationship or formula.\n3. Solve step-by-step without skipping algebra steps.';
      formula = 'Result = (Fundamental Law applied to conditions)';
      concept = 'Scientific Inquiry & Problem Solving';
      followUps = [
        'Can you show a practice problem for this?',
        'Explain with a real life example',
      ];
    }

    return DoubtMessage(
      id: 'dm_${DateTime.now().millisecondsSinceEpoch}_tutor',
      text: responseText,
      isStudent: false,
      timestamp: DateTime.now(),
      formulaOrSnippet: formula,
      keyConcept: concept,
      followUpSuggestions: followUps,
    );
  }
}

class StudentStateScope extends InheritedNotifier<StudentState> {
  const StudentStateScope({
    super.key,
    required super.notifier,
    required super.child,
  });

  static StudentState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<StudentStateScope>();
    assert(scope != null, 'No StudentStateScope found in context');
    return scope!.notifier!;
  }
}
