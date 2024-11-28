import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'flutter_blue_event.dart';
import 'flutter_blue_state.dart';

class FlutterBlueBloc extends Bloc<FlutterBlueEvent, FlutterBlueState> {

  FlutterBlueBloc() : super(const FlutterBlueInitial()) {
    on<StartScan>((event, emit) => _onStarted(event, emit));
  }



  Future<void> _onStarted(
      StartScan event, Emitter<FlutterBlueState> emit) async {
    emit(const FlutterBlueScanning());
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      var systemDevices = await FlutterBluePlus.systemDevices(withServices);
      emit(FlutterBlueScanResult(systemDevices: systemDevices));
    } catch (e) {
      emit(FlutterBlueOnError(message: "$e"));
    }

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      await emit.forEach<List<ScanResult>>(
        FlutterBluePlus.scanResults,
        onData: (scanResults) => FlutterBlueScanResult(scanResult: scanResults),
        onError: (error, stackTrace) {
          FlutterBluePlus.stopScan();
          return FlutterBlueOnError(message: error.toString());
        },
      );
    } catch (e) {
      emit(FlutterBlueOnError(message: "$e"));
    }
  }
}
