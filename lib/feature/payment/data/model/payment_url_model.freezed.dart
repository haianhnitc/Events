// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_url_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentUrlModel _$PaymentUrlModelFromJson(Map<String, dynamic> json) {
  return _PaymentUrlModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentUrlModel {
  String? get paymentUrl => throw _privateConstructorUsedError;
  String? get qrCodeUrl => throw _privateConstructorUsedError;
  int? get orderId => throw _privateConstructorUsedError;
  String? get requestId => throw _privateConstructorUsedError;
  @JsonKey(name: 'expireTime')
  int? get expireTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentUrlModelCopyWith<PaymentUrlModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentUrlModelCopyWith<$Res> {
  factory $PaymentUrlModelCopyWith(
          PaymentUrlModel value, $Res Function(PaymentUrlModel) then) =
      _$PaymentUrlModelCopyWithImpl<$Res, PaymentUrlModel>;
  @useResult
  $Res call(
      {String? paymentUrl,
      String? qrCodeUrl,
      int? orderId,
      String? requestId,
      @JsonKey(name: 'expireTime') int? expireTime});
}

/// @nodoc
class _$PaymentUrlModelCopyWithImpl<$Res, $Val extends PaymentUrlModel>
    implements $PaymentUrlModelCopyWith<$Res> {
  _$PaymentUrlModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentUrl = freezed,
    Object? qrCodeUrl = freezed,
    Object? orderId = freezed,
    Object? requestId = freezed,
    Object? expireTime = freezed,
  }) {
    return _then(_value.copyWith(
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      expireTime: freezed == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentUrlModelImplCopyWith<$Res>
    implements $PaymentUrlModelCopyWith<$Res> {
  factory _$$PaymentUrlModelImplCopyWith(_$PaymentUrlModelImpl value,
          $Res Function(_$PaymentUrlModelImpl) then) =
      __$$PaymentUrlModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? paymentUrl,
      String? qrCodeUrl,
      int? orderId,
      String? requestId,
      @JsonKey(name: 'expireTime') int? expireTime});
}

/// @nodoc
class __$$PaymentUrlModelImplCopyWithImpl<$Res>
    extends _$PaymentUrlModelCopyWithImpl<$Res, _$PaymentUrlModelImpl>
    implements _$$PaymentUrlModelImplCopyWith<$Res> {
  __$$PaymentUrlModelImplCopyWithImpl(
      _$PaymentUrlModelImpl _value, $Res Function(_$PaymentUrlModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentUrl = freezed,
    Object? qrCodeUrl = freezed,
    Object? orderId = freezed,
    Object? requestId = freezed,
    Object? expireTime = freezed,
  }) {
    return _then(_$PaymentUrlModelImpl(
      paymentUrl: freezed == paymentUrl
          ? _value.paymentUrl
          : paymentUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      qrCodeUrl: freezed == qrCodeUrl
          ? _value.qrCodeUrl
          : qrCodeUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      orderId: freezed == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int?,
      requestId: freezed == requestId
          ? _value.requestId
          : requestId // ignore: cast_nullable_to_non_nullable
              as String?,
      expireTime: freezed == expireTime
          ? _value.expireTime
          : expireTime // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentUrlModelImpl implements _PaymentUrlModel {
  const _$PaymentUrlModelImpl(
      {this.paymentUrl,
      this.qrCodeUrl,
      this.orderId,
      this.requestId,
      @JsonKey(name: 'expireTime') this.expireTime});

  factory _$PaymentUrlModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentUrlModelImplFromJson(json);

  @override
  final String? paymentUrl;
  @override
  final String? qrCodeUrl;
  @override
  final int? orderId;
  @override
  final String? requestId;
  @override
  @JsonKey(name: 'expireTime')
  final int? expireTime;

  @override
  String toString() {
    return 'PaymentUrlModel(paymentUrl: $paymentUrl, qrCodeUrl: $qrCodeUrl, orderId: $orderId, requestId: $requestId, expireTime: $expireTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentUrlModelImpl &&
            (identical(other.paymentUrl, paymentUrl) ||
                other.paymentUrl == paymentUrl) &&
            (identical(other.qrCodeUrl, qrCodeUrl) ||
                other.qrCodeUrl == qrCodeUrl) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.requestId, requestId) ||
                other.requestId == requestId) &&
            (identical(other.expireTime, expireTime) ||
                other.expireTime == expireTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, paymentUrl, qrCodeUrl, orderId, requestId, expireTime);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentUrlModelImplCopyWith<_$PaymentUrlModelImpl> get copyWith =>
      __$$PaymentUrlModelImplCopyWithImpl<_$PaymentUrlModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentUrlModelImplToJson(
      this,
    );
  }
}

abstract class _PaymentUrlModel implements PaymentUrlModel {
  const factory _PaymentUrlModel(
          {final String? paymentUrl,
          final String? qrCodeUrl,
          final int? orderId,
          final String? requestId,
          @JsonKey(name: 'expireTime') final int? expireTime}) =
      _$PaymentUrlModelImpl;

  factory _PaymentUrlModel.fromJson(Map<String, dynamic> json) =
      _$PaymentUrlModelImpl.fromJson;

  @override
  String? get paymentUrl;
  @override
  String? get qrCodeUrl;
  @override
  int? get orderId;
  @override
  String? get requestId;
  @override
  @JsonKey(name: 'expireTime')
  int? get expireTime;
  @override
  @JsonKey(ignore: true)
  _$$PaymentUrlModelImplCopyWith<_$PaymentUrlModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
