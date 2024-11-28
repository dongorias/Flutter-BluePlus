import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'blue_adapter_event.dart';
import 'blue_adapter_state.dart';

class BlueAdapterBloc extends Bloc<BlueLowAdapterEvent, BlueLowAdapterState> {
  BlueAdapterBloc() : super(const BlueLowAdapterInitial()) {
    on<CheckingBlueLowStatus>(_onStartListening);
  }

  Future<void> _onStartListening(event, emit) async {
    if (await FlutterBluePlus.isSupported == false) {
      emit(const BlueLowNotSupported());
      return;
    }
    await emit.forEach(
      FlutterBluePlus.adapterState,
      onData: (status) => BlueLowAdapterStatus(status: status),
      onError: (error, stackTrace) {
        return BlueLowAdapterError(message: error);
      },
    );
  }

  Future<void> turnOn() async {
    try {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      log("$e");
    }
  }
}
