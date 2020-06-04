import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class ScanBle {

  factory ScanBle() {
    if (_instance == null) {
      final MethodChannel methodChannel = const MethodChannel(
          'roktok.immu.dev/bluetoothScanner');

      final EventChannel eventChannel = const EventChannel(
          'roktok.immu.dev/bluetoothScannerResponse');
      _instance = ScanBle.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  @visibleForTesting
  ScanBle.private(this._methodChannel, this._eventChannel);

  static ScanBle _instance;
  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  Future<void> startScanning({@required List<String> uuids}) async {
    await _methodChannel.invokeMethod('startScanning', uuids);
  }
  Future<void> stopScanning() async {
    await _methodChannel.invokeMethod('stopScanning');
  }

  Stream<dynamic> getDetected() {
    return _eventChannel.receiveBroadcastStream().cast<dynamic>();
  }
}
