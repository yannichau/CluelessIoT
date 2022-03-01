import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imfresh/services/utils.dart';

class CustomTimePicker extends StatefulWidget {
  final String schedule;
  final ValueChanged<String> onChanged;
  const CustomTimePicker(
      {Key? key, required this.schedule, required this.onChanged})
      : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  String _schedule = "";
  late String stringTime;
  late DateTime actTime;
  late String daysOfWeek;

  @override
  void initState() {
    _schedule = widget.schedule;
    stringTime = _schedule.split("-")[0];
    actTime = DateTime(0, 1, 1, int.parse(stringTime.split(":")[0]),
        int.parse(stringTime.split(":")[1]));
    daysOfWeek = _schedule.split("-")[1];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Text(stringTime),
          ),
          onPressed: () {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext builder) {
                return Container(
                  height: MediaQuery.of(context).copyWith().size.height * 0.33,
                  color: Colors.white,
                  child: CupertinoDatePicker(
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (value) {
                      if (value != actTime) {
                        setState(() {
                          actTime = value;
                          String hour = actTime.hour.toString();
                          if (hour.length == 1) hour = "0" + hour;
                          String min = actTime.minute.toString();
                          if (min.length == 1) min = "0" + min;
                          stringTime = hour + ":" + min;
                        });
                        widget.onChanged(stringTime + "-" + daysOfWeek);
                      }
                    },
                    initialDateTime: actTime,
                    minimumYear: 2019,
                    maximumYear: 2050,
                  ),
                );
              },
            );
          },
        ),
        ToggleButtons(
          constraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ),
          children: const <Widget>[
            Text("M"),
            Text("T"),
            Text("W"),
            Text("T"),
            Text("F"),
            Text("S"),
            Text("S"),
          ],
          onPressed: (int index) {
            // int count = 0;
            List<bool> isSelected = getSelected(daysOfWeek);
            // isSelected.forEach((bool val) {
            //   if (val) count++;
            // });

            // if (isSelected[index] && count < 2) return;

            setState(() {
              isSelected[index] = !isSelected[index];
              daysOfWeek = getSelectedReverse(isSelected);
            });
            widget.onChanged(stringTime + "-" + daysOfWeek);
          },
          isSelected: getSelected(daysOfWeek),
        ),
      ],
    );
  }
}
