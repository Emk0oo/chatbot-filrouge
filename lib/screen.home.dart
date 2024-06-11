import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/class/Univers.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot_filrouge/screen.univers.description.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accueil",
          style: TextStyle(
            fontSize: 30,
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement du token'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Token non disponible'));
          } else {
            final String? token = snapshot.data;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "Dernières conversations",
                    style: TextStyle(
                      fontSize: 23,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 238, 238, 238),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              const Text("Nom personnage"),
                              const Text(
                                "Nom univers",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Ajoutez d'autres containers ici pour les autres conversations
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Univers",
                    style: TextStyle(
                      fontSize: 23,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final universId = data[index]['id'].toString();
                              final imageUrl = data[index]['image'] == ''
                                  ? 'https://via.placeholder.com/175'
                                  : 'https://mds.sprw.dev/image_data/' +
                                      data[index]['image'];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ScreenUniversDescription(
                                        universId: universId,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 175,
                                        height: 175,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 238, 238, 238),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.network(
                                              'https://via.placeholder.com/175',
                                              fit: BoxFit.cover,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(data[index]['name']),
                                    ],
                                  ),
                                ),
                              );
                            },
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
