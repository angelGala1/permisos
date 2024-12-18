import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permisos/bloc/notification_cubit.dart';
import 'package:permisos/bloc/notification_state.dart';
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
      body: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state.status == Status.success) {
            // If permission was successfully granted
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false, // Remove all previous routes
            );
          } else if (state.status == Status.error) {
            // If there was an error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.02), // Adjust padding based on screen size
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width * 0.1),
              // Image from assets aligned to the left
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
                      await context
                          .read<NotificationCubit>()
                          .requestNotificationPermission();
                    } else if (Platform.isAndroid) {
                      await context
                          .read<NotificationCubit>()
                          .openAppSettingsManually();
                    }
                    Navigator.pop(context, true); // Close the dialog
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
                      final preferencesService = PreferencesService();
                      await preferencesService.markDialogAsShown();
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('You did not allow the services.'),
                        ),
                      );
                      
                      Navigator.pop(context, false); 
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