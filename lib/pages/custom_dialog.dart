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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return Scaffold(
      body: BlocListener<NotificacionCubit, NotificacionEstado>(
        listener: (context, estado) {
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
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height *
                  0.02), // Ajusta el padding según el tamaño de la pantalla
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width * 0.1),
              // Imagen desde assets alineada a la izquierda
              Container(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  'assets/png/campana.png',
                  width: width * 0.1,
                  height: width * 0.1,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: width * 0.05),
              Text(
                "Imagine missing a match because you didn't see it?",
                style: TextStyle(
                    fontSize: width * 0.079, fontWeight: FontWeight.w800),
              ),
              SizedBox(height: width * 0.02),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
                child: Text(
                  "Turn on your notifications so we can let you know when you have new messages or matches.",
                  style: TextStyle(
                      fontSize: width * 0.05, fontWeight: FontWeight.w600),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: height * 0.08,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      // En iOS, solicita permiso de notificaciones
                      await context
                          .read<NotificacionCubit>()
                          .solicitarPermisoNotificaciones();
                    } else if (Platform.isAndroid) {
                      // En Android, abre directamente la configuración para habilitar las notificaciones

                      await context
                          .read<NotificacionCubit>()
                          .abrirConfiguracionManual();
                    }
                    Navigator.pop(context, true); // Cierra el diálogo
                  },
                  icon: const Icon(Icons.message, size: 20),
                  label: Text(
                    "Allow notifications",
                    style: TextStyle(fontSize: width * 0.043),
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
                    child: Text(
                      "Not now",
                      style: TextStyle(
                          fontSize: width * 0.043, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.06),
            ],
          ),
        ),
      ),
    );
  }
}
