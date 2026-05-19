import 'package:events_app/api_template/api_path.dart';
import 'package:events_app/api_template/api_provider.dart';
import 'package:events_app/api_template/base_request/api_request.dart';
import 'package:events_app/api_template/base_response/api_response.dart';
import 'package:events_app/api_template/base_response/api_response_forwarder.dart';
import 'package:events_app/api_template/services/rest_clients.dart';
import 'package:events_app/feature/common/data/model/file_model.dart';
import 'package:injectable/injectable.dart';

abstract class FileDatasource {
  Future<ApiResponse<FileModel>> uploadFile({
    required String filePath,
    required String fileType,
  });

  Future<ApiResponse<void>> deleteFile(int fileId);
}

@Injectable(as: FileDatasource)
class FileDatasourceImpl extends ApiProvider implements FileDatasource {
  FileDatasourceImpl({RestClient? client})
      : super(client: client ?? NRDRestClient());

  @override
  Future<ApiResponse<FileModel>> uploadFile({
    required String filePath,
    required String fileType,
  }) async {
    try {
      final response = await upload<Map<String, dynamic>>(
        ApiPath.upload,
        (data) => Map<String, dynamic>.from(data as Map),
        body: ApiRequestBody.file({
          'filePath': filePath,
          'fileType': fileType,
        }),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<FileModel>(
        response,
        (object) {
          if (object is! Map<String, dynamic>) {
            throw const FormatException('Invalid object payload');
          }
          return FileModel.fromJson(object);
        },
        fallbackError: 'Upload file thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }

  @override
  Future<ApiResponse<void>> deleteFile(int fileId) async {
    try {
      final response = await delete<Map<String, dynamic>>(
        ApiPath.deleteUpload(fileId),
        (data) => Map<String, dynamic>.from(data as Map),
        requireAuth: true,
      );

      return forwardEnvelopeResponse<void>(
        response,
        (_) {},
        fallbackError: 'Xóa file thất bại',
      );
    } catch (e) {
      return mapExceptionToApiResponse(e);
    }
  }
}
