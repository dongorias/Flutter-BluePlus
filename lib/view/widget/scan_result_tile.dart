import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTile extends StatefulWidget {
  const ScanResultTile(
      {super.key, required this.result, this.onConnect, this.onDisconnect});

  final ScanResult result;
  final VoidCallback? onConnect;
  final VoidCallback? onDisconnect;

  @override
  State<ScanResultTile> createState() => _ScanResultTileState();
}

class _ScanResultTileState extends State<ScanResultTile> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    _connectionStateSubscription =
        widget.result.device.connectionState.listen((state) {
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
      title: Text(widget.result.device.platformName.isEmpty
          ? 'N/A'
          : widget.result.device.platformName),
      subtitle: Text(widget.result.device.remoteId.str),
      trailing: expansionTile(),
    );
  }

  Widget expansionTile() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: (widget.result.advertisementData.connectable)
          ? isConnected
              ? widget.onDisconnect
              : widget.onConnect
          : null,
      child: isConnected ? const Text('Déconnecter') : const Text('Connecter'),
    );
  }
}
