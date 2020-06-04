import 'dart:async';

import 'package:flutter/services.dart';

class ScanBle {
  static const MethodChannel _channel =
      const MethodChannel('scanBle');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
