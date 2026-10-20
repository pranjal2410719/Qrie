enum QuestionType {
  singleChoice,
  numeric,
}

class QuizQuestion {
  final String id;
  final String subjectId;
  final String question;
  final QuestionType questionType;
  final List<String> options;
  final int correctIndex;
  final double? numericAnswer;
  final String explanation;
  final String hint; // Rung 2: Strategic Domain Hint
  final String? rethinkPrompt; // Rung 1: Metacognitive Rethink
  final String? scaffoldSubstep; // Rung 3: Scaffolded Substep
  final int xpReward;
  final String category;
  final String? subjectName;
  final String? topic;
  final String? difficulty;

  String get prompt => question;

  const QuizQuestion({
    required this.id,
    required this.subjectId,
    required this.question,
    this.questionType = QuestionType.singleChoice,
    this.options = const [],
    this.correctIndex = 0,
    this.numericAnswer,
    required this.explanation,
    required this.hint,
    this.rethinkPrompt,
    this.scaffoldSubstep,
    this.xpReward = 15,
    this.category = 'Concept Check',
    this.subjectName,
    this.topic,
    this.difficulty,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final typeStr = json['question_type'] as String? ?? 'single_choice';
    final qType = (typeStr == 'numeric') ? QuestionType.numeric : QuestionType.singleChoice;

    return QuizQuestion(
      id: json['id'] as String? ?? '',
      subjectId: json['subject_id'] as String? ?? 'math',
      question: json['question'] as String? ?? '',
      questionType: qType,
      options: (json['options'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      correctIndex: json['correct_index'] as int? ?? 0,
      numericAnswer: (json['numeric_answer'] as num?)?.toDouble(),
      explanation: json['explanation'] as String? ?? '',
      hint: json['hint'] as String? ?? 'Think about the core formula.',
      rethinkPrompt: json['rethink_prompt'] as String?,
      scaffoldSubstep: json['scaffold_substep'] as String?,
      xpReward: json['xp_reward'] as int? ?? 15,
      category: json['category'] as String? ?? 'Concept Check',
    );
  }
}
