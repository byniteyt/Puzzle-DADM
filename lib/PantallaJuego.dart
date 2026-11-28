import 'package:flutter/material.dart';

class PuzzleData {
  static const double ancho = 800;
  static const double alto = 700;

  List<Size> crearTamanos() {
    return [
      const Size(365, 420),
      const Size(450, 240),
      const Size(350, 240),
      const Size(440, 365),
      const Size(420, 235),
      const Size(355, 240),
      const Size(380, 240),
      const Size(300, 240),
      const Size(120, 120),
    ];
  }

  List<Offset> crearPosiciones() {
    return [
      const Offset(425, 350),
      const Offset(385, 230),
      const Offset(430, 120),
      const Offset(-85, 320),
      const Offset(-20, 120),
      const Offset(-40, 10),
      const Offset(50, 430),
      const Offset(193, 230),
      const Offset(335, 550),
    ];
  }

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

  List<List<Offset>> crearHitboxes() {
    return [
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
      [
        Offset(0.14, 0.505),
        Offset(0.61, 0.505),
        Offset(0.61, 0.09),
        Offset(0.84, 0.09),
        Offset(0.84, 0.9),
        Offset(0.14, 0.9),
      ],
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
      [
        Offset(0.21, 0.10),
        Offset(0.78, 0.10),
        Offset(0.78, 0.5),
        Offset(0.5, 0.5),
        Offset(0.5, 0.9),
        Offset(0.21, 0.9),
      ],
      [
        Offset(0.24, 0.09),
        Offset(0.76, 0.09),
        Offset(0.76, 0.91),
        Offset(0.5, 0.91),
        Offset(0.5, 0.5),
        Offset(0.24, 0.5),
      ],
      [
        Offset(0.5, 0.09),
        Offset(0.84, 0.09),
        Offset(0.84, 0.9),
        Offset(0.15, 0.9),
        Offset(0.15, 0.5),
        Offset(0.5, 0.5),
      ],
      [
        Offset(0.13, 0.1),
        Offset(0.86, 0.1),
        Offset(0.86, 0.9),
        Offset(0.13, 0.9),
      ],
    ];
  }

  List<Offset> crearHitboxMarco() {
    return [
      Offset(0.04, 0.04),
      Offset(0.96, 0.04),
      Offset(0.96, 0.95),
      Offset(0.04, 0.95),
    ];
  }

  List<Offset> crearObjetivo() {
    return [
      Offset(0.49, 0),
      Offset(0.51, 0),
      Offset(0.51, 0.06),
      Offset(0.49, 0.06),
    ];
  }
}

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

  bool puntoDentroPoligono(
    Offset punto,
    List<Offset> poligono,
  ) {
    bool dentro = false;

    for (int i = 0, j = poligono.length - 1; i < poligono.length; j = i++) {
      final a = poligono[i];
      final b = poligono[j];

      final cruza = ((a.dy > punto.dy) != (b.dy > punto.dy)) &&
          (punto.dx <
              (b.dx - a.dx) * (punto.dy - a.dy) / (b.dy - a.dy) + a.dx);

      if (cruza) {
        dentro = !dentro;
      }
    }

    return dentro;
  }

  double orientacion(
    Offset a,
    Offset b,
    Offset c,
  ) {
    return (b.dx - a.dx) * (c.dy - a.dy) - (b.dy - a.dy) * (c.dx - a.dx);
  }

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

    return ((o1 > epsilon && o2 < -epsilon) ||
            (o1 < -epsilon && o2 > epsilon)) &&
        ((o3 > epsilon && o4 < -epsilon) || (o3 < -epsilon && o4 > epsilon));
  }

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

  bool movimientoValido(
    int indice,
    Offset posicion,
    List<Offset> posiciones,
  ) {
    return !fueraDelMarco(indice, posicion) &&
        !hayColision(indice, posicion, posiciones);
  }

  bool bombillaEnObjetivo(Offset posicion) {
    final bombilla = obtenerPuntos(8, posicion);
    final objetivo = obtenerPuntosObjetivo();

    return poligonosColisionan(bombilla, objetivo);
  }
}

