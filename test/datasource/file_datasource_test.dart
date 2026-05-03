import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/feature/common/data/datasource/file_datasource.dart';
import 'package:events_app/feature/common/data/model/file_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_data.dart';

class TestFileDatasource extends FileDatasourceImpl {
  ApiResponse<Map<String, dynamic>>? uploadStub;
  ApiResponse<Map<String, dynamic>>? deleteStub;

  TestFileDatasource({this.uploadStub, this.deleteStub}) : super(client: null);

  @override
  Future<ApiResponse<FileModel>> uploadFile({
    required String filePath,
    required String fileType,
  }) async {
    final envelope = uploadStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFileJson(),
        });
    return forwardEnvelopeResponse<FileModel>(
      envelope,
      (object) {
        if (object is! Map<String, dynamic>) {
          throw const FormatException('Invalid object payload');
        }
        return FileModel.fromJson(object);
      },
      fallbackError: 'Upload file thất bại',
    );
  }

  @override
  Future<ApiResponse<void>> deleteFile(int fileId) async {
    final envelope = deleteStub ??
        ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        });
    return forwardEnvelopeResponse<void>(
      envelope,
      (_) => null,
      fallbackError: 'Xóa file thất bại',
    );
  }
}

void main() {
  group('uploadFile', () {
    test('trả về FileModel khi upload thành công', () async {
      final datasource = TestFileDatasource(
        uploadStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': fakeFileJson(id: 10),
        }),
      );

      final result = await datasource.uploadFile(
        filePath: '/path/to/file.jpg',
        fileType: 'AVATAR',
      );

      result.when(
        success: (file) {
          expect(file, isNotNull);
          expect(file.fileId, equals(10));
          expect(file.url, isNotNull);
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

    test('trả về badRequest khi file không hợp lệ', () async {
      final datasource = TestFileDatasource(
        uploadStub: const ApiResponse.badRequest(
          ApiResponseError(code: '400', message: 'Bad request', errors: []),
        ),
      );

      final result = await datasource.uploadFile(
        filePath: '/invalid/path',
        fileType: 'AVATAR',
      );

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

    test('trả về unauthorized khi chưa đăng nhập', () async {
      final datasource = TestFileDatasource(
        uploadStub: const ApiResponse.unauthorized(
          ApiResponseError(code: '401', message: 'Unauthorized', errors: []),
        ),
      );

      final result = await datasource.uploadFile(
        filePath: '/path/to/file.jpg',
        fileType: 'AVATAR',
      );

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

    test('trả về responseParsing khi object không phải Map', () async {
      final datasource = TestFileDatasource(
        uploadStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': 123,
        }),
      );

      final result = await datasource.uploadFile(
        filePath: '/path/to/file.jpg',
        fileType: 'AVATAR',
      );

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

  group('deleteFile', () {
    test('trả về success khi xóa thành công', () async {
      final datasource = TestFileDatasource(
        deleteStub: ApiResponse.success({
          'errorCode': 0,
          'statusCode': 200,
          'message': 'OK',
          'object': null,
        }),
      );

      final result = await datasource.deleteFile(10);

      expect(
        result.when(
          success: (_) => true,
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
          responseParsing: () => false,
          unexpected: (_) => false,
        ),
        isTrue,
      );
    });

    test('trả về notFound khi file không tồn tại', () async {
      final datasource = TestFileDatasource(
        deleteStub: const ApiResponse.notFound(
          ApiResponseError(code: '404', message: 'Not found', errors: []),
        ),
      );

      final result = await datasource.deleteFile(9999);

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

    test('trả về forbidden khi không có quyền xóa', () async {
      final datasource = TestFileDatasource(
        deleteStub: const ApiResponse.forbidden(
          ApiResponseError(code: '403', message: 'Forbidden', errors: []),
        ),
      );

      final result = await datasource.deleteFile(10);

      expect(
        result.when(
          success: (_) => false,
          forbidden: (_) => true,
          unauthorized: (_) => false,
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
}
