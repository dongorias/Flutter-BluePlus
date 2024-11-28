import 'package:equatable/equatable.dart';

sealed class DeviceState extends Equatable {
  const DeviceState();

  @override
  List<Object> get props => [];
}

final class DeviceInitial extends DeviceState {
  const DeviceInitial();
}

final class DeviceConnecting extends DeviceState {
  const DeviceConnecting();
}

final class DeviceDisconnecting extends DeviceState {
  const DeviceDisconnecting();
}

final class DeviceConnected extends DeviceState {
  const DeviceConnected();
}

final class ErrorDevice extends DeviceState {
  final String message;

  const ErrorDevice({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => message;
}
