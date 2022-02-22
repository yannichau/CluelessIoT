import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTHandler {
  late MqttServerClient client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.idle;

  void setupMqttClient() {
    client = MqttServerClient('test.mosquitto.org', '');
    client.logging(on: true);
    client.setProtocolV311();
    client.secure = true;
    client.port = 8883;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void unsubscribe(String topic) {
    client.unsubscribe(topic);
  }

  void disconnectClient() {
    client.disconnect();
  }

  void _onDisconnected() {
    print('MQTT client disconnected');
    connectionState = MqttCurrentConnectionState.disconnected;
  }

  void _onConnected() {
    print('MQTT client connected');
    connectionState = MqttCurrentConnectionState.connected;
  }

  void _onSubscribed(String topic) {
    print('MQTT client subscribed to topic $topic');
    subscriptionState = MqttSubscriptionState.subscribed;
  }
}

enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  error
}
enum MqttSubscriptionState { idle, subscribed }
