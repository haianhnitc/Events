// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FailureEntity {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code, String message) serverFailure,
    required TResult Function() dataParsingFailure,
    required TResult Function() noConnectionFailure,
    required TResult Function(String code, String message) systemFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code, String message)? serverFailure,
    TResult? Function()? dataParsingFailure,
    TResult? Function()? noConnectionFailure,
    TResult? Function(String code, String message)? systemFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code, String message)? serverFailure,
    TResult Function()? dataParsingFailure,
    TResult Function()? noConnectionFailure,
    TResult Function(String code, String message)? systemFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(DataParsingFailure value) dataParsingFailure,
    required TResult Function(NoConnectionFailure value) noConnectionFailure,
    required TResult Function(SystemFailure value) systemFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(DataParsingFailure value)? dataParsingFailure,
    TResult? Function(NoConnectionFailure value)? noConnectionFailure,
    TResult? Function(SystemFailure value)? systemFailure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(DataParsingFailure value)? dataParsingFailure,
    TResult Function(NoConnectionFailure value)? noConnectionFailure,
    TResult Function(SystemFailure value)? systemFailure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureEntityCopyWith<$Res> {
  factory $FailureEntityCopyWith(
          FailureEntity value, $Res Function(FailureEntity) then) =
      _$FailureEntityCopyWithImpl<$Res, FailureEntity>;
}

/// @nodoc
class _$FailureEntityCopyWithImpl<$Res, $Val extends FailureEntity>
    implements $FailureEntityCopyWith<$Res> {
  _$FailureEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ServerFailureImplCopyWith<$Res> {
  factory _$$ServerFailureImplCopyWith(
          _$ServerFailureImpl value, $Res Function(_$ServerFailureImpl) then) =
      __$$ServerFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$ServerFailureImplCopyWithImpl<$Res>
    extends _$FailureEntityCopyWithImpl<$Res, _$ServerFailureImpl>
    implements _$$ServerFailureImplCopyWith<$Res> {
  __$$ServerFailureImplCopyWithImpl(
      _$ServerFailureImpl _value, $Res Function(_$ServerFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$ServerFailureImpl(
      null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ServerFailureImpl extends ServerFailure {
  const _$ServerFailureImpl(this.code, this.message) : super._();

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'FailureEntity.serverFailure(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerFailureImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      __$$ServerFailureImplCopyWithImpl<_$ServerFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code, String message) serverFailure,
    required TResult Function() dataParsingFailure,
    required TResult Function() noConnectionFailure,
    required TResult Function(String code, String message) systemFailure,
  }) {
    return serverFailure(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code, String message)? serverFailure,
    TResult? Function()? dataParsingFailure,
    TResult? Function()? noConnectionFailure,
    TResult? Function(String code, String message)? systemFailure,
  }) {
    return serverFailure?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code, String message)? serverFailure,
    TResult Function()? dataParsingFailure,
    TResult Function()? noConnectionFailure,
    TResult Function(String code, String message)? systemFailure,
    required TResult orElse(),
  }) {
    if (serverFailure != null) {
      return serverFailure(code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(DataParsingFailure value) dataParsingFailure,
    required TResult Function(NoConnectionFailure value) noConnectionFailure,
    required TResult Function(SystemFailure value) systemFailure,
  }) {
    return serverFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(DataParsingFailure value)? dataParsingFailure,
    TResult? Function(NoConnectionFailure value)? noConnectionFailure,
    TResult? Function(SystemFailure value)? systemFailure,
  }) {
    return serverFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(DataParsingFailure value)? dataParsingFailure,
    TResult Function(NoConnectionFailure value)? noConnectionFailure,
    TResult Function(SystemFailure value)? systemFailure,
    required TResult orElse(),
  }) {
    if (serverFailure != null) {
      return serverFailure(this);
    }
    return orElse();
  }
}

abstract class ServerFailure extends FailureEntity {
  const factory ServerFailure(final String code, final String message) =
      _$ServerFailureImpl;
  const ServerFailure._() : super._();

