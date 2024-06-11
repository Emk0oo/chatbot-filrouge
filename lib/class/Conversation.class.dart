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

  Future<List<dynamic>> getAllConversation(String token) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get conversation');
    }

    List<dynamic> conversations = jsonDecode(response.body);
    return conversations;
  }

  Future<void> getConversation(String token, int conversationId) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId');
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get conversation');
    }
  }

  Future<void> deleteConversation(String token, int conversationId) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/$conversationId');
    var response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete conversation');
    }
  }
}
