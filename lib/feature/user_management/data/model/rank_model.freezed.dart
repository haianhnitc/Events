// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RankModel _$RankModelFromJson(Map<String, dynamic> json) {
  return _RankModel.fromJson(json);
}

/// @nodoc
mixin _$RankModel {
  int? get userId => throw _privateConstructorUsedError;
  UserSummaryModel? get user => throw _privateConstructorUsedError;
  int? get totalCoin => throw _privateConstructorUsedError;
  int? get ranking => throw _privateConstructorUsedError;
  int? get level => throw _privateConstructorUsedError;
  String? get levelName => throw _privateConstructorUsedError;
  DateTime? get updatedTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RankModelCopyWith<RankModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankModelCopyWith<$Res> {
  factory $RankModelCopyWith(RankModel value, $Res Function(RankModel) then) =
      _$RankModelCopyWithImpl<$Res, RankModel>;
  @useResult
  $Res call(
      {int? userId,
      UserSummaryModel? user,
      int? totalCoin,
      int? ranking,
      int? level,
      String? levelName,
      DateTime? updatedTime});

  $UserSummaryModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$RankModelCopyWithImpl<$Res, $Val extends RankModel>
    implements $RankModelCopyWith<$Res> {
  _$RankModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? user = freezed,
    Object? totalCoin = freezed,
    Object? ranking = freezed,
    Object? level = freezed,
    Object? levelName = freezed,
    Object? updatedTime = freezed,
  }) {
    return _then(_value.copyWith(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      totalCoin: freezed == totalCoin
          ? _value.totalCoin
          : totalCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      ranking: freezed == ranking
          ? _value.ranking
          : ranking // ignore: cast_nullable_to_non_nullable
              as int?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      levelName: freezed == levelName
          ? _value.levelName
          : levelName // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedTime: freezed == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserSummaryModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserSummaryModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RankModelImplCopyWith<$Res>
    implements $RankModelCopyWith<$Res> {
  factory _$$RankModelImplCopyWith(
          _$RankModelImpl value, $Res Function(_$RankModelImpl) then) =
      __$$RankModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? userId,
      UserSummaryModel? user,
      int? totalCoin,
      int? ranking,
      int? level,
      String? levelName,
      DateTime? updatedTime});

  @override
  $UserSummaryModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$$RankModelImplCopyWithImpl<$Res>
    extends _$RankModelCopyWithImpl<$Res, _$RankModelImpl>
    implements _$$RankModelImplCopyWith<$Res> {
  __$$RankModelImplCopyWithImpl(
      _$RankModelImpl _value, $Res Function(_$RankModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? user = freezed,
    Object? totalCoin = freezed,
    Object? ranking = freezed,
    Object? level = freezed,
    Object? levelName = freezed,
    Object? updatedTime = freezed,
  }) {
    return _then(_$RankModelImpl(
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserSummaryModel?,
      totalCoin: freezed == totalCoin
          ? _value.totalCoin
          : totalCoin // ignore: cast_nullable_to_non_nullable
              as int?,
      ranking: freezed == ranking
          ? _value.ranking
          : ranking // ignore: cast_nullable_to_non_nullable
              as int?,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int?,
      levelName: freezed == levelName
          ? _value.levelName
          : levelName // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedTime: freezed == updatedTime
          ? _value.updatedTime
          : updatedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RankModelImpl implements _RankModel {
  const _$RankModelImpl(
      {this.userId,
      this.user,
      this.totalCoin = 0,
      this.ranking = 0,
      this.level = 1,
      this.levelName,
      this.updatedTime});

  factory _$RankModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankModelImplFromJson(json);

  @override
  final int? userId;
  @override
  final UserSummaryModel? user;
  @override
  @JsonKey()
  final int? totalCoin;
  @override
  @JsonKey()
  final int? ranking;
  @override
  @JsonKey()
  final int? level;
  @override
  final String? levelName;
  @override
  final DateTime? updatedTime;

  @override
  String toString() {
    return 'RankModel(userId: $userId, user: $user, totalCoin: $totalCoin, ranking: $ranking, level: $level, levelName: $levelName, updatedTime: $updatedTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.totalCoin, totalCoin) ||
                other.totalCoin == totalCoin) &&
            (identical(other.ranking, ranking) || other.ranking == ranking) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.levelName, levelName) ||
                other.levelName == levelName) &&
            (identical(other.updatedTime, updatedTime) ||
                other.updatedTime == updatedTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userId, user, totalCoin, ranking,
      level, levelName, updatedTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RankModelImplCopyWith<_$RankModelImpl> get copyWith =>
      __$$RankModelImplCopyWithImpl<_$RankModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankModelImplToJson(
      this,
    );
  }
}

abstract class _RankModel implements RankModel {
  const factory _RankModel(
      {final int? userId,
      final UserSummaryModel? user,
      final int? totalCoin,
      final int? ranking,
      final int? level,
      final String? levelName,
      final DateTime? updatedTime}) = _$RankModelImpl;

  factory _RankModel.fromJson(Map<String, dynamic> json) =
      _$RankModelImpl.fromJson;

  @override
  int? get userId;
  @override
  UserSummaryModel? get user;
  @override
  int? get totalCoin;
  @override
  int? get ranking;
  @override
  int? get level;
  @override
  String? get levelName;
  @override
  DateTime? get updatedTime;
  @override
  @JsonKey(ignore: true)
  _$$RankModelImplCopyWith<_$RankModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
