// lib/class/Conversation.class.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Conversation {
  Future<void> createConversation(
      String token, int characterId, int userId) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'character_id': characterId, 'user_id': userId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create conversation');
    }
  }
}
