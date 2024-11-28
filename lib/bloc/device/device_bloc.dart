import 'package:flutter_bloc/flutter_bloc.dart';

import 'device_event.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  DeviceBloc() : super(const DeviceInitial()) {
    on<ConnectToDevice>((event, emit) => _onConnectToDevice(event, emit));
    on<DisconnectToDevice>((event, emit) => _onDisconnectToDevice(event, emit));
  }
  Future<void> _onConnectToDevice(ConnectToDevice event, Emitter<DeviceState> emit) async {
    emit(const DeviceConnecting());
    try {
      await event.device.connect();
      emit(const DeviceConnected());
    } catch (e) {
      emit(ErrorDevice(message: "$e"));
    }
  }

  Future<void> _onDisconnectToDevice(DisconnectToDevice event, Emitter<DeviceState> emit) async {
    emit(const DeviceConnecting());
    try {
      await event.device.disconnect();
      emit(const DeviceConnected());
    } catch (e) {
      emit(ErrorDevice(message: "$e"));
    }
  }
}