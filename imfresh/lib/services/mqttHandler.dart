import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:imfresh/models/settings.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

final client = MqttServerClient('3.83.201.238', '');

void setupMqttClient() {
  client.logging(on: false);
  client.setProtocolV31();
  client.secure = false;
  client.port = 1883;
  client.keepAlivePeriod = 20;
  client.onDisconnected = _onDisconnected;
  client.onConnected = _onConnected;
  client.onSubscribed = _onSubscribed;
}

void connectClient() async {
  final connMess = MqttConnectMessage()
      .authenticateAs("cluelessIoT", "Imfresh")
      .withClientIdentifier('Mqtt_MyClasdsfdasdfientUniqueId')
      .withWillTopic('willtopic') // If you set this you must set a will message
      .withWillMessage('My Will message')
      .withWillQos(MqttQos.atLeastOnce);
  client.connectionMessage = connMess;
  try {
    await client.connect();
  } on NoConnectionException catch (e) {
    // Raised by the client when connection fails.
    log('EXAMPLE::client exception - $e');
    client.disconnect();
  } on SocketException catch (e) {
    // Raised by the socket layer
    log('EXAMPLE::socket exception - $e');
    client.disconnect();
  }
  if (client.connectionStatus!.state == MqttConnectionState.connected) {
    log('MQTT client connected');
  } else {
    /// Use status here rather than state if you also want the broker return code.
    log('MQTT::ERROR  client connection failed - disconnecting, status is ${client.connectionStatus}');
    client.disconnect();
  }
}

void subscribeToDeviceTopics(String deviceID) {
  const topic = "IC.embedded/cluelessIoT/imfresh/";
  client.subscribe(deviceID + "/data", MqttQos.exactlyOnce);
  client.subscribe(deviceID + "/settings", MqttQos.exactlyOnce);
  client.subscribe(deviceID + "/error", MqttQos.exactlyOnce);
}

void publishSettingsMessage(String deviceID, Settings setting) {
  String topic = deviceID + "/settings";
  final builder = MqttClientPayloadBuilder()..addString(jsonEncode(setting));
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
}

void publishWashedMessage(String deviceID) {
  String topic = deviceID + "/settings";
  final builder = MqttClientPayloadBuilder()..addString("Washed");
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
}

void publishPeriodicDataRequest(String deviceID, DateTime lastUpdate) {
  String topic = deviceID + "/settings";
  final builder = MqttClientPayloadBuilder()
    ..addString("PeriodicLog " + lastUpdate.toIso8601String());
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
}

void publishErrorLogMessage(String deviceID) {
  String topic = deviceID + "/settings";
  final builder = MqttClientPayloadBuilder()..addString("ErrorLog");
  client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
}

void unsubscribe(String topic) {
  client.unsubscribe(topic);
}

void disconnectClient() {
  client.disconnect();
}

void _onDisconnected() {
  log('MQTT client disconnected');
}

void _onConnected() {
  log('MQTT client connected');
}

void _onSubscribed(String topic) {
  log('MQTT client subscribed to topic $topic');
}
