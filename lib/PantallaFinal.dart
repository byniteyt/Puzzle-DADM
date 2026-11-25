import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class FinalPage extends StatelessWidget {

  final String usuario;
  //final int score;

  final VoidCallback onRanking;
  final VoidCallback onMenu;

  const FinalPage({
    super.key,
    required this.usuario,
   // required this.score,
    required this.onRanking,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          '¡ENHORABUENA!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          '¡$usuario has completado el puzzle!',
          style: const TextStyle(fontSize: 20),
        ),

        const SizedBox(height: 40),

        ElevatedButton(
          onPressed: onRanking,
          child: const Text('VER RANKING'),
        ),

        const SizedBox(height: 15),

        ElevatedButton(
          onPressed: onMenu,
          child: const Text('VOLVER AL MENÚ'),
        ),
      ],
    );
  }
}