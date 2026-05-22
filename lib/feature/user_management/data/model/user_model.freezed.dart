// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  int? get userId => throw _privateConstructorUsedError;
  String get firebaseUid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  UserRole? get role => throw _privateConstructorUsedError;
  UserStatus? get status => throw _privateConstructorUsedError;
  int get currentCoin => throw _privateConstructorUsedError;
  DateTime? get createdTime => throw _privateConstructorUsedError;
  UserProfileModel? get userProfile => throw _privateConstructorUsedError;
  OrganizationProfileModel? get organizationProfile =>
      throw _privateConstructorUsedError;
  List<VerificationDocumentModel>? get verificationDocuments =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call(
      {int? userId,
      String firebaseUid,
      String email,
      String? phoneNumber,
      UserRole? role,
      UserStatus? status,
      int currentCoin,
      DateTime? createdTime,
      UserProfileModel? userProfile,
      OrganizationProfileModel? organizationProfile,
      List<VerificationDocumentModel>? verificationDocuments});

  $UserProfileModelCopyWith<$Res>? get userProfile;
  $OrganizationProfileModelCopyWith<$Res>? get organizationProfile;
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? firebaseUid = null,
    Object? email = null,
    Object? phoneNumber = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? currentCoin = null,
    Object? createdTime = freezed,
    Object? userProfile = freezed,
    Object? organizationProfile = freezed,
    Object? verificationDocuments = freezed,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      firebaseUid: null == firebaseUid
          ? _value.firebaseUid
          : firebaseUid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus?,
      currentCoin: null == currentCoin
          ? _value.currentCoin
          : currentCoin // ignore: cast_nullable_to_non_nullable
              as int,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
      organizationProfile: freezed == organizationProfile
          ? _value.organizationProfile
          : organizationProfile // ignore: cast_nullable_to_non_nullable
              as OrganizationProfileModel?,
      verificationDocuments: freezed == verificationDocuments
          ? _value.verificationDocuments
          : verificationDocuments // ignore: cast_nullable_to_non_nullable
              as List<VerificationDocumentModel>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileModelCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $UserProfileModelCopyWith<$Res>(_value.userProfile!, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OrganizationProfileModelCopyWith<$Res>? get organizationProfile {
    if (_value.organizationProfile == null) {
      return null;
    }

    return $OrganizationProfileModelCopyWith<$Res>(_value.organizationProfile!,
        (value) {
      return _then(_value.copyWith(organizationProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
          _$UserModelImpl value, $Res Function(_$UserModelImpl) then) =
      __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? userId,
      String firebaseUid,
      String email,
      String? phoneNumber,
      UserRole? role,
      UserStatus? status,
      int currentCoin,
      DateTime? createdTime,
      UserProfileModel? userProfile,
      OrganizationProfileModel? organizationProfile,
      List<VerificationDocumentModel>? verificationDocuments});

  @override
  $UserProfileModelCopyWith<$Res>? get userProfile;
  @override
  $OrganizationProfileModelCopyWith<$Res>? get organizationProfile;
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
      _$UserModelImpl _value, $Res Function(_$UserModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? firebaseUid = null,
    Object? email = null,
    Object? phoneNumber = freezed,
    Object? role = freezed,
    Object? status = freezed,
    Object? currentCoin = null,
    Object? createdTime = freezed,
    Object? userProfile = freezed,
    Object? organizationProfile = freezed,
    Object? verificationDocuments = freezed,
  }) {
    return _then(_$UserModelImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      firebaseUid: null == firebaseUid
          ? _value.firebaseUid
          : firebaseUid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserStatus?,
      currentCoin: null == currentCoin
          ? _value.currentCoin
          : currentCoin // ignore: cast_nullable_to_non_nullable
              as int,
      createdTime: freezed == createdTime
          ? _value.createdTime
          : createdTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfileModel?,
      organizationProfile: freezed == organizationProfile
          ? _value.organizationProfile
          : organizationProfile // ignore: cast_nullable_to_non_nullable
              as OrganizationProfileModel?,
      verificationDocuments: freezed == verificationDocuments
          ? _value._verificationDocuments
          : verificationDocuments // ignore: cast_nullable_to_non_nullable
              as List<VerificationDocumentModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl implements _UserModel {
  const _$UserModelImpl(
      {this.userId,
      required this.firebaseUid,
      required this.email,
      this.phoneNumber,
      this.role = UserRole.user,
      this.status,
      this.currentCoin = 0,
      this.createdTime,
      this.userProfile,
      this.organizationProfile,
      final List<VerificationDocumentModel>? verificationDocuments})
      : _verificationDocuments = verificationDocuments;

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  final int? userId;
  @override
  final String firebaseUid;
  @override
  final String email;
  @override
  final String? phoneNumber;
  @override
  @JsonKey()
  final UserRole? role;
  @override
  final UserStatus? status;
  @override
  @JsonKey()
  final int currentCoin;
  @override
  final DateTime? createdTime;
  @override
  final UserProfileModel? userProfile;
  @override
  final OrganizationProfileModel? organizationProfile;
  final List<VerificationDocumentModel>? _verificationDocuments;
  @override
  List<VerificationDocumentModel>? get verificationDocuments {
    final value = _verificationDocuments;
    if (value == null) return null;
    if (_verificationDocuments is EqualUnmodifiableListView)
      return _verificationDocuments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserModel(userId: $userId, firebaseUid: $firebaseUid, email: $email, phoneNumber: $phoneNumber, role: $role, status: $status, currentCoin: $currentCoin, createdTime: $createdTime, userProfile: $userProfile, organizationProfile: $organizationProfile, verificationDocuments: $verificationDocuments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.firebaseUid, firebaseUid) ||
                other.firebaseUid == firebaseUid) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.currentCoin, currentCoin) ||
                other.currentCoin == currentCoin) &&
            (identical(other.createdTime, createdTime) ||
                other.createdTime == createdTime) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.organizationProfile, organizationProfile) ||
                other.organizationProfile == organizationProfile) &&
            const DeepCollectionEquality()
                .equals(other._verificationDocuments, _verificationDocuments));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      firebaseUid,
      email,
      phoneNumber,
      role,
      status,
      currentCoin,
      createdTime,
      userProfile,
      organizationProfile,
      const DeepCollectionEquality().hash(_verificationDocuments));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(
      this,
    );
  }
}

abstract class _UserModel implements UserModel {
  const factory _UserModel(
          {final int? userId,
          required final String firebaseUid,
          required final String email,
          final String? phoneNumber,
          final UserRole? role,
          final UserStatus? status,
          final int currentCoin,
          final DateTime? createdTime,
          final UserProfileModel? userProfile,
          final OrganizationProfileModel? organizationProfile,
          final List<VerificationDocumentModel>? verificationDocuments}) =
      _$UserModelImpl;

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  int? get userId;
  @override
  String get firebaseUid;
  @override
  String get email;
  @override
  String? get phoneNumber;
  @override
  UserRole? get role;
  @override
  UserStatus? get status;
  @override
  int get currentCoin;
  @override
  DateTime? get createdTime;
  @override
  UserProfileModel? get userProfile;
  @override
  OrganizationProfileModel? get organizationProfile;
  @override
  List<VerificationDocumentModel>? get verificationDocuments;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
