import 'package:flutter/material.dart';
import 'package:start_algorithm/home_screen.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Algorithm',
      home: HomeScreen(),
    );
  }
}
