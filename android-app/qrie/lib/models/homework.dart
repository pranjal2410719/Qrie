import 'package:flutter/material.dart';
import 'quiz_question.dart';

/// Homework lifecycle states as required by PRD Section 1.2
enum HomeworkStatus {
  assigned,                 // Published but not started (neutral/pastel)
  inProgress,               // Started but steps remaining (cobalt/periwinkle)
  readyForVerification,     // Written work complete, mini-test pending (amber/mustard)
  completed,                // All conditions satisfied (restrained mint green)
  overdue,                  // Deadline passed and incomplete (rose/coral)
  submittedAwaitingReview,  // Submitted by student, awaiting teacher review
}

extension HomeworkStatusExtension on HomeworkStatus {
  String get label {
    switch (this) {
      case HomeworkStatus.assigned:
        return 'Assigned';
      case HomeworkStatus.inProgress:
        return 'In Progress';
      case HomeworkStatus.readyForVerification:
        return 'Ready for Test';
      case HomeworkStatus.completed:
        return 'Completed';
      case HomeworkStatus.overdue:
        return 'Overdue';
      case HomeworkStatus.submittedAwaitingReview:
        return 'Awaiting Review';
    }
  }

  Color get badgeColor {
    switch (this) {
      case HomeworkStatus.assigned:
        return const Color(0xFF6B7280); // Neutral slate
      case HomeworkStatus.inProgress:
        return const Color(0xFF6982F3); // Cobalt
      case HomeworkStatus.readyForVerification:
        return const Color(0xFFF28D35); // Amber
      case HomeworkStatus.completed:
        return const Color(0xFF32C787); // Mint green
      case HomeworkStatus.overdue:
        return const Color(0xFFEB5A28); // Coral red
      case HomeworkStatus.submittedAwaitingReview:
        return const Color(0xFF8B5CF6); // Violet
    }
  }

  Color get badgeBackground {
    switch (this) {
      case HomeworkStatus.assigned:
        return const Color(0xFFF3F4F6);
      case HomeworkStatus.inProgress:
        return const Color(0xFFEEF2FF);
      case HomeworkStatus.readyForVerification:
        return const Color(0xFFFFF7ED);
      case HomeworkStatus.completed:
        return const Color(0xFFECFDF5);
      case HomeworkStatus.overdue:
        return const Color(0xFFFEF2F2);
      case HomeworkStatus.submittedAwaitingReview:
        return const Color(0xFFF5F3FF);
    }
  }

  IconData get icon {
    switch (this) {
      case HomeworkStatus.assigned:
        return Icons.assignment_outlined;
      case HomeworkStatus.inProgress:
        return Icons.timelapse_rounded;
      case HomeworkStatus.readyForVerification:
        return Icons.quiz_outlined;
      case HomeworkStatus.completed:
        return Icons.check_circle_rounded;
      case HomeworkStatus.overdue:
        return Icons.error_outline_rounded;
      case HomeworkStatus.submittedAwaitingReview:
        return Icons.hourglass_top_rounded;
    }
  }
}

/// Content block types for rich structured homework content (Section 2B)
enum HomeworkBlockType {
  heading,
  paragraph,
  bulletList,
  equation,
  diagram,
  qaSection,
  attachment,
  questionPrompt,
}

class HomeworkContentBlock {
  final String id;
  final HomeworkBlockType type;
  final String? title;
  final String content;
  final List<String>? items;
  final String? equation;
  final String? diagramCaption;
  final String? attachmentName;
  final String? attachmentSize;

  const HomeworkContentBlock({
    String? id,
    required this.type,
    this.title,
    required this.content,
    this.items,
    this.equation,
    String? caption,
    String? diagramCaption,
    this.attachmentName,
    this.attachmentSize,
  }) : id = id ?? 'block',
       diagramCaption = caption ?? diagramCaption;

  String? get caption => diagramCaption ?? title;
}

