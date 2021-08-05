import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';

class DeviceInfo {
  Map<String, dynamic>? deviceData;

  Future<void> userDevice() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          "brand": androidInfo.brand,
          "board": androidInfo.board,
          "versionCodeName": androidInfo.version.codename,
          "manufacturer": androidInfo.manufacturer,
          "androidID": androidInfo.id,
        };

      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        print(iosInfo.utsname.machine);
      }
    } on PlatformException {
      print("Could not get device info");
    }
  }
}
