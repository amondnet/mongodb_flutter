import 'dart:async';

import 'package:flutter/services.dart';

class MongodbMobile {
  static const MethodChannel _channel =
      const MethodChannel('amond.dev/mongodb_mobile');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> setAppId(dynamic config) async {
    final res = await _channel.invokeMethod('setAppId', config);
  }
}
