import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/result.dart';
import '../models/survey.dart';
import '../service/survey_service.dart';

class VotingWidget extends StatefulWidget {
  const VotingWidget({super.key});
  @override
  _VotingWidgetState createState() => _VotingWidgetState();
}

class _VotingWidgetState extends State<VotingWidget> {
  final SurveyService surveyService =
      SurveyService(baseUrl: 'http://localhost:3000');
  String _selectedOption = '';
  late List<ResultElement> _results = List.empty();
  late List<Survey> allSurveys;
  late Future<Survey> futureSurvey = Future.value(Survey(surveyId: '', question: '', options: []));
  late String surveyId = '';
  int surveyIndex = 0;

  @override
  void initState() {
    super.initState();
    loadSurveys();
  }

  Future<void> loadSurveys() async {
    allSurveys = await surveyService.fetchAllSurveys();
    if (allSurveys.isNotEmpty) {
      setState(() {
        surveyId = allSurveys.elementAtOrNull(surveyIndex)?.surveyId ?? '';
        futureSurvey = surveyService.fetchSurvey(surveyId);
      });
    }
  }

  void _handleRadioValueChanged(String? value) {
    setState(() {
      _selectedOption = value ?? '';
    });
  }

  Future<void> _sendAndFetchData() async {
    await _sendDataToAPI();
    await _fetchDataFromAPI();
  }

  Future<void> _sendDataToAPI() async {
    if (_selectedOption.isEmpty) {
      return;
    }
    await surveyService.submitSurveyAnswer(surveyId, _selectedOption);
  }

  Future<void> _fetchDataFromAPI() async {
    if (surveyId.isEmpty) {
      return;
    }
    var result = await surveyService.fetchResult(surveyId);
    setState(() {
      _results = result.elements;
    });
  }

  Future<void> _switchSurvey() async {
    if (allSurveys.isEmpty) {
      return;
    }
    surveyIndex++;
    if (surveyIndex >= allSurveys.length) {
      surveyIndex = 0;
    }
    surveyId = allSurveys.elementAt(surveyIndex).surveyId;
    setState(() {
      futureSurvey = surveyService.fetchSurvey(surveyId);
      _results = List.empty();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Umfrage'),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              child: FutureBuilder<Survey>(
                future: futureSurvey,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView(
                      children: [
                        ListTile(title: Text(snapshot.data!.question)),
                        ...snapshot.data!.options.asMap().entries.map(
                            (optionEntry) => RadioListTile(
                                title: Text(optionEntry.value),
                                value: optionEntry.key.toString(),
                                groupValue: _selectedOption,
                                onChanged: _handleRadioValueChanged)),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const Text('keine Umfrage erstellt...');
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _sendAndFetchData();
              },
              child: const Text('Abstimmen und Ergebnis anzeigen'),
            ),
            const SizedBox(height: 20),
            const Text('Ergebnis:'),
            Container(
                constraints:
                    const BoxConstraints(minHeight: 260, maxWidth: 300),
                child: Column(
                  children: _results
                      .map((entry) => ListTile(
                            title: Text(entry.option),
                            subtitle: Text(
                                '${(entry.percentage * 100).toStringAsFixed(2)}%'),
                          ))
                      .toList(),
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _switchSurvey();
              },
              child: const Text('Nächste Umfrage ->'),
            ),
            const SizedBox(height: 50)
          ]),
        ));
  }
}
