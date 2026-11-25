
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

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
@override
void continuar() {
final nombre=controlador.text.trim();

if(nombre.isNotEmpty){
  widget.onStart(nombre);
}

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