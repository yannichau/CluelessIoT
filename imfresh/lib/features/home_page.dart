import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imfresh/services/mqttHander.dart';
import 'package:imfresh/services/shared_prefs_handler.dart';
import 'package:imfresh/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    test();
    connectClient();
    super.initState();
  }

  void test() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove('deviceList');
    print((await getDeviceList()).toString());
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
                          await Future.delayed(Duration(seconds: 1));
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
        onPressed: () {
          // Navigator.pushNamed(context, '/addDevice');
          print("Adding new device");
          addNewDevice(Settings(
              deviceId: "asu343ui41823jisdjajdio1jo2i",
              deviceName: "Bed 1",
              deviceLocation: "London",
              alarmOn: true,
              alarmTime: DateTime.now(),
              realtimeMeasuringOn: false,
              periodicMeasuringEnabled: true,
              periodicMeasuringTimePeriod: 10,
              measuringTimes: [DateTime.now()],
              cleanlinessThreshold: 3));
          setState(() {});
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
