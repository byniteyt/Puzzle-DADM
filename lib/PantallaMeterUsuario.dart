
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'db/database_helper.dart';

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

  //Solo se puede jugar si se ha metido un nombre de usuario

void continuar() async {
  final nombre = controlador.text.trim();

  if (nombre.isEmpty) return;

  await GetUserByName(nombre);

  debugPrint('Entrando a sala...');
  widget.onStart(nombre);
}

  Future<void> GetUserByName(String nombre) async {
    final user = await DatabaseHelper.instance.getUser(nombre);
    debugPrint('Busqueda de user acabada');
    if (user == null) {
      debugPrint('Creando user');
      await DatabaseHelper.instance.insertUser(nombre);
      debugPrint('User creado');
    }

    print('User asegurado');
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
            ),
          ),
        ),

        const SizedBox(height: 25),

        ElevatedButton(
          onPressed: continuar,
          child: const Text('CONTINUAR'),
        ),
      ],
    );
  }
}