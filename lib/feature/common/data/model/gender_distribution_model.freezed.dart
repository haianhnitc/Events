// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gender_distribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GenderDistributionModel _$GenderDistributionModelFromJson(
    Map<String, dynamic> json) {
  return _GenderDistributionModel.fromJson(json);
}

/// @nodoc
mixin _$GenderDistributionModel {
  int? get male => throw _privateConstructorUsedError;
  double? get malePercentage => throw _privateConstructorUsedError;
  int? get female => throw _privateConstructorUsedError;
  double? get femalePercentage => throw _privateConstructorUsedError;
  int? get other => throw _privateConstructorUsedError;
  double? get otherPercentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GenderDistributionModelCopyWith<GenderDistributionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenderDistributionModelCopyWith<$Res> {
  factory $GenderDistributionModelCopyWith(GenderDistributionModel value,
          $Res Function(GenderDistributionModel) then) =
      _$GenderDistributionModelCopyWithImpl<$Res, GenderDistributionModel>;
  @useResult
  $Res call(
      {int? male,
      double? malePercentage,
      int? female,
      double? femalePercentage,
      int? other,
      double? otherPercentage});
}

/// @nodoc
class _$GenderDistributionModelCopyWithImpl<$Res,
        $Val extends GenderDistributionModel>
    implements $GenderDistributionModelCopyWith<$Res> {
  _$GenderDistributionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? male = freezed,
    Object? malePercentage = freezed,
    Object? female = freezed,
    Object? femalePercentage = freezed,
    Object? other = freezed,
    Object? otherPercentage = freezed,
  }) {
    return _then(_value.copyWith(
      male: freezed == male
          ? _value.male
          : male // ignore: cast_nullable_to_non_nullable
              as int?,
      malePercentage: freezed == malePercentage
          ? _value.malePercentage
          : malePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      female: freezed == female
          ? _value.female
          : female // ignore: cast_nullable_to_non_nullable
              as int?,
      femalePercentage: freezed == femalePercentage
          ? _value.femalePercentage
          : femalePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      other: freezed == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as int?,
      otherPercentage: freezed == otherPercentage
          ? _value.otherPercentage
          : otherPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenderDistributionModelImplCopyWith<$Res>
    implements $GenderDistributionModelCopyWith<$Res> {
  factory _$$GenderDistributionModelImplCopyWith(
          _$GenderDistributionModelImpl value,
          $Res Function(_$GenderDistributionModelImpl) then) =
      __$$GenderDistributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? male,
      double? malePercentage,
      int? female,
      double? femalePercentage,
      int? other,
      double? otherPercentage});
}

/// @nodoc
class __$$GenderDistributionModelImplCopyWithImpl<$Res>
    extends _$GenderDistributionModelCopyWithImpl<$Res,
        _$GenderDistributionModelImpl>
    implements _$$GenderDistributionModelImplCopyWith<$Res> {
  __$$GenderDistributionModelImplCopyWithImpl(
      _$GenderDistributionModelImpl _value,
      $Res Function(_$GenderDistributionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? male = freezed,
    Object? malePercentage = freezed,
    Object? female = freezed,
    Object? femalePercentage = freezed,
    Object? other = freezed,
    Object? otherPercentage = freezed,
  }) {
    return _then(_$GenderDistributionModelImpl(
      male: freezed == male
          ? _value.male
          : male // ignore: cast_nullable_to_non_nullable
              as int?,
      malePercentage: freezed == malePercentage
          ? _value.malePercentage
          : malePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      female: freezed == female
          ? _value.female
          : female // ignore: cast_nullable_to_non_nullable
              as int?,
      femalePercentage: freezed == femalePercentage
          ? _value.femalePercentage
          : femalePercentage // ignore: cast_nullable_to_non_nullable
              as double?,
      other: freezed == other
          ? _value.other
          : other // ignore: cast_nullable_to_non_nullable
              as int?,
      otherPercentage: freezed == otherPercentage
          ? _value.otherPercentage
          : otherPercentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GenderDistributionModelImpl implements _GenderDistributionModel {
  const _$GenderDistributionModelImpl(
      {this.male,
      this.malePercentage,
      this.female,
      this.femalePercentage,
      this.other,
      this.otherPercentage});

  factory _$GenderDistributionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$GenderDistributionModelImplFromJson(json);

  @override
  final int? male;
  @override
  final double? malePercentage;
  @override
  final int? female;
  @override
  final double? femalePercentage;
  @override
  final int? other;
  @override
  final double? otherPercentage;

  @override
  String toString() {
    return 'GenderDistributionModel(male: $male, malePercentage: $malePercentage, female: $female, femalePercentage: $femalePercentage, other: $other, otherPercentage: $otherPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenderDistributionModelImpl &&
            (identical(other.male, male) || other.male == male) &&
            (identical(other.malePercentage, malePercentage) ||
                other.malePercentage == malePercentage) &&
            (identical(other.female, female) || other.female == female) &&
            (identical(other.femalePercentage, femalePercentage) ||
                other.femalePercentage == femalePercentage) &&
            (identical(other.other, this.other) || other.other == this.other) &&
            (identical(other.otherPercentage, otherPercentage) ||
                other.otherPercentage == otherPercentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, male, malePercentage, female,
      femalePercentage, other, otherPercentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenderDistributionModelImplCopyWith<_$GenderDistributionModelImpl>
      get copyWith => __$$GenderDistributionModelImplCopyWithImpl<
          _$GenderDistributionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GenderDistributionModelImplToJson(
      this,
    );
  }
}

abstract class _GenderDistributionModel implements GenderDistributionModel {
  const factory _GenderDistributionModel(
      {final int? male,
      final double? malePercentage,
      final int? female,
      final double? femalePercentage,
      final int? other,
      final double? otherPercentage}) = _$GenderDistributionModelImpl;

  factory _GenderDistributionModel.fromJson(Map<String, dynamic> json) =
      _$GenderDistributionModelImpl.fromJson;

  @override
  int? get male;
  @override
  double? get malePercentage;
  @override
  int? get female;
  @override
  double? get femalePercentage;
  @override
  int? get other;
  @override
  double? get otherPercentage;
  @override
  @JsonKey(ignore: true)
  _$$GenderDistributionModelImplCopyWith<_$GenderDistributionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
