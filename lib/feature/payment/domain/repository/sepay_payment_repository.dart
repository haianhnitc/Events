import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';

abstract class SePayPaymentRepository {
  Future<Either<FailureEntity, PaymentUrlEntity>> createSePayPayment(
    CreateTransactionParams params,
  );

  Future<Either<FailureEntity, TransactionEntity>> getTransactionById(
    GetTransactionStatusParams params,
  );

  Future<Either<FailureEntity, List<TransactionEntity>>> getTransactions();
}
