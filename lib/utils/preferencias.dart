import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _keyDialogShown = 'dialogShown';

  // Method to check if the dialog has already been shown
  Future<bool> checkIfDialogAlreadyShown() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_keyDialogShown) ?? false;
  }

  // Method to mark the dialog as shown
  Future<void> markDialogAsShown() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_keyDialogShown, true);
  }
}
