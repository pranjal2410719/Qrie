class StudentProfile {
  final String id;
  final String name;
  final String grade;
  final String board;
  final int streakDays;
  final int totalXp;
  final int gems;
  final int dailyGoalCurrent;
  final int dailyGoalTarget;
  final Set<String> completedLessonIds;
  final Set<String> bookmarkedLessonIds;

  const StudentProfile({
    required this.id,
    required this.name,
    required this.grade,
    required this.board,
    required this.streakDays,
    required this.totalXp,
    required this.gems,
    required this.dailyGoalCurrent,
    required this.dailyGoalTarget,
    required this.completedLessonIds,
    required this.bookmarkedLessonIds,
  });

  StudentProfile copyWith({
    String? id,
    String? name,
    String? grade,
    String? board,
    int? streakDays,
    int? totalXp,
    int? gems,
    int? dailyGoalCurrent,
    int? dailyGoalTarget,
    Set<String>? completedLessonIds,
    Set<String>? bookmarkedLessonIds,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      grade: grade ?? this.grade,
      board: board ?? this.board,
      streakDays: streakDays ?? this.streakDays,
      totalXp: totalXp ?? this.totalXp,
      gems: gems ?? this.gems,
      dailyGoalCurrent: dailyGoalCurrent ?? this.dailyGoalCurrent,
      dailyGoalTarget: dailyGoalTarget ?? this.dailyGoalTarget,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
      bookmarkedLessonIds: bookmarkedLessonIds ?? this.bookmarkedLessonIds,
    );
  }
}
