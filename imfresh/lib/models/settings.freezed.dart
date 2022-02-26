// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return _Settings.fromJson(json);
}

/// @nodoc
class _$SettingsTearOff {
  const _$SettingsTearOff();

  _Settings call(
      {required String deviceId,
      required String deviceName,
      required bool alarmOn,
      required String deviceLocation,
      DateTime? alarmTime,
      required bool realtimeMeasuringOn,
      required bool periodicMeasuringEnabled,
      int? periodicMeasuringTimePeriod,
      List<DateTime>? measuringTimes,
      required int cleanlinessThreshold}) {
    return _Settings(
      deviceId: deviceId,
      deviceName: deviceName,
      alarmOn: alarmOn,
      deviceLocation: deviceLocation,
      alarmTime: alarmTime,
      realtimeMeasuringOn: realtimeMeasuringOn,
      periodicMeasuringEnabled: periodicMeasuringEnabled,
      periodicMeasuringTimePeriod: periodicMeasuringTimePeriod,
      measuringTimes: measuringTimes,
      cleanlinessThreshold: cleanlinessThreshold,
    );
  }

  Settings fromJson(Map<String, Object?> json) {
    return Settings.fromJson(json);
  }
}

/// @nodoc
const $Settings = _$SettingsTearOff();

/// @nodoc
mixin _$Settings {
  String get deviceId => throw _privateConstructorUsedError;
  String get deviceName => throw _privateConstructorUsedError;
  bool get alarmOn => throw _privateConstructorUsedError;
  String get deviceLocation => throw _privateConstructorUsedError;
  DateTime? get alarmTime => throw _privateConstructorUsedError;
  bool get realtimeMeasuringOn => throw _privateConstructorUsedError;
  bool get periodicMeasuringEnabled => throw _privateConstructorUsedError;
  int? get periodicMeasuringTimePeriod => throw _privateConstructorUsedError;
  List<DateTime>? get measuringTimes => throw _privateConstructorUsedError;
  int get cleanlinessThreshold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res>;
  $Res call(
      {String deviceId,
      String deviceName,
      bool alarmOn,
      String deviceLocation,
      DateTime? alarmTime,
      bool realtimeMeasuringOn,
      bool periodicMeasuringEnabled,
      int? periodicMeasuringTimePeriod,
      List<DateTime>? measuringTimes,
      int cleanlinessThreshold});
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res> implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

  final Settings _value;
  // ignore: unused_field
  final $Res Function(Settings) _then;

  @override
  $Res call({
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? alarmOn = freezed,
    Object? deviceLocation = freezed,
    Object? alarmTime = freezed,
    Object? realtimeMeasuringOn = freezed,
    Object? periodicMeasuringEnabled = freezed,
    Object? periodicMeasuringTimePeriod = freezed,
    Object? measuringTimes = freezed,
    Object? cleanlinessThreshold = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: deviceName == freezed
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      alarmOn: alarmOn == freezed
          ? _value.alarmOn
          : alarmOn // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceLocation: deviceLocation == freezed
          ? _value.deviceLocation
          : deviceLocation // ignore: cast_nullable_to_non_nullable
              as String,
      alarmTime: alarmTime == freezed
          ? _value.alarmTime
          : alarmTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      realtimeMeasuringOn: realtimeMeasuringOn == freezed
          ? _value.realtimeMeasuringOn
          : realtimeMeasuringOn // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicMeasuringEnabled: periodicMeasuringEnabled == freezed
          ? _value.periodicMeasuringEnabled
          : periodicMeasuringEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicMeasuringTimePeriod: periodicMeasuringTimePeriod == freezed
          ? _value.periodicMeasuringTimePeriod
          : periodicMeasuringTimePeriod // ignore: cast_nullable_to_non_nullable
              as int?,
      measuringTimes: measuringTimes == freezed
          ? _value.measuringTimes
          : measuringTimes // ignore: cast_nullable_to_non_nullable
              as List<DateTime>?,
      cleanlinessThreshold: cleanlinessThreshold == freezed
          ? _value.cleanlinessThreshold
          : cleanlinessThreshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) then) =
      __$SettingsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String deviceId,
      String deviceName,
      bool alarmOn,
      String deviceLocation,
      DateTime? alarmTime,
      bool realtimeMeasuringOn,
      bool periodicMeasuringEnabled,
      int? periodicMeasuringTimePeriod,
      List<DateTime>? measuringTimes,
      int cleanlinessThreshold});
}

