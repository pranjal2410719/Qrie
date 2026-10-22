import 'package:flutter/material.dart';

enum CalendarEventType {
  exam,
  liveClass,
  studySession,
  schoolEvent,
  assignmentDeadline,
}

class AcademicCalendarEvent {
  final String id;
  final String title;
  final String description;
  final CalendarEventType type;
  final DateTime dateTime;
  final DateTime? endDateTime;
  final String subjectId;
  final String subjectName;
  final String status; // 'scheduled', 'ongoing', 'completed'
  final String? roomOrLink;

  const AcademicCalendarEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.dateTime,
    this.endDateTime,
    required this.subjectId,
    required this.subjectName,
    this.status = 'scheduled',
    this.roomOrLink,
  });

  IconData get icon {
    switch (type) {
      case CalendarEventType.exam:
        return Icons.assignment_late_rounded;
      case CalendarEventType.liveClass:
        return Icons.live_tv_rounded;
      case CalendarEventType.studySession:
        return Icons.menu_book_rounded;
      case CalendarEventType.schoolEvent:
        return Icons.school_rounded;
      case CalendarEventType.assignmentDeadline:
        return Icons.alarm_rounded;
    }
  }

  Color get color {
    switch (type) {
      case CalendarEventType.exam:
        return const Color(0xFFEF4444); // Red
      case CalendarEventType.liveClass:
        return const Color(0xFF6366F1); // Indigo / Cobalt
      case CalendarEventType.studySession:
        return const Color(0xFF10B981); // Emerald / Mint
      case CalendarEventType.schoolEvent:
        return const Color(0xFFF59E0B); // Amber
      case CalendarEventType.assignmentDeadline:
        return const Color(0xFFEC4899); // Rose
    }
  }

  String get typeLabel {
    switch (type) {
      case CalendarEventType.exam:
        return 'Exam';
      case CalendarEventType.liveClass:
        return 'Live Class';
      case CalendarEventType.studySession:
        return 'Study Session';
      case CalendarEventType.schoolEvent:
        return 'School Event';
      case CalendarEventType.assignmentDeadline:
        return 'Assignment Due';
    }
  }

  bool isSameDay(DateTime other) {
    return dateTime.year == other.year &&
        dateTime.month == other.month &&
        dateTime.day == other.day;
  }
}
