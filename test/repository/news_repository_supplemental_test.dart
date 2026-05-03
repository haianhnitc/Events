import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/news/data/datasource/news_datasource.dart';
import 'package:events_app/feature/news/data/model/news_claim_response_model.dart';
import 'package:events_app/feature/news/data/model/news_model.dart';
import 'package:events_app/feature/news/data/repository/news_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mock_rest_client.dart';

class MockNewsDatasource extends Mock implements NewsDatasource {}

void main() {
  late MockNewsDatasource mockDatasource;
  late NewsRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockNewsDatasource();
    repository = NewsRepositoryImpl(mockDatasource);
  });

  group('getNewsById - supplemental', () {
    test('trả về Left dataParsingFailure khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getNewsById(1)).thenAnswer(
          (_) async => errorResponse<NewsModel>(const ApiResponse.responseParsing()));

      final result = await repository.getNewsById(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure.errorCode(), equals('12002')); // DATA_PARSING_FAILURE
        },
        (_) => fail('Expected Left'),
      );
    });

    test('trả về Left serverFailure khi datasource trả conflict', () async {
      when(() => mockDatasource.getNewsById(1)).thenAnswer(
          (_) async => errorResponse<NewsModel>(conflictResponse()));

      final result = await repository.getNewsById(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) {
          expect(failure, isA<FailureEntity>());
        },
        (_) => fail('Expected Left'),
      );
    });
  });

  group('claimNews', () {
    test('trả về NewsClaimResponseModel khi datasource trả success', () async {
      const claimResponse = NewsClaimResponseModel(
        coinsEarned: 10,
        remainingRewardCoin: 90,
        exhausted: false,
      );
      when(() => mockDatasource.claimNews(1))
          .thenAnswer((_) async => successResponse(claimResponse));

      final result = await repository.claimNews(1);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (response) {
          expect(response.coinsEarned, equals(10));
          expect(response.exhausted, isFalse);
        },
      );
    });

    test('trả về Left khi datasource trả badRequest', () async {
      when(() => mockDatasource.claimNews(1)).thenAnswer(
          (_) async => errorResponse<NewsClaimResponseModel>(badRequestResponse()));

      final result = await repository.claimNews(1);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left khi datasource trả notFound', () async {
      when(() => mockDatasource.claimNews(9999)).thenAnswer(
          (_) async => errorResponse<NewsClaimResponseModel>(notFoundResponse()));

      final result = await repository.claimNews(9999);

      expect(result.isLeft(), isTrue);
    });
  });
}
