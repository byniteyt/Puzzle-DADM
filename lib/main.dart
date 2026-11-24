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

  // ==========================================
  // SISTEMA DE COORDENADAS ORIGINAL
  // ==========================================

  static const double anchoReferencia = 800;
  static const double altoReferencia = 700;

  // ESCALA ACTUAL
  double escala = 1;

  // ==========================================
  // TAMAÑOS ORIGINALES
  // ==========================================

  final List<Size> tamanos = [
    const Size(410, 460),
    const Size(500, 270),
    const Size(395, 260),
    const Size(470, 385),
    const Size(420, 235),
    const Size(355, 240),
    const Size(390, 250),
    const Size(315, 260),
    const Size(140, 140),
  ];

  // ==========================================
  // POSICIONES ORIGINALES
  // ==========================================

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

  // ==========================================
  // IMÁGENES
  // ==========================================

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

  // ==========================================
  // HITBOXES DE LOS BLOQUES
  // ==========================================

  final List<List<Offset>> hitboxes = [

    // BLOQUE 1 ROJO
    [
      Offset(0.07, 0.25),
      Offset(0.34, 0.25),
      Offset(0.34, 0.49),
      Offset(0.64, 0.49),
      Offset(0.64, 0.25),
      Offset(0.93, 0.25),
      Offset(0.93, 0.73),
      Offset(0.07, 0.73),
    ],

    // BLOQUE 2 NARANJA
    [
      Offset(0.14, 0.505),
      Offset(0.61, 0.505),
      Offset(0.61, 0.09),
      Offset(0.84, 0.09),
      Offset(0.84, 0.9),
      Offset(0.14, 0.9),
    ],

    // BLOQUE 3 CIAN
    [
      Offset(0.07, 0.09),
      Offset(0.93, 0.09),
      Offset(0.93, 0.48),
      Offset(0.63, 0.48),
      Offset(0.63, 0.91),
      Offset(0.35, 0.91),
      Offset(0.35, 0.48),
      Offset(0.07, 0.48),
    ],

    // BLOQUE 4 VERDE
    [
      Offset(0.27, 0.08),
      Offset(0.73, 0.08),
      Offset(0.73, 0.34),
      Offset(0.49, 0.34),
      Offset(0.49, 0.65),
      Offset(0.73, 0.65),
      Offset(0.73, 0.91),
      Offset(0.27, 0.91),
    ],

    // BLOQUE 5 AMARILLO
    [
      Offset(0.13, 0.5),
      Offset(0.38, 0.5),
      Offset(0.38, 0.08),
      Offset(0.88, 0.08),
      Offset(0.88, 0.48),
      Offset(0.62, 0.48),
      Offset(0.62, 0.91),
      Offset(0.13, 0.91),
    ],

    // BLOQUE 6 ROSA
    [
      Offset(0.21, 0.10),
      Offset(0.78, 0.10),
      Offset(0.78, 0.5),
      Offset(0.5, 0.5),
      Offset(0.5, 0.9),
      Offset(0.21, 0.9),
    ],

    // BLOQUE 7 MORADO
    [
      Offset(0.24, 0.09),
      Offset(0.76, 0.09),
      Offset(0.76, 0.91),
      Offset(0.5, 0.91),
      Offset(0.5, 0.5),
      Offset(0.24, 0.5),
    ],

    // BLOQUE 8 AZUL
    [
      Offset(0.5, 0.09),
      Offset(0.84, 0.09),
      Offset(0.84, 0.9),
      Offset(0.15, 0.9),
      Offset(0.15, 0.5),
      Offset(0.5, 0.5),
    ],

    // BOMBILLA
    [
      Offset(0.13, 0.1),
      Offset(0.86, 0.1),
      Offset(0.86, 0.9),
      Offset(0.13, 0.9),
    ],
  ];

  // ==========================================
  // HITBOX DEL MARCO
  // ==========================================

  final List<Offset> hitboxMarco = [
    Offset(0.04, 0.04),
    Offset(0.96, 0.04),
    Offset(0.96, 0.95),
    Offset(0.04, 0.95),
  ];

  bool mostrarColisiones = true;
  int? piezaSeleccionada;

  // ==========================================
  // CONVERTIR HITBOX A COORDENADAS REALES
  // ==========================================

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

  List<Offset> obtenerPuntosMarco() {
    return hitboxMarco.map((punto) {
      return Offset(
        punto.dx * anchoReferencia,
        punto.dy * altoReferencia,
      );
    }).toList();
  }

  // ==========================================
  // PUNTO DENTRO DE POLIGONO
  // ==========================================

  bool puntoDentroPoligono(
      Offset punto,
      List<Offset> poligono,
      ) {
    bool dentro = false;

    for (int i = 0, j = poligono.length - 1;
    i < poligono.length;
    j = i++) {

      final a = poligono[i];
      final b = poligono[j];

      final cruza =
          ((a.dy > punto.dy) != (b.dy > punto.dy)) &&
              (punto.dx <
                  (b.dx - a.dx) *
                      (punto.dy - a.dy) /
                      (b.dy - a.dy) +
                      a.dx);

      if (cruza) dentro = !dentro;
    }

    return dentro;
  }

  // ==========================================
  // ORIENTACION
  // ==========================================

  double orientacion(
      Offset a,
      Offset b,
      Offset c,
      ) {
    return (b.dx - a.dx) * (c.dy - a.dy) -
        (b.dy - a.dy) * (c.dx - a.dx);
  }

  // ==========================================
  // SEGMENTOS
  // ==========================================

  bool segmentosSeCruzan(
      Offset a,
      Offset b,
      Offset c,
      Offset d,
      ) {
    const epsilon = 0.000001;

    final o1 = orientacion(a, b, c);
    final o2 = orientacion(a, b, d);
    final o3 = orientacion(c, d, a);
    final o4 = orientacion(c, d, b);

    return (
        (o1 > epsilon && o2 < -epsilon) ||
            (o1 < -epsilon && o2 > epsilon)
    ) && (
        (o3 > epsilon && o4 < -epsilon) ||
            (o3 < -epsilon && o4 > epsilon)
    );
  }

  // ==========================================
  // COLISION ENTRE POLIGONOS
  // ==========================================

  bool poligonosColisionan(
      List<Offset> a,
      List<Offset> b,
      ) {

    for (int i = 0; i < a.length; i++) {
      final a1 = a[i];
      final a2 = a[(i + 1) % a.length];

      for (int j = 0; j < b.length; j++) {
        final b1 = b[j];
        final b2 = b[(j + 1) % b.length];

        if (segmentosSeCruzan(a1, a2, b1, b2)) {
          return true;
        }
      }
    }

    for (final punto in a) {
      if (puntoDentroPoligono(punto, b)) {
        return true;
      }
    }

    for (final punto in b) {
      if (puntoDentroPoligono(punto, a)) {
        return true;
      }
    }

    return false;
  }

  // ==========================================
  // COLISION CON MARCO
  // ==========================================

  bool fueraDelMarco(
      int indice,
      Offset nuevaPosicion,
      ) {

    final puntos = obtenerPuntos(
      indice,
      nuevaPosicion,
    );

    final marco = obtenerPuntosMarco();

    for (final punto in puntos) {
      if (!puntoDentroPoligono(punto, marco)) {
        return true;
      }
    }

    for (int i = 0; i < puntos.length; i++) {
      final a = puntos[i];
      final b = puntos[(i + 1) % puntos.length];

      for (int j = 0; j < marco.length; j++) {
        final c = marco[j];
        final d = marco[(j + 1) % marco.length];

        if (segmentosSeCruzan(a, b, c, d)) {
          return true;
        }
      }
    }

    return false;
  }

  // ==========================================
  // COLISIONES ENTRE BLOQUES
  // ==========================================

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

  bool movimientoValido(
      int indice,
      Offset posicion,
      ) {
    return !fueraDelMarco(indice, posicion) &&
        !hayColision(indice, posicion);
  }

  // ==========================================
  // BLOQUE ARRASTRABLE
  // ==========================================

  Widget crearBloque(int indice) {
    return Positioned(
      left: posiciones[indice].dx,
      top: posiciones[indice].dy,
      width: tamanos[indice].width,
      height: tamanos[indice].height,

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onPanStart: (_) {
          setState(() {
            piezaSeleccionada = indice;
          });
        },

        onPanUpdate: (details) {
          final dx = details.delta.dx / escala;
          final dy = details.delta.dy / escala;

          final actual = posiciones[indice];

          Offset nueva = actual;

          // MOVIMIENTO HORIZONTAL
          final horizontal = Offset(
            actual.dx + dx,
            actual.dy,
          );

          if (movimientoValido(indice, horizontal)) {
            nueva = horizontal;
          }

          // MOVIMIENTO VERTICAL
          final vertical = Offset(
            nueva.dx,
            nueva.dy + dy,
          );

          if (movimientoValido(indice, vertical)) {
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
          width: tamanos[indice].width,
          height: tamanos[indice].height,
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
    );
  }
  // ==========================================
  // CONSTRUIR INTERFAZ ADAPTATIVA
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        // ESPACIO DISPONIBLE
        final double anchoDisponible = constraints.maxWidth;
        final double altoDisponible = constraints.maxHeight;

        // ESCALA PROPORCIONAL
        escala = [
          anchoDisponible / anchoReferencia,
          altoDisponible / altoReferencia,
        ].reduce((a, b) => a < b ? a : b);

        // TAMAÑO REAL DEL PUZZLE
        final double anchoPuzzle = anchoReferencia * escala;
        final double altoPuzzle = altoReferencia * escala;

        return Column(
          children: [

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
                child: SizedBox(
                  width: anchoPuzzle,
                  height: altoPuzzle,

                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: anchoReferencia,
                      height: altoReferencia,

                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [

                          // MARCO
                          Positioned.fill(
                            child: Image.asset(
                              'img/marco.PNG',
                              fit: BoxFit.fill,
                            ),
                          ),

                          // BLOQUES
                          for (int i = 0;
                          i < imagenes.length;
                          i++)
                            crearBloque(i),

                          // COLISIONES
                          if (mostrarColisiones)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: CustomPaint(
                                  painter: HitboxPainter(
                                    posiciones: posiciones,
                                    tamanos: tamanos,
                                    hitboxes: hitboxes,
                                    hitboxMarco: hitboxMarco,
                                    piezaSeleccionada:
                                    piezaSeleccionada,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


// ==========================================
// PAINTER DE COLISIONES
// ==========================================

class HitboxPainter extends CustomPainter {

  final List<Offset> posiciones;
  final List<Size> tamanos;
  final List<List<Offset>> hitboxes;
  final List<Offset> hitboxMarco;
  final int? piezaSeleccionada;

  HitboxPainter({
    required this.posiciones,
    required this.tamanos,
    required this.hitboxes,
    required this.hitboxMarco,
    required this.piezaSeleccionada,
  });

  @override
  void paint(Canvas canvas, Size size) {

    // MARCO
    final pathMarco = Path();

    for (int i = 0; i < hitboxMarco.length; i++) {

      final punto = Offset(
        hitboxMarco[i].dx * _PuzzleState.anchoReferencia,
        hitboxMarco[i].dy * _PuzzleState.altoReferencia,
      );

      if (i == 0) {
        pathMarco.moveTo(punto.dx, punto.dy);
      } else {
        pathMarco.lineTo(punto.dx, punto.dy);
      }
    }

    pathMarco.close();

    canvas.drawPath(
      pathMarco,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // BLOQUES
    for (int i = 0; i < hitboxes.length; i++) {

      final puntos = hitboxes[i].map((punto) {
        return Offset(
          posiciones[i].dx +
              punto.dx * tamanos[i].width,
          posiciones[i].dy +
              punto.dy * tamanos[i].height,
        );
      }).toList();

      final path = Path();

      for (int j = 0; j < puntos.length; j++) {
        if (j == 0) {
          path.moveTo(puntos[j].dx, puntos[j].dy);
        } else {
          path.lineTo(puntos[j].dx, puntos[j].dy);
        }
      }

      path.close();

      canvas.drawPath(
        path,
        Paint()
          ..color = piezaSeleccionada == i
              ? Colors.yellow
              : Colors.greenAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(
      covariant HitboxPainter oldDelegate,
      ) {
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
