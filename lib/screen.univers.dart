import 'package:flutter/material.dart';

class ScreenUnivers extends StatefulWidget {
  const ScreenUnivers({super.key});

  @override
  State<ScreenUnivers> createState() => _ScreenUniversState();
}

class _ScreenUniversState extends State<ScreenUnivers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Univers",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Text("Welcome to Screen Universsssss!"),
    );
  }
}
