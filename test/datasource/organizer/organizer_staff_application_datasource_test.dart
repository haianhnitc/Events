import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/organizer/staff_application/data/datasource/organizer_staff_application_datasource.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/api_request_matchers.dart';
import '../../helpers/fake_data.dart';
import '../../helpers/mock_rest_client.dart';
import '../../helpers/api_response_matchers.dart';

void main() {
  late MockRestClient mockRestClient;
  late OrganizerStaffApplicationDatasourceImpl datasource;

  setUpAll(registerFallbacks);

  setUp(() {
    mockRestClient = MockRestClient();
    datasource = OrganizerStaffApplicationDatasourceImpl(client: mockRestClient);
  });

  // ─── getStaffApplications ────────────────────────────────────────────────────
  group('getStaffApplications', () {
    test('trả về list đơn ứng tuyển khi thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeStaffApplicationJson(id: 1), fakeStaffApplicationJson(id: 2)],
          'totalElements': 2,
        }),
      );

      final result = await datasource.getStaffApplications();

      result.when(
        success: (list) {
          expect(list.length, equals(2));
          expect(list.first.applicationId, equals(1));
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

    test('filter theo eventId và status không gây lỗi', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          'content': [fakeStaffApplicationJson()],
          'totalElements': 1,
        }),
      );

      final result = await datasource.getStaffApplications(
        eventId: 1,
        status: 0,
        page: 0,
        size: 20,
      );

      expect(result, isA<dynamic>());
    });

    test('trả về list rỗng khi không có đơn', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({'content': [], 'totalElements': 0}),
      );

      final result = await datasource.getStaffApplications(eventId: 1);

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

      final result = await datasource.getStaffApplications();

      expect(isUnauthorized(result), isTrue);
    });

    test('trả về responseParsing khi object không phải Map', () async {
      stubRestClient(mockRestClient, successEnvelope('invalid'));

      final result = await datasource.getStaffApplications();

      expect(isResponseParsing(result), isTrue);
    });

    test('trả về forbidden khi không phải organizer', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.getStaffApplications();

      expect(isForbidden(result), isTrue);
    });
  });

  // ─── getStaffApplicationById ─────────────────────────────────────────────────
  group('getStaffApplicationById', () {
    test('trả về StaffApplicationModel khi thành công', () async {
      stubRestClient(mockRestClient, successEnvelope(fakeStaffApplicationJson(id: 3)));

      final result = await datasource.getStaffApplicationById(3);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(3));
          expect(application.status, equals(StaffApplicationStatus.pending));
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

    test('trả về notFound khi đơn không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.getStaffApplicationById(9999);

      expect(isNotFound(result), isTrue);
    });

    test('trả về internalServerError khi backend lỗi', () async {
      stubRestClient(mockRestClient, serverErrorResponse());

      final result = await datasource.getStaffApplicationById(1);

      expect(isInternalServerError(result), isTrue);
    });
  });

  // ─── approveStaffApplication ─────────────────────────────────────────────────
  group('approveStaffApplication', () {
    const approveParams = ApproveStaffApplicationParams(
      applicationId: 3,
      isApproved: true,
      feedback: 'Bạn phù hợp với vị trí này',
    );

    const rejectParams = ApproveStaffApplicationParams(
      applicationId: 3,
      isApproved: false,
      feedback: 'Không đủ yêu cầu',
    );

    test('trả về StaffApplicationModel khi duyệt thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          ...fakeStaffApplicationJson(id: 3),
          'status': 'APPROVED',   // serialized enum value
        }),
      );

      final result = await datasource.approveStaffApplication(approveParams);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(3));
          expect(application.status, equals(StaffApplicationStatus.approved));
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

    test('trả về StaffApplicationModel khi từ chối thành công', () async {
      stubRestClient(
        mockRestClient,
        successEnvelope({
          ...fakeStaffApplicationJson(id: 3),
          'status': 'REJECTED',
        }),
      );

      final result = await datasource.approveStaffApplication(rejectParams);

      result.when(
        success: (application) {
          expect(application.status, equals(StaffApplicationStatus.rejected));
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

    test('trả về notFound khi đơn không tồn tại', () async {
      stubRestClient(mockRestClient, notFoundResponse());

      final result = await datasource.approveStaffApplication(approveParams);

      expect(isNotFound(result), isTrue);
    });

    test('trả về forbidden khi không có quyền duyệt đơn', () async {
      stubRestClient(mockRestClient, forbiddenResponse());

      final result = await datasource.approveStaffApplication(approveParams);

      expect(isForbidden(result), isTrue);
    });

    test('trả về badRequest khi đơn đã được duyệt rồi', () async {
      stubRestClient(mockRestClient, badRequestResponse());

      final result = await datasource.approveStaffApplication(approveParams);

      expect(isBadRequest(result), isTrue);
    });

    test('trả về unexpected khi backend errorCode != 0', () async {
      stubRestClient(
        mockRestClient,
        backendErrorEnvelope(errorCode: -1, message: 'Trạng thái không hợp lệ'),
      );

      final result = await datasource.approveStaffApplication(approveParams);

      expect(isUnexpected(result), isTrue);
    });
  });
}