/// Contextual resource categories (Section 3)
enum HomeworkResourceType {
  masterclass,
  classLecture,
  recordedLecture,
  studyNotes,
  practiceQuestions,
  practiceSet,
  revisionTest,
  chapterTest,
}

extension HomeworkResourceTypeExtension on HomeworkResourceType {
  String get label {
    switch (this) {
      case HomeworkResourceType.masterclass:
        return 'Concept Masterclass';
      case HomeworkResourceType.classLecture:
      case HomeworkResourceType.recordedLecture:
        return 'Recorded Lecture';
      case HomeworkResourceType.studyNotes:
        return 'Study Notes & Formulas';
      case HomeworkResourceType.practiceQuestions:
      case HomeworkResourceType.practiceSet:
        return 'Practice Questions';
      case HomeworkResourceType.revisionTest:
      case HomeworkResourceType.chapterTest:
        return 'Topic Revision Test';
    }
  }

  IconData get icon {
    switch (this) {
      case HomeworkResourceType.masterclass:
        return Icons.ondemand_video_rounded;
      case HomeworkResourceType.classLecture:
      case HomeworkResourceType.recordedLecture:
        return Icons.play_circle_outline_rounded;
      case HomeworkResourceType.studyNotes:
        return Icons.article_outlined;
      case HomeworkResourceType.practiceQuestions:
      case HomeworkResourceType.practiceSet:
        return Icons.fitness_center_rounded;
      case HomeworkResourceType.revisionTest:
      case HomeworkResourceType.chapterTest:
        return Icons.assignment_turned_in_outlined;
    }
  }
}

class HomeworkResource {
  final String id;
  final String title;
  final HomeworkResourceType type;
  final String durationOrPages;
  final String summary;
  final String? lessonId;
  final String? targetSubjectId;
  final int? durationMinutes;
  final int? pageCount;
  final int? questionCount;
  final String? urlOrPath;

  const HomeworkResource({
    required this.id,
    required this.title,
    required this.type,
    this.durationOrPages = '',
    this.summary = '',
    this.lessonId,
    this.targetSubjectId,
    this.durationMinutes,
    this.pageCount,
    this.questionCount,
    this.urlOrPath,
  });
}

/// Verification Mini Question (compatible with QuizQuestion)
typedef HomeworkMiniQuestion = QuizQuestion;

/// Topic Verification Mini-Test Configuration & Questions (Section 4)
class HomeworkMiniTest {
  final String id;
  final String title;
  final int questionsCount;
  final int passingScorePercent;
  final int maxAttempts;
  final List<QuizQuestion> questions;
  final String description;
  final int estimatedMinutes;

  const HomeworkMiniTest({
    required this.id,
    required this.title,
    int? questionsCount,
    int? passingPercentage,
    int? passingScorePercent,
    this.maxAttempts = 3,
    required this.questions,
    this.description = '',
    this.estimatedMinutes = 8,
  }) : questionsCount = questionsCount ?? questions.length,
       passingScorePercent = passingPercentage ?? passingScorePercent ?? 70;

  int get passingPercentage => passingScorePercent;
}

/// Student test attempt recording
class HomeworkTestAttempt {
  final String id;
  final int attemptNumber;
  final int scorePercent;
  final int correctCount;
  final int totalCount;
  final bool passed;
  final DateTime timestamp;

  const HomeworkTestAttempt({
    String? id,
    int? attemptNumber,
    int? scorePercentage,
    int? scorePercent,
    required this.correctCount,
    int? totalQuestions,
    int? totalCount,
    required this.passed,
    DateTime? attemptedAt,
    DateTime? timestamp,
  }) : id = id ?? 'att',
       attemptNumber = attemptNumber ?? 1,
       scorePercent = scorePercentage ?? scorePercent ?? 0,
       totalCount = totalQuestions ?? totalCount ?? 5,
       timestamp = attemptedAt ?? timestamp ?? const _ConstDateTime();

