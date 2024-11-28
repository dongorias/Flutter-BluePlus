import 'package:equatable/equatable.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

sealed class BlueLowAdapterState extends Equatable {
  const BlueLowAdapterState();

  @override
  List<Object> get props => [];
}

final class BlueLowAdapterStatus extends BlueLowAdapterState {
  const BlueLowAdapterStatus({this.status = BluetoothAdapterState.unknown});

  final BluetoothAdapterState status;

  BlueLowAdapterStatus copyWith({BluetoothAdapterState? status}) {
    return BlueLowAdapterStatus(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}

final class BlueLowAdapterInitial extends BlueLowAdapterState {
  const BlueLowAdapterInitial();

  @override
  String toString() => 'BlueLowAdapterInitial ...';
}

final class BlueLowAdapterError extends BlueLowAdapterState {
  final String message;

  const BlueLowAdapterError({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'BlueLowAdapterError $message';
}

final class BlueLowNotSupported extends BlueLowAdapterState {
  const BlueLowNotSupported();

  @override
  String toString() => 'BlueLowNotSupported ...';
}
