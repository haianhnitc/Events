import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/staff_application/data/datasource/staff_application_datasource.dart';
import 'package:events_app/feature/staff_application/data/model/staff_application_model.dart';
import 'package:events_app/feature/staff_application/domain/usecase/apply_ctv_params.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';
import '../helpers/mock_rest_client.dart';

class TestStaffApplicationDatasource extends StaffApplicationDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? createApplicationStub;
  ApiResponse<Map<String, dynamic>>? getApplicationByIdStub;

  TestStaffApplicationDatasource({
    this.createApplicationStub,
    this.getApplicationByIdStub,
  }) : super(client: StubRestClient());

  @override
  Future<ApiResponse<StaffApplicationModel>> createApplication(
    ApplyCtvParams params,
  ) async {
    final envelope =
        createApplicationStub ?? successEnvelope(fakeStaffApplicationJson());
    return forwardEnvelopeResponse<StaffApplicationModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return StaffApplicationModel.fromJson(object);
      },
      fallbackError: 'Gửi đơn ứng tuyển thất bại',
    );
  }

  @override
  Future<ApiResponse<StaffApplicationModel>> getApplicationById(int id) async {
    final envelope = getApplicationByIdStub ??
        successEnvelope(fakeStaffApplicationJson(id: id));
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
}

void main() {
  group('createApplication', () {
    test('trả về StaffApplicationModel khi thành công', () async {
      final datasource = TestStaffApplicationDatasource(
        createApplicationStub: successEnvelope(fakeStaffApplicationJson(id: 5)),
      );

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await datasource.createApplication(params);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(5));
          expect(application.roleName, equals('Tình nguyện viên'));
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

    test('truyền đúng JSON body với answers', () async {
      final datasource = TestStaffApplicationDatasource(
        createApplicationStub: successEnvelope(fakeStaffApplicationJson()),
      );

      const params = ApplyCtvParams(
        eventId: 1,
        cvUrl: 'https://example.com/cv.pdf',
        answers: [
          AnswerItem(questionId: 1, answerText: 'Tôi muốn tham gia'),
        ],
      );
      final result = await datasource.createApplication(params);

      result.when(
        success: (application) => expect(application, isNotNull),
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

    test('trả về conflict khi đã ứng tuyển rồi', () async {
      final datasource = TestStaffApplicationDatasource(
        createApplicationStub: conflictResponse(),
      );

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await datasource.createApplication(params);

      expect(
        result.when(
          success: (_) => false,
          conflict: (_) => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
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

    test('trả về badRequest khi params không hợp lệ', () async {
      final datasource = TestStaffApplicationDatasource(
        createApplicationStub: badRequestResponse(),
      );

      const params = ApplyCtvParams(eventId: 1, answers: []);
      final result = await datasource.createApplication(params);

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
  });

  group('getApplicationById', () {
    test('trả về StaffApplicationModel khi thành công', () async {
      final datasource = TestStaffApplicationDatasource(
        getApplicationByIdStub:
            successEnvelope(fakeStaffApplicationJson(id: 10)),
      );

      final result = await datasource.getApplicationById(10);

      result.when(
        success: (application) {
          expect(application.applicationId, equals(10));
          expect(application.eventTitle, equals('Test Event'));
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

    test('trả về notFound khi đơn không tồn tại', () async {
      final datasource = TestStaffApplicationDatasource(
        getApplicationByIdStub: notFoundResponse(),
      );

      final result = await datasource.getApplicationById(9999);

      expect(
        result.when(
          success: (_) => false,
          notFound: (_) => true,
          conflict: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          badRequest: (_) => false,
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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestStaffApplicationDatasource(
        getApplicationByIdStub: successEnvelope('invalid'),
      );

      final result = await datasource.getApplicationById(1);

      expect(
        result.when(
          success: (_) => false,
          responseParsing: () => true,
          badRequest: (_) => false,
          unauthorized: (_) => false,
          forbidden: (_) => false,
          notFound: (_) => false,
          conflict: (_) => false,
          internalServerError: () => false,
          badGateway: () => false,
          serviceUnavailable: () => false,
          gatewayTimeout: () => false,
          canceled: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });
  });
}
