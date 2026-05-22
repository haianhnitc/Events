// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ApiResponse<Model> {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseCopyWith<Model, $Res> {
  factory $ApiResponseCopyWith(
          ApiResponse<Model> value, $Res Function(ApiResponse<Model>) then) =
      _$ApiResponseCopyWithImpl<Model, $Res, ApiResponse<Model>>;
}

/// @nodoc
class _$ApiResponseCopyWithImpl<Model, $Res, $Val extends ApiResponse<Model>>
    implements $ApiResponseCopyWith<Model, $Res> {
  _$ApiResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<Model, $Res> {
  factory _$$SuccessImplCopyWith(_$SuccessImpl<Model> value,
          $Res Function(_$SuccessImpl<Model>) then) =
      __$$SuccessImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({Model model});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$SuccessImpl<Model>>
    implements _$$SuccessImplCopyWith<Model, $Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl<Model> _value, $Res Function(_$SuccessImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? model = freezed,
  }) {
    return _then(_$SuccessImpl<Model>(
      freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as Model,
    ));
  }
}

/// @nodoc

class _$SuccessImpl<Model> implements _Success<Model> {
  const _$SuccessImpl(this.model);

  @override
  final Model model;

  @override
  String toString() {
    return 'ApiResponse<$Model>.success(model: $model)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl<Model> &&
            const DeepCollectionEquality().equals(other.model, model));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(model));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<Model, _$SuccessImpl<Model>> get copyWith =>
      __$$SuccessImplCopyWithImpl<Model, _$SuccessImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return success(model);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return success?.call(model);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(model);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success<Model> implements ApiResponse<Model> {
  const factory _Success(final Model model) = _$SuccessImpl<Model>;

  Model get model;
  @JsonKey(ignore: true)
  _$$SuccessImplCopyWith<Model, _$SuccessImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BadRequestImplCopyWith<Model, $Res> {
  factory _$$BadRequestImplCopyWith(_$BadRequestImpl<Model> value,
          $Res Function(_$BadRequestImpl<Model>) then) =
      __$$BadRequestImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({ApiResponseError error});

  $ApiResponseErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$BadRequestImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$BadRequestImpl<Model>>
    implements _$$BadRequestImplCopyWith<Model, $Res> {
  __$$BadRequestImplCopyWithImpl(_$BadRequestImpl<Model> _value,
      $Res Function(_$BadRequestImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$BadRequestImpl<Model>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiResponseError,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiResponseErrorCopyWith<$Res> get error {
    return $ApiResponseErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$BadRequestImpl<Model> implements _BadRequest<Model> {
  const _$BadRequestImpl(this.error);

  @override
  final ApiResponseError error;

  @override
  String toString() {
    return 'ApiResponse<$Model>.badRequest(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BadRequestImpl<Model> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BadRequestImplCopyWith<Model, _$BadRequestImpl<Model>> get copyWith =>
      __$$BadRequestImplCopyWithImpl<Model, _$BadRequestImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return badRequest(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return badRequest?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return badRequest(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return badRequest?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (badRequest != null) {
      return badRequest(this);
    }
    return orElse();
  }
}

abstract class _BadRequest<Model> implements ApiResponse<Model> {
  const factory _BadRequest(final ApiResponseError error) =
      _$BadRequestImpl<Model>;

  ApiResponseError get error;
  @JsonKey(ignore: true)
  _$$BadRequestImplCopyWith<Model, _$BadRequestImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedImplCopyWith<Model, $Res> {
  factory _$$UnauthorizedImplCopyWith(_$UnauthorizedImpl<Model> value,
          $Res Function(_$UnauthorizedImpl<Model>) then) =
      __$$UnauthorizedImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({ApiResponseError error});

  $ApiResponseErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$UnauthorizedImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$UnauthorizedImpl<Model>>
    implements _$$UnauthorizedImplCopyWith<Model, $Res> {
  __$$UnauthorizedImplCopyWithImpl(_$UnauthorizedImpl<Model> _value,
      $Res Function(_$UnauthorizedImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$UnauthorizedImpl<Model>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiResponseError,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiResponseErrorCopyWith<$Res> get error {
    return $ApiResponseErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$UnauthorizedImpl<Model> implements _Unauthorized<Model> {
  const _$UnauthorizedImpl(this.error);

  @override
  final ApiResponseError error;

  @override
  String toString() {
    return 'ApiResponse<$Model>.unauthorized(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedImpl<Model> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthorizedImplCopyWith<Model, _$UnauthorizedImpl<Model>> get copyWith =>
      __$$UnauthorizedImplCopyWithImpl<Model, _$UnauthorizedImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return unauthorized(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return unauthorized?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class _Unauthorized<Model> implements ApiResponse<Model> {
  const factory _Unauthorized(final ApiResponseError error) =
      _$UnauthorizedImpl<Model>;

  ApiResponseError get error;
  @JsonKey(ignore: true)
  _$$UnauthorizedImplCopyWith<Model, _$UnauthorizedImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ForbiddenImplCopyWith<Model, $Res> {
  factory _$$ForbiddenImplCopyWith(_$ForbiddenImpl<Model> value,
          $Res Function(_$ForbiddenImpl<Model>) then) =
      __$$ForbiddenImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({ApiResponseError error});

  $ApiResponseErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$ForbiddenImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$ForbiddenImpl<Model>>
    implements _$$ForbiddenImplCopyWith<Model, $Res> {
  __$$ForbiddenImplCopyWithImpl(_$ForbiddenImpl<Model> _value,
      $Res Function(_$ForbiddenImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$ForbiddenImpl<Model>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiResponseError,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiResponseErrorCopyWith<$Res> get error {
    return $ApiResponseErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$ForbiddenImpl<Model> implements _Forbidden<Model> {
  const _$ForbiddenImpl(this.error);

  @override
  final ApiResponseError error;

  @override
  String toString() {
    return 'ApiResponse<$Model>.forbidden(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForbiddenImpl<Model> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ForbiddenImplCopyWith<Model, _$ForbiddenImpl<Model>> get copyWith =>
      __$$ForbiddenImplCopyWithImpl<Model, _$ForbiddenImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return forbidden(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return forbidden?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return forbidden(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return forbidden?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (forbidden != null) {
      return forbidden(this);
    }
    return orElse();
  }
}

abstract class _Forbidden<Model> implements ApiResponse<Model> {
  const factory _Forbidden(final ApiResponseError error) =
      _$ForbiddenImpl<Model>;

  ApiResponseError get error;
  @JsonKey(ignore: true)
  _$$ForbiddenImplCopyWith<Model, _$ForbiddenImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundImplCopyWith<Model, $Res> {
  factory _$$NotFoundImplCopyWith(_$NotFoundImpl<Model> value,
          $Res Function(_$NotFoundImpl<Model>) then) =
      __$$NotFoundImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({ApiResponseError error});

  $ApiResponseErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$NotFoundImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$NotFoundImpl<Model>>
    implements _$$NotFoundImplCopyWith<Model, $Res> {
  __$$NotFoundImplCopyWithImpl(
      _$NotFoundImpl<Model> _value, $Res Function(_$NotFoundImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$NotFoundImpl<Model>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiResponseError,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiResponseErrorCopyWith<$Res> get error {
    return $ApiResponseErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$NotFoundImpl<Model> implements _NotFound<Model> {
  const _$NotFoundImpl(this.error);

  @override
  final ApiResponseError error;

  @override
  String toString() {
    return 'ApiResponse<$Model>.notFound(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundImpl<Model> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundImplCopyWith<Model, _$NotFoundImpl<Model>> get copyWith =>
      __$$NotFoundImplCopyWithImpl<Model, _$NotFoundImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return notFound(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return notFound?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class _NotFound<Model> implements ApiResponse<Model> {
  const factory _NotFound(final ApiResponseError error) = _$NotFoundImpl<Model>;

  ApiResponseError get error;
  @JsonKey(ignore: true)
  _$$NotFoundImplCopyWith<Model, _$NotFoundImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConflictImplCopyWith<Model, $Res> {
  factory _$$ConflictImplCopyWith(_$ConflictImpl<Model> value,
          $Res Function(_$ConflictImpl<Model>) then) =
      __$$ConflictImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({ApiResponseError error});

  $ApiResponseErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$ConflictImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$ConflictImpl<Model>>
    implements _$$ConflictImplCopyWith<Model, $Res> {
  __$$ConflictImplCopyWithImpl(
      _$ConflictImpl<Model> _value, $Res Function(_$ConflictImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$ConflictImpl<Model>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiResponseError,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiResponseErrorCopyWith<$Res> get error {
    return $ApiResponseErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$ConflictImpl<Model> implements _Conflict<Model> {
  const _$ConflictImpl(this.error);

  @override
  final ApiResponseError error;

  @override
  String toString() {
    return 'ApiResponse<$Model>.conflict(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConflictImpl<Model> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConflictImplCopyWith<Model, _$ConflictImpl<Model>> get copyWith =>
      __$$ConflictImplCopyWithImpl<Model, _$ConflictImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return conflict(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return conflict?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (conflict != null) {
      return conflict(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return conflict(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return conflict?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (conflict != null) {
      return conflict(this);
    }
    return orElse();
  }
}

abstract class _Conflict<Model> implements ApiResponse<Model> {
  const factory _Conflict(final ApiResponseError error) = _$ConflictImpl<Model>;

  ApiResponseError get error;
  @JsonKey(ignore: true)
  _$$ConflictImplCopyWith<Model, _$ConflictImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InternalServerErrorImplCopyWith<Model, $Res> {
  factory _$$InternalServerErrorImplCopyWith(
          _$InternalServerErrorImpl<Model> value,
          $Res Function(_$InternalServerErrorImpl<Model>) then) =
      __$$InternalServerErrorImplCopyWithImpl<Model, $Res>;
}

/// @nodoc
class __$$InternalServerErrorImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res,
        _$InternalServerErrorImpl<Model>>
    implements _$$InternalServerErrorImplCopyWith<Model, $Res> {
  __$$InternalServerErrorImplCopyWithImpl(
      _$InternalServerErrorImpl<Model> _value,
      $Res Function(_$InternalServerErrorImpl<Model>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$InternalServerErrorImpl<Model> implements _InternalServerError<Model> {
  const _$InternalServerErrorImpl();

  @override
  String toString() {
    return 'ApiResponse<$Model>.internalServerError()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InternalServerErrorImpl<Model>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return internalServerError();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return internalServerError?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (internalServerError != null) {
      return internalServerError();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return internalServerError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return internalServerError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (internalServerError != null) {
      return internalServerError(this);
    }
    return orElse();
  }
}

abstract class _InternalServerError<Model> implements ApiResponse<Model> {
  const factory _InternalServerError() = _$InternalServerErrorImpl<Model>;
}

/// @nodoc
abstract class _$$BadGatewayImplCopyWith<Model, $Res> {
  factory _$$BadGatewayImplCopyWith(_$BadGatewayImpl<Model> value,
          $Res Function(_$BadGatewayImpl<Model>) then) =
      __$$BadGatewayImplCopyWithImpl<Model, $Res>;
}

/// @nodoc
class __$$BadGatewayImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$BadGatewayImpl<Model>>
    implements _$$BadGatewayImplCopyWith<Model, $Res> {
  __$$BadGatewayImplCopyWithImpl(_$BadGatewayImpl<Model> _value,
      $Res Function(_$BadGatewayImpl<Model>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$BadGatewayImpl<Model> implements _BadGateway<Model> {
  const _$BadGatewayImpl();

  @override
  String toString() {
    return 'ApiResponse<$Model>.badGateway()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BadGatewayImpl<Model>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return badGateway();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return badGateway?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (badGateway != null) {
      return badGateway();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return badGateway(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return badGateway?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (badGateway != null) {
      return badGateway(this);
    }
    return orElse();
  }
}

abstract class _BadGateway<Model> implements ApiResponse<Model> {
  const factory _BadGateway() = _$BadGatewayImpl<Model>;
}

/// @nodoc
abstract class _$$ServiceUnavailableImplCopyWith<Model, $Res> {
  factory _$$ServiceUnavailableImplCopyWith(
          _$ServiceUnavailableImpl<Model> value,
          $Res Function(_$ServiceUnavailableImpl<Model>) then) =
      __$$ServiceUnavailableImplCopyWithImpl<Model, $Res>;
}

/// @nodoc
class __$$ServiceUnavailableImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res,
        _$ServiceUnavailableImpl<Model>>
    implements _$$ServiceUnavailableImplCopyWith<Model, $Res> {
  __$$ServiceUnavailableImplCopyWithImpl(_$ServiceUnavailableImpl<Model> _value,
      $Res Function(_$ServiceUnavailableImpl<Model>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ServiceUnavailableImpl<Model> implements _ServiceUnavailable<Model> {
  const _$ServiceUnavailableImpl();

  @override
  String toString() {
    return 'ApiResponse<$Model>.serviceUnavailable()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceUnavailableImpl<Model>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return serviceUnavailable();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return serviceUnavailable?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (serviceUnavailable != null) {
      return serviceUnavailable();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return serviceUnavailable(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return serviceUnavailable?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (serviceUnavailable != null) {
      return serviceUnavailable(this);
    }
    return orElse();
  }
}

abstract class _ServiceUnavailable<Model> implements ApiResponse<Model> {
  const factory _ServiceUnavailable() = _$ServiceUnavailableImpl<Model>;
}

/// @nodoc
abstract class _$$GatewayTimeoutImplCopyWith<Model, $Res> {
  factory _$$GatewayTimeoutImplCopyWith(_$GatewayTimeoutImpl<Model> value,
          $Res Function(_$GatewayTimeoutImpl<Model>) then) =
      __$$GatewayTimeoutImplCopyWithImpl<Model, $Res>;
}

/// @nodoc
class __$$GatewayTimeoutImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$GatewayTimeoutImpl<Model>>
    implements _$$GatewayTimeoutImplCopyWith<Model, $Res> {
  __$$GatewayTimeoutImplCopyWithImpl(_$GatewayTimeoutImpl<Model> _value,
      $Res Function(_$GatewayTimeoutImpl<Model>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GatewayTimeoutImpl<Model> implements _GatewayTimeout<Model> {
  const _$GatewayTimeoutImpl();

  @override
  String toString() {
    return 'ApiResponse<$Model>.gatewayTimeout()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GatewayTimeoutImpl<Model>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return gatewayTimeout();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return gatewayTimeout?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (gatewayTimeout != null) {
      return gatewayTimeout();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return gatewayTimeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return gatewayTimeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (gatewayTimeout != null) {
      return gatewayTimeout(this);
    }
    return orElse();
  }
}

abstract class _GatewayTimeout<Model> implements ApiResponse<Model> {
  const factory _GatewayTimeout() = _$GatewayTimeoutImpl<Model>;
}

/// @nodoc
abstract class _$$CanceledImplCopyWith<Model, $Res> {
  factory _$$CanceledImplCopyWith(_$CanceledImpl<Model> value,
          $Res Function(_$CanceledImpl<Model>) then) =
      __$$CanceledImplCopyWithImpl<Model, $Res>;
}

/// @nodoc
class __$$CanceledImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$CanceledImpl<Model>>
    implements _$$CanceledImplCopyWith<Model, $Res> {
  __$$CanceledImplCopyWithImpl(
      _$CanceledImpl<Model> _value, $Res Function(_$CanceledImpl<Model>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$CanceledImpl<Model> implements _Canceled<Model> {
  const _$CanceledImpl();

  @override
  String toString() {
    return 'ApiResponse<$Model>.canceled()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CanceledImpl<Model>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return canceled();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return canceled?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (canceled != null) {
      return canceled();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return canceled(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return canceled?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (canceled != null) {
      return canceled(this);
    }
    return orElse();
  }
}

abstract class _Canceled<Model> implements ApiResponse<Model> {
  const factory _Canceled() = _$CanceledImpl<Model>;
}

/// @nodoc
abstract class _$$ResponseParsingImplCopyWith<Model, $Res> {
  factory _$$ResponseParsingImplCopyWith(_$ResponseParsingImpl<Model> value,
          $Res Function(_$ResponseParsingImpl<Model>) then) =
      __$$ResponseParsingImplCopyWithImpl<Model, $Res>;
}

/// @nodoc
class __$$ResponseParsingImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$ResponseParsingImpl<Model>>
    implements _$$ResponseParsingImplCopyWith<Model, $Res> {
  __$$ResponseParsingImplCopyWithImpl(_$ResponseParsingImpl<Model> _value,
      $Res Function(_$ResponseParsingImpl<Model>) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ResponseParsingImpl<Model> implements _ResponseParsing<Model> {
  const _$ResponseParsingImpl();

  @override
  String toString() {
    return 'ApiResponse<$Model>.responseParsing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResponseParsingImpl<Model>);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return responseParsing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return responseParsing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (responseParsing != null) {
      return responseParsing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return responseParsing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return responseParsing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (responseParsing != null) {
      return responseParsing(this);
    }
    return orElse();
  }
}

abstract class _ResponseParsing<Model> implements ApiResponse<Model> {
  const factory _ResponseParsing() = _$ResponseParsingImpl<Model>;
}

/// @nodoc
abstract class _$$UnexpectedImplCopyWith<Model, $Res> {
  factory _$$UnexpectedImplCopyWith(_$UnexpectedImpl<Model> value,
          $Res Function(_$UnexpectedImpl<Model>) then) =
      __$$UnexpectedImplCopyWithImpl<Model, $Res>;
  @useResult
  $Res call({ApiResponseError error});

  $ApiResponseErrorCopyWith<$Res> get error;
}

/// @nodoc
class __$$UnexpectedImplCopyWithImpl<Model, $Res>
    extends _$ApiResponseCopyWithImpl<Model, $Res, _$UnexpectedImpl<Model>>
    implements _$$UnexpectedImplCopyWith<Model, $Res> {
  __$$UnexpectedImplCopyWithImpl(_$UnexpectedImpl<Model> _value,
      $Res Function(_$UnexpectedImpl<Model>) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
  }) {
    return _then(_$UnexpectedImpl<Model>(
      null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ApiResponseError,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $ApiResponseErrorCopyWith<$Res> get error {
    return $ApiResponseErrorCopyWith<$Res>(_value.error, (value) {
      return _then(_value.copyWith(error: value));
    });
  }
}

/// @nodoc

class _$UnexpectedImpl<Model> implements _Unexpected<Model> {
  const _$UnexpectedImpl(this.error);

  @override
  final ApiResponseError error;

  @override
  String toString() {
    return 'ApiResponse<$Model>.unexpected(error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedImpl<Model> &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedImplCopyWith<Model, _$UnexpectedImpl<Model>> get copyWith =>
      __$$UnexpectedImplCopyWithImpl<Model, _$UnexpectedImpl<Model>>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(Model model) success,
    required TResult Function(ApiResponseError error) badRequest,
    required TResult Function(ApiResponseError error) unauthorized,
    required TResult Function(ApiResponseError error) forbidden,
    required TResult Function(ApiResponseError error) notFound,
    required TResult Function(ApiResponseError error) conflict,
    required TResult Function() internalServerError,
    required TResult Function() badGateway,
    required TResult Function() serviceUnavailable,
    required TResult Function() gatewayTimeout,
    required TResult Function() canceled,
    required TResult Function() responseParsing,
    required TResult Function(ApiResponseError error) unexpected,
  }) {
    return unexpected(error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(Model model)? success,
    TResult? Function(ApiResponseError error)? badRequest,
    TResult? Function(ApiResponseError error)? unauthorized,
    TResult? Function(ApiResponseError error)? forbidden,
    TResult? Function(ApiResponseError error)? notFound,
    TResult? Function(ApiResponseError error)? conflict,
    TResult? Function()? internalServerError,
    TResult? Function()? badGateway,
    TResult? Function()? serviceUnavailable,
    TResult? Function()? gatewayTimeout,
    TResult? Function()? canceled,
    TResult? Function()? responseParsing,
    TResult? Function(ApiResponseError error)? unexpected,
  }) {
    return unexpected?.call(error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(Model model)? success,
    TResult Function(ApiResponseError error)? badRequest,
    TResult Function(ApiResponseError error)? unauthorized,
    TResult Function(ApiResponseError error)? forbidden,
    TResult Function(ApiResponseError error)? notFound,
    TResult Function(ApiResponseError error)? conflict,
    TResult Function()? internalServerError,
    TResult Function()? badGateway,
    TResult Function()? serviceUnavailable,
    TResult Function()? gatewayTimeout,
    TResult Function()? canceled,
    TResult Function()? responseParsing,
    TResult Function(ApiResponseError error)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Success<Model> value) success,
    required TResult Function(_BadRequest<Model> value) badRequest,
    required TResult Function(_Unauthorized<Model> value) unauthorized,
    required TResult Function(_Forbidden<Model> value) forbidden,
    required TResult Function(_NotFound<Model> value) notFound,
    required TResult Function(_Conflict<Model> value) conflict,
    required TResult Function(_InternalServerError<Model> value)
        internalServerError,
    required TResult Function(_BadGateway<Model> value) badGateway,
    required TResult Function(_ServiceUnavailable<Model> value)
        serviceUnavailable,
    required TResult Function(_GatewayTimeout<Model> value) gatewayTimeout,
    required TResult Function(_Canceled<Model> value) canceled,
    required TResult Function(_ResponseParsing<Model> value) responseParsing,
    required TResult Function(_Unexpected<Model> value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Success<Model> value)? success,
    TResult? Function(_BadRequest<Model> value)? badRequest,
    TResult? Function(_Unauthorized<Model> value)? unauthorized,
    TResult? Function(_Forbidden<Model> value)? forbidden,
    TResult? Function(_NotFound<Model> value)? notFound,
    TResult? Function(_Conflict<Model> value)? conflict,
    TResult? Function(_InternalServerError<Model> value)? internalServerError,
    TResult? Function(_BadGateway<Model> value)? badGateway,
    TResult? Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult? Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult? Function(_Canceled<Model> value)? canceled,
    TResult? Function(_ResponseParsing<Model> value)? responseParsing,
    TResult? Function(_Unexpected<Model> value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Success<Model> value)? success,
    TResult Function(_BadRequest<Model> value)? badRequest,
    TResult Function(_Unauthorized<Model> value)? unauthorized,
    TResult Function(_Forbidden<Model> value)? forbidden,
    TResult Function(_NotFound<Model> value)? notFound,
    TResult Function(_Conflict<Model> value)? conflict,
    TResult Function(_InternalServerError<Model> value)? internalServerError,
    TResult Function(_BadGateway<Model> value)? badGateway,
    TResult Function(_ServiceUnavailable<Model> value)? serviceUnavailable,
    TResult Function(_GatewayTimeout<Model> value)? gatewayTimeout,
    TResult Function(_Canceled<Model> value)? canceled,
    TResult Function(_ResponseParsing<Model> value)? responseParsing,
    TResult Function(_Unexpected<Model> value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class _Unexpected<Model> implements ApiResponse<Model> {
  const factory _Unexpected(final ApiResponseError error) =
      _$UnexpectedImpl<Model>;

  ApiResponseError get error;
  @JsonKey(ignore: true)
  _$$UnexpectedImplCopyWith<Model, _$UnexpectedImpl<Model>> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiResponseError _$ApiResponseErrorFromJson(Map<String, dynamic> json) {
  return _ApiResponseError.fromJson(json);
}

/// @nodoc
mixin _$ApiResponseError {
  String get code => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<ApiResponseErrorDetail>? get errors =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiResponseErrorCopyWith<ApiResponseError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseErrorCopyWith<$Res> {
  factory $ApiResponseErrorCopyWith(
          ApiResponseError value, $Res Function(ApiResponseError) then) =
      _$ApiResponseErrorCopyWithImpl<$Res, ApiResponseError>;
  @useResult
  $Res call(
      {String code, String message, List<ApiResponseErrorDetail>? errors});
}

/// @nodoc
class _$ApiResponseErrorCopyWithImpl<$Res, $Val extends ApiResponseError>
    implements $ApiResponseErrorCopyWith<$Res> {
  _$ApiResponseErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<ApiResponseErrorDetail>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseErrorImplCopyWith<$Res>
    implements $ApiResponseErrorCopyWith<$Res> {
  factory _$$ApiResponseErrorImplCopyWith(_$ApiResponseErrorImpl value,
          $Res Function(_$ApiResponseErrorImpl) then) =
      __$$ApiResponseErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code, String message, List<ApiResponseErrorDetail>? errors});
}

/// @nodoc
class __$$ApiResponseErrorImplCopyWithImpl<$Res>
    extends _$ApiResponseErrorCopyWithImpl<$Res, _$ApiResponseErrorImpl>
    implements _$$ApiResponseErrorImplCopyWith<$Res> {
  __$$ApiResponseErrorImplCopyWithImpl(_$ApiResponseErrorImpl _value,
      $Res Function(_$ApiResponseErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? message = null,
    Object? errors = freezed,
  }) {
    return _then(_$ApiResponseErrorImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      errors: freezed == errors
          ? _value._errors
          : errors // ignore: cast_nullable_to_non_nullable
              as List<ApiResponseErrorDetail>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiResponseErrorImpl implements _ApiResponseError {
  const _$ApiResponseErrorImpl(
      {required this.code,
      required this.message,
      required final List<ApiResponseErrorDetail>? errors})
      : _errors = errors;

  factory _$ApiResponseErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiResponseErrorImplFromJson(json);

  @override
  final String code;
  @override
  final String message;
  final List<ApiResponseErrorDetail>? _errors;
  @override
  List<ApiResponseErrorDetail>? get errors {
    final value = _errors;
    if (value == null) return null;
    if (_errors is EqualUnmodifiableListView) return _errors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ApiResponseError(code: $code, message: $message, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other._errors, _errors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, code, message, const DeepCollectionEquality().hash(_errors));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseErrorImplCopyWith<_$ApiResponseErrorImpl> get copyWith =>
      __$$ApiResponseErrorImplCopyWithImpl<_$ApiResponseErrorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiResponseErrorImplToJson(
      this,
    );
  }
}

abstract class _ApiResponseError implements ApiResponseError {
  const factory _ApiResponseError(
          {required final String code,
          required final String message,
          required final List<ApiResponseErrorDetail>? errors}) =
      _$ApiResponseErrorImpl;

  factory _ApiResponseError.fromJson(Map<String, dynamic> json) =
      _$ApiResponseErrorImpl.fromJson;

  @override
  String get code;
  @override
  String get message;
  @override
  List<ApiResponseErrorDetail>? get errors;
  @override
  @JsonKey(ignore: true)
  _$$ApiResponseErrorImplCopyWith<_$ApiResponseErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApiResponseErrorDetail _$ApiResponseErrorDetailFromJson(
    Map<String, dynamic> json) {
  return _ApiResponseErrorDetail.fromJson(json);
}

/// @nodoc
mixin _$ApiResponseErrorDetail {
  String? get reason => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApiResponseErrorDetailCopyWith<ApiResponseErrorDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiResponseErrorDetailCopyWith<$Res> {
  factory $ApiResponseErrorDetailCopyWith(ApiResponseErrorDetail value,
          $Res Function(ApiResponseErrorDetail) then) =
      _$ApiResponseErrorDetailCopyWithImpl<$Res, ApiResponseErrorDetail>;
  @useResult
  $Res call({String? reason, String? description});
}

/// @nodoc
class _$ApiResponseErrorDetailCopyWithImpl<$Res,
        $Val extends ApiResponseErrorDetail>
    implements $ApiResponseErrorDetailCopyWith<$Res> {
  _$ApiResponseErrorDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApiResponseErrorDetailImplCopyWith<$Res>
    implements $ApiResponseErrorDetailCopyWith<$Res> {
  factory _$$ApiResponseErrorDetailImplCopyWith(
          _$ApiResponseErrorDetailImpl value,
          $Res Function(_$ApiResponseErrorDetailImpl) then) =
      __$$ApiResponseErrorDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? reason, String? description});
}

/// @nodoc
class __$$ApiResponseErrorDetailImplCopyWithImpl<$Res>
    extends _$ApiResponseErrorDetailCopyWithImpl<$Res,
        _$ApiResponseErrorDetailImpl>
    implements _$$ApiResponseErrorDetailImplCopyWith<$Res> {
  __$$ApiResponseErrorDetailImplCopyWithImpl(
      _$ApiResponseErrorDetailImpl _value,
      $Res Function(_$ApiResponseErrorDetailImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reason = freezed,
    Object? description = freezed,
  }) {
    return _then(_$ApiResponseErrorDetailImpl(
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApiResponseErrorDetailImpl implements _ApiResponseErrorDetail {
  const _$ApiResponseErrorDetailImpl({this.reason, this.description});

  factory _$ApiResponseErrorDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApiResponseErrorDetailImplFromJson(json);

  @override
  final String? reason;
  @override
  final String? description;

  @override
  String toString() {
    return 'ApiResponseErrorDetail(reason: $reason, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApiResponseErrorDetailImpl &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, reason, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApiResponseErrorDetailImplCopyWith<_$ApiResponseErrorDetailImpl>
      get copyWith => __$$ApiResponseErrorDetailImplCopyWithImpl<
          _$ApiResponseErrorDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApiResponseErrorDetailImplToJson(
      this,
    );
  }
}

abstract class _ApiResponseErrorDetail implements ApiResponseErrorDetail {
  const factory _ApiResponseErrorDetail(
      {final String? reason,
      final String? description}) = _$ApiResponseErrorDetailImpl;

  factory _ApiResponseErrorDetail.fromJson(Map<String, dynamic> json) =
      _$ApiResponseErrorDetailImpl.fromJson;

  @override
  String? get reason;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$ApiResponseErrorDetailImplCopyWith<_$ApiResponseErrorDetailImpl>
      get copyWith => throw _privateConstructorUsedError;
}
