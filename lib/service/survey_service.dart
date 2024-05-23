import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/result.dart';
import '../models/survey.dart';

class SurveyService {
  final String baseUrl;

  SurveyService({required this.baseUrl});

  Future<List<Survey>> fetchAllSurveys() async {
    Uri surveyEndpoint = Uri.parse('$baseUrl/surveys');
    Response response;
    try {
      response = await http.get(surveyEndpoint);
    }
    catch(e) {
      throw Exception('Failed to call surveys endpoint');
    }
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((surveyJson) => Survey.fromJson(surveyJson)).toList();
    } else {
      throw Exception('Failed to load all surveys');
    }
  }

  Future<Survey> fetchSurvey(String surveyId) async {
    Uri surveyEndpoint = Uri.parse('$baseUrl/surveys/$surveyId');
    Response response;
    try {
      response = await http.get(surveyEndpoint);
    }
    catch(e) {
      throw Exception('Failed to call surveys endpoint');
    }
    
    if (response.statusCode == 200) {
      return Survey.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load survey');
    }
  }

  Future<Result> fetchResult(String surveyId) async {
    Uri surveyEndpoint = Uri.parse('$baseUrl/result/$surveyId');
    Response response;
    try {
      response = await http.get(surveyEndpoint);
    }
    catch(e) {
      throw Exception('Failed to call result endpoint');
    }
    
    if (response.statusCode == 200) {
      return Result.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load result');
    }
  }

  Future<void> submitSurveyAnswer(String surveyId, String optionId) async {
    final url = Uri.parse('$baseUrl/votings');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({ 'surveyId': surveyId, 'userId': '1', 'optionId': optionId }),
    );

    if (response.statusCode == 201) {
      print('Survey answer submitted successfully.');
    } else {
      throw Exception('Failed to submit survey answers: ${response.reasonPhrase}');
    }
  }

  Future<void> submitNewSurvey(Survey survey) async {
    final url = Uri.parse('$baseUrl/surveys');
    final surveyJson = jsonEncode(survey);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: surveyJson
    );

    if (response.statusCode == 201) {
      print('Survey submitted successfully.');
    } else {
      throw Exception('Failed to submit survey: ${response.reasonPhrase}');
    }
  }
}