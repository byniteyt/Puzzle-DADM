import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'PantallaFinal.dart';
import 'PantallaJuego.dart';
import 'PantallaMainMenu.dart';
import 'PantallaMeterUsuario.dart';
import 'PantallaRanking.dart';
import 'db/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  runApp(const MyApp());
}

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  String usuario = '';
  List<Map<String, dynamic>> ranking = [];

  Future<void> cargarRanking() async {
    final usuarios = await DatabaseHelper.instance.getUsers();

    setState(() {
      ranking = usuarios;
    });
  }
  void cambiarPantalla(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = MainMenu(
          onPlay: () => cambiarPantalla(1),
            onRanking: () async {
              await cargarRanking();
              cambiarPantalla(4);
            },
        );
        break;

      case 1:
        page = MeterUsuario(
          onStart: (nombre) {
            setState(() {
              usuario = nombre;
              selectedIndex = 2;
            });
          },
        );
        break;

      case 2:
        page = Puzzle(
          onFinish: () async {

            final usuarios = await DatabaseHelper.instance.getUsers();

            setState(() {
              ranking = usuarios;
              selectedIndex = 3;
            });
          },
        );
        break;

      case 3:
        page = FinalPage(
          usuario: usuario,
          onRanking: () async {
            await cargarRanking();
            cambiarPantalla(4);
          },
          onMenu: () => cambiarPantalla(0),
        );
        break;

      case 4:
        page = Pantallaranking(
          ranking: ranking,
          onMenu: () => cambiarPantalla(0),
        );
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
              title: const Text('USUARIO'),
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('JUEGO'),
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('RANKING'),
              onTap: () {
                setState(() {
                  selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('FINAL'),
              onTap: () {
                setState(() {
                  selectedIndex = 4;
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