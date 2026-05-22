// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSummaryModel _$UserSummaryModelFromJson(Map<String, dynamic> json) {
  return _UserSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$UserSummaryModel {
  int? get userId => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get avatarUrl => throw _privateConstructorUsedError;
  UserRole? get role => throw _privateConstructorUsedError;
  UserStatus? get status => throw _privateConstructorUsedError;
  DateTime? get joinedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSummaryModelCopyWith<UserSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSummaryModelCopyWith<$Res> {
  factory $UserSummaryModelCopyWith(
          UserSummaryModel value, $Res Function(UserSummaryModel) then) =
      _$UserSummaryModelCopyWithImpl<$Res, UserSummaryModel>;
  @useResult
  $Res call(
      {int? userId,
      String? fullName,
      String? email,
      String? avatarUrl,
      UserRole? role,
      UserStatus? status,
      DateTime? joinedAt});
}

/// @nodoc
class _$UserSummaryModelCopyWithImpl<$Res, $Val extends UserSummaryModel>
    implements $UserSummaryModelCopyWith<$Res> {
  _$UserSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? joinedAt = freezed,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus?,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSummaryModelImplCopyWith<$Res>
    implements $UserSummaryModelCopyWith<$Res> {
  factory _$$UserSummaryModelImplCopyWith(_$UserSummaryModelImpl value,
          $Res Function(_$UserSummaryModelImpl) then) =
      __$$UserSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? userId,
      String? fullName,
      String? email,
      String? avatarUrl,
      UserRole? role,
      UserStatus? status,
      DateTime? joinedAt});
}

/// @nodoc
class __$$UserSummaryModelImplCopyWithImpl<$Res>
    extends _$UserSummaryModelCopyWithImpl<$Res, _$UserSummaryModelImpl>
    implements _$$UserSummaryModelImplCopyWith<$Res> {
  __$$UserSummaryModelImplCopyWithImpl(_$UserSummaryModelImpl _value,
      $Res Function(_$UserSummaryModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? avatarUrl = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? joinedAt = freezed,
  }) {
    return _then(_$UserSummaryModelImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus?,
      joinedAt: freezed == joinedAt
          ? _value.joinedAt
          : joinedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSummaryModelImpl implements _UserSummaryModel {
  const _$UserSummaryModelImpl(
      {this.userId,
      this.fullName,
      this.email,
      this.avatarUrl,
      this.role,
      this.status,
      this.joinedAt});

  factory _$UserSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSummaryModelImplFromJson(json);

  @override
  final int? userId;
  @override
  final String? fullName;
  @override
  final String? email;
  @override
  final String? avatarUrl;
  @override
  final UserRole? role;
  @override
  final UserStatus? status;
  @override
  final DateTime? joinedAt;

  @override
  String toString() {
    return 'UserSummaryModel(userId: $userId, fullName: $fullName, email: $email, avatarUrl: $avatarUrl, role: $role, status: $status, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSummaryModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, userId, fullName, email, avatarUrl, role, status, joinedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSummaryModelImplCopyWith<_$UserSummaryModelImpl> get copyWith =>
      __$$UserSummaryModelImplCopyWithImpl<_$UserSummaryModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSummaryModelImplToJson(
      this,
    );
  }
}

abstract class _UserSummaryModel implements UserSummaryModel {
  const factory _UserSummaryModel(
      {final int? userId,
      final String? fullName,
      final String? email,
      final String? avatarUrl,
      final UserRole? role,
      final UserStatus? status,
      final DateTime? joinedAt}) = _$UserSummaryModelImpl;

  factory _UserSummaryModel.fromJson(Map<String, dynamic> json) =
      _$UserSummaryModelImpl.fromJson;

  @override
  int? get userId;
  @override
  String? get fullName;
  @override
  String? get email;
  @override
  String? get avatarUrl;
  @override
  UserRole? get role;
  @override
  UserStatus? get status;
  @override
  DateTime? get joinedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserSummaryModelImplCopyWith<_$UserSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
