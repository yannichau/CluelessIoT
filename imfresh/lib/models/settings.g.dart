// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Settings _$$_SettingsFromJson(Map<String, dynamic> json) => _$_Settings(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      alarmOn: json['alarmOn'] as bool,
      alarmTime: json['alarmTime'] == null
          ? null
          : DateTime.parse(json['alarmTime'] as String),
      realtimeMeasuringOn: json['realtimeMeasuringOn'] as bool,
      periodicMeasuringOn: json['periodicMeasuringOn'] as bool,
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
      'alarmTime': instance.alarmTime?.toIso8601String(),
      'realtimeMeasuringOn': instance.realtimeMeasuringOn,
      'periodicMeasuringOn': instance.periodicMeasuringOn,
      'measuringTimes':
          instance.measuringTimes?.map((e) => e.toIso8601String()).toList(),
      'cleanlinessThreshold': instance.cleanlinessThreshold,
    };
