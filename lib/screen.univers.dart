import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:chatbot_filrouge/class/token.dart';
import 'package:chatbot_filrouge/class/univers.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ScreenUnivers extends StatefulWidget {
  const ScreenUnivers({super.key});

  @override
  State<ScreenUnivers> createState() => _ScreenUniversState();
}

class _ScreenUniversState extends State<ScreenUnivers> {
  final Token _tokenClass = Token();

  Future<Uint8List?> _fetchImage(String url, String token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Univers",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _tokenClass.getToken(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No token found'));
          } else {
            final String token = snapshot.data!;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Expanded(
                    child: FutureBuilder<List<dynamic>>(
                      future: Univers().getAllUnivers(token),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Erreur de chargement des univers'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('Aucun univers disponible'));
                        } else {
                          final data = snapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                data.length,
                                (index) {
                                  final imageUrl = data[index]['image'] == ''
                                      ? 'https://via.placeholder.com/75'
                                      : 'https://mds.sprw.dev/image_data/' +
                                          data[index]['image'];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 238, 238, 238),
                                            borderRadius:
                                                BorderRadius.circular(9),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            child: FutureBuilder<Uint8List?>(
                                              future:
                                                  _fetchImage(imageUrl, token),
                                              builder:
                                                  (context, imageSnapshot) {
                                                if (imageSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                } else if (imageSnapshot
                                                        .hasError ||
                                                    !imageSnapshot.hasData) {
                                                  return Image.network(
                                                    'https://via.placeholder.com/75',
                                                    fit: BoxFit.cover,
                                                  );
                                                } else {
                                                  return Image.memory(
                                                    imageSnapshot.data!,
                                                    fit: BoxFit.cover,
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index]['name'],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                data[index]['description'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const NavigationBarCustom(),
    );
  }
}
