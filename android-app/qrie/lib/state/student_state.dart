import 'package:flutter/material.dart';
import '../models/student_profile.dart';
import '../models/doubt_message.dart';
import '../models/homework.dart';
import '../models/recent_lecture.dart';
import '../models/student_notification.dart';
import '../models/subject.dart';
import '../models/chapter.dart';
import '../models/lesson.dart';
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

  // Recent Lecture Activity (Student's actual ongoing learning session)
  RecentLectureRecord? _recentLecture = RecentLectureRecord(
    subjectId: 'science',
    subjectName: 'Science & Bio',
    chapterId: 'sci_ch1',
    chapterTitle: 'Chapter 1: Cell — Structure & Functions',
    lessonId: 'sci_ch1_les2',
    topicTitle: 'Parts of a Cell & Membrane',
    lastAccessedAt: DateTime.now().subtract(const Duration(minutes: 42)),
    playbackProgress: 0.65,
    isCompleted: false,
    durationMinutes: 10,
    xpReward: 25,
  );

  // Student Notifications
  final List<StudentNotification> _notifications = [
    StudentNotification(
      id: 'notif_1',
      title: 'Math Homework Due Today',
      message: 'Linear Equations in One Variable Problem Set is due at 5:00 PM today.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      type: NotificationType.homework,
      isRead: false,
      actionPayload: 'math_hw_1',
    ),
    StudentNotification(
      id: 'notif_2',
      title: 'Upcoming Live Class in 30 Mins',
      message: 'Physics: Force & Laws of Motion live doubt resolution begins at 10:30 AM.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      type: NotificationType.liveClass,
      isRead: false,
      actionPayload: 'science',
    ),
    StudentNotification(
      id: 'notif_3',
      title: 'Term 1 Science Diagnostic Ready',
      message: 'Take the 10-minute diagnostic quiz to verify your mid-term readiness.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: NotificationType.exam,
      isRead: false,
      actionPayload: 'science',
    ),
    StudentNotification(
      id: 'notif_4',
      title: 'Streak Master! 6 Days Active',
      message: 'Awesome consistency! You are on a 6-day learning streak. Complete 1 topic today to reach day 7.',
      timestamp: DateTime.now().subtract(const Duration(hours: 7)),
      type: NotificationType.streak,
      isRead: true,
    ),
    StudentNotification(
      id: 'notif_5',
      title: 'School Notice: Mid-Term Schedule',
      message: 'The official CBSE Class 8 mid-term examination timetable has been published.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.schoolNotice,
      isRead: true,
    ),
  ];

  StudentProfile get profile => _profile;
  String get selectedSubjectId => _selectedSubjectId;
  List<DoubtMessage> get doubtMessages => List.unmodifiable(_doubtMessages);
  List<HomeworkAssignment> get homeworkAssignments => List.unmodifiable(_homeworkAssignments);
  Map<String, HomeworkStudentProgress> get homeworkProgress => Map.unmodifiable(_homeworkProgress);
  bool get isTeacherMode => _isTeacherMode;
  HomeworkAssignment? get activeHomeworkContext => _activeHomeworkContext;
  String? get activeQuestionContext => _activeQuestionContext;
  bool get isTestGuardrailActive => _isTestGuardrailActive;
  RecentLectureRecord? get recentLecture => _recentLecture;

  List<StudentNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  void markNotificationAsRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx != -1 && !_notifications[idx].isRead) {
      _notifications[idx] = _notifications[idx].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    bool changed = false;
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void clearRecentLecture() {
    _recentLecture = null;
    notifyListeners();
  }

  void recordLectureActivity({
    required Lesson lesson,
    required Chapter chapter,
    required Subject subject,
    double progress = 0.0,
    bool isCompleted = false,
  }) {
    _recentLecture = RecentLectureRecord(
      subjectId: subject.id,
      subjectName: subject.name,
      chapterId: chapter.id,
      chapterTitle: chapter.title,
      lessonId: lesson.id,
      topicTitle: lesson.title,
      lastAccessedAt: DateTime.now(),
      playbackProgress: progress,
      isCompleted: isCompleted,
      durationMinutes: lesson.durationMinutes,
      xpReward: lesson.xpReward,
    );
    notifyListeners();
  }

  void updateLectureProgress({
    required String lessonId,
    required double progress,
    bool isCompleted = false,
  }) {
    if (_recentLecture != null && _recentLecture!.lessonId == lessonId) {
      _recentLecture = _recentLecture!.copyWith(
        playbackProgress: progress,
        isCompleted: isCompleted,
        lastAccessedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

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

  void refreshHomeworkFeed() {
    // Re-evaluates statuses against current timestamps and notifies listeners
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

  HomeworkStatus getEffectiveStatus(HomeworkAssignment hw) {
    final progress = getProgressForAssignment(hw.id);
    return hw.computeStatus(progress);
  }

  /// Toggles permissible checklist items (steps 1 & 2).
  /// Restricted steps (step_3: written upload, step_4: mini-test, step_5: teacher approval)
  /// cannot be arbitrarily checked by students without completing the action.
  bool toggleChecklistItem(String assignmentId, String stepId) {
    if (stepId == 'step_3' || stepId == 'step_4' || stepId == 'step_5') {
      return false; // Action required to complete this step
    }

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
    }

    _homeworkProgress[assignmentId] = current.copyWith(
      completedStepIds: updatedSteps,
      status: newStatus,
      readInstructions: updatedSteps.contains('step_1'),
      studiedMaterial: updatedSteps.contains('step_2'),
    );
    notifyListeners();
    return true;
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

  void updateProfileName(String newName) {
    if (newName.trim().isNotEmpty) {
      _profile = _profile.copyWith(name: newName.trim());
      notifyListeners();
    }
  }

  void updateProfileImage(String imageUrl) {
    _profile = _profile.copyWith(profileImageUrl: imageUrl);
    notifyListeners();
  }

  void updateDailyGoalTarget(int newTarget) {
    if (newTarget > 0) {
      _profile = _profile.copyWith(dailyGoalTarget: newTarget);
      notifyListeners();
    }
  }

  /// Initialize state for demo student user
  void initializeForDemo() {
    _profile = const StudentProfile(
      id: 'demo_student_qrie',
      name: 'Aarav Sharma',
      grade: 'Class 10',
      board: 'CBSE',
      streakDays: 6,
      totalXp: 1840,
      gems: 240,
      dailyGoalCurrent: 3,
      dailyGoalTarget: 5,
      completedLessonIds: {'sci_ch1_les1', 'math_ch1_les1', 'sci_ch2_les1'},
      bookmarkedLessonIds: {'sci_ch1_les2', 'math_ch2_les1'},
      profileImageUrl: 'assets/default_icon.png',
    );
    notifyListeners();
  }

  /// Reset session state on logout
  void resetSession() {
    _profile = MockData.initialStudent;
    _doubtMessages.clear();
    _doubtMessages.addAll(MockData.initialDoubtMessages);
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

  void clearDoubtHistory() {
    _doubtMessages.clear();
    _doubtMessages.addAll(MockData.initialDoubtMessages);
    notifyListeners();
  }

  void addDoubt({
    required String text,
    String? formulaOrSnippet,
    String? keyConcept,
    List<String>? followUpSuggestions,
    String? imageAttachment,
    bool isTestMode = false,
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
    Future.delayed(const Duration(milliseconds: 450), () {
      final tutorMsg = _generateTutorResponse(
        text,
        isTestMode: isTestMode || _isTestGuardrailActive,
        homework: _activeHomeworkContext,
        questionContext: _activeQuestionContext,
      );
      _doubtMessages.add(tutorMsg);
      // Reward XP for academic curiosity
      _profile = _profile.copyWith(
        totalXp: _profile.totalXp + 10,
        gems: _profile.gems + 2,
      );
      notifyListeners();
    });
  }

  DoubtMessage _generateTutorResponse(
    String query, {
    bool isTestMode = false,
    HomeworkAssignment? homework,
    String? questionContext,
  }) {
    final q = query.toLowerCase();
    String responseText = '';
    String? formula;
    String? concept;
    List<String>? followUps;

    if (isTestMode) {
      // ── Socratic Guardrails Mode for Verification Tests ───────────────
      if (q.contains('formula') || q.contains('equation')) {
        responseText =
            '🎯 Core Relationship Hint:\nIdentify the independent and dependent variables. If temperature is constant, recall how potential difference relates to current. What remains unchanged across resistors in series vs parallel?';
        formula = 'Ohm\'s Law: V = I · R  |  Series: R_eq = ∑R  |  Parallel: 1/R_eq = ∑(1/R)';
        concept = 'Ohmic Relationships & Network Conservation';
        followUps = [
          'What happens to current if resistance doubles?',
          'How does potential divide across series resistors?',
        ];
      } else if (q.contains('resistor') || q.contains('parallel') || q.contains('series') || q.contains('circuit')) {
        responseText =
            '💡 Socratic Guidance:\nIn parallel networks, every branch experiences the exact same voltage. The total current splits among branches. Does adding parallel branches increase or decrease the overall circuit resistance?';
        formula = '1/R_eq = 1/R₁ + 1/R₂  (R_eq is always smaller than the smallest branch)';
        concept = 'Equivalent Resistance in Parallel Networks';
        followUps = [
          'Calculate Req for two identical 4Ω resistors in parallel',
          'Why does series connection increase total resistance?',
        ];
      } else if (q.contains('linear') || q.contains('solution') || q.contains('k') || q.contains('infinitely')) {
        responseText =
            '💡 Conceptual Hint:\nFor a system a₁x + b₁y = c₁ and a₂x + b₂y = c₂:\n• Infinitely many solutions occur when the two lines are coincident (overlapping).\n• Set up the ratio condition: a₁/a₂ = b₁/b₂ = c₁/c₂ and cross-multiply to isolate the unknown parameter.';
        formula = 'Coincident condition: a₁/a₂ = b₁/b₂ = c₁/c₂';
        concept = 'Consistency & Coincident Linear Equations';
        followUps = [
          'What is the condition for parallel lines (no solution)?',
          'How do you check consistency with ratios?',
        ];
      } else if (q.contains('cell') || q.contains('atp') || q.contains('respiration') || q.contains('glucose')) {
        responseText =
            '💡 Conceptual Guidance:\nThink about where cellular respiration begins vs where it concludes:\n• Glycolysis occurs in the cytoplasm and breaks glucose (6C) into pyruvate (3C).\n• The aerobic breakdown utilizing oxygen occurs inside mitochondria yielding 36-38 ATP.';
        formula = 'Glucose (6C) -> 2 Pyruvate (3C) + ATP  [Cytoplasm]';
        concept = 'Aerobic vs Anaerobic Breakdown Pathways';
        followUps = [
          'What is produced during anaerobic respiration in yeast?',
          'Why is ATP called the energy currency?',
        ];
      } else {
        responseText =
            '💡 Socratic Nudge:\nRead the prompt carefully and highlight the given values. Ask yourself:\n1. What physical or mathematical principle connects the knowns to the unknowns?\n2. What condition or constraint must hold true?\n\nEliminate choices that violate fundamental units or conservation principles.';
        formula = 'Fundamental Law: Apply definition -> Substitute knowns -> Simplify';
        concept = 'Deductive Scientific Reasoning';
        followUps = [
          'Which core formula applies here?',
          'Give me a conceptual clue about the variables',
        ];
      }
    } else {
      // ── Standard Interactive Homework & Lesson Tutoring ───────────────
      if (q.contains('cell') || q.contains('membrane')) {
        responseText =
            'Great question about cell biology! The cell membrane acts as a selective gatekeeper (selectively permeable). It allows essential nutrients, water, and oxygen to diffuse in while pumping out metabolic waste products.';
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
      } else if (q.contains('ohm') || q.contains('resistance') || q.contains('current') || q.contains('voltage')) {
        responseText =
            'Ohm\'s Law states that at constant temperature, the electric current (I) through a conductor is directly proportional to the potential difference (V) applied across it.\n\nThe constant of proportionality is resistance (R), measured in Ohms (Ω).';
        formula = 'V = I · R   |   I = V / R   |   R = V / I';
        concept = 'Ohm\'s Law & Conductance';
        followUps = [
          'What is the V-I graph for an ohmic resistor?',
          'How does temperature affect metal resistance?',
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
            'Great inquiry! In academic learning, the golden rule is connecting abstract formulas to first principles:\n\n1. Identify the given variables and target output.\n2. Recall the governing law or theorem.\n3. Solve methodically step by step.';
        formula = 'Result = Governing Principle(Conditions)';
        concept = 'Conceptual Application & Mastery';
        followUps = [
          'Can you show a practice example?',
          'Explain with a real life analogy',
        ];
      }
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
