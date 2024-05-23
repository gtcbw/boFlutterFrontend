import 'package:flutter/material.dart';

class CenteredWidget extends StatelessWidget {
  final Widget child;

  const CenteredWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: child
    );
  }
}