  String get code;
  String get message;
  @JsonKey(ignore: true)
  _$$ServerFailureImplCopyWith<_$ServerFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DataParsingFailureImplCopyWith<$Res> {
  factory _$$DataParsingFailureImplCopyWith(_$DataParsingFailureImpl value,
          $Res Function(_$DataParsingFailureImpl) then) =
      __$$DataParsingFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DataParsingFailureImplCopyWithImpl<$Res>
    extends _$FailureEntityCopyWithImpl<$Res, _$DataParsingFailureImpl>
    implements _$$DataParsingFailureImplCopyWith<$Res> {
  __$$DataParsingFailureImplCopyWithImpl(_$DataParsingFailureImpl _value,
      $Res Function(_$DataParsingFailureImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DataParsingFailureImpl extends DataParsingFailure {
  const _$DataParsingFailureImpl() : super._();

  @override
  String toString() {
    return 'FailureEntity.dataParsingFailure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DataParsingFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code, String message) serverFailure,
    required TResult Function() dataParsingFailure,
    required TResult Function() noConnectionFailure,
    required TResult Function(String code, String message) systemFailure,
  }) {
    return dataParsingFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code, String message)? serverFailure,
    TResult? Function()? dataParsingFailure,
    TResult? Function()? noConnectionFailure,
    TResult? Function(String code, String message)? systemFailure,
  }) {
    return dataParsingFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code, String message)? serverFailure,
    TResult Function()? dataParsingFailure,
    TResult Function()? noConnectionFailure,
    TResult Function(String code, String message)? systemFailure,
    required TResult orElse(),
  }) {
    if (dataParsingFailure != null) {
      return dataParsingFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(DataParsingFailure value) dataParsingFailure,
    required TResult Function(NoConnectionFailure value) noConnectionFailure,
    required TResult Function(SystemFailure value) systemFailure,
  }) {
    return dataParsingFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(DataParsingFailure value)? dataParsingFailure,
    TResult? Function(NoConnectionFailure value)? noConnectionFailure,
    TResult? Function(SystemFailure value)? systemFailure,
  }) {
    return dataParsingFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(DataParsingFailure value)? dataParsingFailure,
    TResult Function(NoConnectionFailure value)? noConnectionFailure,
    TResult Function(SystemFailure value)? systemFailure,
    required TResult orElse(),
  }) {
    if (dataParsingFailure != null) {
      return dataParsingFailure(this);
    }
    return orElse();
  }
}

abstract class DataParsingFailure extends FailureEntity {
  const factory DataParsingFailure() = _$DataParsingFailureImpl;
  const DataParsingFailure._() : super._();
}

/// @nodoc
abstract class _$$NoConnectionFailureImplCopyWith<$Res> {
  factory _$$NoConnectionFailureImplCopyWith(_$NoConnectionFailureImpl value,
          $Res Function(_$NoConnectionFailureImpl) then) =
      __$$NoConnectionFailureImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoConnectionFailureImplCopyWithImpl<$Res>
    extends _$FailureEntityCopyWithImpl<$Res, _$NoConnectionFailureImpl>
    implements _$$NoConnectionFailureImplCopyWith<$Res> {
  __$$NoConnectionFailureImplCopyWithImpl(_$NoConnectionFailureImpl _value,
      $Res Function(_$NoConnectionFailureImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NoConnectionFailureImpl extends NoConnectionFailure {
  const _$NoConnectionFailureImpl() : super._();

  @override
  String toString() {
    return 'FailureEntity.noConnectionFailure()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoConnectionFailureImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code, String message) serverFailure,
    required TResult Function() dataParsingFailure,
    required TResult Function() noConnectionFailure,
    required TResult Function(String code, String message) systemFailure,
  }) {
    return noConnectionFailure();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code, String message)? serverFailure,
    TResult? Function()? dataParsingFailure,
    TResult? Function()? noConnectionFailure,
    TResult? Function(String code, String message)? systemFailure,
  }) {
    return noConnectionFailure?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code, String message)? serverFailure,
    TResult Function()? dataParsingFailure,
    TResult Function()? noConnectionFailure,
    TResult Function(String code, String message)? systemFailure,
    required TResult orElse(),
  }) {
    if (noConnectionFailure != null) {
      return noConnectionFailure();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(DataParsingFailure value) dataParsingFailure,
    required TResult Function(NoConnectionFailure value) noConnectionFailure,
    required TResult Function(SystemFailure value) systemFailure,
  }) {
    return noConnectionFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(DataParsingFailure value)? dataParsingFailure,
    TResult? Function(NoConnectionFailure value)? noConnectionFailure,
    TResult? Function(SystemFailure value)? systemFailure,
  }) {
    return noConnectionFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(DataParsingFailure value)? dataParsingFailure,
    TResult Function(NoConnectionFailure value)? noConnectionFailure,
    TResult Function(SystemFailure value)? systemFailure,
    required TResult orElse(),
  }) {
    if (noConnectionFailure != null) {
      return noConnectionFailure(this);
    }
    return orElse();
  }
}

