import 'package:flutter/material.dart';
import 'lesson.dart';

class Chapter {
  final String id;
  final String subjectId;
  final String title;
  final String subtitle;
  final IconData icon;
  final int order;
  final bool isUnlocked;
  final List<Lesson> lessons;

  const Chapter({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.order,
    required this.isUnlocked,
    required this.lessons,
  });
}
