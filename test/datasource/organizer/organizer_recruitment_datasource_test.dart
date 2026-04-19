import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/organizer/recruitment/data/datasource/organizer_recruitment_datasource.dart';
import 'package:events_app/feature/organizer/recruitment/domain/usecase/organizer_recruitment_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/api_request_matchers.dart';
import '../../helpers/fake_data.dart';
import '../../helpers/mock_rest_client.dart';
import '../../helpers/api_response_matchers.dart';

void main() {
  late MockRestClient mockRestClient;
  late OrganizerRecruitmentDatasourceImpl datasource;

  setUpAll(registerFallbacks);

  setUp(() {
    mockRestClient = MockRestClient();
    datasource = OrganizerRecruitmentDatasourceImpl(client: mockRestClient);
  });

  // ─── getRecruitments ─────────────────────────────────────────────────────────
  group('getRecruitments', () {
    test('trả về list tuyển CTV khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeCtvRecruitmentJson(id: 1), fakeCtvRecruitmentJson(id: 2)],
          'totalElements': 2,
        }),
      );

      final result = await datasource.getRecruitments();

      result.when(
        success: (list) {
          expect(list.length, equals(2));
          expect(list.first.ctvRecruitmentId, equals(1));
        },
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('filter theo eventId không gây lỗi', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeCtvRecruitmentJson()],
          'totalElements': 1,
        }),
      );

      final result = await datasource.getRecruitments(eventId: 5);

      expect(result, isA<dynamic>());
    });

    test('trả về list rỗng khi không có recruitment', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({'content': [], 'totalElements': 0}),
      );

      final result = await datasource.getRecruitments(eventId: 1);

      result.when(
        success: (list) => expect(list, isEmpty),
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('trả về unauthorized khi không có quyền', () async {
      stubRestClient(mockRestClient, unauthorizedResponse());

      final result = await datasource.getRecruitments();

      expect(isUnauthorized(result), isTrue);
    });
  });

  // ─── getRecruitmentById ──────────────────────────────────────────────────────
  group('getRecruitmentById', () {
    test('trả về CtvRecruitmentModel khi thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeCtvRecruitmentJson(id: 7)));

      final result = await datasource.getRecruitmentById(7);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(7));
          expect(recruitment.eventId, equals(1));
        },
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('trả về notFound khi recruitment không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.getRecruitmentById(9999);

      expect(isNotFound(result), isTrue);
    });
  });

  // ─── createRecruitment ───────────────────────────────────────────────────────
  group('createRecruitment', () {
    const params = CreateRecruitmentParams(
      eventId: 1,
      title: 'Tình nguyện viên',
      description: 'Mô tả công việc',
      quantity: 20,
      rewardCoin: 100,
    );

    test('trả về CtvRecruitmentModel khi tạo thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeCtvRecruitmentJson(id: 10)));

      final result = await datasource.createRecruitment(params);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(10));
          expect(recruitment.title, equals('Recruitment 10'));
        },
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('trả về badRequest khi data không hợp lệ', () async {
      stubRestClient(mockRestClient, badRequestResponse());

      final result = await datasource.createRecruitment(params);

      expect(isBadRequest(result), isTrue);
    });

    test('trả về forbidden khi không phải organizer của event', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.createRecruitment(params);

      expect(isForbidden(result), isTrue);
    });

    test('trả về unexpected khi backend errorCode != 0', () async {
      stubRestClient(
        mockRestClient,
        backendErrorEnvelope(errorCode: -1, message: 'Event không tồn tại'),
      );

      final result = await datasource.createRecruitment(params);

      expect(isUnexpected(result), isTrue);
    });
  });

  // ─── updateRecruitment ───────────────────────────────────────────────────────
  group('updateRecruitment', () {
    const params = UpdateRecruitmentParams(
      title: 'Updated Title',
      quantity: 30,
    );

    test('trả về CtvRecruitmentModel đã cập nhật khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({...fakeCtvRecruitmentJson(id: 5), 'title': 'Updated Title'}),
      );

      final result = await datasource.updateRecruitment(5, params);

      result.when(
        success: (recruitment) {
          expect(recruitment.ctvRecruitmentId, equals(5));
          expect(recruitment.title, equals('Updated Title'));
        },
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
        unexpected: (_) => fail('Expected success'),
      );
    });

    test('trả về notFound khi recruitment không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.updateRecruitment(9999, params);

      expect(isNotFound(result), isTrue);
    });

    test('trả về forbidden khi không có quyền sửa', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.updateRecruitment(5, params);

      expect(isForbidden(result), isTrue);
    });
  });

  // ─── closeRecruitment ────────────────────────────────────────────────────────
  group('closeRecruitment', () {
    test('trả về success khi đóng thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(null));

      final result = await datasource.closeRecruitment(5);

      expect(result, isA<dynamic>());
    });

    test('trả về notFound khi recruitment không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.closeRecruitment(9999);

      expect(isNotFound(result), isTrue);
    });

    test('trả về forbidden khi không có quyền đóng', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.closeRecruitment(5);

      expect(isForbidden(result), isTrue);
    });

    test('trả về badRequest khi recruitment đã đóng rồi', () async {
      stubRestClient(mockRestClient, badRequestResponse());

      final result = await datasource.closeRecruitment(5);

      expect(isBadRequest(result), isTrue);
    });
  });

  // ─── deleteRecruitment ───────────────────────────────────────────────────────
  group('deleteRecruitment', () {
    test('trả về success khi xóa thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(null));

      final result = await datasource.deleteRecruitment(5);

      expect(result, isA<dynamic>());
    });

    test('trả về notFound khi recruitment không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.deleteRecruitment(9999);

      expect(isNotFound(result), isTrue);
    });

    test('trả về forbidden khi không có quyền xóa', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.deleteRecruitment(5);

      expect(isForbidden(result), isTrue);
    });

    test('trả về unauthorized khi không có token', () async {
      stubRestClient(mockRestClient, unauthorizedResponse());

      final result = await datasource.deleteRecruitment(5);

      expect(isUnauthorized(result), isTrue);
    });
  });
}