/// @nodoc
class __$SettingsCopyWithImpl<$Res> extends _$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(_Settings _value, $Res Function(_Settings) _then)
      : super(_value, (v) => _then(v as _Settings));

  @override
  _Settings get _value => super._value as _Settings;

  @override
  $Res call({
    Object? deviceId = freezed,
    Object? deviceName = freezed,
    Object? alarmOn = freezed,
    Object? deviceLocation = freezed,
    Object? alarmTime = freezed,
    Object? realtimeMeasuringOn = freezed,
    Object? periodicMeasuringEnabled = freezed,
    Object? periodicMeasuringTimePeriod = freezed,
    Object? measuringTimes = freezed,
    Object? cleanlinessThreshold = freezed,
  }) {
    return _then(_Settings(
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      deviceName: deviceName == freezed
          ? _value.deviceName
          : deviceName // ignore: cast_nullable_to_non_nullable
              as String,
      alarmOn: alarmOn == freezed
          ? _value.alarmOn
          : alarmOn // ignore: cast_nullable_to_non_nullable
              as bool,
      deviceLocation: deviceLocation == freezed
          ? _value.deviceLocation
          : deviceLocation // ignore: cast_nullable_to_non_nullable
              as String,
      alarmTime: alarmTime == freezed
          ? _value.alarmTime
          : alarmTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      realtimeMeasuringOn: realtimeMeasuringOn == freezed
          ? _value.realtimeMeasuringOn
          : realtimeMeasuringOn // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicMeasuringEnabled: periodicMeasuringEnabled == freezed
          ? _value.periodicMeasuringEnabled
          : periodicMeasuringEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicMeasuringTimePeriod: periodicMeasuringTimePeriod == freezed
          ? _value.periodicMeasuringTimePeriod
          : periodicMeasuringTimePeriod // ignore: cast_nullable_to_non_nullable
              as int?,
      measuringTimes: measuringTimes == freezed
          ? _value.measuringTimes
          : measuringTimes // ignore: cast_nullable_to_non_nullable
              as List<DateTime>?,
      cleanlinessThreshold: cleanlinessThreshold == freezed
          ? _value.cleanlinessThreshold
          : cleanlinessThreshold // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Settings implements _Settings {
  _$_Settings(
      {required this.deviceId,
      required this.deviceName,
      required this.alarmOn,
      required this.deviceLocation,
      this.alarmTime,
      required this.realtimeMeasuringOn,
      required this.periodicMeasuringEnabled,
      this.periodicMeasuringTimePeriod,
      this.measuringTimes,
      required this.cleanlinessThreshold});

  factory _$_Settings.fromJson(Map<String, dynamic> json) =>
      _$$_SettingsFromJson(json);

  @override
  final String deviceId;
  @override
  final String deviceName;
  @override
  final bool alarmOn;
  @override
  final String deviceLocation;
  @override
  final DateTime? alarmTime;
  @override
  final bool realtimeMeasuringOn;
  @override
  final bool periodicMeasuringEnabled;
  @override
  final int? periodicMeasuringTimePeriod;
  @override
  final List<DateTime>? measuringTimes;
  @override
  final int cleanlinessThreshold;

  @override
  String toString() {
    return 'Settings(deviceId: $deviceId, deviceName: $deviceName, alarmOn: $alarmOn, deviceLocation: $deviceLocation, alarmTime: $alarmTime, realtimeMeasuringOn: $realtimeMeasuringOn, periodicMeasuringEnabled: $periodicMeasuringEnabled, periodicMeasuringTimePeriod: $periodicMeasuringTimePeriod, measuringTimes: $measuringTimes, cleanlinessThreshold: $cleanlinessThreshold)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Settings &&
            const DeepCollectionEquality().equals(other.deviceId, deviceId) &&
            const DeepCollectionEquality()
                .equals(other.deviceName, deviceName) &&
            const DeepCollectionEquality().equals(other.alarmOn, alarmOn) &&
            const DeepCollectionEquality()
                .equals(other.deviceLocation, deviceLocation) &&
            const DeepCollectionEquality().equals(other.alarmTime, alarmTime) &&
            const DeepCollectionEquality()
                .equals(other.realtimeMeasuringOn, realtimeMeasuringOn) &&
            const DeepCollectionEquality().equals(
                other.periodicMeasuringEnabled, periodicMeasuringEnabled) &&
            const DeepCollectionEquality().equals(
                other.periodicMeasuringTimePeriod,
                periodicMeasuringTimePeriod) &&
            const DeepCollectionEquality()
                .equals(other.measuringTimes, measuringTimes) &&
            const DeepCollectionEquality()
                .equals(other.cleanlinessThreshold, cleanlinessThreshold));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(deviceId),
      const DeepCollectionEquality().hash(deviceName),
      const DeepCollectionEquality().hash(alarmOn),
      const DeepCollectionEquality().hash(deviceLocation),
      const DeepCollectionEquality().hash(alarmTime),
      const DeepCollectionEquality().hash(realtimeMeasuringOn),
      const DeepCollectionEquality().hash(periodicMeasuringEnabled),
      const DeepCollectionEquality().hash(periodicMeasuringTimePeriod),
      const DeepCollectionEquality().hash(measuringTimes),
      const DeepCollectionEquality().hash(cleanlinessThreshold));

  @JsonKey(ignore: true)
  @override
  _$SettingsCopyWith<_Settings> get copyWith =>
      __$SettingsCopyWithImpl<_Settings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SettingsToJson(this);
  }
}

abstract class _Settings implements Settings {
  factory _Settings(
      {required String deviceId,
      required String deviceName,
      required bool alarmOn,
      required String deviceLocation,
      DateTime? alarmTime,
      required bool realtimeMeasuringOn,
      required bool periodicMeasuringEnabled,
      int? periodicMeasuringTimePeriod,
      List<DateTime>? measuringTimes,
      required int cleanlinessThreshold}) = _$_Settings;

  factory _Settings.fromJson(Map<String, dynamic> json) = _$_Settings.fromJson;

  @override
  String get deviceId;
  @override
  String get deviceName;
  @override
  bool get alarmOn;
  @override
  String get deviceLocation;
  @override
  DateTime? get alarmTime;
  @override
  bool get realtimeMeasuringOn;
  @override
  bool get periodicMeasuringEnabled;
  @override
  int? get periodicMeasuringTimePeriod;
  @override
  List<DateTime>? get measuringTimes;
  @override
  int get cleanlinessThreshold;
  @override
  @JsonKey(ignore: true)
  _$SettingsCopyWith<_Settings> get copyWith =>
      throw _privateConstructorUsedError;
}
