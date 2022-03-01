import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imfresh/features/graph_view.dart';
import 'package:imfresh/models/device_reading.dart';
import 'package:imfresh/models/settings.dart';
import 'package:imfresh/services/mqttHandler.dart';
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
  late AnimationController _animationController;
  late Animation _animation;
  late Future<http.Response> weatherResponse;
  final http.Client _httpClient = http.Client();
  WeatherFactory wf = WeatherFactory("5017664c335a080c262ee52428445459");
  bool realtimeMeasurementOn = true;

  final List<int> testWeatherStatus = [500, 731, 804, 903, 321];
  final List<DateTime> testWeatherTimestamps = [
    DateTime.now().add(const Duration(days: 1)),
    DateTime.now().add(const Duration(days: 2)),
    DateTime.now().add(const Duration(days: 3)),
    DateTime.now().add(const Duration(days: 4)),
    DateTime.now().add(const Duration(days: 5)),
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
      publishSettingsMessage(widget.settings.deviceId,
          widget.settings.copyWith(realtimeMeasuringOn: true));
    }
    weatherResponse = _httpClient.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=${widget.settings.deviceLocation}&appid=5017664c335a080c262ee52428445459&lang=en"));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      color: const Color.fromARGB(255, 245, 245, 245),
      elevation: 0.0,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.settings.deviceName,
                    style: GoogleFonts.racingSansOne(fontSize: 28.0),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                    height: 50,
                    child: realtimeMeasurementOn
                        ? TextButton(
                            //tooltip: "View History",
                            onPressed: () {
                              publishSettingsMessage(
                                  widget.settings.deviceId,
                                  widget.settings
                                      .copyWith(realtimeMeasuringOn: false));
                              setState(() {
                                realtimeMeasurementOn = false;
                              });
                            },
                            child: const Icon(
                              Icons.stop,
                              color: Colors.black,
                            ),
                          )
                        : TextButton(
                            //tooltip: "View History",
                            onPressed: () {
                              publishSettingsMessage(
                                  widget.settings.deviceId,
                                  widget.settings
                                      .copyWith(realtimeMeasuringOn: true));
                              setState(() {
                                realtimeMeasurementOn = true;
                              });
                            },
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            ),
                          )),
              ),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextButton(
                    //tooltip: "View History",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DataGraphView(
                                  settings: widget.settings,
                                )),
                      );
                    },
                    child: const Icon(
                      Icons.auto_graph_sharp,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            ],
          ),
          StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
            stream: client.updates!.where((event) =>
                event[0].topic.contains(widget.settings.deviceId + "/data")),
            builder: (BuildContext context,
                AsyncSnapshot<List<MqttReceivedMessage<MqttMessage>>>
                    snapshot) {
              if (snapshot.hasData) {
                final recMess = snapshot.data![0].payload as MqttPublishMessage;
                final pt = MqttPublishPayload.bytesToStringAsString(
                    recMess.payload.message);

                try {
                  final DeviceReading data =
                      DeviceReading.fromJson(jsonDecode(pt));
                  assert(data.type == "realtime");

                  return Column(
                    children: [
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
                                child:
                                    Text(data.VOC.toStringAsFixed(0) + "ppm"),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromARGB(
                                              134, 153, 237, 58),
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
                                    data.temperature.toStringAsFixed(2) + "°C"),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromARGB(
                                              130, 32, 215, 240),
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
                                    data.humidity.toStringAsFixed(2) + "%"),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color.fromARGB(
                                              130, 238, 15, 34),
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
                                        .format(data.nextWash),
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
                                onPressed: () {
                                  publishWashedMessage(
                                      widget.settings.deviceId);
                                }),
                          ),
                        ],
                      ),
                    ],
                  );
                } catch (e) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  );
                }
              } else if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "Can't currently connect to device, please try again later"),
                );
              } else if (!snapshot.hasData & !realtimeMeasurementOn) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Realtime data collection stopped,\n Press start to enable",
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          // Container(
          //   padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          //   height: 90,
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     scrollDirection: Axis.horizontal,
          //     itemCount: testWeatherStatus.length,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          //         child: Column(
          //           children: [
          //             Icon(
          //               iconMapping[testWeatherStatus[index]],
          //               size: 50,
          //             ),
          //             const Spacer(),
          //             Text(DateFormat(' EE')
          //                 .format(testWeatherTimestamps[index])),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
          FutureBuilder(
            future: weatherResponse,
            builder:
                (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.statusCode != 200) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Weather Service Currently Unavailable"),
                  );
                } else {
                  Map<String, dynamic> jsonBody =
                      json.decode(snapshot.data!.body);
                  if (jsonBody["cod"] == "200") {
                    List<int> data = [];
                    List<DateTime> timestamp = [];
                    List<DateTime> displayedLabels = [];
                    List<int> displayedData = [];
                    jsonBody["list"].forEach((v) {
                      timestamp.add(
                          DateTime.fromMillisecondsSinceEpoch(v["dt"] * 1000));
                      v["weather"].forEach((y) {
                        data.add(y["id"]);
                      });
                    });

                    DateTime current = timestamp.first;
                    displayedLabels.add(timestamp.first);
                    displayedData.add(data.first);

                    for (var i = 0; i < timestamp.length; i++) {
                      if (current.day != timestamp[i].day) {
                        displayedLabels.add(timestamp[i]);
                        displayedData.add(data[i]);
                        current = timestamp[i];
                      }
                    }
                    return Container(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                      height: 90,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: displayedLabels.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Column(
                              children: [
                                Icon(
                                  iconMapping[displayedData[index]],
                                  size: 50,
                                ),
                                const Spacer(),
                                Text(DateFormat(' EE')
                                    .format(displayedLabels[index])),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Weather Service Currently Unavailable"),
                    );
                  }
                }
              } else if (snapshot.hasError) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Weather Service Currently Unavailable"),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: const CircularProgressIndicator(),
                    alignment: Alignment.center,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
