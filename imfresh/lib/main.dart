import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:imfresh/features/home_page.dart';
import 'package:imfresh/features/new_device.dart';
import 'package:imfresh/services/databaseHandler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  dbHandler.openDB();
  Hive.initFlutter();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/addDevice': (context) => const NewDevice(),
      },
    );
  }
}
