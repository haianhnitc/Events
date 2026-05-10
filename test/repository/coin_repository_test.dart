import 'package:dartz/dartz.dart';
import 'package:events_app/feature/payment/data/datasource/coin_datasource.dart';
import 'package:events_app/feature/payment/data/model/coin_transaction_model.dart';
import 'package:events_app/feature/payment/data/repository/coin_repository_impl.dart';
import 'package:events_app/feature/payment/domain/entity/coin_transaction_entity.dart';
import 'package:events_app/feature/payment/domain/repository/coin_repository.dart';
import 'package:events_app/feature/payment/domain/usecase/coin_history_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockCoinDatasource extends Mock implements CoinDatasource {}

void main() {
  late MockCoinDatasource mockDatasource;
  late CoinRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockCoinDatasource();
    repository = CoinRepositoryImpl(mockDatasource);
  });

  group('getCoinHistory', () {
    test('trả về list CoinTransactionEntity khi datasource trả success',
        () async {
      final coinPage = CoinPage(
        items: [
          CoinTransactionModel.fromJson(fakeCoinTransactionJson(id: 1)),
          CoinTransactionModel.fromJson(fakeCoinTransactionJson(id: 2)),
        ],
        totalElements: 2,
        totalPages: 1,
        page: 0,
        size: 20,
      );
      when(() => mockDatasource.getCoinHistory(
            page: any(named: 'page'),
            size: any(named: 'size'),
            sort: any(named: 'sort'),
          )).thenAnswer((_) async => successResponse(coinPage));

      final result = await repository.getCoinHistory();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.items.length, equals(2));
          expect(data.items.first.transactionId, equals(1));
          expect(data.totalElements, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả success với content rỗng',
        () async {
      const coinPage = CoinPage(
        items: [],
        totalElements: 0,
        totalPages: 0,
        page: 0,
        size: 20,
      );
      when(() => mockDatasource.getCoinHistory(
            page: any(named: 'page'),
            size: any(named: 'size'),
            sort: any(named: 'sort'),
          )).thenAnswer((_) async => successResponse(coinPage));

      final result = await repository.getCoinHistory();

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.items, isEmpty);
          expect(data.totalElements, equals(0));
        },
      );
    });

    test('trả về Left khi datasource trả failure', () async {
      when(() => mockDatasource.getCoinHistory(
                page: any(named: 'page'),
                size: any(named: 'size'),
                sort: any(named: 'sort'),
              ))
          .thenAnswer(
              (_) async => errorResponse<CoinPage>(unauthorizedResponse()));

      final result = await repository.getCoinHistory();

      expect(result.isLeft(), isTrue);
    });

    test('chuyển đổi CoinTransactionModel sang CoinTransactionEntity đúng',
        () async {
      final coinPage = CoinPage(
        items: [
          CoinTransactionModel.fromJson(fakeCoinTransactionJson(id: 5)),
        ],
        totalElements: 1,
        totalPages: 1,
        page: 0,
        size: 20,
      );
      when(() => mockDatasource.getCoinHistory(
            page: any(named: 'page'),
            size: any(named: 'size'),
            sort: any(named: 'sort'),
          )).thenAnswer((_) async => successResponse(coinPage));

      final result = await repository.getCoinHistory();

      result.fold(
        (_) => fail('Expected Right'),
        (data) {
          expect(data.items.first, isA<CoinTransactionEntity>());
          expect(data.items.first.transactionId, equals(5));
        },
      );
    });
  });
}
