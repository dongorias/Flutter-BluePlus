import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'app.dart';

void main() {
  if(kDebugMode){
    // if your terminal doesn't support color you'll see annoying logs like `\x1B[1;35m`
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: true);
  }

  runApp(const App());
}
