import 'dart:async';

import 'package:flutter/services.dart';

class ScanBle {
  static const MethodChannel _methodChannel =
      const MethodChannel('roktok.immu.dev/bluetoothScanner');
  static const EventChannel _eventChannel =
      const EventChannel('roktok.immu.dev/bluetoothScannerResponse');

  Future<void> startScanning() async {
    await _methodChannel.invokeMethod('startScanning');
  }
  Future<void> stopScanning() async {
    await _methodChannel.invokeMethod('stopScanning');
  }

  Stream<dynamic> getDetected() {
    return _eventChannel.receiveBroadcastStream().cast<dynamic>();
  }
}
