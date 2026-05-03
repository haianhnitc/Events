import 'package:dartz/dartz.dart';
import 'package:events_app/api_template/services/failure.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/ticket/domain/entity/ticket_entity.dart';
import 'package:events_app/feature/ticket/domain/repository/ticket_repository.dart';
import 'package:events_app/feature/ticket/domain/usecase/ticket_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTicketRepository extends Mock implements TicketRepository {}

class FakeGetMyTicketsParams extends Fake implements GetMyTicketsParams {}

class FakeUpdateTicketStatusParams extends Fake implements UpdateTicketStatusParams {}

void main() {
  late MockTicketRepository mockRepository;
  late GetMyTicketsUsecase getMyTicketsUsecase;
  late GetTicketByIdUsecase getTicketByIdUsecase;
  late UpdateTicketStatusUsecase updateTicketStatusUsecase;

  setUpAll(() {
    registerFallbackValue(FakeGetMyTicketsParams());
    registerFallbackValue(FakeUpdateTicketStatusParams());
  });

  setUp(() {
    mockRepository = MockTicketRepository();
    getMyTicketsUsecase = GetMyTicketsUsecase(mockRepository);
    getTicketByIdUsecase = GetTicketByIdUsecase(mockRepository);
    updateTicketStatusUsecase = UpdateTicketStatusUsecase(mockRepository);
  });

  group('GetMyTicketsUsecase', () {
    test('trả về list TicketEntity khi repository thành công', () async {
      final entities = [
        TicketEntity(ticketId: 1, status: TicketStatus.issued),
        TicketEntity(ticketId: 2, status: TicketStatus.issued),
      ];
      when(() => mockRepository.getMyTickets(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => Right(entities));

      final result = await getMyTicketsUsecase(const GetMyTicketsParams(userId: 42));

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (tickets) {
          expect(tickets.length, equals(2));
          expect(tickets.first.ticketId, equals(1));
        },
      );
    });

    test('trả về empty list khi repository trả rỗng', () async {
      when(() => mockRepository.getMyTickets(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async => const Right([]));

      final result = await getMyTicketsUsecase(const GetMyTicketsParams(userId: 42));

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (tickets) => expect(tickets, isEmpty),
      );
    });

    test('trả về failure khi repository thất bại', () async {
      when(() => mockRepository.getMyTickets(
            any(),
            page: any(named: 'page'),
            size: any(named: 'size'),
          )).thenAnswer((_) async =>
              const Left(FailureEntity.serverFailure('500', 'Server error')));

      final result = await getMyTicketsUsecase(const GetMyTicketsParams(userId: 42));

      expect(result.isLeft(), isTrue);
    });
  });

  group('GetTicketByIdUsecase', () {
    test('trả về TicketEntity khi repository thành công', () async {
      final entity = TicketEntity(ticketId: 10, status: TicketStatus.issued);
      when(() => mockRepository.getTicketById(10))
          .thenAnswer((_) async => Right(entity));

      final result = await getTicketByIdUsecase(10);

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (ticket) => expect(ticket.ticketId, equals(10)),
      );
    });

    test('trả về failure khi repository trả notFound', () async {
      when(() => mockRepository.getTicketById(9999)).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('404', 'Not found')));

      final result = await getTicketByIdUsecase(9999);

      expect(result.isLeft(), isTrue);
    });
  });

  group('UpdateTicketStatusUsecase', () {
    test('trả về TicketEntity khi repository thành công', () async {
      final entity = TicketEntity(ticketId: 5, status: TicketStatus.used);
      when(() => mockRepository.updateTicketStatus(any(), any()))
          .thenAnswer((_) async => Right(entity));

      final result = await updateTicketStatusUsecase(
        const UpdateTicketStatusParams(ticketId: 5, status: 'used'),
      );

      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('Expected Right'),
        (ticket) {
          expect(ticket.ticketId, equals(5));
          expect(ticket.status, equals(TicketStatus.used));
        },
      );
    });

    test('trả về failure khi repository trả conflict', () async {
      when(() => mockRepository.updateTicketStatus(any(), any())).thenAnswer(
          (_) async => const Left(FailureEntity.serverFailure('409', 'Conflict')));

      final result = await updateTicketStatusUsecase(
        const UpdateTicketStatusParams(ticketId: 5, status: 'used'),
      );

      expect(result.isLeft(), isTrue);
    });
  });
}