  int get scorePercentage => scorePercent;
  int get totalQuestions => totalCount;
  DateTime get attemptedAt => timestamp;
}

class _ConstDateTime implements DateTime {
  const _ConstDateTime();
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Student's live progress through the homework checklist & test
class HomeworkStudentProgress {
  final String assignmentId;
  final String studentId;
  final HomeworkStatus status;
  final Set<String> completedStepIds;
  final bool readInstructions;
  final bool studiedMaterial;
  final bool completedWrittenWork;
  final String? submittedAnswerText;
  final String? submittedAttachmentName;
  final DateTime? submissionTimestamp;
  final List<HomeworkTestAttempt> testAttempts;
  final String? teacherFeedback;
  final int? gradePoints;
  final bool isApprovedByTeacher;
  final bool writtenWorkSubmitted;
  final DateTime? writtenSubmissionDate;
  final List<String> submittedAttachmentUrls;
  final String studentNotes;

  const HomeworkStudentProgress({
    required this.assignmentId,
    this.studentId = 'stu_1',
    this.status = HomeworkStatus.assigned,
    this.completedStepIds = const {},
    this.readInstructions = false,
    this.studiedMaterial = false,
    this.completedWrittenWork = false,
    this.submittedAnswerText,
    this.submittedAttachmentName,
    this.submissionTimestamp,
    this.testAttempts = const [],
    this.teacherFeedback,
    this.gradePoints,
    this.isApprovedByTeacher = false,
    this.writtenWorkSubmitted = false,
    this.writtenSubmissionDate,
    this.submittedAttachmentUrls = const [],
    this.studentNotes = '',
  });

  bool get hasPassedMiniTest => testAttempts.any((attempt) => attempt.passed);

  int get attemptsCount => testAttempts.length;

  int? get highestTestScore => bestAttempt?.scorePercent;

  HomeworkTestAttempt? get bestAttempt {
    if (testAttempts.isEmpty) return null;
    return testAttempts.reduce((a, b) => a.scorePercent >= b.scorePercent ? a : b);
  }

  HomeworkTestAttempt? get latestAttempt {
    if (testAttempts.isEmpty) return null;
    return testAttempts.last;
  }

  int get checklistCompletedCount {
    int count = 0;
    if (readInstructions || completedStepIds.contains('step_1')) count++;
    if (studiedMaterial || completedStepIds.contains('step_2')) count++;
    if (completedWrittenWork || writtenWorkSubmitted || completedStepIds.contains('step_3')) count++;
    if (hasPassedMiniTest || completedStepIds.contains('step_4')) count++;
    return count;
  }

  double get checklistProgress => checklistCompletedCount / 4.0;

