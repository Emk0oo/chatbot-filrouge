import 'dart:convert';
import 'package:http/http.dart' as http;

class Conversation {
  //create a conversation
  Future<void> createConversation(
      String token, int character_id, int user_id) async {
    var url = Uri.parse('https://mds.sprw.dev/conversations/');
    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'character_id': character_id, 'user_id': user_id}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create conversation');
    }
  }
}
