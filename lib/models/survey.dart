class Survey {
  final String surveyId;
  final String question;
  final List<String> options;

  Survey({
    required this.surveyId,
    required this.question,
    required this.options
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyId: json['surveyId'],
      question: json['question'],
      options: json['options'] != null ? List<String>.from(json['options']) : List.empty(),
    );
  }
  Map<String, dynamic> toJson() => {
    'surveyId': '',
    'question': question,
    'options': options
  };
}