
//https://www.youtube.com/watch?v=6qQvhmlqwY0 botones
//https://www.youtube.com/watch?v=C2XX8nYT7h0 voidCallback?
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class MainMenu extends StatelessWidget {

  final VoidCallback? onPlay;
  final VoidCallback? onRanking;

  const MainMenu({super.key, this.onPlay, this.onRanking});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'TEN UNA IDEA',
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 40),

        ElevatedButton.icon(
          onPressed: onPlay,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('JUGAR'),
        ),

        const SizedBox(height: 20),

        ElevatedButton.icon(
          onPressed: onRanking,
          icon: const Icon(Icons.favorite),
          label: const Text('RANKING'),
        ),
      ],
    );
  }
}