  HomeworkStudentProgress copyWith({
    String? assignmentId,
    String? studentId,
    HomeworkStatus? status,
    Set<String>? completedStepIds,
    bool? readInstructions,
    bool? studiedMaterial,
    bool? completedWrittenWork,
    String? submittedAnswerText,
    String? submittedAttachmentName,
    DateTime? submissionTimestamp,
    List<HomeworkTestAttempt>? testAttempts,
    String? teacherFeedback,
    int? gradePoints,
    int? highestTestScore,
    bool? isApprovedByTeacher,
    bool? writtenWorkSubmitted,
    DateTime? writtenSubmissionDate,
    List<String>? submittedAttachmentUrls,
    String? studentNotes,
  }) {
    return HomeworkStudentProgress(
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      completedStepIds: completedStepIds ?? this.completedStepIds,
      readInstructions: readInstructions ?? this.readInstructions,
      studiedMaterial: studiedMaterial ?? this.studiedMaterial,
      completedWrittenWork: completedWrittenWork ?? this.completedWrittenWork,
      submittedAnswerText: submittedAnswerText ?? this.submittedAnswerText,
      submittedAttachmentName: submittedAttachmentName ?? this.submittedAttachmentName,
      submissionTimestamp: submissionTimestamp ?? this.submissionTimestamp,
      testAttempts: testAttempts ?? this.testAttempts,
      teacherFeedback: teacherFeedback ?? this.teacherFeedback,
      gradePoints: gradePoints ?? this.gradePoints,
      isApprovedByTeacher: isApprovedByTeacher ?? this.isApprovedByTeacher,
      writtenWorkSubmitted: writtenWorkSubmitted ?? this.writtenWorkSubmitted,
      writtenSubmissionDate: writtenSubmissionDate ?? this.writtenSubmissionDate,
      submittedAttachmentUrls: submittedAttachmentUrls ?? this.submittedAttachmentUrls,
      studentNotes: studentNotes ?? this.studentNotes,
    );
  }
}

/// Complete Homework Assignment Model (Sections 1.1 & 8)
class HomeworkAssignment {
  final String id;
  final String title;
  final String subjectId;
  final String subjectName;
  final Color subjectColor;
  final String chapterId;
  final String chapterTitle;
  final String topic;
  final String teacherId;
  final String teacherName;
  final String classAndSection;
  final String description;
  final String teacherInstructions;
  final DateTime assignedDate;
  final DateTime dueDate;
  final int estimatedMinutes;
  final List<String> learningObjectives;
  final List<HomeworkContentBlock> contentBlocks;
  final List<HomeworkResource> resources;
  final HomeworkMiniTest? miniTest;
  final bool requiresTeacherReview;

  const HomeworkAssignment({
    required this.id,
    required this.title,
    this.subjectId = 'math',
    String? subject,
    String? subjectName,
    this.subjectColor = const Color(0xFF6982F3),
    this.chapterId = 'chap_1',
    String? chapter,
    String? chapterTitle,
    this.topic = '',
    this.teacherId = 't_1',
    this.teacherName = 'Prof. Sharma',
    String? className,
    String? classAndSection,
    this.description = '',
    String? instructions,
    String? teacherInstructions,
    required this.assignedDate,
    required this.dueDate,
    this.estimatedMinutes = 30,
    this.learningObjectives = const [],
    this.contentBlocks = const [],
    List<HomeworkResource>? linkedResources,
    List<HomeworkResource>? resources,
    this.miniTest,
    this.requiresTeacherReview = false,
  }) : subjectName = subject ?? subjectName ?? 'Mathematics',
       chapterTitle = chapter ?? chapterTitle ?? 'Chapter',
       classAndSection = className ?? classAndSection ?? 'Class 9-A',
       teacherInstructions = instructions ?? teacherInstructions ?? '',
       resources = linkedResources ?? resources ?? const [];

  String get subject => subjectName;
  String get chapter => chapterTitle;
  String get className => classAndSection;
  String get instructions => teacherInstructions;
  List<HomeworkResource> get linkedResources => resources;

  /// Compute student-specific status based on progress and due date
  HomeworkStatus computeStatus(HomeworkStudentProgress? progress) {
    final now = DateTime.now();
    final isDeadlinePassed = now.isAfter(dueDate);

    if (progress == null) {
      return isDeadlinePassed ? HomeworkStatus.overdue : HomeworkStatus.assigned;
    }

    if (progress.status != HomeworkStatus.assigned) {
      return progress.status;
    }

    if (progress.writtenWorkSubmitted && progress.hasPassedMiniTest) {
      if (requiresTeacherReview && !progress.isApprovedByTeacher) {
        return HomeworkStatus.submittedAwaitingReview;
      }
      return HomeworkStatus.completed;
    }

    if (isDeadlinePassed) {
      return HomeworkStatus.overdue;
    }

    if (progress.writtenWorkSubmitted && !progress.hasPassedMiniTest) {
      return HomeworkStatus.readyForVerification;
    }

    if (progress.readInstructions || progress.studiedMaterial || progress.writtenWorkSubmitted || progress.testAttempts.isNotEmpty) {
      return HomeworkStatus.inProgress;
    }

    return HomeworkStatus.assigned;
  }
}