class PuzzleMovement {
  final PuzzleCollision colisiones;
  PuzzleMovement(this.colisiones);

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
  final PuzzleData datos = PuzzleData();

  late final List<Size> tamanos;
  late final List<Offset> posiciones;
  late final List<String> imagenes;
  late final List<List<Offset>> hitboxes;
  late final List<Offset> hitboxMarco;
  late final List<Offset> objetivo;

  late final PuzzleCollision colisiones;
  late final PuzzleMovement movimiento;

  bool mostrarColisiones = true;
  int movimientos = 0; //contador movimientos
  bool movimientoContado = false; //bool para la cuenta
  int? piezaSeleccionada;
  final GlobalKey puzzleKey = GlobalKey();
  Offset desplazamientoAgarre = Offset.zero;

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
        movimientoContado = false; //reiniciar el booleano para poder volver a contar
      });
    }
  }

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

    Offset nueva = movimiento.moverEnEje(
      indice,
      actual,
      destino.dx,
      true,
      posiciones,
    );

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
        if (!movimientoContado) {
          movimientos++; //sumar al contador
          movimientoContado = true;// 'dirty flag' para evitar problemas de conteo
        }
      });

      comprobarVictoria(indice, nueva);
    }
  }

  void finalizarArrastre(int indice) {
    if (piezaSeleccionada == indice) {
      setState(() {
        piezaSeleccionada = null;
      });
    }
  }

  void comprobarVictoria(
    int indice,
    Offset nuevaPosicion,
  ) {
    if (indice == 8 && colisiones.bombillaEnObjetivo(nuevaPosicion)) {
      widget.onFinish?.call();
    }
  }

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

  Widget construirBotonColisiones() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          mostrarColisiones = !mostrarColisiones;
        });
      },
      icon: Icon(
        mostrarColisiones ? Icons.visibility : Icons.visibility_off,
      ),
      label: Text(
        mostrarColisiones ? 'Ocultar colisiones' : 'Mostrar colisiones',
      ),
    );
  }

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
              Positioned.fill(
                child: Image.asset(
                  'img/marco.PNG',
                  fit: BoxFit.fill,
                ),
              ),
              for (int i = 0; i < imagenes.length; i++) crearBloque(i),
              if (mostrarColisiones) construirColisiones(),
            ],
          ),
        ),
      ),
    );
  }
  //el contador de los movimientos en pantalla
  Widget construirContadorMovimientos() {
    return Text(
      'Movimientos: $movimientos',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double anchoDisponible = constraints.maxWidth;
        final double altoDisponible = constraints.maxHeight;

        final double escala = [
          anchoDisponible / PuzzleData.ancho,
          altoDisponible / PuzzleData.alto,
        ].reduce((a, b) => a < b ? a : b);

        final double anchoPuzzle = PuzzleData.ancho * escala;
        final double altoPuzzle = PuzzleData.alto * escala;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  construirContadorMovimientos(),
                  construirBotonColisiones(),
                ],
              ),
            ),
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

  void dibujarBloques(Canvas canvas) {
    for (int i = 0; i < hitboxes.length; i++) {
      final puntos = hitboxes[i].map((punto) {
        return Offset(
          posiciones[i].dx + punto.dx * tamanos[i].width,
          posiciones[i].dy + punto.dy * tamanos[i].height,
        );
      }).toList();

      final color =
          piezaSeleccionada == i ? Colors.yellow : Colors.greenAccent;

      dibujarPoligono(
        canvas,
        puntos,
        color,
        2,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    dibujarMarco(canvas);
    dibujarObjetivo(canvas);
    dibujarBloques(canvas);
  }

  @override
  bool shouldRepaint(covariant HitboxPainter oldDelegate) {
    return true;
  }
}