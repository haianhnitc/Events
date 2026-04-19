import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/payment_url_entity.dart';

part 'payment_url_model.freezed.dart';
part 'payment_url_model.g.dart';

@freezed
class PaymentUrlModel with _$PaymentUrlModel {
  const factory PaymentUrlModel({
    String? paymentUrl,
    String? qrCodeUrl,
    int? orderId,
    String? requestId,
    @JsonKey(name: 'expireTime') int? expireTime,
  }) = _PaymentUrlModel;

  factory PaymentUrlModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentUrlModelFromJson(json);
}

extension PaymentUrlModelToEntity on PaymentUrlModel {
  PaymentUrlEntity toEntity() {
    return PaymentUrlEntity(
      paymentUrl: paymentUrl,
      qrCodeUrl: qrCodeUrl,
      orderId: orderId,
      requestId: requestId,
      expireTime: expireTime,
    );
  }
}
