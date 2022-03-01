import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imfresh/features/home_page.dart';
import 'package:imfresh/features/new_device.dart';
import 'package:imfresh/services/databaseHandler.dart';
import 'package:imfresh/services/mqttHandler.dart';

import 'features/settings_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbHandler.openDB();
  setupMqttClient();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.white,
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/addDevice': (context) => const NewDevice(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
