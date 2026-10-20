enum LessonType { video, interactive, quiz, flashcard }

class Lesson {
  final String id;
  final String chapterId;
  final String title;
  final String subtitle;
  final LessonType type;
  final int durationMinutes;
  final int xpReward;
  final String videoThumbnailUrl;
  final List<String> keyPoints;
  final String summaryText;
  final String funFact;

  const Lesson({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.durationMinutes,
    required this.xpReward,
    this.videoThumbnailUrl = '',
    required this.keyPoints,
    required this.summaryText,
    this.funFact = '',
  });
}
