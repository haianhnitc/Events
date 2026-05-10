import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/ticket/data/datasource/ticket_datasource.dart';
import 'package:events_app/feature/ticket/data/model/ticket_model.dart';
import 'package:events_app/feature/ticket/data/repository/ticket_repository_impl.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class MockTicketDatasource extends Mock implements TicketDatasource {}

void main() {
  late MockTicketDatasource mockDatasource;
  late TicketRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockTicketDatasource();
    repository = TicketRepositoryImpl(mockDatasource);
  });

  group('getMyTickets', () {
    test('trả về list TicketEntity khi datasource trả success', () async {
      final models = [
        TicketModel.fromJson(fakeTicketJson(id: 1)),
        TicketModel.fromJson(fakeTicketJson(id: 2)),
      ];
      when(() => mockDatasource.getMyTickets(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse(models));

      final result = await repository.getMyTickets(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) {
          expect(entities.length, equals(2));
          expect(entities.first.ticketId, equals(1));
          expect(entities.last.ticketId, equals(2));
        },
      );
    });

    test('trả về empty list khi datasource trả success với content rỗng',
        () async {
      when(() => mockDatasource.getMyTickets(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => successResponse<List<TicketModel>>([]));

      final result = await repository.getMyTickets(42);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entities) => expect(entities, isEmpty),
      );
    });

    test('trả về Left khi datasource trả failure', () async {
      when(() => mockDatasource.getMyTickets(
                any(),
                page: any(named: 'page'),
                size: any(named: 'size'),
              ))
          .thenAnswer((_) async =>
              errorResponse<List<TicketModel>>(unauthorizedResponse()));

      final result = await repository.getMyTickets(42);

      expect(result.isLeft(), isTrue);
    });
  });

  group('getTicketById', () {
    test('trả về TicketEntity khi datasource trả success', () async {
      final model = TicketModel.fromJson(fakeTicketJson(id: 99));
      when(() => mockDatasource.getTicketById(99))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getTicketById(99);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.ticketId, equals(99)),
      );
    });

    test('trả về Left khi datasource trả notFound', () async {
      when(() => mockDatasource.getTicketById(9999)).thenAnswer(
          (_) async => errorResponse<TicketModel>(notFoundResponse()));

      final result = await repository.getTicketById(9999);

      expect(result.isLeft(), isTrue);
    });

    test('trả về Left khi datasource trả responseParsing', () async {
      when(() => mockDatasource.getTicketById(1)).thenAnswer((_) async =>
          errorResponse<TicketModel>(const ApiResponse.responseParsing()));

      final result = await repository.getTicketById(1);

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<FailureEntity>()),
        (_) => fail('Expected Left'),
      );
    });
  });

  group('updateTicketStatus', () {
    test('trả về TicketEntity khi datasource trả success', () async {
      final model = TicketModel.fromJson(fakeTicketJson(id: 5));
      when(() => mockDatasource.updateTicketStatus(5, 'used'))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.updateTicketStatus(5, 'used');

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (entity) => expect(entity.ticketId, equals(5)),
      );
    });

    test('trả về Left khi datasource trả conflict', () async {
      when(() => mockDatasource.updateTicketStatus(any(), any())).thenAnswer(
          (_) async => errorResponse<TicketModel>(conflictResponse()));

      final result = await repository.updateTicketStatus(5, 'used');

      expect(result.isLeft(), isTrue);
    });
  });

  group('map model to entity', () {
    test('chuyển đổi TicketModel sang TicketEntity đúng', () async {
      final model = TicketModel.fromJson(fakeTicketJson(id: 10));
      when(() => mockDatasource.getTicketById(10))
          .thenAnswer((_) async => successResponse(model));

      final result = await repository.getTicketById(10);

      result.fold(
        (_) => fail('Expected Right'),
        (entity) {
          expect(entity, isA<TicketEntity>());
          expect(entity.ticketId, equals(10));
        },
      );
    });
  });
}
