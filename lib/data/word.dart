class Word {
  final String topic;
  final String polish;
  final String german;

  Word({
    required this.topic,
    required this.polish,
    required this.german,
  });

  Map<String, dynamic> toMap() {
    return {
      'topic': topic,
      'polish': polish,
      'german': german,
    };
  }

  factory Word.fromMap({required Map<String, dynamic> map}) {
    return Word(
      topic: map['topic'],
      polish: map['polish'],
      german: map['german'],
    );
  }
}