abstract class NoConnectionFailure extends FailureEntity {
  const factory NoConnectionFailure() = _$NoConnectionFailureImpl;
  const NoConnectionFailure._() : super._();
}

/// @nodoc
abstract class _$$SystemFailureImplCopyWith<$Res> {
  factory _$$SystemFailureImplCopyWith(
          _$SystemFailureImpl value, $Res Function(_$SystemFailureImpl) then) =
      __$$SystemFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String code, String message});
}

/// @nodoc
class __$$SystemFailureImplCopyWithImpl<$Res>
    extends _$FailureEntityCopyWithImpl<$Res, _$SystemFailureImpl>
    implements _$$SystemFailureImplCopyWith<$Res> {
  __$$SystemFailureImplCopyWithImpl(
      _$SystemFailureImpl _value, $Res Function(_$SystemFailureImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
  }) {
    return _then(_$SystemFailureImpl(
      null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$SystemFailureImpl extends SystemFailure {
  const _$SystemFailureImpl(this.code, this.message) : super._();

  @override
  final String code;
  @override
  final String message;

  @override
  String toString() {
    return 'FailureEntity.systemFailure(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemFailureImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemFailureImplCopyWith<_$SystemFailureImpl> get copyWith =>
      __$$SystemFailureImplCopyWithImpl<_$SystemFailureImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String code, String message) serverFailure,
    required TResult Function() dataParsingFailure,
    required TResult Function() noConnectionFailure,
    required TResult Function(String code, String message) systemFailure,
  }) {
    return systemFailure(code, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String code, String message)? serverFailure,
    TResult? Function()? dataParsingFailure,
    TResult? Function()? noConnectionFailure,
    TResult? Function(String code, String message)? systemFailure,
  }) {
    return systemFailure?.call(code, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String code, String message)? serverFailure,
    TResult Function()? dataParsingFailure,
    TResult Function()? noConnectionFailure,
    TResult Function(String code, String message)? systemFailure,
    required TResult orElse(),
  }) {
    if (systemFailure != null) {
      return systemFailure(code, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ServerFailure value) serverFailure,
    required TResult Function(DataParsingFailure value) dataParsingFailure,
    required TResult Function(NoConnectionFailure value) noConnectionFailure,
    required TResult Function(SystemFailure value) systemFailure,
  }) {
    return systemFailure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ServerFailure value)? serverFailure,
    TResult? Function(DataParsingFailure value)? dataParsingFailure,
    TResult? Function(NoConnectionFailure value)? noConnectionFailure,
    TResult? Function(SystemFailure value)? systemFailure,
  }) {
    return systemFailure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ServerFailure value)? serverFailure,
    TResult Function(DataParsingFailure value)? dataParsingFailure,
    TResult Function(NoConnectionFailure value)? noConnectionFailure,
    TResult Function(SystemFailure value)? systemFailure,
    required TResult orElse(),
  }) {
    if (systemFailure != null) {
      return systemFailure(this);
    }
    return orElse();
  }
}

abstract class SystemFailure extends FailureEntity {
  const factory SystemFailure(final String code, final String message) =
      _$SystemFailureImpl;
  const SystemFailure._() : super._();

  String get code;
  String get message;
  @JsonKey(ignore: true)
  _$$SystemFailureImplCopyWith<_$SystemFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
