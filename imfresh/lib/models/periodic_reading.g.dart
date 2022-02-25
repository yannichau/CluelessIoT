// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'periodic_reading.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PeriodicReading _$$_PeriodicReadingFromJson(Map<String, dynamic> json) =>
    _$_PeriodicReading(
      timestamp: json['timestamp'] as String,
      nextWash: json['nextWash'] as String,
      deviceID: json['deviceID'] as String,
      humidity: (json['humidity'] as num).toDouble(),
      temperature: (json['temperature'] as num).toDouble(),
      airQuality: (json['airQuality'] as num).toDouble(),
      cleanlinessScore: json['cleanlinessScore'] as int,
    );

Map<String, dynamic> _$$_PeriodicReadingToJson(_$_PeriodicReading instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp,
      'nextWash': instance.nextWash,
      'deviceID': instance.deviceID,
      'humidity': instance.humidity,
      'temperature': instance.temperature,
      'airQuality': instance.airQuality,
      'cleanlinessScore': instance.cleanlinessScore,
    };
