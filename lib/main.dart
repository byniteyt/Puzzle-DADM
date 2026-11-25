import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

import 'PantallaFinal.dart';
import 'PantallaMainMenu.dart';
import 'PantallaMeterUsuario.dart';
import 'PantallaRanking.dart';

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

  String usuario = '';

 // int score=0;
  //GUARDAR LA PUNTUACIÓN
List<String> ranking=[];
  //CAMBIAR DE PANTALLA
  void cambiarPantalla(int index){
    setState((){
      selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      //MENU PRINCIPAL
      case 0:
        page = MainMenu(
          //función boton on play
          onPlay: () => cambiarPantalla(1),
          //funcón boton ranking
          onRanking: () => cambiarPantalla(4),
        );
        break;

      case 1:
        page = MeterUsuario(
          onStart:(nombre){
            setState(() {
                          usuario=nombre;
                          selectedIndex=2;
                        });
          },
        );
        break;
      case 2:
        page = Puzzle(
          onFinish:(){
            setState(() {
                          ranking.add(usuario);
                          selectedIndex=3;
                        });
          },
        );
      case 3:
        page = FinalPage(
          usuario:usuario,
          onRanking:()=>cambiarPantalla(4),
          onMenu:()=>cambiarPantalla(0),
        );
      case 4:
        page=Pantallaranking(
          ranking:ranking,
          onMenu:()=>cambiarPantalla(0),
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
/*
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
*/
/*
class MeterUsuario extends StatefulWidget {

  final Function(String) onStart;

  const MeterUsuario({
    super.key,
    required this.onStart,
  });

  @override
  State<MeterUsuario> createState() => _MeterUsuarioState();
}

class _MeterUsuarioState extends State<MeterUsuario> {

  final TextEditingController controlador = TextEditingController();

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        const Text(
          'INTRODUCE TU NOMBRE',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        SizedBox(
          width: 250,
          child: TextField(
            controller: controlador,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nombre de usuario',
            ),
          ),
        ),

        const SizedBox(height: 25),

        ElevatedButton(
          onPressed: () {

            String nombre = controlador.text.trim();

            if (nombre.isNotEmpty) {
              widget.onStart(nombre);
            }
          },
          child: const Text('CONTINUAR'),
        ),
      ],
    );
  }
}
*/

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class PuzzleData {
  // DIMENSIONES DE TABLERO
  static const double ancho = 800;
  static const double alto = 700;

  // TAMAÑO DE BLOQUES
  List<Size> crearTamanos() {
    return [
      const Size(365, 420), // ROJO
      const Size(450, 240), // NARANJA
      const Size(350, 240), // CIAN
      const Size(440, 365), // VERDE
      const Size(420, 235), // AMARILLO
      const Size(355, 240), // ROSA
      const Size(380, 240), // MORADO
      const Size(300, 240), // AZUL
      const Size(120, 120), // BOMBILLA
    ];
  }

  // POSICIÓN INICIAL DE BLOQUES
  List<Offset> crearPosiciones() {
    return [
      const Offset(425, 350), // ROJO
      const Offset(385, 230), // NARANJA
      const Offset(430, 120), // CIAN
      const Offset(-85, 320), // VERDE
      const Offset(-20, 120), // AMARILLO
      const Offset(-40, 10), // ROSA
      const Offset(50, 430), // MORADO
      const Offset(193, 230), // AZUL
      const Offset(335, 550), // BOMBILLA
    ];
  }

  // IMÁGENES
  List<String> crearImagenes() {
    return [
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
  }

  // HITBOX DE BLOQUES
  List<List<Offset>> crearHitboxes() {
    return [
      // ROJO
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
      // NARANJA
      [
        Offset(0.14, 0.505),
        Offset(0.61, 0.505),
        Offset(0.61, 0.09),
        Offset(0.84, 0.09),
        Offset(0.84, 0.9),
        Offset(0.14, 0.9),
      ],
      // CIAN
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
      // VERDE
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
      // AMARILLO
      [
        Offset(0.13, 0.5),
        Offset(0.38, 0.5),
        Offset(0.38, 0.08),
        Offset(0.85, 0.08),
        Offset(0.85, 0.48),
        Offset(0.62, 0.48),
        Offset(0.62, 0.91),
        Offset(0.13, 0.91),
      ],
      // ROSA
      [
        Offset(0.21, 0.10),
        Offset(0.78, 0.10),
        Offset(0.78, 0.5),
        Offset(0.5, 0.5),
        Offset(0.5, 0.9),
        Offset(0.21, 0.9),
      ],
      // MORADO
      [
        Offset(0.24, 0.09),
        Offset(0.76, 0.09),
        Offset(0.76, 0.91),
        Offset(0.5, 0.91),
        Offset(0.5, 0.5),
        Offset(0.24, 0.5),
      ],
      // AZUL
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
  }

  // HITBOX DE MARCO
  List<Offset> crearHitboxMarco() {
    return [
      Offset(0.04, 0.04),
      Offset(0.96, 0.04),
      Offset(0.96, 0.95),
      Offset(0.04, 0.95),
    ];
  }

  // ZONA OBJETIVO
  List<Offset> crearObjetivo() {
    return [
      Offset(0.49, 0),
      Offset(0.51, 0),
      Offset(0.51, 0.06),
      Offset(0.49, 0.06),
    ];
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class PuzzleCollision {

  final List<Size> tamanos;
  final List<List<Offset>> hitboxes;
  final List<Offset> hitboxMarco;
  final List<Offset> objetivo;

  PuzzleCollision({
    required this.tamanos,
    required this.hitboxes,
    required this.hitboxMarco,
    required this.objetivo,
  });


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
        punto.dx * PuzzleData.ancho,
        punto.dy * PuzzleData.alto,
      );
    }).toList();
  }


  List<Offset> obtenerPuntosObjetivo() {
    return objetivo.map((punto) {
      return Offset(
        punto.dx * PuzzleData.ancho,
        punto.dy * PuzzleData.alto,
      );
    }).toList();
  }

  // COMPROBAR SI UN PUNTO ESTÁ DENTRO
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

            if (cruza) {
              dentro = !dentro;
            }
          }

          return dentro;
        }

  // CALCULAR ORIENTACIÓN
  double orientacion(
      Offset a,
      Offset b,
      Offset c,
      ) {
    return (b.dx - a.dx) * (c.dy - a.dy) -
        (b.dy - a.dy) * (c.dx - a.dx);
  }

  // COMPROBAR SI DOS SEGMENTOS SE CRUZAN
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

  // COMPROBAR COLISIÓN ENTRE POLÍGONOS
  bool poligonosColisionan(
      List<Offset> a,
      List<Offset> b,
      ) {

          // Comprobar si se cruzan los lados.
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

          // Comprobar si A está dentro de B.
          for (final punto in a) {
            if (puntoDentroPoligono(punto, b)) {
              return true;
            }
          }

          // Comprobar si B está dentro de A.
          for (final punto in b) {
            if (puntoDentroPoligono(punto, a)) {
              return true;
            }
          }

          return false;
        }

  // COMPROBAR SI UN BLOQUE SALE DEL MARCO
  bool fueraDelMarco(
      int indice,
      Offset nuevaPosicion,
      ) {
          final puntos = obtenerPuntos(indice, nuevaPosicion);
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

  // COMPROBAR COLISIÓN CON OTROS BLOQUES
  bool hayColision(
      int indice,
      Offset nuevaPosicion,
      List<Offset> posiciones,
      ) {
    final nuevosPuntos = obtenerPuntos(indice, nuevaPosicion);

    for (int i = 0; i < posiciones.length; i++) {

      if (i == indice) continue;

      final otrosPuntos = obtenerPuntos(i, posiciones[i]);

      if (poligonosColisionan(nuevosPuntos, otrosPuntos)) {
        return true;
      }
    }

    return false;
  }

  // COMPROBAR SI EL MOVIMIENTO ES VÁLIDO
  bool movimientoValido(
      int indice,
      Offset posicion,
      List<Offset> posiciones,
      ) {
    return !fueraDelMarco(indice, posicion) &&
        !hayColision(indice, posicion, posiciones);
  }

  // COMPROBAR SI LA BOMBILLA ESTÁ EN EL OBJETIVO
  bool bombillaEnObjetivo(Offset posicion) {
    final bombilla = obtenerPuntos(8, posicion);
    final objetivo = obtenerPuntosObjetivo();

    return poligonosColisionan(bombilla, objetivo);
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class PuzzleMovement {
  final PuzzleCollision colisiones;
  PuzzleMovement(this.colisiones);

  // MOVER UN BLOQUE EN UN EJE
  Offset moverEnEje(
      int indice,
      Offset actual,
      double destino,
      bool horizontal,
      List<Offset> posiciones,
      ) {
            double inicio = horizontal ? actual.dx : actual.dy;
            double diferencia = destino - inicio;
            int pasos = (diferencia.abs() / 2).ceil();

            if (pasos == 0) return actual;

            Offset nueva = actual;

            for (int i = 1; i <= pasos; i++) {
              double valor = inicio + diferencia * i / pasos;
              Offset candidata;

              if (horizontal) {
                candidata = Offset(valor, nueva.dy);
              } else {
                candidata = Offset(nueva.dx, valor);
              }

              if (colisiones.movimientoValido(
                indice,
                candidata,
                posiciones,
              )) {
                nueva = candidata;
              } else {
                break;
              }
            }

            return nueva;
          }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class Puzzle extends StatefulWidget {

  final VoidCallback? onFinish;

  const Puzzle({
    super.key,
    this.onFinish,
  });

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {

  // OBJETOS DEL JUEGO
  final PuzzleData datos = PuzzleData();

  late final List<Size> tamanos;
  late final List<Offset> posiciones;
  late final List<String> imagenes;
  late final List<List<Offset>> hitboxes;
  late final List<Offset> hitboxMarco;
  late final List<Offset> objetivo;

  late final PuzzleCollision colisiones;
  late final PuzzleMovement movimiento;

  // VARIABLES DE CONTROL

  bool mostrarColisiones = true;

  int? piezaSeleccionada;

  final GlobalKey puzzleKey = GlobalKey();

  Offset desplazamientoAgarre = Offset.zero;

  // INICIALIZACIÓN
  @override
  void initState() {
    super.initState();

    tamanos = datos.crearTamanos();
    posiciones = datos.crearPosiciones();
    imagenes = datos.crearImagenes();
    hitboxes = datos.crearHitboxes();
    hitboxMarco = datos.crearHitboxMarco();
    objetivo = datos.crearObjetivo();

    colisiones = PuzzleCollision(
      tamanos: tamanos,
      hitboxes: hitboxes,
      hitboxMarco: hitboxMarco,
      objetivo: objetivo,
    );
    movimiento = PuzzleMovement(colisiones);
  }

  // INICIAR ARRASTRE
  void iniciarArrastre(
      int indice,
      DragStartDetails details,
      ) {
          final RenderBox caja =
          puzzleKey.currentContext!.findRenderObject() as RenderBox;

          final punto = caja.globalToLocal(details.globalPosition);

          final puntos = colisiones.obtenerPuntos(
            indice,
            posiciones[indice],
          );

          if (colisiones.puntoDentroPoligono(punto, puntos)) {
            setState(() {
              piezaSeleccionada = indice;
              desplazamientoAgarre = punto - posiciones[indice];
            });
          }
        }

  // ACTUALIZAR ARRASTRE
  void actualizarArrastre(
      int indice,
      DragUpdateDetails details,
      ) {
            if (piezaSeleccionada != indice) return;

            final RenderBox caja =
            puzzleKey.currentContext!.findRenderObject() as RenderBox;

            final puntero = caja.globalToLocal(details.globalPosition);

            final destino = puntero - desplazamientoAgarre;

            final actual = posiciones[indice];

            // Primero intenta mover horizontalmente.

            Offset nueva = movimiento.moverEnEje(
              indice,
              actual,
              destino.dx,
              true,
              posiciones,
            );

            // Después intenta mover verticalmente.

            nueva = movimiento.moverEnEje(
              indice,
              nueva,
              destino.dy,
              false,
              posiciones,
            );

            if (nueva != actual) {
              setState(() {
                posiciones[indice] = nueva;
              });

              comprobarVictoria(indice, nueva);
            }
          }

  // FINALIZAR ARRASTRE
  void finalizarArrastre(int indice) {
    if (piezaSeleccionada == indice) {
      setState(() {
        piezaSeleccionada = null;
      });
    }
  }

  // COMPROBAR VICTORIA
  void comprobarVictoria(
      int indice,
      Offset nuevaPosicion,
      ) {
    if (indice == 8 &&
        colisiones.bombillaEnObjetivo(nuevaPosicion)) {
      widget.onFinish?.call();
    }
  }

  // CREAR UN BLOQUE
  Widget crearBloque(int indice) {
    return Positioned(
      left: posiciones[indice].dx,
      top: posiciones[indice].dy,
      width: tamanos[indice].width,
      height: tamanos[indice].height,

      child: GestureDetector(
        behavior: HitTestBehavior.translucent,

        onPanStart: (details) {
          iniciarArrastre(indice, details);
        },

        onPanUpdate: (details) {
          actualizarArrastre(indice, details);
        },

        onPanEnd: (_) {
          finalizarArrastre(indice);
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

  // BOTÓN DE COLISIONES
  Widget construirBotonColisiones() {
    return ElevatedButton.icon(
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
    );
  }

  // DIBUJAR LAS COLISIONES
  Widget construirColisiones() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(
          painter: HitboxPainter(
            posiciones: posiciones,
            tamanos: tamanos,
            hitboxes: hitboxes,
            hitboxMarco: hitboxMarco,
            zonaObjetivo: objetivo,
            piezaSeleccionada: piezaSeleccionada,
          ),
        ),
      ),
    );
  }

  // CONSTRUIR EL TABLERO
  Widget construirTablero(
      double anchoPuzzle,
      double altoPuzzle,
      ) {
            return SizedBox(
              width: anchoPuzzle,
              height: altoPuzzle,

              child: FittedBox(
                fit: BoxFit.fill,

                child: SizedBox(
                  width: PuzzleData.ancho,
                  height: PuzzleData.alto,

                  child: Stack(
                    key: puzzleKey,
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

                      for (int i = 0; i < imagenes.length; i++)
                        crearBloque(i),

                      // HITBOXES

                      if (mostrarColisiones)
                        construirColisiones(),
                    ],
                  ),
                ),
              ),
            );
          }

  // BUILD PRINCIPAL
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {

        final double anchoDisponible = constraints.maxWidth;
        final double altoDisponible = constraints.maxHeight;

        // Calcula la escala del tablero.

        final double escala = [
          anchoDisponible / PuzzleData.ancho,
          altoDisponible / PuzzleData.alto,
        ].reduce((a, b) => a < b ? a : b);

        final double anchoPuzzle =
            PuzzleData.ancho * escala;

        final double altoPuzzle =
            PuzzleData.alto * escala;

        return Column(
          children: [

            construirBotonColisiones(),

            Expanded(
              child: Center(
                child: construirTablero(
                  anchoPuzzle,
                  altoPuzzle,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// ESTO JUNTO CON EL BOTON DE LINEAS DE COLISIÓN TOCA BORRARLO CUANDO TERMINEMOS
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

class HitboxPainter extends CustomPainter {

  final List<Offset> posiciones;
  final List<Size> tamanos;
  final List<List<Offset>> hitboxes;
  final List<Offset> hitboxMarco;
  final List<Offset> zonaObjetivo;
  final int? piezaSeleccionada;


  HitboxPainter({
    required this.posiciones,
    required this.tamanos,
    required this.hitboxes,
    required this.hitboxMarco,
    required this.zonaObjetivo,
    required this.piezaSeleccionada,
  });

  // DIBUJAR UN POLÍGONO
  void dibujarPoligono(
      Canvas canvas,
      List<Offset> puntos,
      Color color,
      double grosor,
      ) {
          final path = Path();

          for (int i = 0; i < puntos.length; i++) {
            if (i == 0) {
              path.moveTo(puntos[i].dx, puntos[i].dy);
            } else {
              path.lineTo(puntos[i].dx, puntos[i].dy);
            }
          }

          path.close();

          canvas.drawPath(
            path,
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = grosor,
          );
        }

  // DIBUJAR EL MARCO
  void dibujarMarco(Canvas canvas) {
    final puntos = hitboxMarco.map((punto) {
      return Offset(
        punto.dx * PuzzleData.ancho,
        punto.dy * PuzzleData.alto,
      );
    }).toList();

    dibujarPoligono(
      canvas,
      puntos,
      Colors.red,
      3,
    );
  }

  // DIBUJAR EL OBJETIVO
  void dibujarObjetivo(Canvas canvas) {
    final puntos = zonaObjetivo.map((punto) {
      return Offset(
        punto.dx * PuzzleData.ancho,
        punto.dy * PuzzleData.alto,
      );
    }).toList();

    dibujarPoligono(
      canvas,
      puntos,
      Colors.orange,
      3,
    );
  }

  // DIBUJAR LOS BLOQUES
  void dibujarBloques(Canvas canvas) {
    for (int i = 0; i < hitboxes.length; i++) {

      final puntos = hitboxes[i].map((punto) {
        return Offset(
          posiciones[i].dx + punto.dx * tamanos[i].width,
          posiciones[i].dy + punto.dy * tamanos[i].height,
        );
      }).toList();

      final color = piezaSeleccionada == i
          ? Colors.yellow
          : Colors.greenAccent;

      dibujarPoligono(
        canvas,
        puntos,
        color,
        2,
      );
    }
  }

  // MÉTODO PRINCIPAL DE DIBUJO
  @override
  void paint(Canvas canvas, Size size) {
    dibujarMarco(canvas);
    dibujarObjetivo(canvas);
    dibujarBloques(canvas);
  }

  // ACTUALIZAR EL DIBUJO
  @override
  bool shouldRepaint(covariant HitboxPainter oldDelegate) {
    return true;
  }
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
/*
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

*/
/*
class FinalPage extends StatelessWidget {

  final String usuario;
  final VoidCallback onRanking;
  final VoidCallback onMenu;

  const FinalPage({
    super.key,
    required this.usuario,
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
*/
/*
class RankingPage extends StatelessWidget {

  final List<String> ranking;
  final VoidCallback onMenu;

  const RankingPage({
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
}*/