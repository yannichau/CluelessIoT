// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'periodic_reading.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PeriodicReading _$PeriodicReadingFromJson(Map<String, dynamic> json) {
  return _PeriodicReading.fromJson(json);
}

/// @nodoc
class _$PeriodicReadingTearOff {
  const _$PeriodicReadingTearOff();

  _PeriodicReading call(
      {required DateTime timestamp,
      required DateTime nextWash,
      required String deviceID,
      required double humidity,
      required double temperature,
      required double VOC}) {
    return _PeriodicReading(
      timestamp: timestamp,
      nextWash: nextWash,
      deviceID: deviceID,
      humidity: humidity,
      temperature: temperature,
      VOC: VOC,
    );
  }

  PeriodicReading fromJson(Map<String, Object?> json) {
    return PeriodicReading.fromJson(json);
  }
}

/// @nodoc
const $PeriodicReading = _$PeriodicReadingTearOff();

/// @nodoc
mixin _$PeriodicReading {
  DateTime get timestamp => throw _privateConstructorUsedError;
  DateTime get nextWash => throw _privateConstructorUsedError;
  String get deviceID => throw _privateConstructorUsedError;
  double get humidity => throw _privateConstructorUsedError;
  double get temperature => throw _privateConstructorUsedError;
  double get VOC => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PeriodicReadingCopyWith<PeriodicReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PeriodicReadingCopyWith<$Res> {
  factory $PeriodicReadingCopyWith(
          PeriodicReading value, $Res Function(PeriodicReading) then) =
      _$PeriodicReadingCopyWithImpl<$Res>;
  $Res call(
      {DateTime timestamp,
      DateTime nextWash,
      String deviceID,
      double humidity,
      double temperature,
      double VOC});
}

/// @nodoc
class _$PeriodicReadingCopyWithImpl<$Res>
    implements $PeriodicReadingCopyWith<$Res> {
  _$PeriodicReadingCopyWithImpl(this._value, this._then);

  final PeriodicReading _value;
  // ignore: unused_field
  final $Res Function(PeriodicReading) _then;

  @override
  $Res call({
    Object? timestamp = freezed,
    Object? nextWash = freezed,
    Object? deviceID = freezed,
    Object? humidity = freezed,
    Object? temperature = freezed,
    Object? VOC = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextWash: nextWash == freezed
          ? _value.nextWash
          : nextWash // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deviceID: deviceID == freezed
          ? _value.deviceID
          : deviceID // ignore: cast_nullable_to_non_nullable
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
abstract class _$PeriodicReadingCopyWith<$Res>
    implements $PeriodicReadingCopyWith<$Res> {
  factory _$PeriodicReadingCopyWith(
          _PeriodicReading value, $Res Function(_PeriodicReading) then) =
      __$PeriodicReadingCopyWithImpl<$Res>;
  @override
  $Res call(
      {DateTime timestamp,
      DateTime nextWash,
      String deviceID,
      double humidity,
      double temperature,
      double VOC});
}

/// @nodoc
class __$PeriodicReadingCopyWithImpl<$Res>
    extends _$PeriodicReadingCopyWithImpl<$Res>
    implements _$PeriodicReadingCopyWith<$Res> {
  __$PeriodicReadingCopyWithImpl(
      _PeriodicReading _value, $Res Function(_PeriodicReading) _then)
      : super(_value, (v) => _then(v as _PeriodicReading));

  @override
  _PeriodicReading get _value => super._value as _PeriodicReading;

  @override
  $Res call({
    Object? timestamp = freezed,
    Object? nextWash = freezed,
    Object? deviceID = freezed,
    Object? humidity = freezed,
    Object? temperature = freezed,
    Object? VOC = freezed,
  }) {
    return _then(_PeriodicReading(
      timestamp: timestamp == freezed
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextWash: nextWash == freezed
          ? _value.nextWash
          : nextWash // ignore: cast_nullable_to_non_nullable
              as DateTime,
      deviceID: deviceID == freezed
          ? _value.deviceID
          : deviceID // ignore: cast_nullable_to_non_nullable
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
class _$_PeriodicReading implements _PeriodicReading {
  _$_PeriodicReading(
      {required this.timestamp,
      required this.nextWash,
      required this.deviceID,
      required this.humidity,
      required this.temperature,
      required this.VOC});

  factory _$_PeriodicReading.fromJson(Map<String, dynamic> json) =>
      _$$_PeriodicReadingFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final DateTime nextWash;
  @override
  final String deviceID;
  @override
  final double humidity;
  @override
  final double temperature;
  @override
  final double VOC;

  @override
  String toString() {
    return 'PeriodicReading(timestamp: $timestamp, nextWash: $nextWash, deviceID: $deviceID, humidity: $humidity, temperature: $temperature, VOC: $VOC)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PeriodicReading &&
            const DeepCollectionEquality().equals(other.timestamp, timestamp) &&
            const DeepCollectionEquality().equals(other.nextWash, nextWash) &&
            const DeepCollectionEquality().equals(other.deviceID, deviceID) &&
            const DeepCollectionEquality().equals(other.humidity, humidity) &&
            const DeepCollectionEquality()
                .equals(other.temperature, temperature) &&
            const DeepCollectionEquality().equals(other.VOC, VOC));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(timestamp),
      const DeepCollectionEquality().hash(nextWash),
      const DeepCollectionEquality().hash(deviceID),
      const DeepCollectionEquality().hash(humidity),
      const DeepCollectionEquality().hash(temperature),
      const DeepCollectionEquality().hash(VOC));

  @JsonKey(ignore: true)
  @override
  _$PeriodicReadingCopyWith<_PeriodicReading> get copyWith =>
      __$PeriodicReadingCopyWithImpl<_PeriodicReading>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PeriodicReadingToJson(this);
  }
}

abstract class _PeriodicReading implements PeriodicReading {
  factory _PeriodicReading(
      {required DateTime timestamp,
      required DateTime nextWash,
      required String deviceID,
      required double humidity,
      required double temperature,
      required double VOC}) = _$_PeriodicReading;

  factory _PeriodicReading.fromJson(Map<String, dynamic> json) =
      _$_PeriodicReading.fromJson;

  @override
  DateTime get timestamp;
  @override
  DateTime get nextWash;
  @override
  String get deviceID;
  @override
  double get humidity;
  @override
  double get temperature;
  @override
  double get VOC;
  @override
  @JsonKey(ignore: true)
  _$PeriodicReadingCopyWith<_PeriodicReading> get copyWith =>
      throw _privateConstructorUsedError;
}
