import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class DeviceEvent {
  const DeviceEvent();
}

final class ConnectToDevice extends DeviceEvent {
  final BluetoothDevice device;
  const ConnectToDevice({required this.device});
}

final class DisconnectToDevice extends DeviceEvent {
  final BluetoothDevice device;
  const DisconnectToDevice({required this.device});
}
