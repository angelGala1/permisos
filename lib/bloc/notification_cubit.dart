import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permisos/bloc/notification_state.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit()
      : super(NotificationState(
            status: Status.initial, message: 'Initial State'));

  // Request notification permission
  Future<void> requestNotificationPermission() async {
    try {
      final permissionStatus = await Permission.notification.request();

      if (permissionStatus.isGranted) {
        emit(state.copyWith(
            status: Status.success, message: 'Permission granted'));
      } else {
        emit(state.copyWith(
            status: Status.success, message: 'Permission denied'));
      }
    } catch (e) {
      emit(state.copyWith(
          status: Status.error, message: 'Error granting permission'));
    }
  }

  // Open the settings manually
  Future<void> openAppSettingsManually() async {
    try {
      await openAppSettings();
    } catch (e) {
      emit(state.copyWith(
          status: Status.error, message: 'Error opening settings'));
    }
  }
}