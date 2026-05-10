import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/ticket/data/datasource/ticket_datasource.dart';
import 'package:events_app/feature/ticket/data/model/ticket_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class TestTicketDatasource extends TicketDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getMyTicketsStub;
  ApiResponse<Map<String, dynamic>>? getTicketByIdStub;
  ApiResponse<Map<String, dynamic>>? updateTicketStatusStub;

  TestTicketDatasource({
    this.getMyTicketsStub,
    this.getTicketByIdStub,
    this.updateTicketStatusStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<List<TicketModel>>> getMyTickets(
    int userId, {
    int page = 0,
    int size = 20,
  }) async {
    final envelope = getMyTicketsStub ??
        successEnvelope({
          'content': [fakeTicketJson()],
          'totalElements': 1,
        });
    return forwardEnvelopeResponse<List<TicketModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = object['content'] as List<dynamic>? ?? [];
        return content
            .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách vé thất bại',
    );
  }

  @override
  Future<ApiResponse<TicketModel>> getTicketById(int id) async {
    final envelope =
        getTicketByIdStub ?? successEnvelope(fakeTicketJson(id: id));
    return forwardEnvelopeResponse<TicketModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return TicketModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết vé thất bại',
    );
  }

  @override
  Future<ApiResponse<TicketModel>> updateTicketStatus(
    int ticketId,
    String status,
  ) async {
    final envelope =
        updateTicketStatusStub ?? successEnvelope(fakeTicketJson(id: ticketId));
    return forwardEnvelopeResponse<TicketModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return TicketModel.fromJson(object);
      },
      fallbackError: 'Cập nhật trạng thái vé thất bại',
    );
  }
}

void main() {
  group('getMyTickets', () {
    test('trả về list TicketModel khi thành công', () async {
      final datasource = TestTicketDatasource(
        getMyTicketsStub: successEnvelope({
          'content': [
            fakeTicketJson(id: 1),
            fakeTicketJson(id: 2),
          ],
          'totalElements': 2,
        }),
      );

      final result = await datasource.getMyTickets(42);

      result.when(
        success: (tickets) {
          expect(tickets.length, equals(2));
          expect(tickets.first.ticketId, equals(1));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về list rỗng khi content rỗng', () async {
      final datasource = TestTicketDatasource(
        getMyTicketsStub: successEnvelope({
          'content': <dynamic>[],
          'totalElements': 0,
        }),
      );

      final result = await datasource.getMyTickets(42);

      result.when(
        success: (tickets) => expect(tickets, isEmpty),
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('truyền đúng userId và pagination params', () async {
      final datasource = TestTicketDatasource(
        getMyTicketsStub: successEnvelope({
          'content': [fakeTicketJson()],
          'totalElements': 1,
        }),
      );

      final result = await datasource.getMyTickets(42, page: 1, size: 10);

      result.when(
        success: (tickets) => expect(tickets.length, equals(1)),
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về unauthorized khi 401', () async {
      final datasource = TestTicketDatasource(
        getMyTicketsStub: unauthorizedResponse(),
      );

      final result = await datasource.getMyTickets(42);

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          badRequest: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về notFound khi 404', () async {
      final datasource = TestTicketDatasource(
        getMyTicketsStub: notFoundResponse(),
      );

      final result = await datasource.getMyTickets(42);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          badRequest: (_) => false,
          forbidden: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('getTicketById', () {
    test('trả về TicketModel khi thành công', () async {
      final datasource = TestTicketDatasource(
        getTicketByIdStub: successEnvelope(fakeTicketJson(id: 10)),
      );

      final result = await datasource.getTicketById(10);

      result.when(
        success: (ticket) {
          expect(ticket.ticketId, equals(10));
          expect(ticket.event?.title, equals('Test Event'));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về notFound khi vé không tồn tại', () async {
      final datasource = TestTicketDatasource(
        getTicketByIdStub: notFoundResponse(),
      );

      final result = await datasource.getTicketById(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          badRequest: (_) => false,
          forbidden: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });

  group('updateTicketStatus', () {
    test('trả về TicketModel đã cập nhật khi thành công', () async {
      final datasource = TestTicketDatasource(
        updateTicketStatusStub: successEnvelope(fakeTicketJson(id: 5)),
      );

      final result = await datasource.updateTicketStatus(5, 'used');

      result.when(
        success: (ticket) {
          expect(ticket.ticketId, equals(5));
        },
        unexpected: (_) => fail('Expected success'),
        badRequest: (_) => fail('Expected success'),
        unauthorized: (_) => fail('Expected success'),
        forbidden: (_) => fail('Expected success'),
        notFound: (_) => fail('Expected success'),
        conflict: (_) => fail('Expected success'),
        internalServerError: () => fail('Expected success'),
        badGateway: () => fail('Expected success'),
        serviceUnavailable: () => fail('Expected success'),
        gatewayTimeout: () => fail('Expected success'),
        canceled: () => fail('Expected success'),
        responseParsing: () => fail('Expected success'),
      );
    });

    test('trả về badRequest khi status không hợp lệ', () async {
      final datasource = TestTicketDatasource(
        updateTicketStatusStub: badRequestResponse(),
      );

      final result = await datasource.updateTicketStatus(5, 'invalid_status');

      expect(
        result.when(
          success: (_) => false,
          badRequest: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về notFound khi vé không tồn tại', () async {
      final datasource = TestTicketDatasource(
        updateTicketStatusStub: notFoundResponse(),
      );

      final result = await datasource.updateTicketStatus(9999, 'used');

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          badRequest: (_) => false,
          forbidden: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
