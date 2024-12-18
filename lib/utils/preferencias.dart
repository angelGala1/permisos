import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasServicio {
  static const String _claveDialogoMostrado = 'dialogoMostrado';

  // Método para verificar si el diálogo ya se mostró
  Future<bool> verificarSiDialogoYaSeMostro() async {
    final preferencias = await SharedPreferences.getInstance();
    return preferencias.getBool(_claveDialogoMostrado) ?? false;
  }

  // Método para marcar que el diálogo se mostró
  Future<void> marcarDialogoComoMostrado() async {
    final preferencias = await SharedPreferences.getInstance();
    await preferencias.setBool(_claveDialogoMostrado, true);
  }
}
