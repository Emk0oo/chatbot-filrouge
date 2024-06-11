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
  final TextEditingController _messageController = TextEditingController();
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

    List<dynamic> messages =
        await _message.getAllMessage(token, _conversationId!);
    messages.sort((a, b) => DateTime.parse(a['created_at'])
        .compareTo(DateTime.parse(b['created_at'])));
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
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
                        return Center(
                            child: Text('Error: ${messageSnapshot.error}'));
                      } else if (!messageSnapshot.hasData ||
                          messageSnapshot.data!.isEmpty) {
                        return const Center(child: Text('No messages found'));
                      }

                      List<dynamic> messages = messageSnapshot.data!;

                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          var message = messages[index];
                          bool isSentByHuman = message['is_sent_by_human'];
                          return Align(
                            alignment: isSentByHuman
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSentByHuman
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                message['content'],
                                style: TextStyle(
                                  color: isSentByHuman
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Nouveau message ...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Méthode pour envoyer le message
                    // Vous pourrez ajouter la logique ici plus tard
                    String content = _messageController.text;
                    _messageController.clear();
                    print('Message envoyé: $content');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
