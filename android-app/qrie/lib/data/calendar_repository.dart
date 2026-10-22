import '../models/calendar_event.dart';

class AcademicCalendarRepository {
  static final AcademicCalendarRepository instance =
      AcademicCalendarRepository._internal();

  AcademicCalendarRepository._internal();

  factory AcademicCalendarRepository() => instance;

  List<AcademicCalendarEvent> _buildEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return [
      // Today
      AcademicCalendarEvent(
        id: 'event_today_1',
        title: 'Science Live Class: Cell Organelles & Functions',
        description: 'Interactive doubt resolution on nucleus and mitochondria.',
        type: CalendarEventType.liveClass,
        dateTime: today.add(const Duration(hours: 15, minutes: 0)), // 3:00 PM
        endDateTime: today.add(const Duration(hours: 16, minutes: 0)), // 4:00 PM
        subjectId: 'science',
        subjectName: 'Science & Bio',
        status: 'scheduled',
        roomOrLink: 'Virtual Room B-4',
      ),
      AcademicCalendarEvent(
        id: 'event_today_2',
        title: 'Math Self-Study Session: Linear Equations Practice',
        description: 'Solve 10 textbook word problems on age puzzles.',
        type: CalendarEventType.studySession,
        dateTime: today.add(const Duration(hours: 17, minutes: 30)), // 5:30 PM
        endDateTime: today.add(const Duration(hours: 18, minutes: 30)),
        subjectId: 'math',
        subjectName: 'Mathematics',
        status: 'scheduled',
      ),

      // Tomorrow (+1 day)
      AcademicCalendarEvent(
        id: 'event_tmrw_1',
        title: 'Physics Homework Due: Forces & Friction',
        description: 'Submit written worksheet and complete mini verification test.',
        type: CalendarEventType.assignmentDeadline,
        dateTime: today.add(const Duration(days: 1, hours: 18)),
        subjectId: 'physics',
        subjectName: 'Physics',
        status: 'scheduled',
      ),
      AcademicCalendarEvent(
        id: 'event_tmrw_2',
        title: 'Weekly Science Diagnostic Assessment',
        description: 'Formative assessment on Chapter 1 concepts.',
        type: CalendarEventType.exam,
        dateTime: today.add(const Duration(days: 1, hours: 10)),
        endDateTime: today.add(const Duration(days: 1, hours: 11, minutes: 30)),
        subjectId: 'science',
        subjectName: 'Science & Bio',
        status: 'scheduled',
        roomOrLink: 'Hall 3',
      ),

      // Day + 3
      AcademicCalendarEvent(
        id: 'event_future_1',
        title: 'Inter-School Science Olympiad Screening',
        description: 'Annual competitive science and mathematics evaluation.',
        type: CalendarEventType.schoolEvent,
        dateTime: today.add(const Duration(days: 3, hours: 9)),
        endDateTime: today.add(const Duration(days: 3, hours: 12)),
        subjectId: 'science',
        subjectName: 'School Wide',
        status: 'scheduled',
        roomOrLink: 'Main Auditorium',
      ),

      // Day - 1 (Yesterday)
      AcademicCalendarEvent(
        id: 'event_past_1',
        title: 'Chemistry Lab Session: Synthetic Fibres',
        description: 'Observation of tensile strength in synthetic vs natural polymers.',
        type: CalendarEventType.liveClass,
        dateTime: today.subtract(const Duration(days: 1)).add(const Duration(hours: 11)),
        endDateTime: today.subtract(const Duration(days: 1)).add(const Duration(hours: 12, minutes: 30)),
        subjectId: 'chemistry',
        subjectName: 'Chemistry',
        status: 'completed',
        roomOrLink: 'Lab 201',
      ),
    ];
  }

  Future<List<AcademicCalendarEvent>> getEventsForDate(DateTime date) async {
    // In production this connects to API endpoint GET /api/v1/student/calendar-events?date=YYYY-MM-DD
    final allEvents = _buildEvents();
    return allEvents.where((e) => e.isSameDay(date)).toList();
  }

  Future<List<AcademicCalendarEvent>> getAllUpcomingEvents() async {
    final now = DateTime.now();
    final allEvents = _buildEvents();
    return allEvents.where((e) => e.dateTime.isAfter(now.subtract(const Duration(hours: 12)))).toList();
  }
}
