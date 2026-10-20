class DoubtMessage {
  final String id;
  final String text;
  final bool isStudent;
  final DateTime timestamp;
  final String? formulaOrSnippet;
  final String? keyConcept;
  final List<String>? followUpSuggestions;
  final String? imageAttachment;

  const DoubtMessage({
    required this.id,
    required this.text,
    required this.isStudent,
    required this.timestamp,
    this.formulaOrSnippet,
    this.keyConcept,
    this.followUpSuggestions,
    this.imageAttachment,
  });
}
