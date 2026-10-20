# Qrie Student App — Data Models & Serialization Specification

**Document Reference:** `docs/student-app/DATA_MODEL_SPEC.md`  
**Status:** Approved Specification  
**Author:** Principal Data Architect & Senior Flutter Engineer  

---

## 1. Domain Entities & Client Data Models

```
┌────────────────────────────────────────────────────────────────────────┐
│                        DATA OWNERSHIP HIERARCHY                        │
├───────────────────────┬────────────────────────┬───────────────────────┤
│ Entity                │ Authoritative Source   │ Client Local Role     │
├───────────────────────┼────────────────────────┼───────────────────────┤
│ StudentProfile        │ Qrie Backend / Supabase│ Secure In-Memory Cache│
│ CurriculumSubject     │ Qrie Backend / Content │ Public Cached Storage │
│ Chapter & Concept     │ Qrie Backend / Content │ Public Cached Storage │
│ LessonContent         │ Qrie Backend / Content │ Downloaded Offline DB │
│ LearningSession       │ Qrie Backend Ledger    │ Active Session State  │
│ InteractionEvent      │ Client Minted ➔ Server │ Durable Outbox Queue  │
│ ConceptState (Mastery)│ LAM Engine ➔ Backend   │ Read-Only Local Cache │
│ Recommendation        │ LAM Engine             │ Ephemeral State       │
│ SpacedReviewItem      │ LAM Engine             │ Due List Cache        │
└───────────────────────┴────────────────────────┴───────────────────────┘
```

---

## 2. Model Definitions

### 2.1 StudentProfile
Represents the verified student identity and academic curriculum scope.

```dart
class StudentProfile {
  final String userId;           // Supabase Auth UID
  final String email;
  final String fullName;
  final String schoolId;         // Multi-tenant isolation key
  final int gradeLevel;          // 6 through 12
  final String board;            // 'CBSE', 'ICSE', 'State'
  final String lamStudentId;     // Pseudonymous identifier for LAM
  final int streakDays;          // Active streak count
  final int totalXp;             // Accumulated gamification XP
  final int gems;                // Reward currency
  final DateTime updatedAt;

  const StudentProfile({
    required this.userId,
    required this.email,
    required this.fullName,
    required this.schoolId,
    required this.gradeLevel,
    required this.board,
    required this.lamStudentId,
    required this.streakDays,
    required this.totalXp,
    required this.gems,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson();
  factory StudentProfile.fromJson(Map<String, dynamic> json);
}
```
- **Source of Truth:** Qrie Backend (`users` + `student_profiles` tables).
- **Cache Policy:** Stored in `flutter_secure_storage` as encrypted JSON.

---

### 2.2 CurriculumSubject & Chapter
Hierarchical curriculum definitions aligned with NCERT.

```dart
class CurriculumSubject {
  final String id;              // e.g., 'mathematics', 'science'
  final String name;            // 'Mathematics'
  final String emoji;           // '📐'
  final int chaptersCount;
  final int completedCount;
  final double progressRatio;   // 0.0 to 1.0

  const CurriculumSubject({
    required this.id,
    required this.name,
    required this.emoji,
    required this.chaptersCount,
    required this.completedCount,
    required this.progressRatio,
  });
}

class Chapter {
  final String id;              // e.g., 'sci_ch01_cell'
  final String subjectId;       // 'science'
  final int order;              // 1
  final String title;           // 'Cell — Structure & Functions'
  final String subtitle;        // 'Fundamental unit of life'
  final int conceptsCount;
  final bool isUnlocked;
  final List<LessonSummary> lessons;

  const Chapter({
    required this.id,
    required this.subjectId,
    required this.order,
    required this.title,
    required this.subtitle,
    required this.conceptsCount,
    required this.isUnlocked,
    required this.lessons,
  });
}
```

---

### 2.3 Interactive LessonContent
Bite-sized storybook lesson with visual diagram metadata and takeaways.

```dart
enum LessonContentType { title, narrative, diagram, checkpoint, formulaBox, takeawayList }

class LessonContent {
  final String id;
  final String chapterId;
  final String title;
  final String subtitle;
  final int durationMinutes;
  final int xpReward;
  final String? diagramSvgAsset;
  final List<String> keyTakeaways;
  final String summaryText;
  final String funFact;

  const LessonContent({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.subtitle,
    required this.durationMinutes,
    required this.xpReward,
    this.diagramSvgAsset,
    required this.keyTakeaways,
    required this.summaryText,
    required this.funFact,
  });
}
```

---

### 2.4 PracticeQuestion & AnswerAttempt
Authoritative question representation with multiple choice and numerical checking.

```dart
enum QuestionFormat { singleChoice, multipleChoice, numericInput }

class PracticeQuestion {
  final String itemId;
  final String conceptId;
  final String questionText;
  final List<String> options;
  final QuestionFormat format;
  final double difficulty;      // 0.0 (easiest) to 1.0 (hardest)
  final int xpReward;
  final String? hintRung1;      // Rethink prompt
  final String? hintRung2;      // Strategic clue

  const PracticeQuestion({
    required this.itemId,
    required this.conceptId,
    required this.questionText,
    required this.options,
    required this.format,
    required this.difficulty,
    required this.xpReward,
    this.hintRung1,
    this.hintRung2,
  });
}

class AnswerAttempt {
  final String eventId;          // Client-minted UUID
  final String sessionId;
  final String itemId;
  final String conceptId;
  final dynamic studentAnswer;   // int index or double number
  final int attemptNumber;
  final int assistanceLevel;     // 0 = unassisted
  final int responseTimeMs;
  final int activeMs;
  final DateTime timestamp;

  const AnswerAttempt({
    required this.eventId,
    required this.sessionId,
    required this.itemId,
    required this.conceptId,
    required this.studentAnswer,
    required this.attemptNumber,
    required this.assistanceLevel,
    required this.responseTimeMs,
    required this.activeMs,
    required this.timestamp,
  });

  Map<String, dynamic> toJson();
}
```

---

### 2.5 ConceptState & Mastery Representation
Read-only learner state derived by LAM from the immutable interaction ledger.

```dart
class ConceptState {
  final String conceptId;
  final double conceptMastery;        // All evidence BKT probability (0.0 to 1.0)
  final double independentMastery;    // Rung 0 unassisted mastery (0.0 to 1.0)
  final double assistedPerformance;   // Success probability with scaffolding
  final double uncertainty;           // Beta distribution variance
  final int observationsCount;
  final int unassistedObservations;
  final double retentionStrength;     // Spaced retrieval memory strength
  final DateTime? nextReviewAt;       // Due date for spaced repetition
  final DateTime updatedAt;

  const ConceptState({
    required this.conceptId,
    required this.conceptMastery,
    required this.independentMastery,
    required this.assistedPerformance,
    required this.uncertainty,
    required this.observationsCount,
    required this.unassistedObservations,
    required this.retentionStrength,
    this.nextReviewAt,
    required this.updatedAt,
  });

  /// High-level badge indicator for student UI
  bool get isMastered => independentMastery >= 0.85 && unassistedObservations >= 3;
}
```

---

### 2.6 SyncOutboxItem (Durable Offline Queue)
```dart
class SyncOutboxItem {
  final String id;               // Client-minted UUID
  final String sessionId;
  final String payloadJson;      // Serialized AnswerAttempt
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;

  const SyncOutboxItem({
    required this.id,
    required this.sessionId,
    required this.payloadJson,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
  });
}
```
