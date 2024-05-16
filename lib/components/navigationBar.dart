import 'package:flutter/material.dart';

class NavigationBarCustom extends StatefulWidget {
  const NavigationBarCustom({super.key});

  @override
  State<NavigationBarCustom> createState() => _NavigationBarCustomState();
}

class _NavigationBarCustomState extends State<NavigationBarCustom> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Accueil",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: "Recherche",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.message),
        label: "Messages",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Profil",
      ),
    ])
  }
}
