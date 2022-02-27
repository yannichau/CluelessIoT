import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imfresh/models/settings.dart';
import 'package:imfresh/services/mqttHander.dart';
import 'package:imfresh/services/shared_prefs_handler.dart';
import 'package:mqtt_client/mqtt_client.dart';

class DeviceSettingsCard extends StatefulWidget {
  final Settings initalSettings;

  const DeviceSettingsCard({Key? key, required this.initalSettings})
      : super(key: key);

  @override
  _DeviceSettingsCardState createState() => _DeviceSettingsCardState();
}

class _DeviceSettingsCardState extends State<DeviceSettingsCard> {
  late Settings _settings;
  final TextEditingController _textFieldController = TextEditingController();
  String valueText = "";

  @override
  void initState() {
    _settings = widget.initalSettings;
    valueText = _settings.deviceName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            alignment: Alignment.center,
            child: Text(
              '${_settings.deviceName} Settings',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          ListTile(
            title: const Text('Device Location'),
            subtitle: Text('Current Location: ${_settings.deviceLocation}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Device Location (closest city)'),
                      content: TextField(
                        onChanged: (value) {
                          setState(() {
                            valueText = value;
                          });
                        },
                        controller: _textFieldController
                          ..text = _settings.deviceLocation,
                        decoration: const InputDecoration(
                            hintText: 'Enter closest city to device'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('CANCEL'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            setState(() {
                              _settings =
                                  _settings.copyWith(deviceLocation: valueText);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SwitchListTile(
            title: const Text('Alarm Setting'),
            subtitle:
                const Text('Enable or Disable the alarm located on device'),
            value: _settings.alarmOn,
            onChanged: (status) =>
                setState(() => _settings = _settings.copyWith(alarmOn: status)),
          ),
          if (_settings.alarmOn)
            ListTile(
              title: const Text('Alarm Time'),
              subtitle: const Text('Tap to change preferred alarm time(24h)'),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Text(_settings.alarmTime!.hour.toString() +
                    ':' +
                    _settings.alarmTime!.minute.toString()),
              ),
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext builder) {
                      return Container(
                        height: MediaQuery.of(context).copyWith().size.height *
                            0.33,
                        color: Colors.white,
                        child: CupertinoDatePicker(
                          use24hFormat: true,
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (value) {
                            if (value != _settings.alarmTime) {
                              setState(() {
                                _settings =
                                    _settings.copyWith(alarmTime: value);
                              });
                            }
                          },
                          initialDateTime: DateTime.now(),
                          minimumYear: 2019,
                          maximumYear: 2050,
                        ),
                      );
                    });
              },
            ),
          SwitchListTile(
            title: const Text('Realtime Measurement Setting'),
            subtitle: const Text(
                'Enables or disables realtime measurement when app is open'),
            value: _settings.realtimeMeasuringOn,
            onChanged: (status) => setState(() =>
                _settings = _settings.copyWith(realtimeMeasuringOn: status)),
          ),
          SwitchListTile(
            title: const Text('Periodic Measurement Setting'),
            subtitle: const Text('Enables or disables periodic measurements'),
            value: _settings.periodicMeasuringEnabled,
            onChanged: (status) => setState(() => _settings =
                _settings.copyWith(periodicMeasuringEnabled: status)),
          ),
          ListTile(
            title: const Text('Cleanliness Threshold'),
            subtitle: const Text('Set the threshold for washing'),
            trailing: DropdownButton<int>(
              value: _settings.cleanlinessThreshold,
              onChanged: (value) => setState(() =>
                  _settings = _settings.copyWith(cleanlinessThreshold: value!)),
              items:
                  <int>[1, 2, 3, 4, 5].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
          Text(
            "Device ID: ${_settings.deviceId}",
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              _displayTextInputDialog(context);
            },
            child: const Text("Edit Device Name",
                style: TextStyle(
                  color: Colors.blue,
                )),
          ),
          TextButton(
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Reset ${_settings.deviceName}'),
                  content: const Text(
                      'Proceed with destructive action? This cannot be undone.'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Yes'),
                      isDestructiveAction: true,
                      onPressed: () {
                        removeDevice(widget.initalSettings.deviceId);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ).then((value) => setState(() {}));
            },
            child: const Text(
              'Reset device and delete all data',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    updateDeviceSettings(widget.initalSettings.deviceId, _settings);
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      publishSettingsMessage(widget.initalSettings.deviceId, _settings);
    }
    super.dispose();
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Device Name'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _textFieldController..text = _settings.deviceName,
            decoration: const InputDecoration(hintText: 'Enter Device Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _settings = _settings.copyWith(deviceName: valueText);
                  Navigator.pop(context);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
