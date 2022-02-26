import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imfresh/models/periodic_reading.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import '../models/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final PeriodicReading _reading = PeriodicReading(
    nextWash: DateTime.now().add(Duration(days: 7)),
    timestamp: DateTime.now(),
    deviceID: "askdfjhdsklfhjkjasdhfjlsk",
    humidity: 56,
    temperature: 11,
    VOC: 1,
  );

  final Settings _settings = Settings(
      deviceId: "askdfjhdsklfhjkjasdhfjlsk",
      deviceName: "Bed 1",
      deviceLocation: "London",
      alarmOn: true,
      alarmTime: DateTime.now(),
      realtimeMeasuringOn: true,
      periodicMeasuringEnabled: false,
      cleanlinessThreshold: 3);

  late AnimationController _animationController;
  late Animation _animation;
  WeatherFactory wf = WeatherFactory("5017664c335a080c262ee52428445459");

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
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
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
                Card(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Color.fromARGB(255, 245, 245, 245),
                  elevation: 0.0,
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _settings.deviceName,
                                style: const TextStyle(
                                  fontSize: 28.0,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              tooltip: "View History",
                              onPressed: null,
                              icon: Icon(
                                Icons.auto_graph_sharp,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 60,
                                child: Text(_reading.VOC.toString() + " ppm"),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(134, 153, 237, 58),
                                          blurRadius: _animation.value,
                                          spreadRadius: _animation.value)
                                    ]),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 60,
                                child: Text(
                                    _reading.temperature.toString() + "°C"),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(130, 32, 215, 240),
                                          blurRadius: _animation.value,
                                          spreadRadius: _animation.value)
                                    ]),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                width: 60,
                                height: 60,
                                child: Text(_reading.humidity.toString() + "%"),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(130, 238, 15, 34),
                                          blurRadius: _animation.value,
                                          spreadRadius: _animation.value)
                                    ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Suggested Next Wash Date: " +
                                    DateFormat('MMMMEEEEd')
                                        .format(_reading.nextWash),
                                maxLines: 3,
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextButton(
                                child: const Text(
                                  "Done Washing!",
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                      FutureBuilder(
                          future: wf.fiveDayForecastByCityName(
                              _settings.deviceLocation),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Weather>> snapshot) {
                            if (snapshot.hasData) {
                              List<Weather> forecast = snapshot.data!;
                              return Text(forecast.toString());
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              return Container(
                                child: const CircularProgressIndicator(),
                                alignment: Alignment.center,
                              );
                            }
                          }),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addDevice');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
