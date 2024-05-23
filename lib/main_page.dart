import 'package:flutter/material.dart';
import 'widgets/centered_widget.dart';
import 'widgets/create_survey_widget.dart';
import 'widgets/voting_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Umfragen'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Verwalten'),
            Tab(text: 'Abstimmen')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
           CenteredWidget(child: CreateSurveyWidget()),
          CenteredWidget(child: VotingWidget())
        ],
      ),
    );
  }
}
