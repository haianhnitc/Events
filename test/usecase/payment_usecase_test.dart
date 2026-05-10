import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';
import 'package:events_app/feature/payment/domain/entity/payment_url_entity.dart';
import 'package:events_app/feature/payment/domain/entity/transaction_entity.dart';
import 'package:events_app/feature/payment/domain/repository/coin_repository.dart';
import 'package:events_app/feature/payment/domain/repository/sepay_payment_repository.dart';
import 'package:events_app/feature/payment/domain/usecase/coin_history_usecase.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_usecase.dart';
import 'package:events_app/feature/payment/domain/usecase/sepay_payment_params.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoinRepository extends Mock implements CoinRepository {}

class MockSePayPaymentRepository extends Mock
    implements SePayPaymentRepository {}

class FakeCoinHistoryParams extends Fake implements CoinHistoryParams {}

class FakeCreateTransactionParams extends Fake
    implements CreateTransactionParams {}

class FakeGetTransactionStatusParams extends Fake
    implements GetTransactionStatusParams {}

void main() {
  late MockCoinRepository mockCoinRepository;
  late MockSePayPaymentRepository mockSePayPaymentRepository;
  late GetCoinHistoryUsecase getCoinHistoryUsecase;
  late CreateSePayPaymentUsecase createSePayPaymentUsecase;
  late GetTransactionStatusUsecase getTransactionStatusUsecase;

  setUpAll(() {
    registerFallbackValue(FakeCoinHistoryParams());
    registerFallbackValue(FakeCreateTransactionParams());
    registerFallbackValue(FakeGetTransactionStatusParams());
  });

  setUp(() {
    mockCoinRepository = MockCoinRepository();
    mockSePayPaymentRepository = MockSePayPaymentRepository();
    getCoinHistoryUsecase = GetCoinHistoryUsecase(mockCoinRepository);
    createSePayPaymentUsecase =
        CreateSePayPaymentUsecase(mockSePayPaymentRepository);
    getTransactionStatusUsecase =
        GetTransactionStatusUsecase(mockSePayPaymentRepository);
  });

  group('GetCoinHistoryUsecase', () {
    test('trả về list CoinTransactionEntity khi repository thành công',
        () async {
      final entities = [
        CoinTransactionEntity(transactionId: 1, amount: 10),
        CoinTransactionEntity(transactionId: 2, amount: -5),
      ];
      when(() => mockCoinRepository.getCoinHistory(
            page: any(named: 'page'),
            size: any(named: 'size'),
            sort: any(named: 'sort'),
          )).thenAnswer((_) async => Right((
            items: entities,
            totalElements: 2,
            totalPages: 1,
          )));

      final result = await getCoinHistoryUsecase(const CoinHistoryParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.items.length, equals(2));
          expect(data.totalElements, equals(2));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockCoinRepository.getCoinHistory(
            page: any(named: 'page'),
            size: any(named: 'size'),
            sort: any(named: 'sort'),
          )).thenAnswer((_) async => const Right((
            items: <CoinTransactionEntity>[],
            totalElements: 0,
            totalPages: 0,
          )));

      final result = await getCoinHistoryUsecase(const CoinHistoryParams());

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.items, isEmpty);
          expect(data.totalElements, equals(0));
        },
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockCoinRepository.getCoinHistory(
                page: any(named: 'page'),
                size: any(named: 'size'),
                sort: any(named: 'sort'),
              ))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getCoinHistoryUsecase(const CoinHistoryParams());

      expect(result.isLeft(), isTrue);
    });
  });

  group('CreateSePayPaymentUsecase', () {
    test('trả về PaymentUrlEntity khi repository thành công', () async {
      final entity = PaymentUrlEntity(
        paymentUrl: 'https://sepay.vn/pay/123',
        qrCodeUrl: 'https://sepay.vn/qr/123.png',
        orderId: 123,
      );
      when(() => mockSePayPaymentRepository.createSePayPayment(any()))
          .thenAnswer((_) async => Right(entity));

      final result = await createSePayPaymentUsecase(
        const CreateTransactionParams(
          referenceType: TransactionReferenceType.ticket,
          originalAmount: 100000,
          paymentProvider: PaymentProvider.sepay,
        ),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (paymentUrl) {
          expect(paymentUrl.paymentUrl, isNotNull);
          expect(paymentUrl.qrCodeUrl, isNotNull);
        },
      );
    });

    test('trả về Left khi repository trả badRequest', () async {
      when(() => mockSePayPaymentRepository.createSePayPayment(any()))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('400', 'Bad request')));

      final result = await createSePayPaymentUsecase(
        const CreateTransactionParams(
          referenceType: TransactionReferenceType.ticket,
          originalAmount: 0,
          paymentProvider: PaymentProvider.sepay,
        ),
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetTransactionStatusUsecase', () {
    test('trả về TransactionEntity khi repository thành công', () async {
      final entity = TransactionEntity(
        transactionId: 77,
        status: TransactionStatus.success,
      );
      when(() => mockSePayPaymentRepository.getTransactionById(any()))
          .thenAnswer((_) async => Right(entity));

      final result = await getTransactionStatusUsecase(
        const GetTransactionStatusParams(transactionId: 77),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (transaction) => expect(transaction.transactionId, equals(77)),
      );
    });

    test('trả về Left khi repository trả notFound', () async {
      when(() => mockSePayPaymentRepository.getTransactionById(any()))
          .thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getTransactionStatusUsecase(
        const GetTransactionStatusParams(transactionId: 9999),
      );

      expect(result.isLeft(), isTrue);
    });
  });
}
