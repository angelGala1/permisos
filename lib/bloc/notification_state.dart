
import 'package:equatable/equatable.dart';

enum Status { initial, success, error }

class NotificationState extends Equatable {
  final Status status;
  final String message;

  NotificationState({required this.status, required this.message});

  @override
  List<Object> get props => [status, message];

  // `copyWith` method to create copies with modifications
  NotificationState copyWith({Status? status, String? message}) {
    return NotificationState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}