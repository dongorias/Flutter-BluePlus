import 'package:blue_plus_connect/bloc/device/device_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../bloc/adapter/blue_adapter_bloc.dart';
import '../bloc/adapter/blue_adapter_event.dart';
import '../bloc/adapter/blue_adapter_state.dart';
import '../bloc/device/device_bloc.dart';
import '../bloc/device/device_event.dart';
import '../bloc/flutter_blue_bloc.dart';
import '../bloc/flutter_blue_event.dart';
import '../bloc/flutter_blue_state.dart';
import 'widget/bluetooth_off_title.dart';
import 'widget/scan_result_tile.dart';
import 'widget/show_error_title.dart';
import 'widget/system_device_tile.dart';

class FlutterBluePage extends StatefulWidget {
  const FlutterBluePage({super.key});

  @override
  State<FlutterBluePage> createState() => _FlutterBluePageState();
}

class _FlutterBluePageState extends State<FlutterBluePage> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _checkBluetoothStatus();
    super.initState();
  }

  void _checkBluetoothStatus() {
    context.read<BlueAdapterBloc>().add(const CheckingBlueLowStatus());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _checkBluetoothStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BlueAdapterBloc, BlueLowAdapterState>(
        builder: (context, state) {
          if (state is BlueLowAdapterStatus) {
            context.read<FlutterBlueBloc>().add(const StartScan());
            return _buildAdapterStatusView(state.status);
          } else if (state is BlueLowAdapterError) {
            return ShowErroTile(text: state.message);
          } else if (state is BlueLowNotSupported) {
            return const ShowErroTile(
                text: "Bluetooth Low Energy n'est pas pris en charge par cet appareil");
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Widget _buildAdapterStatusView(BluetoothAdapterState status) {
  switch (status) {
    case BluetoothAdapterState.on:
      return const BlueView();
    case BluetoothAdapterState.off:
      return const Center(child: BluetoothOffTile());
    case BluetoothAdapterState.unauthorized:
      return const ShowErroTile(
        text:
            "L'accès au Bluetooth Low Energy est non autorisé. Vérifiez les permissions dans les paramètres.",
      );
    case BluetoothAdapterState.unavailable:
      return const ShowErroTile(
        text: "Bluetooth Low Energy non disponible sur cet appareil.",
      );
    default:
      return const ShowErroTile(
        text:
            "Statut Bluetooth Bluetooth Low Energy inconnu. Veuillez réessayer.",
      );
  }
}

class BlueView extends StatelessWidget {
  const BlueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan BLE Connect'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bluetooth_audio_rounded),
        onPressed: () async => _startBluetoothScan(context),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _startBluetoothScan(context),
        child: BlocBuilder<FlutterBlueBloc, FlutterBlueState>(
          builder: (context, state) {
            if (state is FlutterBlueScanning) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FlutterBlueOnError) {
              return Text(state.message);
            } else if (state is FlutterBlueScanResult) {
              return _buildScanResultView(context, state);
            } else {
              return const ShowErroTile(
                text: "Oups, une erreur est survenue. Veuillez réessayer.",
              );
            }
          },
        ),
      ),
    );
  }

  void _startBluetoothScan(BuildContext context) {
    context.read<FlutterBlueBloc>().add(const StartScan());
  }
}

Widget _buildScanResultView(BuildContext context, FlutterBlueScanResult state) {
  void connectToDevice(BuildContext context, BluetoothDevice device) {
    context.read<DeviceBloc>().add(ConnectToDevice(device: device));
  }
  void disconnectToDevice(BuildContext context, BluetoothDevice device) {
    context.read<DeviceBloc>().add(DisconnectToDevice(device: device));
  }

  return BlocBuilder<DeviceBloc, DeviceState>(
    builder: (context, dstate) {
      return Stack(
        children: [
          ListView(
            children: [
              ...state.scanResult.map((r) => ScanResultTile(
                    result: r,
                    onConnect: () => connectToDevice(context, r.device),
                    onDisconnect: ()=>disconnectToDevice(context, r.device),
                  )),
              ...state.systemDevices.map((d) => SystemDeviceTile(
                    device: d,
                    onConnect: () => connectToDevice(context, d),
                    onDisconnect: () => disconnectToDevice(context, d),
                  )),
            ],
          ),
          if (dstate is DeviceConnecting)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      );
    },
  );
}
