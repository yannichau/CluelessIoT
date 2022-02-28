import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_reading.freezed.dart';
part 'device_reading.g.dart';

@freezed
class DeviceReading with _$DeviceReading {
  factory DeviceReading({
    required String type,
    required DateTime timestamp,
    required DateTime nextWash,
    required String deviceId,
    required double humidity,
    required double temperature,
    required double VOC,
  }) = _DeviceReading;

  factory DeviceReading.fromJson(Map<String, dynamic> json) =>
      _$DeviceReadingFromJson(json);
}
