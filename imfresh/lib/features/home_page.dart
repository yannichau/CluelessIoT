import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imfresh/services/mqttHandler.dart';
import 'package:imfresh/services/shared_prefs_handler.dart';
import 'package:imfresh/services/utils.dart';

import '../models/settings.dart';
import 'home_device_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    connectClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "imfresh!",
                        style: GoogleFonts.racingSansOne(fontSize: 60.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      tooltip: "Settings",
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings')
                            .then((value) async {
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),
                FutureBuilder(
                  future: getDeviceList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Settings>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                              8.0,
                              MediaQuery.of(context).size.height / 3.0,
                              8.0,
                              8.0),
                          child: const Center(
                            child: Text("No devices found, add one!"),
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: snapshot.data!
                              .map((Settings device) => HomeDeviceCard(
                                    settings: device,
                                  ))
                              .toList(),
                        );
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final _keyForm = GlobalKey<FormState>();
              final _id = TextEditingController();
              final _name = TextEditingController();
              final _location = TextEditingController();
              String? newDeviceId = "";
              String? deviceCity = "";
              String? deviceName = "";
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
                              'Add New Device',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        ),
                        Form(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: TextFormField(
                                          controller: _id,
                                          enableSuggestions: false,
                                          onSaved: (newVal) =>
                                              newDeviceId = newVal,
                                          decoration: const InputDecoration(
                                            labelText: 'Device ID',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter an ID';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            tooltip:
                                                "Scan QR Code for Device ID",
                                            onPressed: () async {
                                              final result =
                                                  await Navigator.pushNamed(
                                                      context, '/addDevice');

                                              setState(() {
                                                _id.text = "$result";
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.qr_code_scanner_sharp)),
                                      ),
                                    ],
                                  ),
                                  TextFormField(
                                    controller: _name,
                                    onSaved: (newVal) => deviceName = newVal,
                                    decoration: const InputDecoration(
                                      labelText: 'Device Name',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    onSaved: (newVal) => deviceCity = newVal,
                                    controller: _location,
                                    decoration: const InputDecoration(
                                      labelText: 'City Location',
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter device city';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('ADD'),
                                    onPressed: () {
                                      if (_keyForm.currentState!.validate()) {
                                        _keyForm.currentState!.save();
                                        addNewDevice(
                                          Settings(
                                              deviceId: newDeviceId!,
                                              deviceName: deviceName!,
                                              alarmOn: true,
                                              alarmTime: DateTime.now(),
                                              deviceLocation: deviceCity!,
                                              realtimeMeasuringOn: true,
                                              periodicMeasuringTimePeriod: 1,
                                              periodicMeasuringEnabled: true,
                                              measuringTimes: getSchedule(
                                                  ["01:00-1234567"]),
                                              cleanlinessThreshold: 3),
                                        );

                                        Navigator.pop(context);
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                            key: _keyForm),
                      ],
                    ),
                  );
                },
              );
            },
          ).then((value) async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          });
        },
        tooltip: 'Add New Device',
        child: const Icon(Icons.add),
      ),
    );
  }
}
