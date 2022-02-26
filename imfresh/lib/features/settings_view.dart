import 'package:flutter/material.dart';
import 'package:imfresh/features/device_settings_card.dart';
import 'package:imfresh/models/settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool alarmOn = false;
  bool measuringOn = false;
  DateTime selectedDate = DateTime.now();
  int cleanlinessThreshold = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Material(
          child: SingleChildScrollView(
              child: DeviceSettingsCard(
            initalSettings: Settings(
                deviceId: "askdfjhdsklfhjkjasdhfjlk",
                deviceName: "Kitchen imfresh",
                alarmOn: true,
                alarmTime: DateTime.now(),
                realtimeMeasuringOn: true,
                periodicMeasuringOn: false,
                cleanlinessThreshold: 3),
          )),
        ),
      ),
    );
  }
}
