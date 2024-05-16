import 'package:flutter/material.dart';
import 'package:chatbot_filrouge/components/navigationBar.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              "Dernières conversations",
              style: TextStyle(
                fontSize: 23,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ici data dernières conversations
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        Text("Nom personnage"),
                        Text(
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
            SizedBox(height: 50),
            Text(
              "Univers",
              style: TextStyle(
                fontSize: 23,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Centrer verticalement dans la colonne
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Centrer horizontalement dans la colonne
                      children: [
                        // Ici data dernières conversations
                        Container(
                          width: 175,
                          height: 175,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 238, 238, 238),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        SizedBox(
                            height:
                                8), // Espacement entre le container et le texte
                        Text("Nom univers"),
                      ],
                    ),
                  ),

                  // Ajoutez d'autres containers ici pour les autres conversations
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarCustom(),
    );
  }
}
