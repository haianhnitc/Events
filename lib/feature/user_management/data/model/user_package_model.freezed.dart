// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_package_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserPackageModel _$UserPackageModelFromJson(Map<String, dynamic> json) {
  return _UserPackageModel.fromJson(json);
}

/// @nodoc
mixin _$UserPackageModel {
  int? get id => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  int? get packageId => throw _privateConstructorUsedError;
  String? get packageName => throw _privateConstructorUsedError;
  UserPackageStatus? get status => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  num? get price => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  bool? get autoRenew => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserPackageModelCopyWith<UserPackageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPackageModelCopyWith<$Res> {
  factory $UserPackageModelCopyWith(
          UserPackageModel value, $Res Function(UserPackageModel) then) =
      _$UserPackageModelCopyWithImpl<$Res, UserPackageModel>;
  @useResult
  $Res call(
      {int? id,
      int? userId,
      int? packageId,
      String? packageName,
      UserPackageStatus? status,
      DateTime? startDate,
      DateTime? expiryDate,
      num? price,
      DateTime? createdAt,
      bool? autoRenew});
}

/// @nodoc
class _$UserPackageModelCopyWithImpl<$Res, $Val extends UserPackageModel>
    implements $UserPackageModelCopyWith<$Res> {
  _$UserPackageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? packageId = freezed,
    Object? packageName = freezed,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? expiryDate = freezed,
    Object? price = freezed,
    Object? createdAt = freezed,
    Object? autoRenew = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      packageId: freezed == packageId
          ? _value.packageId
          : packageId // ignore: cast_nullable_to_non_nullable
              as int?,
      packageName: freezed == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserPackageStatus?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      autoRenew: freezed == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPackageModelImplCopyWith<$Res>
    implements $UserPackageModelCopyWith<$Res> {
  factory _$$UserPackageModelImplCopyWith(_$UserPackageModelImpl value,
          $Res Function(_$UserPackageModelImpl) then) =
      __$$UserPackageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      int? userId,
      int? packageId,
      String? packageName,
      UserPackageStatus? status,
      DateTime? startDate,
      DateTime? expiryDate,
      num? price,
      DateTime? createdAt,
      bool? autoRenew});
}

/// @nodoc
class __$$UserPackageModelImplCopyWithImpl<$Res>
    extends _$UserPackageModelCopyWithImpl<$Res, _$UserPackageModelImpl>
    implements _$$UserPackageModelImplCopyWith<$Res> {
  __$$UserPackageModelImplCopyWithImpl(_$UserPackageModelImpl _value,
      $Res Function(_$UserPackageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? userId = freezed,
    Object? packageId = freezed,
    Object? packageName = freezed,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? expiryDate = freezed,
    Object? price = freezed,
    Object? createdAt = freezed,
    Object? autoRenew = freezed,
  }) {
    return _then(_$UserPackageModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      packageId: freezed == packageId
          ? _value.packageId
          : packageId // ignore: cast_nullable_to_non_nullable
              as int?,
      packageName: freezed == packageName
          ? _value.packageName
          : packageName // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as UserPackageStatus?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as num?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      autoRenew: freezed == autoRenew
          ? _value.autoRenew
          : autoRenew // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserPackageModelImpl implements _UserPackageModel {
  const _$UserPackageModelImpl(
      {this.id,
      this.userId,
      this.packageId,
      this.packageName,
      this.status,
      this.startDate,
      this.expiryDate,
      this.price,
      this.createdAt,
      this.autoRenew = false});

  factory _$UserPackageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserPackageModelImplFromJson(json);

  @override
  final int? id;
  @override
  final int? userId;
  @override
  final int? packageId;
  @override
  final String? packageName;
  @override
  final UserPackageStatus? status;
  @override
  final DateTime? startDate;
  @override
  final DateTime? expiryDate;
  @override
  final num? price;
  @override
  final DateTime? createdAt;
  @override
  @JsonKey()
  final bool? autoRenew;

  @override
  String toString() {
    return 'UserPackageModel(id: $id, userId: $userId, packageId: $packageId, packageName: $packageName, status: $status, startDate: $startDate, expiryDate: $expiryDate, price: $price, createdAt: $createdAt, autoRenew: $autoRenew)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPackageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.packageId, packageId) ||
                other.packageId == packageId) &&
            (identical(other.packageName, packageName) ||
                other.packageName == packageName) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.autoRenew, autoRenew) ||
                other.autoRenew == autoRenew));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, packageId,
      packageName, status, startDate, expiryDate, price, createdAt, autoRenew);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPackageModelImplCopyWith<_$UserPackageModelImpl> get copyWith =>
      __$$UserPackageModelImplCopyWithImpl<_$UserPackageModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserPackageModelImplToJson(
      this,
    );
  }
}

abstract class _UserPackageModel implements UserPackageModel {
  const factory _UserPackageModel(
      {final int? id,
      final int? userId,
      final int? packageId,
      final String? packageName,
      final UserPackageStatus? status,
      final DateTime? startDate,
      final DateTime? expiryDate,
      final num? price,
      final DateTime? createdAt,
      final bool? autoRenew}) = _$UserPackageModelImpl;

  factory _UserPackageModel.fromJson(Map<String, dynamic> json) =
      _$UserPackageModelImpl.fromJson;

  @override
  int? get id;
  @override
  int? get userId;
  @override
  int? get packageId;
  @override
  String? get packageName;
  @override
  UserPackageStatus? get status;
  @override
  DateTime? get startDate;
  @override
  DateTime? get expiryDate;
  @override
  num? get price;
  @override
  DateTime? get createdAt;
  @override
  bool? get autoRenew;
  @override
  @JsonKey(ignore: true)
  _$$UserPackageModelImplCopyWith<_$UserPackageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
