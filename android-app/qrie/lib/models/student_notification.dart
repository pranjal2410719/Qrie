import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum NotificationType {
  homework,
  liveClass,
  exam,
  streak,
  schoolNotice,
}

class StudentNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? actionPayload;

  const StudentNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.actionPayload,
  });

  StudentNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? actionPayload,
  }) {
    return StudentNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      actionPayload: actionPayload ?? this.actionPayload,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.homework:
        return Icons.assignment_rounded;
      case NotificationType.liveClass:
        return Icons.video_call_rounded;
      case NotificationType.exam:
        return Icons.quiz_rounded;
      case NotificationType.streak:
        return Icons.local_fire_department_rounded;
      case NotificationType.schoolNotice:
        return Icons.campaign_rounded;
    }
  }

  Color get color {
    switch (type) {
      case NotificationType.homework:
        return AppColors.accentCobalt;
      case NotificationType.liveClass:
        return AppColors.accentPeriwinkle;
      case NotificationType.exam:
        return AppColors.accentRose;
      case NotificationType.streak:
        return AppColors.accentAmber;
      case NotificationType.schoolNotice:
        return AppColors.accentMint;
    }
  }

  String get categoryLabel {
    switch (type) {
      case NotificationType.homework:
        return 'Homework';
      case NotificationType.liveClass:
        return 'Live Class';
      case NotificationType.exam:
        return 'Exam / Quiz';
      case NotificationType.streak:
        return 'Streak & XP';
      case NotificationType.schoolNotice:
        return 'School Notice';
    }
  }

  String get timeAgoFormatted {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }
}
