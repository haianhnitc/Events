import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/common/helpers/no_params.dart';
import 'package:events_app/common/helpers/use_case.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/repository/sepay_payment_repository.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateSePayPaymentUsecase
    implements UseCase<PaymentUrlEntity, CreateTransactionParams> {
  final SePayPaymentRepository _repository;

  CreateSePayPaymentUsecase(this._repository);

  @override
  Future<Either<FailureEntity, PaymentUrlEntity>> call(
    CreateTransactionParams params,
  ) async {
    return await _repository.createSePayPayment(params);
  }
}

@injectable
class GetTransactionStatusUsecase
    implements UseCase<TransactionEntity, GetTransactionStatusParams> {
  final SePayPaymentRepository _repository;

  GetTransactionStatusUsecase(this._repository);

  @override
  Future<Either<FailureEntity, TransactionEntity>> call(
    GetTransactionStatusParams params,
  ) async {
    return await _repository.getTransactionById(params);
  }
}

@injectable
class GetTransactionsUsecase
    implements UseCase<List<TransactionEntity>, NoParams> {
  final SePayPaymentRepository _repository;

  GetTransactionsUsecase(this._repository);

  @override
  Future<Either<FailureEntity, List<TransactionEntity>>> call(
    NoParams params,
  ) async {
    return await _repository.getTransactions();
  }
}
