class PaymentUrlEntity {
  final String? paymentUrl;
  final String? qrCodeUrl;
  final int? orderId;
  final String? requestId;
  final int? expireTime;

  PaymentUrlEntity({
    this.paymentUrl,
    this.qrCodeUrl,
    this.orderId,
    this.requestId,
    this.expireTime,
  });

  DateTime? get expireTimeAsDateTime {
    if (expireTime == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expireTime!);
  }

  bool get isExpired {
    final dt = expireTimeAsDateTime;
    if (dt == null) return false;
    return DateTime.now().isAfter(dt);
  }
}
