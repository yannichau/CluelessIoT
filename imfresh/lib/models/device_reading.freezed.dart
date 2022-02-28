// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'device_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DeviceReading _$DeviceReadingFromJson(Map<String, dynamic> json) {
  return _DeviceReading.fromJson(json);
}

/// @nodoc
class _$DeviceReadingTearOff {
  const _$DeviceReadingTearOff();

  _DeviceReading call(
      {required String type,
      required DateTime timestamp,
      required DateTime nextWash,
      required String deviceId,
      required double humidity,
      required double temperature,
      required double VOC}) {
    return _DeviceReading(
      type: type,
      timestamp: timestamp,
      nextWash: nextWash,
      deviceId: deviceId,
      humidity: humidity,
      temperature: temperature,
      VOC: VOC,
    );
  }

  DeviceReading fromJson(Map<String, Object?> json) {
    return DeviceReading.fromJson(json);
  }
}

/// @nodoc
const $DeviceReading = _$DeviceReadingTearOff();

/// @nodoc
mixin _$DeviceReading {
  String get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime get nextWash => throw _privateConstructorUsedError;
  String get deviceId => throw _privateConstructorUsedError;
  double get humidity => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  double get VOC => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceReadingCopyWith<DeviceReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceReadingCopyWith<$Res> {
  factory $DeviceReadingCopyWith(
          DeviceReading value, $Res Function(DeviceReading) then) =
      _$DeviceReadingCopyWithImpl<$Res>;
  $Res call(
      {String type,
      DateTime timestamp,
      DateTime nextWash,
      String deviceId,
      double humidity,
      double temperature,
      double VOC});
}

/// @nodoc
class _$DeviceReadingCopyWithImpl<$Res>
    implements $DeviceReadingCopyWith<$Res> {
  _$DeviceReadingCopyWithImpl(this._value, this._then);

  final DeviceReading _value;
  // ignore: unused_field
  final $Res Function(DeviceReading) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? timestamp = freezed,
    Object? nextWash = freezed,
    Object? deviceId = freezed,
    Object? humidity = freezed,
    Object? temperature = freezed,
    Object? VOC = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextWash: nextWash == freezed
          ? _value.nextWash
          : nextWash // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      humidity: humidity == freezed
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as double,
      temperature: temperature == freezed
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      VOC: VOC == freezed
          ? _value.VOC
          : VOC // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$DeviceReadingCopyWith<$Res>
    implements $DeviceReadingCopyWith<$Res> {
  factory _$DeviceReadingCopyWith(
          _DeviceReading value, $Res Function(_DeviceReading) then) =
      __$DeviceReadingCopyWithImpl<$Res>;
  @override
  $Res call(
      {String type,
      DateTime timestamp,
      DateTime nextWash,
      String deviceId,
      double humidity,
      double temperature,
      double VOC});
}

/// @nodoc
class __$DeviceReadingCopyWithImpl<$Res>
    extends _$DeviceReadingCopyWithImpl<$Res>
    implements _$DeviceReadingCopyWith<$Res> {
  __$DeviceReadingCopyWithImpl(
      _DeviceReading _value, $Res Function(_DeviceReading) _then)
      : super(_value, (v) => _then(v as _DeviceReading));

  @override
  _DeviceReading get _value => super._value as _DeviceReading;

  @override
  $Res call({
    Object? type = freezed,
    Object? timestamp = freezed,
    Object? nextWash = freezed,
    Object? deviceId = freezed,
    Object? humidity = freezed,
    Object? temperature = freezed,
    Object? VOC = freezed,
  }) {
    return _then(_DeviceReading(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextWash: nextWash == freezed
          ? _value.nextWash
          : nextWash // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      humidity: humidity == freezed
          ? _value.humidity
          : humidity // ignore: cast_nullable_to_non_nullable
              as double,
      temperature: temperature == freezed
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      VOC: VOC == freezed
          ? _value.VOC
          : VOC // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_DeviceReading implements _DeviceReading {
  _$_DeviceReading(
      {required this.type,
      required this.timestamp,
      required this.nextWash,
      required this.deviceId,
      required this.humidity,
      required this.temperature,
      required this.VOC});

  factory _$_DeviceReading.fromJson(Map<String, dynamic> json) =>
      _$$_DeviceReadingFromJson(json);

  @override
  final String type;
  @override
  final DateTime timestamp;
  @override
  final DateTime nextWash;
  @override
  final String deviceId;
  @override
  final double humidity;
  @override
  final double temperature;
  @override
  final double VOC;

  @override
  String toString() {
    return 'DeviceReading(type: $type, timestamp: $timestamp, nextWash: $nextWash, deviceId: $deviceId, humidity: $humidity, temperature: $temperature, VOC: $VOC)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DeviceReading &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.timestamp, timestamp) &&
            const DeepCollectionEquality().equals(other.nextWash, nextWash) &&
            const DeepCollectionEquality().equals(other.deviceId, deviceId) &&
            const DeepCollectionEquality().equals(other.humidity, humidity) &&
            const DeepCollectionEquality()
                .equals(other.temperature, temperature) &&
            const DeepCollectionEquality().equals(other.VOC, VOC));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(timestamp),
      const DeepCollectionEquality().hash(nextWash),
      const DeepCollectionEquality().hash(deviceId),
      const DeepCollectionEquality().hash(humidity),
      const DeepCollectionEquality().hash(temperature),
      const DeepCollectionEquality().hash(VOC));

  @JsonKey(ignore: true)
  @override
  _$DeviceReadingCopyWith<_DeviceReading> get copyWith =>
      __$DeviceReadingCopyWithImpl<_DeviceReading>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DeviceReadingToJson(this);
  }
}

abstract class _DeviceReading implements DeviceReading {
  factory _DeviceReading(
      {required String type,
      required DateTime timestamp,
      required DateTime nextWash,
      required String deviceId,
      required double humidity,
      required double temperature,
      required double VOC}) = _$_DeviceReading;

  factory _DeviceReading.fromJson(Map<String, dynamic> json) =
      _$_DeviceReading.fromJson;

  @override
  String get type;
  @override
  DateTime get timestamp;
  @override
  DateTime get nextWash;
  @override
  String get deviceId;
  @override
  double get humidity;
  @override
  double get temperature;
  @override
  double get VOC;
  @override
  @JsonKey(ignore: true)
  _$DeviceReadingCopyWith<_DeviceReading> get copyWith =>
      throw _privateConstructorUsedError;
}
