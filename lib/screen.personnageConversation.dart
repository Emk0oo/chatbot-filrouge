// lib/screen/screen_personnage_conversation.dart
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart'; // Assurez-vous de mettre le bon chemin vers votre classe
import 'package:chatbot_filrouge/class/Token.dart'; // Assurez-vous de mettre le bon chemin vers votre classe

class ScreenPersonnageConversation extends StatefulWidget {
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
  _ScreenPersonnageConversationState createState() =>
      _ScreenPersonnageConversationState();
}

class _ScreenPersonnageConversationState
    extends State<ScreenPersonnageConversation> {
  final Conversation _conversation = Conversation();
  final Token _token = Token();

  Future<List<dynamic>> _fetchConversations() async {
    final String? token = await _token.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    List<dynamic> allConversations =
        await _conversation.getAllConversation(token);

    // Filtrer les conversations par characterId
    List<dynamic> filteredConversations =
        allConversations.where((conversation) {
      return conversation['character_id'] == widget.characterId;
    }).toList();

    // Si aucune conversation n'est trouvée, afficher un message de débogage
    if (filteredConversations.isEmpty) {
      debugPrint(
          'No conversations found for character_id: ${widget.characterId}');
      await _conversation.createConversation(
          token, widget.characterId, widget.userId);

      // Récupérer à nouveau les conversations après en avoir créé une nouvelle
      allConversations = await _conversation.getAllConversation(token);
      filteredConversations = allConversations.where((conversation) {
        return conversation['character_id'] == widget.characterId;
      }).toList();
    }

    return filteredConversations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: _fetchConversations(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No conversations found'));
            }

            List<dynamic> conversations = snapshot.data!;

            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                var conversation = conversations[index];
                return ListTile(
                  title: Text('Conversation ID: ${conversation['id']}'),
                  subtitle: Text('Created At: ${conversation['created_at']}'),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
