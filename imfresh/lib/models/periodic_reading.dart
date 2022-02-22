import 'package:freezed_annotation/freezed_annotation.dart';

part 'periodic_reading.freezed.dart';
part 'periodic_reading.g.dart';

@freezed
class PeriodicReading with _$PeriodicReading {
  factory PeriodicReading({
    required String timestamp,
    required String nextWash,
    required double humidity,
    required double temperature,
    required double airQuality,
    required int cleanlinessScore,
  }) = _PeriodicReading;

  factory PeriodicReading.fromJson(Map<String, dynamic> json) =>
      _$PeriodicReadingFromJson(json);
}
