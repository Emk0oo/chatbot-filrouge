// lib/screen/screen_personnage_conversation.dart
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Conversation.class.dart';
import 'package:chatbot_filrouge/class/Token.dart';
import 'package:chatbot_filrouge/class/Message.class.dart';

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
  final Message _message = Message();
  int? _conversationId;

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

    // Si aucune conversation n'est trouvée, créer une nouvelle conversation
    if (filteredConversations.isEmpty) {
      await _conversation.createConversation(
          token, widget.characterId, widget.userId);

      // Récupérer à nouveau les conversations après en avoir créé une nouvelle
      allConversations = await _conversation.getAllConversation(token);
      filteredConversations = allConversations.where((conversation) {
        return conversation['character_id'] == widget.characterId;
      }).toList();
    }

    // Assigner l'ID de la première conversation trouvée (ou nouvellement créée)
    if (filteredConversations.isNotEmpty) {
      _conversationId = filteredConversations.first['id'];
    }

    return filteredConversations;
  }

  Future<List<dynamic>> _fetchMessages() async {
    final String? token = await _token.getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    if (_conversationId == null) {
      throw Exception('No conversation ID found');
    }

    return await _message.getAllMessage(token, _conversationId!);
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
            _conversationId = conversations.first['id'];

            return FutureBuilder<List<dynamic>>(
              future: _fetchMessages(),
              builder: (context, messageSnapshot) {
                if (messageSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (messageSnapshot.hasError) {
                  return Center(child: Text('Error: ${messageSnapshot.error}'));
                } else if (!messageSnapshot.hasData ||
                    messageSnapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages found'));
                }

                List<dynamic> messages = messageSnapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    return ListTile(
                      title: Text('Message ID: ${message['id']}'),
                      subtitle: Text('Content: ${message['content']}'),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
