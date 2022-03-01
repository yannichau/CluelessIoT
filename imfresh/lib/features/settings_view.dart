import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:imfresh/features/device_settings_card.dart';
import 'package:imfresh/models/settings.dart';
import 'package:imfresh/services/shared_prefs_handler.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<Settings> test = [
    Settings(
        deviceId: "askdfjhdsklfhjkjasdhfjlsk",
        deviceName: "Kitchen imfresh",
        deviceLocation: "London",
        alarmOn: true,
        alarmTime: DateTime.now(),
        realtimeMeasuringOn: true,
        periodicMeasuringEnabled: false,
        cleanlinessThreshold: 3),
    Settings(
        deviceId: "askdfjhdsklfhjkjasdhfjlk",
        deviceName: "Laundry imfresh",
        deviceLocation: "Singapore",
        alarmOn: true,
        alarmTime: DateTime.now(),
        realtimeMeasuringOn: true,
        periodicMeasuringEnabled: false,
        cleanlinessThreshold: 5)
  ];

  final List<Widget> _sliders = [
    DeviceSettingsCard(
        initalSettings: Settings(
            deviceId: "askdfjhdsklfhjkjasdhfjlsk",
            deviceName: "Kitchen imfresh",
            deviceLocation: "London",
            alarmOn: true,
            alarmTime: DateTime.now(),
            realtimeMeasuringOn: true,
            periodicMeasuringEnabled: false,
            cleanlinessThreshold: 3)),
    DeviceSettingsCard(
        initalSettings: Settings(
            deviceId: "askdfjhdsklfhjkjasdhfjlk",
            deviceName: "Laundry imfresh",
            deviceLocation: "Singapore",
            alarmOn: true,
            alarmTime: DateTime.now(),
            realtimeMeasuringOn: true,
            periodicMeasuringEnabled: false,
            cleanlinessThreshold: 5)),
  ];

  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    // print(jsonEncode(test.map((e) => e.toJson()).toList()));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SafeArea(
        child: Material(
          child: FutureBuilder(
            future: getDeviceList(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Settings>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No devices found, add one!"),
                  );
                } else {
                  List<Widget> _newSliders = snapshot.data!.map((e) {
                    return DeviceSettingsCard(
                      initalSettings: e,
                    );
                  }).toList();
                  return SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: CarouselSlider(
                          items: _newSliders,
                          carouselController: _controller,
                          options: CarouselOptions(
                              autoPlay: false,
                              enlargeCenterPage: false,
                              aspectRatio: 0.6,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.9,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              }),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _newSliders.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () => _controller.animateToPage(entry.key),
                            child: Container(
                              width: 12.0,
                              height: 12.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black)
                                      .withOpacity(
                                          _current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                    ]),
                  );
                }
              } else {
                return Container();
              }
            },
            //
          ),
        ),
      ),
    );
  }
}
