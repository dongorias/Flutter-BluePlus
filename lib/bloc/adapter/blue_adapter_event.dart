import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class BlueLowAdapterEvent extends Equatable {
  const BlueLowAdapterEvent();

  @override
  List<Object?> get props => [];
}

final class CheckingBlueLowStatus extends BlueLowAdapterEvent {
  final BluetoothAdapterState status;

  const CheckingBlueLowStatus({this.status = BluetoothAdapterState.unknown});
}
