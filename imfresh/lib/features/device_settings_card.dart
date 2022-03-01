import 'dart:io';
import 'package:imfresh/features/custom_time_picker.dart';
import 'package:imfresh/services/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imfresh/models/settings.dart';
import 'package:imfresh/services/mqttHandler.dart';
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
  late Directory tempDir;

  String valueText = "";

  @override
  void initState() {
    _settings = widget.initalSettings;
    valueText = _settings.deviceName;
    getTempDir();
    super.initState();
  }

  void getTempDir() async {
    tempDir = await getTemporaryDirectory();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      margin: const EdgeInsets.all(8.0),
      elevation: 2,
      child: SingleChildScrollView(
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
                                _settings = _settings.copyWith(
                                    deviceLocation: valueText);
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
              onChanged: (status) => setState(
                  () => _settings = _settings.copyWith(alarmOn: status)),
            ),
            if (_settings.alarmOn)
              ListTile(
                title: const Text('Alarm Time'),
                subtitle: const Text('Tap to change preferred alarm time(24h)'),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
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
                    },
                  );
                },
              ),
            // SwitchListTile(
            //   title: const Text('Realtime Measurement Setting'),
            //   subtitle: const Text(
            //       'Enables or disables realtime measurement when app is open'),
            //   value: _settings.realtimeMeasuringOn,
            //   onChanged: (status) => setState(() =>
            //       _settings = _settings.copyWith(realtimeMeasuringOn: status)),
            // ),

            SwitchListTile(
              title: const Text('Periodic Measurement Setting'),
              subtitle: const Text('Enables or disables periodic measurements'),
              value: _settings.periodicMeasuringEnabled,
              onChanged: (status) => setState(() => _settings =
                  _settings.copyWith(periodicMeasuringEnabled: status)),
            ),
            if (_settings.periodicMeasuringEnabled)
              ListTile(
                title: const Text('Periodic Measurement Schedule'),
                subtitle:
                    const Text('Tap to view and change the weekly schedule'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      List<String> stringTimes =
                          getScheduleString(_settings.measuringTimes!);
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                    child: Text(
                                      'Weekly Schedule',
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: stringTimes.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CustomTimePicker(
                                      schedule: stringTimes[index],
                                      onChanged: (value) => setState(() {
                                        if (value.split("-")[1] == "") {
                                          List<String> tempList = stringTimes;
                                          tempList.removeAt(index);
                                          if (tempList.isEmpty) {
                                            tempList.add("12:00-1");
                                          }
                                          setState(
                                              () => stringTimes = tempList);
                                        } else {
                                          stringTimes[index] = value;
                                        }
                                      }),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          stringTimes.add("12:00-1");
                                        });
                                      },
                                      child: const Text("Add New Time"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        _settings = _settings.copyWith(
                                            measuringTimes:
                                                getSchedule(stringTimes));
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Done"),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            if (_settings.periodicMeasuringEnabled)
              ListTile(
                title: const Text('Peridoic Measurement Length'),
                subtitle: const Text(
                    'Set the number of hours each periodic measurement is run'),
                trailing: DropdownButton<int>(
                  value: _settings.periodicMeasuringTimePeriod ?? 1,
                  onChanged: (value) => setState(() => _settings =
                      _settings.copyWith(periodicMeasuringTimePeriod: value!)),
                  items: <int>[1, 2, 3].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ListTile(
              title: const Text('Cleanliness Threshold'),
              subtitle: const Text('Set the threshold for washing'),
              trailing: DropdownButton<int>(
                value: _settings.cleanlinessThreshold,
                onChanged: (value) => setState(() => _settings =
                    _settings.copyWith(cleanlinessThreshold: value!)),
                items: <int>[1, 2, 3, 4, 5]
                    .map<DropdownMenuItem<int>>((int value) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
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
                      builder: (BuildContext context) {
                        client.subscribe(_settings.deviceId + "/errorLog",
                            MqttQos.exactlyOnce);
                        publishErrorLogMessage(_settings.deviceId);
                        return CupertinoAlertDialog(
                          title:
                              Text('Get Error Log for ${_settings.deviceName}'),
                          content: StreamBuilder<
                              List<MqttReceivedMessage<MqttMessage>>>(
                            stream: client.updates!.where((event) => event[0]
                                .topic
                                .contains(_settings.deviceId + "/errorLog")),
                            builder: (BuildContext context,
                                AsyncSnapshot<
                                        List<MqttReceivedMessage<MqttMessage>>>
                                    snapshot) {
                              if (snapshot.hasData) {
                                final recMess = snapshot.data![0].payload
                                    as MqttPublishMessage;
                                final pt = MqttPublishPayload.bytesToString(
                                    recMess.payload.message);

                                List<String> dataAsList = pt.split("><");
                                dataAsList[0] = dataAsList[0].substring(1);
                                dataAsList.last = dataAsList.last
                                    .substring(0, dataAsList.last.length - 1);

                                var logFile =
                                    File(tempDir.path + "/ErrorLog.bin");

                                logFile.writeAsBytes(
                                    dataAsList.map(int.parse).toList());

                                return TextButton(
                                    onPressed: () => Share.shareFiles(
                                        [tempDir.path + "/ErrorLog.bin"]),
                                    child: const Text("Share Logfile"));
                              } else {
                                return Column(
                                  children: const [
                                    Text("Data Request Sent..."),
                                    CircularProgressIndicator(),
                                  ],
                                );
                              }
                            },
                          ),
                          actions: <CupertinoDialogAction>[
                            CupertinoDialogAction(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Get Device Logs',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
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
      ),
    );
  }

  @override
  void dispose() {
    updateDeviceSettings(widget.initalSettings.deviceId, _settings);
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      publishSettingsMessage(widget.initalSettings.deviceId, _settings);
    }
    _textFieldController.dispose();
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
