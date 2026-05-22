// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'common_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CommonMeta _$CommonMetaFromJson(Map<String, dynamic> json) {
  return _CommonMeta.fromJson(json);
}

/// @nodoc
mixin _$CommonMeta {
  dynamic get code => throw _privateConstructorUsedError;
  dynamic get page => throw _privateConstructorUsedError;
  dynamic get size => throw _privateConstructorUsedError;
  dynamic get total => throw _privateConstructorUsedError;
  dynamic get message => throw _privateConstructorUsedError;
  dynamic get requestId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommonMetaCopyWith<CommonMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommonMetaCopyWith<$Res> {
  factory $CommonMetaCopyWith(
          CommonMeta value, $Res Function(CommonMeta) then) =
      _$CommonMetaCopyWithImpl<$Res, CommonMeta>;
  @useResult
  $Res call(
      {dynamic code,
      dynamic page,
      dynamic size,
      dynamic total,
      dynamic message,
      dynamic requestId});
}

/// @nodoc
class _$CommonMetaCopyWithImpl<$Res, $Val extends CommonMeta>
    implements $CommonMetaCopyWith<$Res> {
  _$CommonMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? page = freezed,
    Object? size = freezed,
    Object? total = freezed,
    Object? message = freezed,
    Object? requestId = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as dynamic,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as dynamic,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as dynamic,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as dynamic,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as dynamic,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CommonMetaImplCopyWith<$Res>
    implements $CommonMetaCopyWith<$Res> {
  factory _$$CommonMetaImplCopyWith(
          _$CommonMetaImpl value, $Res Function(_$CommonMetaImpl) then) =
      __$$CommonMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {dynamic code,
      dynamic page,
      dynamic size,
      dynamic total,
      dynamic message,
      dynamic requestId});
}

/// @nodoc
class __$$CommonMetaImplCopyWithImpl<$Res>
    extends _$CommonMetaCopyWithImpl<$Res, _$CommonMetaImpl>
    implements _$$CommonMetaImplCopyWith<$Res> {
  __$$CommonMetaImplCopyWithImpl(
      _$CommonMetaImpl _value, $Res Function(_$CommonMetaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? page = freezed,
    Object? size = freezed,
    Object? total = freezed,
    Object? message = freezed,
    Object? requestId = freezed,
  }) {
    return _then(_$CommonMetaImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as dynamic,
      page: freezed == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as dynamic,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as dynamic,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as dynamic,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as dynamic,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CommonMetaImpl implements _CommonMeta {
  const _$CommonMetaImpl(
      {this.code,
      this.page,
      this.size,
      this.total,
      this.message,
      this.requestId});

  factory _$CommonMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$CommonMetaImplFromJson(json);

  @override
  final dynamic code;
  @override
  final dynamic page;
  @override
  final dynamic size;
  @override
  final dynamic total;
  @override
  final dynamic message;
  @override
  final dynamic requestId;

  @override
  String toString() {
    return 'CommonMeta(code: $code, page: $page, size: $size, total: $total, message: $message, requestId: $requestId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommonMetaImpl &&
            const DeepCollectionEquality().equals(other.code, code) &&
            const DeepCollectionEquality().equals(other.page, page) &&
            const DeepCollectionEquality().equals(other.size, size) &&
            const DeepCollectionEquality().equals(other.total, total) &&
            const DeepCollectionEquality().equals(other.message, message) &&
            const DeepCollectionEquality().equals(other.requestId, requestId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(code),
      const DeepCollectionEquality().hash(page),
      const DeepCollectionEquality().hash(size),
      const DeepCollectionEquality().hash(total),
      const DeepCollectionEquality().hash(message),
      const DeepCollectionEquality().hash(requestId));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommonMetaImplCopyWith<_$CommonMetaImpl> get copyWith =>
      __$$CommonMetaImplCopyWithImpl<_$CommonMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CommonMetaImplToJson(
      this,
    );
  }
}

abstract class _CommonMeta implements CommonMeta {
  const factory _CommonMeta(
      {final dynamic code,
      final dynamic page,
      final dynamic size,
      final dynamic total,
      final dynamic message,
      final dynamic requestId}) = _$CommonMetaImpl;

  factory _CommonMeta.fromJson(Map<String, dynamic> json) =
      _$CommonMetaImpl.fromJson;

  @override
  dynamic get code;
  @override
  dynamic get page;
  @override
  dynamic get size;
  @override
  dynamic get total;
  @override
  dynamic get message;
  @override
  dynamic get requestId;
  @override
  @JsonKey(ignore: true)
  _$$CommonMetaImplCopyWith<_$CommonMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
