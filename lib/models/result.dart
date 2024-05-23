class ResultElement {
  final String option;
  final double percentage; 
    ResultElement({
    required this.option,
    required this.percentage
  });
   factory ResultElement.fromJson(Map<String, dynamic> json) {
    return ResultElement(
      option: json['option'],
      percentage: json['percentage']
    );
  }
}

class Result {
  final String surveyId;
  final List<ResultElement> elements;

  Result({
    required this.surveyId,
    required this.elements
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var elementsFromJson = json['elements'] as List;
    List<ResultElement> elementList = elementsFromJson.map((i) => ResultElement.fromJson(i)).toList();

    return Result(
      surveyId: json['surveyId'],
      elements: elementList
    );
  }
}