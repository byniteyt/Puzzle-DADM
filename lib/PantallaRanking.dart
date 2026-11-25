import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class Pantallaranking extends StatelessWidget {

  final List<String> ranking;
  final VoidCallback onMenu;

  const Pantallaranking({
    super.key,
    required this.ranking,
    required this.onMenu,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        const SizedBox(height: 30),

        const Text(
          'RANKING',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: ranking.isEmpty
              ? const Center(
            child: Text('Todavía no hay jugadores.'),
          )
              : ListView.builder(
            itemCount: ranking.length,
            itemBuilder: (context, index) {

              return Card(
                child: ListTile(
                  leading: Text('${index + 1}º'),
                  title: Text(ranking[index]),
                ),
              );
            },
          ),
        ),

        ElevatedButton(
          onPressed: onMenu,
          child: const Text('VOLVER AL MENÚ'),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}