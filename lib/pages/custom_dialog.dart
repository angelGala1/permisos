import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permisos/bloc/permiso_cubit.dart';
import 'package:permisos/bloc/permiso_state.dart';
import 'package:permisos/pages/home_page.dart';
import 'package:permisos/utils/preferencias.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<NotificacionCubit, NotificacionEstado>(
        listener: (context, estado) {
          // Revisamos el estatus del estado
          if (estado.estatus == Estatus.exito) {
            // Si el permiso fue concedido con éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(estado.mensaje)),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false, // Elimina todas las rutas anteriores
            );
          } else if (estado.estatus == Estatus.error) {
            // Si hubo un error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(estado.mensaje)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Imagen desde assets alineada a la izquierda
              Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/png/campana.png',
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Imagine missing a match because you didn't see it?",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(right: 30),
                child: Text(
                  "Turn on your notifications so we can let you know when you have new messages or matches.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      // En iOS, solicita permiso de notificaciones
                      await context
                          .read<NotificacionCubit>()
                          .solicitarPermisoNotificaciones();
                    } else if (Platform.isAndroid) {
                      // En Android, abre directamente la configuración para habilitar las notificaciones

                      // await context
                      //     .read<NotificacionCubit>()
                      //     .abrirConfiguracionManual();
                      await context
                          .read<NotificacionCubit>()
                          .solicitarPermisoNotificaciones();
                    }
                    Navigator.pop(context, true); // Cierra el diálogo
                  },
                  icon: const Icon(Icons.message, size: 20),
                  label: const Text(
                    "Allow notifications",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.delete),
                  TextButton(
                    onPressed: () async {
                      // Marcar el diálogo como mostrado para no mostrarlo nuevamente
                      final preferenciasServicio = PreferenciasServicio();
                      await preferenciasServicio.marcarDialogoComoMostrado();
                      // Redirigir al login y mostrar el mensaje
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                        (route) => false, // Elimina todas las rutas anteriores
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Usted no permitió los servicios.',
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Not now",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
