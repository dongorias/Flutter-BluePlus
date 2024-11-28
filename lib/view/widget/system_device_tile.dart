import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SystemDeviceTile extends StatefulWidget {
  const SystemDeviceTile({
    super.key,
    required this.device,
    required this.onConnect,
    required this.onDisconnect,
  });

  final BluetoothDevice device;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  State<SystemDeviceTile> createState() => _SystemDeviceTileState();
}

class _SystemDeviceTileState extends State<SystemDeviceTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    _connectionStateSubscription =
        widget.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.device.platformName),
      subtitle: Text(widget.device.remoteId.str),
      trailing: ElevatedButton(
        onPressed: isConnected ? widget.onDisconnect : widget.onConnect,
        child:
            isConnected ? const Text('Déconnecter') : const Text('Connecter'),
      ),
    );
  }
}
