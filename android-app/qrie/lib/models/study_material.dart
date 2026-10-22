import 'package:flutter/material.dart';

enum StudyMaterialType {
  pdf,
  image,
  document,
}

class TopicStudyMaterial {
  final String id;
  final String topicId;
  final String title;
  final String description;
  final StudyMaterialType type;
  final String fileUrl;
  final String fileSize;
  final int? pageCount;
  final bool isDownloadable;

  const TopicStudyMaterial({
    required this.id,
    required this.topicId,
    required this.title,
    required this.description,
    required this.type,
    required this.fileUrl,
    required this.fileSize,
    this.pageCount,
    this.isDownloadable = true,
  });

  IconData get icon {
    switch (type) {
      case StudyMaterialType.pdf:
        return Icons.picture_as_pdf_rounded;
      case StudyMaterialType.image:
        return Icons.image_rounded;
      case StudyMaterialType.document:
        return Icons.description_rounded;
    }
  }

  Color get color {
    switch (type) {
      case StudyMaterialType.pdf:
        return const Color(0xFFEF4444); // Crimson / Red
      case StudyMaterialType.image:
        return const Color(0xFF3B82F6); // Blue
      case StudyMaterialType.document:
        return const Color(0xFF10B981); // Emerald
    }
  }

  String get typeLabel {
    switch (type) {
      case StudyMaterialType.pdf:
        return 'PDF Document';
      case StudyMaterialType.image:
        return 'Diagram / Image';
      case StudyMaterialType.document:
        return 'Revision Note';
    }
  }
}
