import 'package:flutter_test/flutter_test.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/organizer/staff_application/data/datasource/organizer_staff_application_datasource.dart';
import 'package:events_app/feature/organizer/staff_application/domain/usecase/organizer_staff_application_params.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';

import '../../helpers/fake_data.dart';

class TestOrganizerStaffApplicationDatasource extends OrganizerStaffApplicationDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? getListStub;
  ApiResponse<Map<String, dynamic>>? getByIdStub;
  ApiResponse<Map<String, dynamic>>? approveStub;

  TestOrganizerStaffApplicationDatasource({
    this.getListStub,
    this.getByIdStub,
    this.approveStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<List<StaffApplicationModel>>> getStaffApplications({
    int? eventId,
    String? keyword,
    int? status,
    int page = 0,
    int size = 20,
  }) async {
    final envelope = getListStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeStaffApplicationJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        });
    return forwardEnvelopeResponse<List<StaffApplicationModel>>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        final content = object['content'] as List<dynamic>? ?? [];
        return content
            .map((e) => StaffApplicationModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
      fallbackError: 'Lấy danh sách đơn ứng tuyển thất bại',
    );
  }

  @override
  Future<ApiResponse<StaffApplicationModel>> getStaffApplicationById(int id) async {
    final envelope = getByIdStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeStaffApplicationJson(id: id),
        });
    return forwardEnvelopeResponse<StaffApplicationModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return StaffApplicationModel.fromJson(object);
      },
      fallbackError: 'Lấy chi tiết đơn thất bại',
    );
  }

  @override
  Future<ApiResponse<StaffApplicationModel>> approveStaffApplication(
      ApproveStaffApplicationParams params) async {
    final envelope = approveStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeStaffApplicationJson(),
        });
    return forwardEnvelopeResponse<StaffApplicationModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return StaffApplicationModel.fromJson(object);
      },
      fallbackError: 'Duyệt đơn thất bại',
    );
  }
}

void main() {
  group('getStaffApplications', () {
    test('success list', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        getListStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': [fakeStaffApplicationJson()],
            'totalElements': 1,
            'totalPages': 1,
            'page': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getStaffApplications(page: 0, size: 20);

      result.when(
        success: (list) {
          expect(list.length, equals(1));
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

    test('empty', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        getListStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': {
            'content': <Map<String, dynamic>>[],
            'totalElements': 0,
            'totalPages': 0,
            'page': 0,
            'size': 20,
          },
        }),
      );

      final result = await datasource.getStaffApplications(page: 0, size: 20);

      result.when(
        success: (list) {
          expect(list, isEmpty);
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

    test('401', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        getListStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.getStaffApplications(page: 0, size: 20);

      expect(
        result.when(
          success: (_) => false,
          unauthorized: (_) => true,
          forbidden: (_) => false,
          notFound: (_) => false,
          badRequest: (_) => false,
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

  group('getStaffApplicationById', () {
    test('success', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        getByIdStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeStaffApplicationJson(),
        }),
      );

      final result = await datasource.getStaffApplicationById(1);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(1));
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

    test('404', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        getByIdStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.getStaffApplicationById(999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          badRequest: (_) => false,
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

  group('approveStaffApplication', () {
    test('approved success', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        approveStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeStaffApplicationJson(),
        }),
      );

      final params = ApproveStaffApplicationParams(
        applicationId: 1,
        isApproved: true,
        feedback: 'Great application!',
      );
      final result = await datasource.approveStaffApplication(params);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(1));
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

    test('rejected success', () async {
      final datasource = TestOrganizerStaffApplicationDatasource(
        approveStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeStaffApplicationJson(),
        }),
      );

      final params = ApproveStaffApplicationParams(
        applicationId: 1,
        isApproved: false,
        feedback: 'Please apply next time',
      );
      final result = await datasource.approveStaffApplication(params);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(1));
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
  });
}
