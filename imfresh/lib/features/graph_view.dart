import 'dart:convert';
import 'dart:io';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:flutter/material.dart';
import 'package:imfresh/models/device_reading.dart';
import 'package:imfresh/models/settings.dart';
import 'package:imfresh/services/databaseHandler.dart';
import 'package:imfresh/services/mqttHandler.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class DataGraphView extends StatefulWidget {
  final Settings settings;
  const DataGraphView({Key? key, required this.settings}) : super(key: key);

  @override
  State<DataGraphView> createState() => _DataGraphViewState();
}

class _DataGraphViewState extends State<DataGraphView> {
  List<DeviceReading> _deviceReadings = [];

  @override
  void initState() {
    getData();
    updateRequest();

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      // final data = jsonDecode(pt);
      if (pt[0] == "[") {
        // try {
        print("recieved list");
        var rawData = jsonDecode(pt);
        List<DeviceReading> readings = List<DeviceReading>.from(
            rawData.map((i) => DeviceReading.fromJson(i)));
        await dbHandler.insertReadings(readings);
        getData();
        // } catch (e) {}
      }
    });
    super.initState();
  }

  void getData() async {
    List<DeviceReading> newDeviceReadings =
        await dbHandler.getReadingsByDevice(widget.settings.deviceId);
    setState(() {
      _deviceReadings = newDeviceReadings;
    });
  }

  void updateRequest() async {
    List<DeviceReading> last =
        (await dbHandler.getLastReading(widget.settings.deviceId));
    DateTime reqDate;
    if (last.isNotEmpty) {
      reqDate = last[0].timestamp;
    } else {
      reqDate = DateTime.now().subtract(const Duration(days: 100));
    }
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      publishPeriodicDataRequest(widget.settings.deviceId, reqDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Graphs'),
        actions: [
          IconButton(
            tooltip: "Export Data from Device",
            icon: const Icon(Icons.share_sharp),
            onPressed: () async {
              Directory tempDir = await getTemporaryDirectory();
              List<DeviceReading> readings =
                  await dbHandler.getReadingsByDevice(widget.settings.deviceId);
              File file = File(
                  '${tempDir.path}/readings_${widget.settings.deviceId}.json');
              await file.writeAsString(
                  jsonEncode(readings.map((e) => e.toJson()).toList()));
              Share.shareFiles([
                tempDir.path + "/readings_${widget.settings.deviceId}.json"
              ]);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Text(_deviceReadings.toString()),
                const Divider(),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Temperature",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          height: 200,
                          child: SlidingViewportOnSelection(
                            _convertTempData(),
                            animate: true,
                            leftAxisTitle: "Temperature [°C]",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Humidity",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          height: 200,
                          child: SlidingViewportOnSelection(
                            _convertHumdData(),
                            animate: true,
                            leftAxisTitle: "Humidity [%]",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "VOCs",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 400,
                          height: 200,
                          child: SlidingViewportOnSelection(
                            _convertVocData(),
                            animate: true,
                            leftAxisTitle: "VOCs [µg/m³]",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<charts.Series<DeviceReading, DateTime>> _convertTempData() {
    return [
      charts.Series<DeviceReading, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (DeviceReading sales, _) => sales.timestamp,
        measureFn: (DeviceReading sales, _) => sales.temperature,
        data: _deviceReadings,
      )
    ];
  }

  List<charts.Series<DeviceReading, DateTime>> _convertHumdData() {
    return [
      charts.Series<DeviceReading, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (DeviceReading sales, _) => sales.timestamp,
        measureFn: (DeviceReading sales, _) => sales.temperature,
        data: _deviceReadings,
      )
    ];
  }

  List<charts.Series<DeviceReading, DateTime>> _convertVocData() {
    return [
      charts.Series<DeviceReading, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (DeviceReading sales, _) => sales.timestamp,
        measureFn: (DeviceReading sales, _) => sales.temperature,
        data: _deviceReadings,
      )
    ];
  }
}

class SlidingViewportOnSelection extends StatelessWidget {
  final List<charts.Series<dynamic, DateTime>> seriesList;
  final bool animate;
  final String leftAxisTitle;

  const SlidingViewportOnSelection(this.seriesList,
      {Key? key, required this.animate, required this.leftAxisTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      defaultInteractions: false,
      defaultRenderer: charts.BarRendererConfig<DateTime>(),

      behaviors: [
        // Add the sliding viewport behavior to have the viewport center on the
        // domain that is currently selected.
        charts.SlidingViewport(),
        // A pan and zoom behavior helps demonstrate the sliding viewport
        // behavior by allowing the data visible in the viewport to be adjusted
        // dynamically.
        charts.PanAndZoomBehavior(),
        charts.SelectNearest(),
        charts.DomainHighlighter(),
        charts.ChartTitle(leftAxisTitle,
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: const charts.TextStyleSpec(
                fontSize: 13, color: charts.MaterialPalette.black),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
      // Set an initial viewport to demonstrate the sliding viewport behavior on
      // initial chart load.
      domainAxis: charts.DateTimeAxisSpec(
          viewport: charts.DateTimeExtents(
              start: DateTime.now().subtract(const Duration(days: 14)),
              end: DateTime.now())),
    );
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
