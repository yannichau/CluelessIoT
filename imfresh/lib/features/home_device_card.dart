import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imfresh/models/periodic_reading.dart';
import 'package:imfresh/models/settings.dart';
import 'package:imfresh/services/mqttHander.dart';
import 'package:imfresh/services/weather_handler.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:weather/weather.dart';

class HomeDeviceCard extends StatefulWidget {
  final Settings settings;
  const HomeDeviceCard({Key? key, required this.settings}) : super(key: key);

  @override
  _HomeDeviceCardState createState() => _HomeDeviceCardState();
}

class _HomeDeviceCardState extends State<HomeDeviceCard>
    with SingleTickerProviderStateMixin {
  PeriodicReading reading = PeriodicReading(
    nextWash: DateTime.now().add(Duration(days: 10)),
    timestamp: DateTime.now(),
    deviceID: "",
    humidity: 56,
    temperature: 11,
    VOC: 1,
  );

  late AnimationController _animationController;
  late Animation _animation;
  WeatherFactory wf = WeatherFactory("5017664c335a080c262ee52428445459");

  final List<int> testWeatherStatus = [500, 731, 804, 903, 321];
  final List<DateTime> testWeatherTimestamps = [
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 4)),
    DateTime.now().add(Duration(days: 5)),
  ];

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 8.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      subscribeToDeviceTopics(widget.settings.deviceId);
      client.published!.listen((MqttPublishMessage message) {
        print(
            'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
      });
      publishSettingsMessage(widget.settings.deviceId, widget.settings);
    }
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      final data = jsonDecode(pt);
      print(data);
      if (c[0].topic.contains("data")) {
        setState(() {
          reading = reading.copyWith(
            humidity: data["humidity"],
            temperature: data["temperature"],
            VOC: data["VOC"],
            //timestamp: DateTime.parse(data["timestamp"]),
            //nextWash: DateTime.parse(data["nextWash"]),
          );
        });
      }

      /// The above may seem a little convoluted for users only interested in the
      /// payload, some users however may be interested in the received publish message,
      /// lets not constrain ourselves yet until the package has been in the wild
      /// for a while.
      /// The payload is a byte buffer, this will be specific to the topic
      // print(
      //     'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      // print('');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    widget.settings.deviceName,
                    style: GoogleFonts.racingSansOne(fontSize: 28.0),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 50,
                  child: TextButton(
                    //tooltip: "View History",
                    onPressed: () {},
                    child: const Icon(
                      Icons.auto_graph_sharp,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    width: 60,
                    height: 60,
                    child: Text(reading.VOC.toStringAsFixed(2) + "ppm"),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(134, 153, 237, 58),
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
                    child: Text(reading.temperature.toStringAsFixed(2) + "°C"),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(130, 32, 215, 240),
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
                    child: Text(reading.humidity.toStringAsFixed(2) + "%"),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 255, 255, 255),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(130, 238, 15, 34),
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
                        DateFormat('MMMMEEEEd').format(reading.nextWash),
                    maxLines: 3,
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                    child: const Text(
                      "I'm Done Washing!",
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {}),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            height: 90,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: testWeatherStatus.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Column(
                    children: [
                      Icon(
                        iconMapping[testWeatherStatus[index]],
                        size: 50,
                      ),
                      Spacer(),
                      Text(DateFormat(' EE')
                          .format(testWeatherTimestamps[index])),
                    ],
                  ),
                );
              },
            ),
          ),
          // FutureBuilder(
          //   future: wf.fiveDayForecastByCityName(
          //       _settings.deviceLocation),
          //   builder: (BuildContext context,
          //       AsyncSnapshot<List<Weather>> snapshot) {
          //     if (snapshot.hasData) {
          //       List<Weather> forecast = snapshot.data!;
          //       List<String?> forecastIcons = [];
          //       forecast.forEach((Weather w) =>
          //           forecastIcons.add(w.weatherIcon));
          //       return Text(forecastIcons.toString());
          //     } else if (snapshot.hasError) {
          //       return Text("${snapshot.error}");
          //     } else {
          //       return Container(
          //         child: const CircularProgressIndicator(),
          //         alignment: Alignment.center,
          //       );
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}
