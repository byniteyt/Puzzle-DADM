import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

// Estado de la aplicación
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  final List<WordPair> favorites = [];

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// Widget principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Random Words',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

// Página con navegación lateral
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = MainMenu(
          //función boton on play
          onPlay: () {
            setState(() {
              selectedIndex = 1;
            });
          },
          //funcón boton ranking
          onRanking: () {
            setState(() {
              selectedIndex = 2;
            });
          },
        );
        break;
      case 1:
        page = const Puzzle();
        break;
      case 2:
        page = const FavoritesPage();
        break;
      default:
        page = const MainMenu();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('TEN UNA IDEA'),
        ),

        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                title: const Text('MENU'),
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('PLAY'),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('RANKING'),
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      body: Center(child: page),
    );
  }
}

//https://www.youtube.com/watch?v=6qQvhmlqwY0 botones
//https://www.youtube.com/watch?v=C2XX8nYT7h0 voidCallback?
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
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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

// Página generadora de palabras
/*class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const RandomWordCard(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [FavoriteIcon(), SizedBox(width: 20), NextButton()],
        ),
      ],
    );
  }
}*/

class Puzzle extends StatelessWidget {
  const Puzzle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Image.asset('img/marco.PNG'),

          Positioned(
            left: 20,
            top: 30,
            child: Image.asset('img/bloque1.PNG'),
          ),

          Positioned(
            left: 80,
            top: 30,
            child: Image.asset('img/bloque2.PNG'),
          ),

          Positioned(
            left: 140,
            top: 30,
            child: Image.asset('img/bloque3.PNG'),
          ),

          Positioned(
            left: 20,
            top: 30,
            child: Image.asset('img/bloque4.PNG'),
          ),

          Positioned(
            left: 80,
            top: 30,
            child: Image.asset('img/bloque5.PNG'),
          ),

          Positioned(
            left: 140,
            top: 30,
            child: Image.asset('img/bloque6.PNG'),
          ),

          Positioned(
            left: 20,
            top: 30,
            child: Image.asset('img/bloque7.PNG'),
          ),

          Positioned(
            left: 80,
            top: 30,
            child: Image.asset('img/bloque8.PNG'),
          ),

          Positioned(
            left: 450,
            top: 590,
            child: Image.asset('img/bombilla.PNG'),
            width: 150,
            height: 150,
          ),
        ],
      ),
    );
  }
}

// Página de favoritos
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var favorites = context.watch<MyAppState>().favorites;

    if (favorites.isEmpty) {
      return const Text('No hay favoritos aún.');
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Tus palabras favoritas:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        for (var pair in favorites)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(pair.asPascalCase),
            ),
          ),
      ],
    );
  }
}

// Widget que muestra la palabra aleatoria
class RandomWordCard extends StatelessWidget {
  const RandomWordCard({super.key});

  @override
  Widget build(BuildContext context) {
    var word = context.watch<MyAppState>().current;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        word.asPascalCase,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Botón para generar una nueva palabra
class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<MyAppState>().getNext();
      },
      child: const Text('Next'),
    );
  }
}

// Botón de favoritos
class FavoriteIcon extends StatelessWidget {
  const FavoriteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    IconData icon;

    if (appState.favorites.contains(appState.current)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return ElevatedButton.icon(
      onPressed: () {
        appState.toggleFavorite();
      },
      icon: Icon(icon),
      label: const Text('Like'),
    );
  }
}
