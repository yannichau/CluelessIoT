// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periodic_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PeriodicReading _$$_PeriodicReadingFromJson(Map<String, dynamic> json) =>
    _$_PeriodicReading(
      timestamp: DateTime.parse(json['timestamp'] as String),
      nextWash: DateTime.parse(json['nextWash'] as String),
      deviceID: json['deviceID'] as String,
      humidity: (json['humidity'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      VOC: (json['VOC'] as num).toDouble(),
    );

Map<String, dynamic> _$$_PeriodicReadingToJson(_$_PeriodicReading instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'nextWash': instance.nextWash.toIso8601String(),
      'deviceID': instance.deviceID,
      'humidity': instance.humidity,
      'temperature': instance.temperature,
      'VOC': instance.VOC,
    };
