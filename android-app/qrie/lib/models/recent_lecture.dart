class RecentLectureRecord {
  final String subjectId;
  final String subjectName;
  final String chapterId;
  final String chapterTitle;
  final String lessonId;
  final String topicTitle;
  final DateTime lastAccessedAt;
  final double playbackProgress; // 0.0 to 1.0
  final bool isCompleted;
  final int durationMinutes;
  final int xpReward;

  const RecentLectureRecord({
    required this.subjectId,
    required this.subjectName,
    required this.chapterId,
    required this.chapterTitle,
    required this.lessonId,
    required this.topicTitle,
    required this.lastAccessedAt,
    this.playbackProgress = 0.0,
    this.isCompleted = false,
    required this.durationMinutes,
    this.xpReward = 20,
  });

  RecentLectureRecord copyWith({
    String? subjectId,
    String? subjectName,
    String? chapterId,
    String? chapterTitle,
    String? lessonId,
    String? topicTitle,
    DateTime? lastAccessedAt,
    double? playbackProgress,
    bool? isCompleted,
    int? durationMinutes,
    int? xpReward,
  }) {
    return RecentLectureRecord(
      subjectId: subjectId ?? this.subjectId,
      subjectName: subjectName ?? this.subjectName,
      chapterId: chapterId ?? this.chapterId,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      lessonId: lessonId ?? this.lessonId,
      topicTitle: topicTitle ?? this.topicTitle,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      playbackProgress: playbackProgress ?? this.playbackProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      xpReward: xpReward ?? this.xpReward,
    );
  }

  String get formattedLastAccessed {
    final now = DateTime.now();
    final difference = now.difference(lastAccessedAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
