import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CreateTransactionParams {
  final TransactionReferenceType referenceType;
  final int? referenceId;
  final int originalAmount;
  final int coinUsed;
  final String currency;
  final PaymentProvider paymentProvider;
  final String? extraData;

  const CreateTransactionParams({
    required this.referenceType,
    this.referenceId,
    required this.originalAmount,
    this.coinUsed = 0,
    this.currency = 'VND',
    this.paymentProvider = PaymentProvider.sepay,
    this.extraData,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'referenceType': referenceType.apiValue,
      'referenceId': referenceId,
      'originalAmount': originalAmount,
      'coinUsed': coinUsed,
      'currency': currency,
      'paymentProvider': paymentProvider.apiValue,
      if (extraData != null && extraData!.trim().isNotEmpty)
        'extraData': extraData,
    };
  }
}

class GetTransactionStatusParams {
  final int transactionId;
  const GetTransactionStatusParams({required this.transactionId});
}
