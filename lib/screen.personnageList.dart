import 'package:chatbot_filrouge/class/token.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Personnage.class.dart';

class ScreenPersonnageList extends StatefulWidget {
  final String universId;

  const ScreenPersonnageList({super.key, required this.universId});

  @override
  State<ScreenPersonnageList> createState() => _ScreenPersonnageListState();
}

class _ScreenPersonnageListState extends State<ScreenPersonnageList> {
  final Personnage _personnage = Personnage();
  final Token _token = Token();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personnages de l\'univers ${widget.universId}'),
      ),
      body: FutureBuilder<String?>(
        future: _token.getToken(),
        builder: (context, tokenSnapshot) {
          if (tokenSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (tokenSnapshot.hasError) {
            return Center(child: Text('Error: ${tokenSnapshot.error}'));
          } else if (!tokenSnapshot.hasData || tokenSnapshot.data == null) {
            return const Center(child: Text('No token found'));
          }

          final token = tokenSnapshot.data!;
          final int universId = int.tryParse(widget.universId) ?? 0;

          return FutureBuilder<List<dynamic>>(
            future: _personnage.getAllPersonnage(token, universId),
            builder: (context, personnageSnapshot) {
              if (personnageSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (personnageSnapshot.hasError) {
                return Center(
                    child: Text('Error: ${personnageSnapshot.error}'));
              } else if (!personnageSnapshot.hasData ||
                  personnageSnapshot.data == null) {
                return const Center(child: Text('No data found'));
              }

              final personnageList = personnageSnapshot.data!;

              return ListView.builder(
                itemCount: personnageList.length,
                itemBuilder: (context, index) {
                  final personnage =
                      personnageList[index] as Map<String, dynamic>;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Remplacez cette image par l'image réelle du personnage
                            Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey, // Placeholder pour l'image
                              margin: const EdgeInsets.only(right: 10.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    personnage['name'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    personnage['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
