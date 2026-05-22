// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserNotificationModel _$UserNotificationModelFromJson(
    Map<String, dynamic> json) {
  return _UserNotificationModel.fromJson(json);
}

/// @nodoc
mixin _$UserNotificationModel {
  int? get userNotificationId => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  int? get notificationId => throw _privateConstructorUsedError;
  bool? get isRead => throw _privateConstructorUsedError;
  bool? get isDeleted => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserNotificationModelCopyWith<UserNotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserNotificationModelCopyWith<$Res> {
  factory $UserNotificationModelCopyWith(UserNotificationModel value,
          $Res Function(UserNotificationModel) then) =
      _$UserNotificationModelCopyWithImpl<$Res, UserNotificationModel>;
  @useResult
  $Res call(
      {int? userNotificationId,
      int? userId,
      int? notificationId,
      bool? isRead,
      bool? isDeleted,
      DateTime? createdTime,
      DateTime? deletedAt});
}

/// @nodoc
class _$UserNotificationModelCopyWithImpl<$Res,
        $Val extends UserNotificationModel>
    implements $UserNotificationModelCopyWith<$Res> {
  _$UserNotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userNotificationId = freezed,
    Object? userId = freezed,
    Object? notificationId = freezed,
    Object? isRead = freezed,
    Object? isDeleted = freezed,
    Object? createdTime = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userNotificationId: freezed == userNotificationId
          ? _value.userNotificationId
          : userNotificationId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int?,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDeleted: freezed == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserNotificationModelImplCopyWith<$Res>
    implements $UserNotificationModelCopyWith<$Res> {
  factory _$$UserNotificationModelImplCopyWith(
          _$UserNotificationModelImpl value,
          $Res Function(_$UserNotificationModelImpl) then) =
      __$$UserNotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? userNotificationId,
      int? userId,
      int? notificationId,
      bool? isRead,
      bool? isDeleted,
      DateTime? createdTime,
      DateTime? deletedAt});
}

/// @nodoc
class __$$UserNotificationModelImplCopyWithImpl<$Res>
    extends _$UserNotificationModelCopyWithImpl<$Res,
        _$UserNotificationModelImpl>
    implements _$$UserNotificationModelImplCopyWith<$Res> {
  __$$UserNotificationModelImplCopyWithImpl(_$UserNotificationModelImpl _value,
      $Res Function(_$UserNotificationModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userNotificationId = freezed,
    Object? userId = freezed,
    Object? notificationId = freezed,
    Object? isRead = freezed,
    Object? isDeleted = freezed,
    Object? createdTime = freezed,
    Object? deletedAt = freezed,
  }) {
    return _then(_$UserNotificationModelImpl(
      userNotificationId: freezed == userNotificationId
          ? _value.userNotificationId
          : userNotificationId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      notificationId: freezed == notificationId
          ? _value.notificationId
          : notificationId // ignore: cast_nullable_to_non_nullable
              as int?,
      isRead: freezed == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool?,
      isDeleted: freezed == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserNotificationModelImpl implements _UserNotificationModel {
  const _$UserNotificationModelImpl(
      {this.userNotificationId,
      this.userId,
      this.notificationId,
      this.isRead,
      this.isDeleted,
      this.createdTime,
      this.deletedAt});

  factory _$UserNotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserNotificationModelImplFromJson(json);

  @override
  final int? userNotificationId;
  @override
  final int? userId;
  @override
  final int? notificationId;
  @override
  final bool? isRead;
  @override
  final bool? isDeleted;
  @override
  final DateTime? createdTime;
  @override
  final DateTime? deletedAt;

  @override
  String toString() {
    return 'UserNotificationModel(userNotificationId: $userNotificationId, userId: $userId, notificationId: $notificationId, isRead: $isRead, isDeleted: $isDeleted, createdTime: $createdTime, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserNotificationModelImpl &&
            (identical(other.userNotificationId, userNotificationId) ||
                other.userNotificationId == userNotificationId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.notificationId, notificationId) ||
                other.notificationId == notificationId) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userNotificationId, userId,
      notificationId, isRead, isDeleted, createdTime, deletedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserNotificationModelImplCopyWith<_$UserNotificationModelImpl>
      get copyWith => __$$UserNotificationModelImplCopyWithImpl<
          _$UserNotificationModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserNotificationModelImplToJson(
      this,
    );
  }
}

abstract class _UserNotificationModel implements UserNotificationModel {
  const factory _UserNotificationModel(
      {final int? userNotificationId,
      final int? userId,
      final int? notificationId,
      final bool? isRead,
      final bool? isDeleted,
      final DateTime? createdTime,
      final DateTime? deletedAt}) = _$UserNotificationModelImpl;

  factory _UserNotificationModel.fromJson(Map<String, dynamic> json) =
      _$UserNotificationModelImpl.fromJson;

  @override
  int? get userNotificationId;
  @override
  int? get userId;
  @override
  int? get notificationId;
  @override
  bool? get isRead;
  @override
  bool? get isDeleted;
  @override
  DateTime? get createdTime;
  @override
  DateTime? get deletedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserNotificationModelImplCopyWith<_$UserNotificationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
