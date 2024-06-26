import 'package:flutter/material.dart';
import 'main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Umfragen',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MainPage()
    );
  }
}