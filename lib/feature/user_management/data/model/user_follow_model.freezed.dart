// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_follow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserFollowModel _$UserFollowModelFromJson(Map<String, dynamic> json) {
  return _UserFollowModel.fromJson(json);
}

/// @nodoc
mixin _$UserFollowModel {
  int? get followerId => throw _privateConstructorUsedError;
  int? get followingId => throw _privateConstructorUsedError;
  DateTime? get updatedTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserFollowModelCopyWith<UserFollowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFollowModelCopyWith<$Res> {
  factory $UserFollowModelCopyWith(
          UserFollowModel value, $Res Function(UserFollowModel) then) =
      _$UserFollowModelCopyWithImpl<$Res, UserFollowModel>;
  @useResult
  $Res call({int? followerId, int? followingId, DateTime? updatedTime});
}

/// @nodoc
class _$UserFollowModelCopyWithImpl<$Res, $Val extends UserFollowModel>
    implements $UserFollowModelCopyWith<$Res> {
  _$UserFollowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followerId = freezed,
    Object? followingId = freezed,
    Object? updatedTime = freezed,
  }) {
    return _then(_value.copyWith(
      followerId: freezed == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as int?,
      followingId: freezed == followingId
          ? _value.followingId
          : followingId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedTime: freezed == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserFollowModelImplCopyWith<$Res>
    implements $UserFollowModelCopyWith<$Res> {
  factory _$$UserFollowModelImplCopyWith(_$UserFollowModelImpl value,
          $Res Function(_$UserFollowModelImpl) then) =
      __$$UserFollowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? followerId, int? followingId, DateTime? updatedTime});
}

/// @nodoc
class __$$UserFollowModelImplCopyWithImpl<$Res>
    extends _$UserFollowModelCopyWithImpl<$Res, _$UserFollowModelImpl>
    implements _$$UserFollowModelImplCopyWith<$Res> {
  __$$UserFollowModelImplCopyWithImpl(
      _$UserFollowModelImpl _value, $Res Function(_$UserFollowModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? followerId = freezed,
    Object? followingId = freezed,
    Object? updatedTime = freezed,
  }) {
    return _then(_$UserFollowModelImpl(
      followerId: freezed == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as int?,
      followingId: freezed == followingId
          ? _value.followingId
          : followingId // ignore: cast_nullable_to_non_nullable
              as int?,
      updatedTime: freezed == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserFollowModelImpl implements _UserFollowModel {
  const _$UserFollowModelImpl(
      {this.followerId, this.followingId, this.updatedTime});

  factory _$UserFollowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserFollowModelImplFromJson(json);

  @override
  final int? followerId;
  @override
  final int? followingId;
  @override
  final DateTime? updatedTime;

  @override
  String toString() {
    return 'UserFollowModel(followerId: $followerId, followingId: $followingId, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserFollowModelImpl &&
            (identical(other.followerId, followerId) ||
                other.followerId == followerId) &&
            (identical(other.followingId, followingId) ||
                other.followingId == followingId) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, followerId, followingId, updatedTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserFollowModelImplCopyWith<_$UserFollowModelImpl> get copyWith =>
      __$$UserFollowModelImplCopyWithImpl<_$UserFollowModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserFollowModelImplToJson(
      this,
    );
  }
}

abstract class _UserFollowModel implements UserFollowModel {
  const factory _UserFollowModel(
      {final int? followerId,
      final int? followingId,
      final DateTime? updatedTime}) = _$UserFollowModelImpl;

  factory _UserFollowModel.fromJson(Map<String, dynamic> json) =
      _$UserFollowModelImpl.fromJson;

  @override
  int? get followerId;
  @override
  int? get followingId;
  @override
  DateTime? get updatedTime;
  @override
  @JsonKey(ignore: true)
  _$$UserFollowModelImplCopyWith<_$UserFollowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
