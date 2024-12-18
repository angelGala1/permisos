import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permisos/bloc/permiso_state.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificacionCubit extends Cubit<NotificacionEstado> {
  NotificacionCubit() : super(NotificacionEstado(estatus: Estatus.inicial, mensaje: 'Estado Inicial'));

  // Solicita el permiso de notificaciones
  Future<void> solicitarPermisoNotificaciones() async {
    final estadoPermiso = await Permission.notification.request();

    if (estadoPermiso.isGranted) {
      emit(NotificacionEstado(estatus: Estatus.exito, mensaje: "Permiso concedido"));
    } else {
      emit(NotificacionEstado(estatus: Estatus.error, mensaje: "Permiso denegado"));
    }
  }

  // Abre la configuración manualmente
  Future<void> abrirConfiguracionManual() async {
    await openAppSettings();
  }
}