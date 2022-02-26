// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Settings _$$_SettingsFromJson(Map<String, dynamic> json) => _$_Settings(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      alarmOn: json['alarmOn'] as bool,
      deviceLocation: json['deviceLocation'] as String,
      alarmTime: json['alarmTime'] == null
          ? null
          : DateTime.parse(json['alarmTime'] as String),
      realtimeMeasuringOn: json['realtimeMeasuringOn'] as bool,
      periodicMeasuringEnabled: json['periodicMeasuringEnabled'] as bool,
      periodicMeasuringTimePeriod: json['periodicMeasuringTimePeriod'] as int?,
      measuringTimes: (json['measuringTimes'] as List<dynamic>?)
          ?.map((e) => DateTime.parse(e as String))
          .toList(),
      cleanlinessThreshold: json['cleanlinessThreshold'] as int,
    );

Map<String, dynamic> _$$_SettingsToJson(_$_Settings instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'alarmOn': instance.alarmOn,
      'deviceLocation': instance.deviceLocation,
      'alarmTime': instance.alarmTime?.toIso8601String(),
      'realtimeMeasuringOn': instance.realtimeMeasuringOn,
      'periodicMeasuringEnabled': instance.periodicMeasuringEnabled,
      'periodicMeasuringTimePeriod': instance.periodicMeasuringTimePeriod,
      'measuringTimes':
          instance.measuringTimes?.map((e) => e.toIso8601String()).toList(),
      'cleanlinessThreshold': instance.cleanlinessThreshold,
    };
