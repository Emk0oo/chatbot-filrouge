// lib/screen/screen_personnage.dart
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:chatbot_filrouge/class/Personnage.class.dart';

class ScreenPersonnage extends StatefulWidget {
  final int universId;
  final int personnageId;

  const ScreenPersonnage({
    Key? key,
    required this.universId,
    required this.personnageId,
  }) : super(key: key);

  @override
  _ScreenPersonnageState createState() => _ScreenPersonnageState();
}

class _ScreenPersonnageState extends State<ScreenPersonnage> {
  final Personnage _personnage = Personnage();
  final Token _token = Token();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du personnage'),
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

          return FutureBuilder<Map<String, dynamic>>(
            future: _personnage.getSinglePersonnage(
                token, widget.universId, widget.personnageId),
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

              final personnage = personnageSnapshot.data!;
              final imageUrl = personnage['image'] == ''
                  ? 'https://via.placeholder.com/175'
                  : 'https://mds.sprw.dev/image_data/' + personnage['image'];

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 175,
                        height: 175,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      personnage['name'],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      personnage['description'],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
