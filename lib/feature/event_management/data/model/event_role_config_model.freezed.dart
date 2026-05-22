// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_role_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventRoleConfigModel _$EventRoleConfigModelFromJson(Map<String, dynamic> json) {
  return _EventRoleConfigModel.fromJson(json);
}

/// @nodoc
mixin _$EventRoleConfigModel {
  int? get eventRoleConfigId => throw _privateConstructorUsedError;
  int? get eventId => throw _privateConstructorUsedError;
  EventRoleType? get roleType => throw _privateConstructorUsedError;
  int? get coinReward => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventRoleConfigModelCopyWith<EventRoleConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventRoleConfigModelCopyWith<$Res> {
  factory $EventRoleConfigModelCopyWith(EventRoleConfigModel value,
          $Res Function(EventRoleConfigModel) then) =
      _$EventRoleConfigModelCopyWithImpl<$Res, EventRoleConfigModel>;
  @useResult
  $Res call(
      {int? eventRoleConfigId,
      int? eventId,
      EventRoleType? roleType,
      int? coinReward});
}

/// @nodoc
class _$EventRoleConfigModelCopyWithImpl<$Res,
        $Val extends EventRoleConfigModel>
    implements $EventRoleConfigModelCopyWith<$Res> {
  _$EventRoleConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventRoleConfigId = freezed,
    Object? eventId = freezed,
    Object? roleType = freezed,
    Object? coinReward = freezed,
  }) {
    return _then(_value.copyWith(
      eventRoleConfigId: freezed == eventRoleConfigId
          ? _value.eventRoleConfigId
          : eventRoleConfigId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      roleType: freezed == roleType
          ? _value.roleType
          : roleType // ignore: cast_nullable_to_non_nullable
              as EventRoleType?,
      coinReward: freezed == coinReward
          ? _value.coinReward
          : coinReward // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventRoleConfigModelImplCopyWith<$Res>
    implements $EventRoleConfigModelCopyWith<$Res> {
  factory _$$EventRoleConfigModelImplCopyWith(_$EventRoleConfigModelImpl value,
          $Res Function(_$EventRoleConfigModelImpl) then) =
      __$$EventRoleConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? eventRoleConfigId,
      int? eventId,
      EventRoleType? roleType,
      int? coinReward});
}

/// @nodoc
class __$$EventRoleConfigModelImplCopyWithImpl<$Res>
    extends _$EventRoleConfigModelCopyWithImpl<$Res, _$EventRoleConfigModelImpl>
    implements _$$EventRoleConfigModelImplCopyWith<$Res> {
  __$$EventRoleConfigModelImplCopyWithImpl(_$EventRoleConfigModelImpl _value,
      $Res Function(_$EventRoleConfigModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventRoleConfigId = freezed,
    Object? eventId = freezed,
    Object? roleType = freezed,
    Object? coinReward = freezed,
  }) {
    return _then(_$EventRoleConfigModelImpl(
      eventRoleConfigId: freezed == eventRoleConfigId
          ? _value.eventRoleConfigId
          : eventRoleConfigId // ignore: cast_nullable_to_non_nullable
              as int?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
      roleType: freezed == roleType
          ? _value.roleType
          : roleType // ignore: cast_nullable_to_non_nullable
              as EventRoleType?,
      coinReward: freezed == coinReward
          ? _value.coinReward
          : coinReward // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventRoleConfigModelImpl implements _EventRoleConfigModel {
  const _$EventRoleConfigModelImpl(
      {this.eventRoleConfigId,
      this.eventId,
      this.roleType,
      this.coinReward = 0});

  factory _$EventRoleConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventRoleConfigModelImplFromJson(json);

  @override
  final int? eventRoleConfigId;
  @override
  final int? eventId;
  @override
  final EventRoleType? roleType;
  @override
  @JsonKey()
  final int? coinReward;

  @override
  String toString() {
    return 'EventRoleConfigModel(eventRoleConfigId: $eventRoleConfigId, eventId: $eventId, roleType: $roleType, coinReward: $coinReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventRoleConfigModelImpl &&
            (identical(other.eventRoleConfigId, eventRoleConfigId) ||
                other.eventRoleConfigId == eventRoleConfigId) &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            (identical(other.roleType, roleType) ||
                other.roleType == roleType) &&
            (identical(other.coinReward, coinReward) ||
                other.coinReward == coinReward));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, eventRoleConfigId, eventId, roleType, coinReward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventRoleConfigModelImplCopyWith<_$EventRoleConfigModelImpl>
      get copyWith =>
          __$$EventRoleConfigModelImplCopyWithImpl<_$EventRoleConfigModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventRoleConfigModelImplToJson(
      this,
    );
  }
}

abstract class _EventRoleConfigModel implements EventRoleConfigModel {
  const factory _EventRoleConfigModel(
      {final int? eventRoleConfigId,
      final int? eventId,
      final EventRoleType? roleType,
      final int? coinReward}) = _$EventRoleConfigModelImpl;

  factory _EventRoleConfigModel.fromJson(Map<String, dynamic> json) =
      _$EventRoleConfigModelImpl.fromJson;

  @override
  int? get eventRoleConfigId;
  @override
  int? get eventId;
  @override
  EventRoleType? get roleType;
  @override
  int? get coinReward;
  @override
  @JsonKey(ignore: true)
  _$$EventRoleConfigModelImplCopyWith<_$EventRoleConfigModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
