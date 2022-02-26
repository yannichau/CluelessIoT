import 'package:freezed_annotation/freezed_annotation.dart';

part 'periodic_reading.freezed.dart';
part 'periodic_reading.g.dart';

@freezed
class PeriodicReading with _$PeriodicReading {
  factory PeriodicReading({
    required DateTime timestamp,
    required DateTime nextWash,
    required String deviceID,
    required double humidity,
    required double temperature,
    required double VOC,
  }) = _PeriodicReading;

  factory PeriodicReading.fromJson(Map<String, dynamic> json) =>
      _$PeriodicReadingFromJson(json);
}
