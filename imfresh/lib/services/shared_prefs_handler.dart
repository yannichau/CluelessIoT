import 'dart:convert';

import 'package:imfresh/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Settings>> getDeviceList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? list = prefs.getString('deviceList');

  if (list == null) {
    await prefs.setString('deviceList', jsonEncode([]));
    print("device list not found");
    return [];
  } else {
    return jsonDecode(list)
        .map<Settings>((json) => Settings.fromJson(json))
        .toList();
  }
}

void addNewDevice(Settings device) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? list = prefs.getString('deviceList');
  List<Settings> current = jsonDecode(list!)
      .map<Settings>((json) => Settings.fromJson(json))
      .toList();
  current.add(device);
  await prefs.setString('deviceList', jsonEncode(current));
}

void updateDeviceSettings(String deviceID, Settings newSettings) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? list = prefs.getString('deviceList');
  List<Settings> current = jsonDecode(list!)
      .map<Settings>((json) => Settings.fromJson(json))
      .toList();
  for (int i = 0; i < current.length; i++) {
    if (current[i].deviceId == deviceID) {
      current[i] = newSettings;
    }
  }
  await prefs.setString('deviceList', jsonEncode(current));
}
