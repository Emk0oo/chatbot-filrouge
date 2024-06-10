// lib/screen/screen_personnage_conversation.dart
import 'package:flutter/material.dart';

class ScreenPersonnageConversation extends StatelessWidget {
  final int characterId;
  final int universId;
  final int userId;

  const ScreenPersonnageConversation({
    Key? key,
    required this.characterId,
    required this.universId,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Character ID: $characterId',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'User ID: $userId',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Univers ID: $universId',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Text('Conversation content goes here...'),
          ],
        ),
      ),
    );
  }
}
