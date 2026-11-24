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
// https://www.youtube.com/watch?v=ee0uHqDHPvQ
class Puzzle extends StatefulWidget {
  const Puzzle({super.key});

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {

  // TAMAÑOS ORIGINALES
  final List<Size> tamanos = [
    const Size(410, 460),
    const Size(500, 270),
    const Size(395, 260),
    const Size(500, 415),
    const Size(450, 265),
    const Size(380, 270),
    const Size(390, 250),
    const Size(315, 260),
    const Size(140, 140),
  ];

  // POSICIONES ORIGINALES
  final List<Offset> posiciones = [
    const Offset(510, 405),
    const Offset(470, 260),
    const Offset(515, 140),
    const Offset(-90, 365),
    const Offset(0, 145),
    const Offset(-30, 20),
    const Offset(100, 500),
    const Offset(255, 270),
    const Offset(395, 620),
  ];

  // NUEVE IMÁGENES
  final List<String> imagenes = [
    'img/bloque1.PNG',
    'img/bloque2.PNG',
    'img/bloque3.PNG',
    'img/bloque4.PNG',
    'img/bloque5.PNG',
    'img/bloque6.PNG',
    'img/bloque7.PNG',
    'img/bloque8.PNG',
    'img/bombilla.PNG',
  ];

  // CONTORNOS PERSONALIZADOS
  // Coordenadas relativas: entre 0 y 1.
  final List<List<Offset>> hitboxes = [

    // BLOQUE 1 ROJO
    [
      const Offset(0.07, 0.25),
      const Offset(0.34, 0.25),
      const Offset(0.34, 0.49),
      const Offset(0.64, 0.49),
      const Offset(0.64, 0.25),
      const Offset(0.93, 0.25),
      const Offset(0.93, 0.73),
      const Offset(0.07, 0.73),
    ],

    // BLOQUE 2
    [
      const Offset(0, 0),
      const Offset(1, 0),
      const Offset(0.8, 1),
      const Offset(0.2, 0.8),
    ],

    // BLOQUE 3
    [
      const Offset(0.5, 0),
      const Offset(1, 0.5),
      const Offset(0.5, 1),
      const Offset(0, 0.5),
    ],

    // BLOQUE 4
    [
      const Offset(0, 0),
      const Offset(1, 0),
      const Offset(0.7, 1),
      const Offset(0.2, 0.8),
    ],

    // BLOQUE 5
    [
      const Offset(0.5, 0),
      const Offset(1, 0.5),
      const Offset(0.5, 1),
      const Offset(0, 0.5),
    ],

    // BLOQUE 6
    [
      const Offset(0, 0),
      const Offset(1, 0),
      const Offset(0.5, 1),
    ],

    // BLOQUE 7
    [
      const Offset(0, 0),
      const Offset(1, 0),
      const Offset(1, 1),
      const Offset(0, 1),
    ],

    // BLOQUE 8
    [
      const Offset(0.5, 0),
      const Offset(1, 1),
      const Offset(0, 1),
    ],

    // BOMBILLA
    [
      const Offset(0.5, 0),
      const Offset(0.9, 0.3),
      const Offset(0.8, 0.8),
      const Offset(0.5, 1),
      const Offset(0.2, 0.8),
      const Offset(0.1, 0.3),
    ],
  ];

  bool mostrarColisiones = true;

  int? piezaSeleccionada;

  // CONVERTIR EL CONTORNO A COORDENADAS REALES
  List<Offset> obtenerPuntos(
      int indice,
      Offset posicion,
      ) {
    return hitboxes[indice].map((punto) {
      return Offset(
        posicion.dx + punto.dx * tamanos[indice].width,
        posicion.dy + punto.dy * tamanos[indice].height,
      );
    }).toList();
  }

  // PRODUCTO VECTORIAL
  double cruz(Offset a, Offset b) {
    return a.dx * b.dy - a.dy * b.dx;
  }

  // COMPROBAR SI DOS POLÍGONOS SE INTERSECTAN
  bool poligonosColisionan(
      List<Offset> a,
      List<Offset> b,
      ) {
    final poligonos = [a, b];

    // SAT: Separating Axis Theorem
    for (final poligono in poligonos) {
      for (int i = 0; i < poligono.length; i++) {
        final p1 = poligono[i];
        final p2 = poligono[(i + 1) % poligono.length];

        final eje = Offset(
          -(p2.dy - p1.dy),
          p2.dx - p1.dx,
        );

        double minA = double.infinity;
        double maxA = double.negativeInfinity;
        double minB = double.infinity;
        double maxB = double.negativeInfinity;

        for (final p in a) {
          final proyeccion = cruz(eje, p);
          minA = proyeccion < minA ? proyeccion : minA;
          maxA = proyeccion > maxA ? proyeccion : maxA;
        }

        for (final p in b) {
          final proyeccion = cruz(eje, p);
          minB = proyeccion < minB ? proyeccion : minB;
          maxB = proyeccion > maxB ? proyeccion : maxB;
        }

        if (maxA <= minB || maxB <= minA) {
          return false;
        }
      }
    }

    return true;
  }

  // COMPROBAR COLISIONES
  bool hayColision(
      int indice,
      Offset nuevaPosicion,
      ) {
    final nuevosPuntos = obtenerPuntos(
      indice,
      nuevaPosicion,
    );

    for (int i = 0; i < posiciones.length; i++) {
      if (i == indice) continue;

      final otrosPuntos = obtenerPuntos(
        i,
        posiciones[i],
      );

      if (poligonosColisionan(
        nuevosPuntos,
        otrosPuntos,
      )) {
        return true;
      }
    }

    return false;
  }

  // CREAR PIEZA ARRASTRABLE
  Widget crearBloque(int indice) {
    return Positioned(
      left: posiciones[indice].dx,
      top: posiciones[indice].dy,
      width: tamanos[indice].width,
      height: tamanos[indice].height,

      child: GestureDetector(
        onPanStart: (_) {
          setState(() {
            piezaSeleccionada = indice;
          });
        },

        onPanUpdate: (details) {
          final actual = posiciones[indice];

          final horizontal = Offset(
            actual.dx + details.delta.dx,
            actual.dy,
          );

          Offset nueva = actual;

          if (!hayColision(indice, horizontal)) {
            nueva = horizontal;
          }

          final vertical = Offset(
            nueva.dx,
            nueva.dy + details.delta.dy,
          );

          if (!hayColision(indice, vertical)) {
            nueva = vertical;
          }

          if (nueva != actual) {
            setState(() {
              posiciones[indice] = nueva;
            });
          }
        },

        onPanEnd: (_) {
          setState(() {
            piezaSeleccionada = null;
          });
        },

        child: Image.asset(
          imagenes[indice],
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // BOTÓN PARA MOSTRAR LOS CONTORNOS
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                mostrarColisiones = !mostrarColisiones;
              });
            },
            icon: Icon(
              mostrarColisiones
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            label: Text(
              mostrarColisiones
                  ? 'Ocultar colisiones'
                  : 'Mostrar colisiones',
            ),
          ),

          Expanded(
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Image.asset('img/marco.PNG'),

                  // NUEVE IMÁGENES ARRASTRABLES
                  for (int i = 0; i < imagenes.length; i++)
                    crearBloque(i),

                  // CONTORNOS DE COLISIÓN
                  if (mostrarColisiones)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: HitboxPainter(
                            posiciones: posiciones,
                            tamanos: tamanos,
                            hitboxes: hitboxes,
                            piezaSeleccionada: piezaSeleccionada,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// DIBUJA LOS POLÍGONOS DE COLISIÓN
class HitboxPainter extends CustomPainter {
  final List<Offset> posiciones;
  final List<Size> tamanos;
  final List<List<Offset>> hitboxes;
  final int? piezaSeleccionada;

  HitboxPainter({
    required this.posiciones,
    required this.tamanos,
    required this.hitboxes,
    required this.piezaSeleccionada,
  });

  @override
  void paint(Canvas canvas, Size size) {

    for (int i = 0; i < hitboxes.length; i++) {

      final puntos = hitboxes[i].map((p) {
        return Offset(
          posiciones[i].dx + p.dx * tamanos[i].width,
          posiciones[i].dy + p.dy * tamanos[i].height,
        );
      }).toList();

      final path = Path()
        ..moveTo(puntos[0].dx, puntos[0].dy);

      for (int j = 1; j < puntos.length; j++) {
        path.lineTo(puntos[j].dx, puntos[j].dy);
      }

      path.close();

      final paintRelleno = Paint()
        ..color = Colors.red.withOpacity(0.12)
        ..style = PaintingStyle.fill;

      final paintBorde = Paint()
        ..color = piezaSeleccionada == i
            ? Colors.yellow
            : Colors.red
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paintRelleno);
      canvas.drawPath(path, paintBorde);

      // DIBUJAR LOS PUNTOS DE CONTROL
      final paintPunto = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;

      for (final punto in puntos) {
        canvas.drawCircle(
          punto,
          4,
          paintPunto,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant HitboxPainter oldDelegate) {
    return true;
  }

/*
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          height: double.maxFinite,
          width:
        )
      )
  }*/
/*
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Image.asset('img/marco.PNG'),

          Positioned(
            left: 510,
            top: 405,
            child: Image.asset('img/bloque1.PNG'),
            width: 410,
            height: 460,
          ),

          Positioned(
            left: 470,
            top: 260,
            child: Image.asset('img/bloque2.PNG'),
            width: 500,
            height: 270,
          ),

          Positioned(
            left: 515,
            top: 140,
            child: Image.asset('img/bloque3.PNG'),
            width: 395,
            height: 260,
          ),

          Positioned(
            left: -90,
            top: 365,
            child: Image.asset('img/bloque4.PNG'),
            width: 500,
            height: 415,
          ),

          Positioned(
            left: 0,
            top: 145,
            child: Image.asset('img/bloque5.PNG'),
            width: 450,
            height: 265,
          ),

          Positioned(
            left: -30,
            top: 20,
            child: Image.asset('img/bloque6.PNG'),
            width: 380,
            height: 270,
          ),

          Positioned(
            left: 100,
            top: 500,
            child: Image.asset('img/bloque7.PNG'),
            width: 390,
            height: 250,
          ),

          Positioned(
            left: 255,
            top: 270,
            child: Image.asset('img/bloque8.PNG'),
            width: 315,
            height: 260,
          ),

          Positioned(
            left: 395,
            top: 620,
            child: Image.asset('img/bombilla.PNG'),
            width: 140,
            height: 140,
          ),
        ],
      ),
    );
  }*/
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
