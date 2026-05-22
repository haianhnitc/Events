// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timeline_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TimelineDataModel _$TimelineDataModelFromJson(Map<String, dynamic> json) {
  return _TimelineDataModel.fromJson(json);
}

/// @nodoc
mixin _$TimelineDataModel {
  String? get time => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimelineDataModelCopyWith<TimelineDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineDataModelCopyWith<$Res> {
  factory $TimelineDataModelCopyWith(
          TimelineDataModel value, $Res Function(TimelineDataModel) then) =
      _$TimelineDataModelCopyWithImpl<$Res, TimelineDataModel>;
  @useResult
  $Res call({String? time, int? count});
}

/// @nodoc
class _$TimelineDataModelCopyWithImpl<$Res, $Val extends TimelineDataModel>
    implements $TimelineDataModelCopyWith<$Res> {
  _$TimelineDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = freezed,
    Object? count = freezed,
  }) {
    return _then(_value.copyWith(
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelineDataModelImplCopyWith<$Res>
    implements $TimelineDataModelCopyWith<$Res> {
  factory _$$TimelineDataModelImplCopyWith(_$TimelineDataModelImpl value,
          $Res Function(_$TimelineDataModelImpl) then) =
      __$$TimelineDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? time, int? count});
}

/// @nodoc
class __$$TimelineDataModelImplCopyWithImpl<$Res>
    extends _$TimelineDataModelCopyWithImpl<$Res, _$TimelineDataModelImpl>
    implements _$$TimelineDataModelImplCopyWith<$Res> {
  __$$TimelineDataModelImplCopyWithImpl(_$TimelineDataModelImpl _value,
      $Res Function(_$TimelineDataModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = freezed,
    Object? count = freezed,
  }) {
    return _then(_$TimelineDataModelImpl(
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineDataModelImpl implements _TimelineDataModel {
  const _$TimelineDataModelImpl({this.time, this.count});

  factory _$TimelineDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineDataModelImplFromJson(json);

  @override
  final String? time;
  @override
  final int? count;

  @override
  String toString() {
    return 'TimelineDataModel(time: $time, count: $count)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineDataModelImpl &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.count, count) || other.count == count));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, time, count);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineDataModelImplCopyWith<_$TimelineDataModelImpl> get copyWith =>
      __$$TimelineDataModelImplCopyWithImpl<_$TimelineDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineDataModelImplToJson(
      this,
    );
  }
}

abstract class _TimelineDataModel implements TimelineDataModel {
  const factory _TimelineDataModel({final String? time, final int? count}) =
      _$TimelineDataModelImpl;

  factory _TimelineDataModel.fromJson(Map<String, dynamic> json) =
      _$TimelineDataModelImpl.fromJson;

  @override
  String? get time;
  @override
  int? get count;
  @override
  @JsonKey(ignore: true)
  _$$TimelineDataModelImplCopyWith<_$TimelineDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
