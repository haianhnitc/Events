// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_option_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoryOptionModel _$CategoryOptionModelFromJson(Map<String, dynamic> json) {
  return _CategoryOptionModel.fromJson(json);
}

/// @nodoc
mixin _$CategoryOptionModel {
  int? get categoryOptionId => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CategoryOptionModelCopyWith<CategoryOptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryOptionModelCopyWith<$Res> {
  factory $CategoryOptionModelCopyWith(
          CategoryOptionModel value, $Res Function(CategoryOptionModel) then) =
      _$CategoryOptionModelCopyWithImpl<$Res, CategoryOptionModel>;
  @useResult
  $Res call({int? categoryOptionId, int? categoryId, String? value});
}

/// @nodoc
class _$CategoryOptionModelCopyWithImpl<$Res, $Val extends CategoryOptionModel>
    implements $CategoryOptionModelCopyWith<$Res> {
  _$CategoryOptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryOptionId = freezed,
    Object? categoryId = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      categoryOptionId: freezed == categoryOptionId
          ? _value.categoryOptionId
          : categoryOptionId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryOptionModelImplCopyWith<$Res>
    implements $CategoryOptionModelCopyWith<$Res> {
  factory _$$CategoryOptionModelImplCopyWith(_$CategoryOptionModelImpl value,
          $Res Function(_$CategoryOptionModelImpl) then) =
      __$$CategoryOptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? categoryOptionId, int? categoryId, String? value});
}

/// @nodoc
class __$$CategoryOptionModelImplCopyWithImpl<$Res>
    extends _$CategoryOptionModelCopyWithImpl<$Res, _$CategoryOptionModelImpl>
    implements _$$CategoryOptionModelImplCopyWith<$Res> {
  __$$CategoryOptionModelImplCopyWithImpl(_$CategoryOptionModelImpl _value,
      $Res Function(_$CategoryOptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryOptionId = freezed,
    Object? categoryId = freezed,
    Object? value = freezed,
  }) {
    return _then(_$CategoryOptionModelImpl(
      categoryOptionId: freezed == categoryOptionId
          ? _value.categoryOptionId
          : categoryOptionId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryOptionModelImpl implements _CategoryOptionModel {
  const _$CategoryOptionModelImpl(
      {this.categoryOptionId, this.categoryId, this.value});

  factory _$CategoryOptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryOptionModelImplFromJson(json);

  @override
  final int? categoryOptionId;
  @override
  final int? categoryId;
  @override
  final String? value;

  @override
  String toString() {
    return 'CategoryOptionModel(categoryOptionId: $categoryOptionId, categoryId: $categoryId, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryOptionModelImpl &&
            (identical(other.categoryOptionId, categoryOptionId) ||
                other.categoryOptionId == categoryOptionId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, categoryOptionId, categoryId, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryOptionModelImplCopyWith<_$CategoryOptionModelImpl> get copyWith =>
      __$$CategoryOptionModelImplCopyWithImpl<_$CategoryOptionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryOptionModelImplToJson(
      this,
    );
  }
}

abstract class _CategoryOptionModel implements CategoryOptionModel {
  const factory _CategoryOptionModel(
      {final int? categoryOptionId,
      final int? categoryId,
      final String? value}) = _$CategoryOptionModelImpl;

  factory _CategoryOptionModel.fromJson(Map<String, dynamic> json) =
      _$CategoryOptionModelImpl.fromJson;

  @override
  int? get categoryOptionId;
  @override
  int? get categoryId;
  @override
  String? get value;
  @override
  @JsonKey(ignore: true)
  _$$CategoryOptionModelImplCopyWith<_$CategoryOptionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
