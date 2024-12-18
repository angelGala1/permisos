
import 'package:equatable/equatable.dart';

enum Estatus { inicial, exito, error }

class NotificacionEstado extends Equatable {
  final Estatus estatus;
  final String mensaje;

  NotificacionEstado({required this.estatus, required this.mensaje});

  @override
  List<Object> get props => [estatus, mensaje];

  // Método `copyWith` para crear copias con modificaciones
  NotificacionEstado copyWith({Estatus? estatus, String? mensaje}) {
    return NotificacionEstado(
      estatus: estatus ?? this.estatus,
      mensaje: mensaje ?? this.mensaje,
    );
  }
}