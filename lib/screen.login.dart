import 'package:flutter/material.dart';



class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion' , style: TextStyle(fontSize: 30, color: Color(0xFF9F5540),fontWeight: FontWeight.bold, ),),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
