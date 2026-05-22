// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_category_option_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

EventCategoryOptionModel _$EventCategoryOptionModelFromJson(
    Map<String, dynamic> json) {
  return _EventCategoryOptionModel.fromJson(json);
}

/// @nodoc
mixin _$EventCategoryOptionModel {
  int? get categoryOptionId => throw _privateConstructorUsedError;
  int? get categoryId => throw _privateConstructorUsedError;
  String? get categoryName => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;
  int? get eventId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCategoryOptionModelCopyWith<EventCategoryOptionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCategoryOptionModelCopyWith<$Res> {
  factory $EventCategoryOptionModelCopyWith(EventCategoryOptionModel value,
          $Res Function(EventCategoryOptionModel) then) =
      _$EventCategoryOptionModelCopyWithImpl<$Res, EventCategoryOptionModel>;
  @useResult
  $Res call(
      {int? categoryOptionId,
      int? categoryId,
      String? categoryName,
      String? value,
      int? eventId});
}

/// @nodoc
class _$EventCategoryOptionModelCopyWithImpl<$Res,
        $Val extends EventCategoryOptionModel>
    implements $EventCategoryOptionModelCopyWith<$Res> {
  _$EventCategoryOptionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryOptionId = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? value = freezed,
    Object? eventId = freezed,
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
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventCategoryOptionModelImplCopyWith<$Res>
    implements $EventCategoryOptionModelCopyWith<$Res> {
  factory _$$EventCategoryOptionModelImplCopyWith(
          _$EventCategoryOptionModelImpl value,
          $Res Function(_$EventCategoryOptionModelImpl) then) =
      __$$EventCategoryOptionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? categoryOptionId,
      int? categoryId,
      String? categoryName,
      String? value,
      int? eventId});
}

/// @nodoc
class __$$EventCategoryOptionModelImplCopyWithImpl<$Res>
    extends _$EventCategoryOptionModelCopyWithImpl<$Res,
        _$EventCategoryOptionModelImpl>
    implements _$$EventCategoryOptionModelImplCopyWith<$Res> {
  __$$EventCategoryOptionModelImplCopyWithImpl(
      _$EventCategoryOptionModelImpl _value,
      $Res Function(_$EventCategoryOptionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categoryOptionId = freezed,
    Object? categoryId = freezed,
    Object? categoryName = freezed,
    Object? value = freezed,
    Object? eventId = freezed,
  }) {
    return _then(_$EventCategoryOptionModelImpl(
      categoryOptionId: freezed == categoryOptionId
          ? _value.categoryOptionId
          : categoryOptionId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      categoryName: freezed == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventCategoryOptionModelImpl implements _EventCategoryOptionModel {
  const _$EventCategoryOptionModelImpl(
      {this.categoryOptionId,
      this.categoryId,
      this.categoryName,
      this.value,
      this.eventId});

  factory _$EventCategoryOptionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventCategoryOptionModelImplFromJson(json);

  @override
  final int? categoryOptionId;
  @override
  final int? categoryId;
  @override
  final String? categoryName;
  @override
  final String? value;
  @override
  final int? eventId;

  @override
  String toString() {
    return 'EventCategoryOptionModel(categoryOptionId: $categoryOptionId, categoryId: $categoryId, categoryName: $categoryName, value: $value, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventCategoryOptionModelImpl &&
            (identical(other.categoryOptionId, categoryOptionId) ||
                other.categoryOptionId == categoryOptionId) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, categoryOptionId, categoryId, categoryName, value, eventId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EventCategoryOptionModelImplCopyWith<_$EventCategoryOptionModelImpl>
      get copyWith => __$$EventCategoryOptionModelImplCopyWithImpl<
          _$EventCategoryOptionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventCategoryOptionModelImplToJson(
      this,
    );
  }
}

abstract class _EventCategoryOptionModel implements EventCategoryOptionModel {
  const factory _EventCategoryOptionModel(
      {final int? categoryOptionId,
      final int? categoryId,
      final String? categoryName,
      final String? value,
      final int? eventId}) = _$EventCategoryOptionModelImpl;

  factory _EventCategoryOptionModel.fromJson(Map<String, dynamic> json) =
      _$EventCategoryOptionModelImpl.fromJson;

  @override
  int? get categoryOptionId;
  @override
  int? get categoryId;
  @override
  String? get categoryName;
  @override
  String? get value;
  @override
  int? get eventId;
  @override
  @JsonKey(ignore: true)
  _$$EventCategoryOptionModelImplCopyWith<_$EventCategoryOptionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
