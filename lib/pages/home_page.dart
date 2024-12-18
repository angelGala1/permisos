import 'package:flutter/material.dart';
import 'package:permisos/utils/preferencias.dart';
import 'package:permisos/pages/custom_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PreferenciasServicio _preferenciasServicio = PreferenciasServicio();

  @override
  void initState() {
    super.initState();
    _verificarSiMostrarDialogo();
  }

  Future<void> _verificarSiMostrarDialogo() async {
    final bool yaMostrado =
        await _preferenciasServicio.verificarSiDialogoYaSeMostro();

    if (!yaMostrado) {
      final resultado = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomDialog()),
      );

      if (resultado == true) {
        await _preferenciasServicio.marcarDialogoComoMostrado();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Página Principal')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenido a la App'),
            const SizedBox(height: 20),
            Text('Este es el inicio'),
            ElevatedButton(
              onPressed: () {
                // Lógica para ir a otra página
                // Navigator.push(context, MaterialPageRoute(builder: (_) => const NextPage()));
              },
              child: const Text('Ir a la siguiente página'),
            ),
            
          ],
        ),
      ),
    );
  }
}
