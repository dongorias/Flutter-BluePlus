import 'package:blue_plus_connect/bloc/device/device_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/adapter/blue_adapter_bloc.dart';
import 'bloc/flutter_blue_bloc.dart';
import 'view/flutter_blue_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterBluePlus',
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BlueAdapterBloc>(
            create: (BuildContext context) => BlueAdapterBloc(),
          ),
          BlocProvider<FlutterBlueBloc>(
            create: (BuildContext context) => FlutterBlueBloc(),
          ),
          BlocProvider<DeviceBloc>(
            create: (BuildContext context) => DeviceBloc(),
          ),
        ],
        child: const FlutterBluePage(),
      ),
    );
  }
}
