// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_claim_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NewsClaimResponseModel _$NewsClaimResponseModelFromJson(
    Map<String, dynamic> json) {
  return _NewsClaimResponseModel.fromJson(json);
}

/// @nodoc
mixin _$NewsClaimResponseModel {
  int? get coinsEarned => throw _privateConstructorUsedError;
  int? get remainingRewardCoin => throw _privateConstructorUsedError;
  bool? get exhausted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NewsClaimResponseModelCopyWith<NewsClaimResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsClaimResponseModelCopyWith<$Res> {
  factory $NewsClaimResponseModelCopyWith(NewsClaimResponseModel value,
          $Res Function(NewsClaimResponseModel) then) =
      _$NewsClaimResponseModelCopyWithImpl<$Res, NewsClaimResponseModel>;
  @useResult
  $Res call({int? coinsEarned, int? remainingRewardCoin, bool? exhausted});
}

/// @nodoc
class _$NewsClaimResponseModelCopyWithImpl<$Res,
        $Val extends NewsClaimResponseModel>
    implements $NewsClaimResponseModelCopyWith<$Res> {
  _$NewsClaimResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinsEarned = freezed,
    Object? remainingRewardCoin = freezed,
    Object? exhausted = freezed,
  }) {
    return _then(_value.copyWith(
      coinsEarned: freezed == coinsEarned
          ? _value.coinsEarned
          : coinsEarned // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingRewardCoin: freezed == remainingRewardCoin
          ? _value.remainingRewardCoin
          : remainingRewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      exhausted: freezed == exhausted
          ? _value.exhausted
          : exhausted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewsClaimResponseModelImplCopyWith<$Res>
    implements $NewsClaimResponseModelCopyWith<$Res> {
  factory _$$NewsClaimResponseModelImplCopyWith(
          _$NewsClaimResponseModelImpl value,
          $Res Function(_$NewsClaimResponseModelImpl) then) =
      __$$NewsClaimResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? coinsEarned, int? remainingRewardCoin, bool? exhausted});
}

/// @nodoc
class __$$NewsClaimResponseModelImplCopyWithImpl<$Res>
    extends _$NewsClaimResponseModelCopyWithImpl<$Res,
        _$NewsClaimResponseModelImpl>
    implements _$$NewsClaimResponseModelImplCopyWith<$Res> {
  __$$NewsClaimResponseModelImplCopyWithImpl(
      _$NewsClaimResponseModelImpl _value,
      $Res Function(_$NewsClaimResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coinsEarned = freezed,
    Object? remainingRewardCoin = freezed,
    Object? exhausted = freezed,
  }) {
    return _then(_$NewsClaimResponseModelImpl(
      coinsEarned: freezed == coinsEarned
          ? _value.coinsEarned
          : coinsEarned // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingRewardCoin: freezed == remainingRewardCoin
          ? _value.remainingRewardCoin
          : remainingRewardCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      exhausted: freezed == exhausted
          ? _value.exhausted
          : exhausted // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NewsClaimResponseModelImpl implements _NewsClaimResponseModel {
  const _$NewsClaimResponseModelImpl(
      {this.coinsEarned, this.remainingRewardCoin, this.exhausted});

  factory _$NewsClaimResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NewsClaimResponseModelImplFromJson(json);

  @override
  final int? coinsEarned;
  @override
  final int? remainingRewardCoin;
  @override
  final bool? exhausted;

  @override
  String toString() {
    return 'NewsClaimResponseModel(coinsEarned: $coinsEarned, remainingRewardCoin: $remainingRewardCoin, exhausted: $exhausted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsClaimResponseModelImpl &&
            (identical(other.coinsEarned, coinsEarned) ||
                other.coinsEarned == coinsEarned) &&
            (identical(other.remainingRewardCoin, remainingRewardCoin) ||
                other.remainingRewardCoin == remainingRewardCoin) &&
            (identical(other.exhausted, exhausted) ||
                other.exhausted == exhausted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, coinsEarned, remainingRewardCoin, exhausted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsClaimResponseModelImplCopyWith<_$NewsClaimResponseModelImpl>
      get copyWith => __$$NewsClaimResponseModelImplCopyWithImpl<
          _$NewsClaimResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsClaimResponseModelImplToJson(
      this,
    );
  }
}

abstract class _NewsClaimResponseModel implements NewsClaimResponseModel {
  const factory _NewsClaimResponseModel(
      {final int? coinsEarned,
      final int? remainingRewardCoin,
      final bool? exhausted}) = _$NewsClaimResponseModelImpl;

  factory _NewsClaimResponseModel.fromJson(Map<String, dynamic> json) =
      _$NewsClaimResponseModelImpl.fromJson;

  @override
  int? get coinsEarned;
  @override
  int? get remainingRewardCoin;
  @override
  bool? get exhausted;
  @override
  @JsonKey(ignore: true)
  _$$NewsClaimResponseModelImplCopyWith<_$NewsClaimResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
