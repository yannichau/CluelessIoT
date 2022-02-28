// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DeviceReading _$$_DeviceReadingFromJson(Map<String, dynamic> json) =>
    _$_DeviceReading(
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      nextWash: DateTime.parse(json['nextWash'] as String),
      deviceId: json['deviceId'] as String,
      humidity: (json['humidity'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      VOC: (json['VOC'] as num).toDouble(),
    );

Map<String, dynamic> _$$_DeviceReadingToJson(_$_DeviceReading instance) =>
    <String, dynamic>{
      'type': instance.type,
      'timestamp': instance.timestamp.toIso8601String(),
      'nextWash': instance.nextWash.toIso8601String(),
      'deviceId': instance.deviceId,
      'humidity': instance.humidity,
      'temperature': instance.temperature,
      'VOC': instance.VOC,
    };
