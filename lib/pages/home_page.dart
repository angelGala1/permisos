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
  final PreferencesService _preferencesService = PreferencesService();

  @override
  void initState() {
    super.initState();
    _checkIfDialogShouldBeShown();
  }

  Future<void> _checkIfDialogShouldBeShown() async {
    final bool alreadyShown =
        await _preferencesService.checkIfDialogAlreadyShown();

    if (!alreadyShown) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomDialog()),
      );

      if (result == true) {
        await _preferencesService.markDialogAsShown();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to the App'),
            const SizedBox(height: 20),
            Text('This is the home screen'),
            ElevatedButton(
              onPressed: () {
                // Logic to navigate to another page
                // Navigator.push(context, MaterialPageRoute(builder: (_) => const NextPage()));
              },
              child: const Text('Go to the next page'),
            ),
          ],
        ),
      ),
    );
  }
}
