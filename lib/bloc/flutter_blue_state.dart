import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class FlutterBlueState extends Equatable {
  const FlutterBlueState();

  @override
  List<Object> get props => [];
}

final class FlutterBlueInitial extends FlutterBlueState {
  const FlutterBlueInitial();

  @override
  String toString() => 'BlueInitial';
}

final class FlutterBlueScanning extends FlutterBlueState {
  const FlutterBlueScanning();

  @override
  String toString() => 'BlueScanInProgress....';
}

final class FlutterBlueScanResult extends FlutterBlueState {
  const FlutterBlueScanResult(
      {this.scanResult = const [], this.systemDevices = const []});

  final List<ScanResult> scanResult;
  final List<BluetoothDevice> systemDevices;

  @override
  List<Object> get props => [scanResult, systemDevices];

  @override
  String toString() => 'BlueScanResult ${scanResult.length}';
}

final class FlutterBlueOnError extends FlutterBlueState {
  final String message;

  const FlutterBlueOnError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'BlueOnError $message';
}
