import 'package:flutter/material.dart';

class ScreenPersonnageList extends StatefulWidget {
  final String universId;

  const ScreenPersonnageList({super.key, required this.universId});

  @override
  State<ScreenPersonnageList> createState() => _ScreenPersonnageListState();
}

class _ScreenPersonnageListState extends State<ScreenPersonnageList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personnages de l'univers ${widget.universId}"),
      ),
      body: Center(
        child:
            Text('Liste des personnages pour univers ID: ${widget.universId}'),
      ),
    );
  }
}
