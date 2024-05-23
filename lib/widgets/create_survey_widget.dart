import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/survey.dart';

import '../service/survey_service.dart';

class CreateSurveyWidget extends StatefulWidget {
  const CreateSurveyWidget({super.key});
  @override
  _CreateSurveyWidgetState createState() => _CreateSurveyWidgetState();
}

class _CreateSurveyWidgetState extends State<CreateSurveyWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers = [];
    final SurveyService surveyService =
      SurveyService(baseUrl: 'http://localhost:3000');

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnswerField() {
    setState(() {
      _answerControllers.add(TextEditingController());
    });
  }

  void _removeAnswerField(int index) {
    setState(() {
      _answerControllers.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final question = _questionController.text;
      final answers = _answerControllers.map((controller) => controller.text).toList();

      Survey survey = Survey(surveyId: '', question: question, options: answers);
      await surveyService.submitNewSurvey(survey);
      
      _questionController.clear();
      for (var controller in _answerControllers) {
        controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frage erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _questionController,
                decoration: const InputDecoration(labelText: 'Frage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bitte eine Frage eingeben';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ..._buildAnswerFields(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addAnswerField,
                child: const Text('Antwort hinzufügen'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Frage erstellen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnswerFields() {
    return List<Widget>.generate(_answerControllers.length, (index) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _answerControllers[index],
              decoration: InputDecoration(labelText: 'Antwort ${index + 1}'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bitte eine Antwort eingeben';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle),
            onPressed: () => _removeAnswerField(index),
          ),
        ],
      );
    });
  }
}
