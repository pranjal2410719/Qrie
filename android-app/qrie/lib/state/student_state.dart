import 'package:flutter/material.dart';
import '../models/student_profile.dart';
import '../models/doubt_message.dart';
import '../data/mock_data.dart';

class StudentState extends ChangeNotifier {
  StudentProfile _profile = MockData.initialStudent;
  String _selectedSubjectId = 'science';
  final List<DoubtMessage> _doubtMessages = List.from(MockData.initialDoubtMessages);

  StudentProfile get profile => _profile;
  String get selectedSubjectId => _selectedSubjectId;
  List<DoubtMessage> get doubtMessages => List.unmodifiable(_doubtMessages);

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
      formula = 'Diffusion & Osmosis: Solvent flows from High ➔ Low concentration';
      concept = 'Selective Permeability & Homeostasis';
      followUps = [
        'What happens when a cell is placed in salt water?',
        'What is active transport vs passive transport?',
      ];
    } else if (q.contains('equation') || q.contains('solve') || q.contains('x')) {
      responseText =
          'Here is the systematic breakdown for solving linear equations:\n1. Move all variable terms to the Left Hand Side by changing signs.\n2. Move all numerical constants to the Right Hand Side.\n3. Simplify both sides and isolate the variable.\n4. Verify your work by substituting the value back into the original equation.';
      formula = 'ax + b = cx + d  ➔  (a - c)x = d - b';
      concept = 'Algebraic Balancing & Transposition';
      followUps = [
        'Solve 4(x - 2) = 12',
        'How to solve fractions in linear equations?',
      ];
    } else if (q.contains('photosynthesis') || q.contains('plant')) {
      responseText =
          'Photosynthesis is the process green plants use to convert light energy into chemical energy. Inside the chloroplasts, green chlorophyll captures photons and combines Carbon Dioxide with Water to create Glucose and Oxygen.';
      formula = '6CO₂ + 6H₂O + Sunlight ➔ C₆H₁₂O₆ + 6O₂';
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
