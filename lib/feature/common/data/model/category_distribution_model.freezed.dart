// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_distribution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryDistributionModel _$CategoryDistributionModelFromJson(
    Map<String, dynamic> json) {
  return _CategoryDistributionModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryDistributionModel {
  String? get name => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;
  double? get percentage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryDistributionModelCopyWith<CategoryDistributionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryDistributionModelCopyWith<$Res> {
  factory $CategoryDistributionModelCopyWith(CategoryDistributionModel value,
          $Res Function(CategoryDistributionModel) then) =
      _$CategoryDistributionModelCopyWithImpl<$Res, CategoryDistributionModel>;
  @useResult
  $Res call({String? name, int? count, double? percentage});
}

/// @nodoc
class _$CategoryDistributionModelCopyWithImpl<$Res,
        $Val extends CategoryDistributionModel>
    implements $CategoryDistributionModelCopyWith<$Res> {
  _$CategoryDistributionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? count = freezed,
    Object? percentage = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      percentage: freezed == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryDistributionModelImplCopyWith<$Res>
    implements $CategoryDistributionModelCopyWith<$Res> {
  factory _$$CategoryDistributionModelImplCopyWith(
          _$CategoryDistributionModelImpl value,
          $Res Function(_$CategoryDistributionModelImpl) then) =
      __$$CategoryDistributionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? name, int? count, double? percentage});
}

/// @nodoc
class __$$CategoryDistributionModelImplCopyWithImpl<$Res>
    extends _$CategoryDistributionModelCopyWithImpl<$Res,
        _$CategoryDistributionModelImpl>
    implements _$$CategoryDistributionModelImplCopyWith<$Res> {
  __$$CategoryDistributionModelImplCopyWithImpl(
      _$CategoryDistributionModelImpl _value,
      $Res Function(_$CategoryDistributionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? count = freezed,
    Object? percentage = freezed,
  }) {
    return _then(_$CategoryDistributionModelImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      percentage: freezed == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryDistributionModelImpl implements _CategoryDistributionModel {
  const _$CategoryDistributionModelImpl(
      {this.name, this.count, this.percentage});

  factory _$CategoryDistributionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryDistributionModelImplFromJson(json);

  @override
  final String? name;
  @override
  final int? count;
  @override
  final double? percentage;

  @override
  String toString() {
    return 'CategoryDistributionModel(name: $name, count: $count, percentage: $percentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryDistributionModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, count, percentage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryDistributionModelImplCopyWith<_$CategoryDistributionModelImpl>
      get copyWith => __$$CategoryDistributionModelImplCopyWithImpl<
          _$CategoryDistributionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryDistributionModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryDistributionModel implements CategoryDistributionModel {
  const factory _CategoryDistributionModel(
      {final String? name,
      final int? count,
      final double? percentage}) = _$CategoryDistributionModelImpl;

  factory _CategoryDistributionModel.fromJson(Map<String, dynamic> json) =
      _$CategoryDistributionModelImpl.fromJson;

  @override
  String? get name;
  @override
  int? get count;
  @override
  double? get percentage;
  @override
  @JsonKey(ignore: true)
  _$$CategoryDistributionModelImplCopyWith<_$CategoryDistributionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
