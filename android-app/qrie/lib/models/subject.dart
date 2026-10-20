import 'package:flutter/material.dart';

class Subject {
  final String id;
  final String name;
  final String emoji;
  final String imageUrl;
  final IconData icon;
  final Color primaryColor;
  final Color shadowColor;
  final int chaptersCount;
  final double progress; // 0.0 to 1.0
  final String tagLine;

  const Subject({
    required this.id,
    required this.name,
    this.emoji = '',
    this.imageUrl = 'https://images.unsplash.com/photo-1532094349884-543bc11b234d?auto=format&fit=crop&w=400&q=80',
    required this.icon,
    required this.primaryColor,
    required this.shadowColor,
    required this.chaptersCount,
    required this.progress,
    required this.tagLine,
  });
}
