import 'package:blue_plus_connect/bloc/adapter/blue_adapter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BluetoothOffTile extends StatelessWidget {
  const BluetoothOffTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.bluetooth_disabled,
        ),
        const SizedBox(height: 10,),
        const Text("Bluetooth désativé"),
        const SizedBox(height: 10,),
        ElevatedButton(
          child: const Text('Activé'),
          onPressed: () async {
            context.read<BlueAdapterBloc>().turnOn();
          },
        ),
      ],
    );
  }
}
