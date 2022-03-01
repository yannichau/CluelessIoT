import 'dart:math';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return add(
      Duration(
        days: (day - weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}

List<DateTime> getSchedule(List<String> schedule) {
  List<DateTime> res = [];
  for (var i = 0; i < schedule.length; i++) {
    var current = schedule[i].split("-");
    String time = current.first;
    String daysOfWeek = current.last;
    for (int j = 0; j < daysOfWeek.length; j++) {
      switch (daysOfWeek[j]) {
        case '1':
          var temp = DateTime.now().next(DateTime.monday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        case '2':
          var temp = DateTime.now().next(DateTime.tuesday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        case '3':
          var temp = DateTime.now().next(DateTime.wednesday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        case '4':
          var temp = DateTime.now().next(DateTime.thursday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        case '5':
          var temp = DateTime.now().next(DateTime.friday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        case '6':
          var temp = DateTime.now().next(DateTime.saturday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        case '7':
          var temp = DateTime.now().next(DateTime.sunday);
          res.add(DateTime(
            temp.year,
            temp.month,
            temp.day,
            int.parse(time.split(":").first),
            int.parse(time.split(":").last),
          ));
          break;
        default:
      }
    }
  }
  return res;
}

List<String> getScheduleString(List<DateTime> schedule) {
  // get all hour mins in list of schedule
  List<String> res = [];
  List<String> times = schedule
      .map((e) => e.hour.toString() + ":" + e.minute.toString())
      .toSet()
      .toList();
  for (var i = 0; i < times.length; i++) {
    String daysOfWeek = "";
    for (int j = 0; j < schedule.length; j++) {
      if (schedule[j].hour.toString() + ":" + schedule[j].minute.toString() ==
          times[i]) {
        daysOfWeek += schedule[j].weekday.toString();
      }
    }
    List<String> temp = daysOfWeek.split("");
    temp.sort();
    daysOfWeek = temp.join();
    String hour = times[i].split(":")[0];
    if (hour.length == 1) hour = "0" + hour;
    String min = times[i].split(":")[1];
    if (min.length == 1) min = "0" + min;
    res.add(hour + ":" + min + "-" + daysOfWeek);
  }
  return res;
}

List<bool> getSelected(String daysofWeek) {
  List<bool> res = [false, false, false, false, false, false, false];
  if (daysofWeek.contains("1")) res[0] = true;
  if (daysofWeek.contains("2")) res[1] = true;
  if (daysofWeek.contains("3")) res[2] = true;
  if (daysofWeek.contains("4")) res[3] = true;
  if (daysofWeek.contains("5")) res[4] = true;
  if (daysofWeek.contains("6")) res[5] = true;
  if (daysofWeek.contains("7")) res[6] = true;
  return res;
}

String getSelectedReverse(List<bool> selected) {
  String res = "";
  for (var i = 0; i < selected.length; i++) {
    if (selected[i]) {
      res += (i + 1).toString();
    }
  }
  return res;
}
