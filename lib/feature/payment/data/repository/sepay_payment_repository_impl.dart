import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/payment/data/datasource/sepay_payment_datasource.dart';
import 'package:events_app/feature/payment/data/model/payment_url_model.dart';
import 'package:events_app/feature/payment/data/model/transaction_model.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/repository/sepay_payment_repository.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SePayPaymentRepository)
class SePayPaymentRepositoryImpl implements SePayPaymentRepository {
  final SePayPaymentDatasource _datasource;

  SePayPaymentRepositoryImpl(this._datasource);

  @override
  Future<Either<FailureEntity, PaymentUrlEntity>> createSePayPayment(
      CreateTransactionParams params) async {
    final response = await _datasource.createSePayPayment(params);
    return response.toEither().map((model) => model.toEntity());
  }

  @override
  Future<Either<FailureEntity, TransactionEntity>> getTransactionById(
      GetTransactionStatusParams params) async {
    final response = await _datasource.getTransactionById(params.transactionId);
    return response.toEither().map((model) => model.toEntity());
  }

  @override
  Future<Either<FailureEntity, List<TransactionEntity>>> getTransactions() async {
    final response = await _datasource.getTransactions();
    return response.toEither().map(
          (models) => models.map((m) => m.toEntity()).toList(),
        );
  }
}
