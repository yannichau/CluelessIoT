import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool alarmOn = false;
  bool measuringOn = false;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Alarm Setting'),
                subtitle:
                    const Text('Enable or Disable the alarm located on device'),
                value: alarmOn,
                onChanged: (status) => setState(() => alarmOn = status),
              ),
              if (alarmOn)
                ListTile(
                  title: const Text('Alarm Time'),
                  subtitle: const Text('Tap to change preferred alarm time'),
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.33,
                            color: Colors.white,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.time,
                              onDateTimeChanged: (value) {
                                if (value != selectedDate) {
                                  setState(() {
                                    selectedDate = value;
                                  });
                                }
                              },
                              initialDateTime: DateTime.now(),
                              minimumYear: 2019,
                              maximumYear: 2050,
                            ),
                          );
                        });
                  },
                ),
              SwitchListTile(
                title: const Text('Realtime Measurement Setting'),
                subtitle: const Text(
                    'Enables or disables realtime measurement when app is open'),
                value: measuringOn,
                onChanged: (status) => setState(() => measuringOn = status),
              )
            ],
          ),
        ),
      ),
    );
  }
}
