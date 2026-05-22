// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OrganizationProfileModel _$OrganizationProfileModelFromJson(
    Map<String, dynamic> json) {
  return _OrganizationProfileModel.fromJson(json);
}

/// @nodoc
mixin _$OrganizationProfileModel {
  int? get userId => throw _privateConstructorUsedError;
  String? get organizationName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  OrganizationType? get organizationType => throw _privateConstructorUsedError;
  String? get logoUrl => throw _privateConstructorUsedError;
  VerificationStatus? get verificationStatus =>
      throw _privateConstructorUsedError;
  DateTime? get verifiedTime => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrganizationProfileModelCopyWith<OrganizationProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrganizationProfileModelCopyWith<$Res> {
  factory $OrganizationProfileModelCopyWith(OrganizationProfileModel value,
          $Res Function(OrganizationProfileModel) then) =
      _$OrganizationProfileModelCopyWithImpl<$Res, OrganizationProfileModel>;
  @useResult
  $Res call(
      {int? userId,
      String? organizationName,
      String? description,
      OrganizationType? organizationType,
      String? logoUrl,
      VerificationStatus? verificationStatus,
      DateTime? verifiedTime,
      String? address});
}

/// @nodoc
class _$OrganizationProfileModelCopyWithImpl<$Res,
        $Val extends OrganizationProfileModel>
    implements $OrganizationProfileModelCopyWith<$Res> {
  _$OrganizationProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? organizationName = freezed,
    Object? description = freezed,
    Object? organizationType = freezed,
    Object? logoUrl = freezed,
    Object? verificationStatus = freezed,
    Object? verifiedTime = freezed,
    Object? address = freezed,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationType: freezed == organizationType
          ? _value.organizationType
          : organizationType // ignore: cast_nullable_to_non_nullable
              as OrganizationType?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus?,
      verifiedTime: freezed == verifiedTime
          ? _value.verifiedTime
          : verifiedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrganizationProfileModelImplCopyWith<$Res>
    implements $OrganizationProfileModelCopyWith<$Res> {
  factory _$$OrganizationProfileModelImplCopyWith(
          _$OrganizationProfileModelImpl value,
          $Res Function(_$OrganizationProfileModelImpl) then) =
      __$$OrganizationProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? userId,
      String? organizationName,
      String? description,
      OrganizationType? organizationType,
      String? logoUrl,
      VerificationStatus? verificationStatus,
      DateTime? verifiedTime,
      String? address});
}

/// @nodoc
class __$$OrganizationProfileModelImplCopyWithImpl<$Res>
    extends _$OrganizationProfileModelCopyWithImpl<$Res,
        _$OrganizationProfileModelImpl>
    implements _$$OrganizationProfileModelImplCopyWith<$Res> {
  __$$OrganizationProfileModelImplCopyWithImpl(
      _$OrganizationProfileModelImpl _value,
      $Res Function(_$OrganizationProfileModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? organizationName = freezed,
    Object? description = freezed,
    Object? organizationType = freezed,
    Object? logoUrl = freezed,
    Object? verificationStatus = freezed,
    Object? verifiedTime = freezed,
    Object? address = freezed,
  }) {
    return _then(_$OrganizationProfileModelImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationType: freezed == organizationType
          ? _value.organizationType
          : organizationType // ignore: cast_nullable_to_non_nullable
              as OrganizationType?,
      logoUrl: freezed == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      verificationStatus: freezed == verificationStatus
          ? _value.verificationStatus
          : verificationStatus // ignore: cast_nullable_to_non_nullable
              as VerificationStatus?,
      verifiedTime: freezed == verifiedTime
          ? _value.verifiedTime
          : verifiedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrganizationProfileModelImpl implements _OrganizationProfileModel {
  const _$OrganizationProfileModelImpl(
      {this.userId,
      this.organizationName,
      this.description,
      this.organizationType,
      this.logoUrl,
      this.verificationStatus,
      this.verifiedTime,
      this.address});

  factory _$OrganizationProfileModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrganizationProfileModelImplFromJson(json);

  @override
  final int? userId;
  @override
  final String? organizationName;
  @override
  final String? description;
  @override
  final OrganizationType? organizationType;
  @override
  final String? logoUrl;
  @override
  final VerificationStatus? verificationStatus;
  @override
  final DateTime? verifiedTime;
  @override
  final String? address;

  @override
  String toString() {
    return 'OrganizationProfileModel(userId: $userId, organizationName: $organizationName, description: $description, organizationType: $organizationType, logoUrl: $logoUrl, verificationStatus: $verificationStatus, verifiedTime: $verifiedTime, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrganizationProfileModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.organizationType, organizationType) ||
                other.organizationType == organizationType) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.verificationStatus, verificationStatus) ||
                other.verificationStatus == verificationStatus) &&
            (identical(other.verifiedTime, verifiedTime) ||
                other.verifiedTime == verifiedTime) &&
            (identical(other.address, address) || other.address == address));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      organizationName,
      description,
      organizationType,
      logoUrl,
      verificationStatus,
      verifiedTime,
      address);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrganizationProfileModelImplCopyWith<_$OrganizationProfileModelImpl>
      get copyWith => __$$OrganizationProfileModelImplCopyWithImpl<
          _$OrganizationProfileModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrganizationProfileModelImplToJson(
      this,
    );
  }
}

abstract class _OrganizationProfileModel implements OrganizationProfileModel {
  const factory _OrganizationProfileModel(
      {final int? userId,
      final String? organizationName,
      final String? description,
      final OrganizationType? organizationType,
      final String? logoUrl,
      final VerificationStatus? verificationStatus,
      final DateTime? verifiedTime,
      final String? address}) = _$OrganizationProfileModelImpl;

  factory _OrganizationProfileModel.fromJson(Map<String, dynamic> json) =
      _$OrganizationProfileModelImpl.fromJson;

  @override
  int? get userId;
  @override
  String? get organizationName;
  @override
  String? get description;
  @override
  OrganizationType? get organizationType;
  @override
  String? get logoUrl;
  @override
  VerificationStatus? get verificationStatus;
  @override
  DateTime? get verifiedTime;
  @override
  String? get address;
  @override
  @JsonKey(ignore: true)
  _$$OrganizationProfileModelImplCopyWith<_$OrganizationProfileModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
