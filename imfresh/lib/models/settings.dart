import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  factory Settings({
    required String deviceId,
    required String deviceName,
    required bool alarmOn,
    required String deviceLocation,
    DateTime? alarmTime,
    required bool realtimeMeasuringOn,
    required bool periodicMeasuringEnabled,
    int? periodicMeasuringTimePeriod,
    List<DateTime>? measuringTimes,
    required int cleanlinessThreshold,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
