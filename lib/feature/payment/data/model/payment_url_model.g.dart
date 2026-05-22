// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_url_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentUrlModelImpl _$$PaymentUrlModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PaymentUrlModelImpl(
      paymentUrl: json['paymentUrl'] as String?,
      qrCodeUrl: json['qrCodeUrl'] as String?,
      orderId: (json['orderId'] as num?)?.toInt(),
      requestId: json['requestId'] as String?,
      expireTime: (json['expireTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$PaymentUrlModelImplToJson(
        _$PaymentUrlModelImpl instance) =>
    <String, dynamic>{
      'paymentUrl': instance.paymentUrl,
      'qrCodeUrl': instance.qrCodeUrl,
      'orderId': instance.orderId,
      'requestId': instance.requestId,
      'expireTime': instance.expireTime,
    };
