import 'package:chatbot_filrouge/class/token.dart';
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Personnage.class.dart';
import 'package:chatbot_filrouge/class/Image.class.dart';
import 'dart:typed_data';

class ScreenPersonnageList extends StatefulWidget {
  final String universId;

  const ScreenPersonnageList({super.key, required this.universId});

  @override
  State<ScreenPersonnageList> createState() => _ScreenPersonnageListState();
}

class _ScreenPersonnageListState extends State<ScreenPersonnageList> {
  final Personnage _personnage = Personnage();
  final Token _token = Token();
  final ImageClass _imageFetcher = ImageClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personnages de l\'univers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Ajoutez un personnage
            },
          ),
        ],
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
                  final imageUrl = personnage['image'] == ''
                      ? 'https://via.placeholder.com/75'
                      : 'https://mds.sprw.dev/image_data/' +
                          personnage['image'];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 75,
                              height: 75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: FutureBuilder<Uint8List?>(
                                  future:
                                      _imageFetcher.fetchImage(imageUrl, token),
                                  builder: (context, imageSnapshot) {
                                    if (imageSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (imageSnapshot.hasError ||
                                        !imageSnapshot.hasData) {
                                      return Image.network(
                                        'https://via.placeholder.com/75',
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      );
                                    } else {
                                      return Image.memory(
                                        imageSnapshot.data!,
                                        width: 75,
                                        height: 75,
                                        fit: BoxFit.cover,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
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
